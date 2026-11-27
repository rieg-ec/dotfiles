#!/usr/bin/env python3
"""Reads this week's KPIs from Metabase and opens the weekly report form with them and their deltas filled in.

Usage: prefill_weekly_reports.py --draws 0 [--keep-text]

Each week's numbers are kept in KPI_FILE, and the deltas are calculated against the
latest earlier week in that file. If the reported numbers differ from Metabase's,
correct them in KPI_FILE so next week's deltas use what was reported.

Needs the Metabase API key in the login Keychain (service "metabase-grupalia") and
a Cloudflare Access session (cloudflared access login https://metabase.grupalia.com).
"""
import argparse
import base64
import datetime as dt
import json
import pathlib
import subprocess
import sys
from decimal import ROUND_HALF_UP, Decimal

BASE_URL = "https://metabase.grupalia.com"
FORM = pathlib.Path(__file__).resolve().parent / "templates" / "reporte-semanal.html"
KPI_FILE = pathlib.Path.home() / "tmp" / "kpis-reportes-semanales.json"
MONTHS = ["ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic"]

PRODUCT_DASHBOARD = 29
GROWTH_DASHBOARD = 37


def credentials():
    key = subprocess.run(["security", "find-generic-password", "-s", "metabase-grupalia", "-w"],
                         capture_output=True, text=True, check=True).stdout.strip()
    access = subprocess.run(["cloudflared", "access", "token", f"--app={BASE_URL}"],
                            capture_output=True, text=True).stdout.strip()
    if not access.startswith("ey"):
        sys.exit(f"No Cloudflare Access session. Run: cloudflared access login {BASE_URL}")
    return key, access


def query(creds, dashboard, dashcard, card, parameters=()):
    # We call Metabase with curl because Cloudflare answers 403 to Python's default HTTP client.
    key, access = creds
    out = subprocess.run(
        ["curl", "-s", "-X", "POST", "-H", f"cf-access-token: {access}", "-H", f"x-api-key: {key}",
         "-H", "content-type: application/json", "-d", json.dumps({"parameters": list(parameters)}),
         f"{BASE_URL}/api/dashboard/{dashboard}/dashcard/{dashcard}/card/{card}/query"],
        capture_output=True, text=True, check=True).stdout
    result = json.loads(out)
    if result.get("error"):
        sys.exit(f"Metabase card {card} failed: {result['error']}")
    columns = [c["name"] for c in result["data"]["cols"]]
    return [dict(zip(columns, row)) for row in result["data"]["rows"]]


def weekly(slug):
    return [{"id": slug, "type": "string/=", "value": ["Semanal"], "target": ["variable", ["template-tag", slug]]}]


def fixed(value, decimals):
    return str(Decimal(str(value)).quantize(Decimal(1).scaleb(-decimals), rounding=ROUND_HALF_UP))


def scalar(rows):
    return next(iter(rows[0].values()))


def row_starting(rows, column, date):
    return next(r for r in rows if r[column].startswith(date.isoformat()))


def product_kpis(creds, today, draws):
    month = f"{MONTHS[today.month - 1]}-{today.year}"
    productivity = query(creds, PRODUCT_DASHBOARD, 278, 352)
    overview = query(creds, PRODUCT_DASHBOARD, 234, 276)
    return {
        "kpi_productividad": fixed(Decimal(next(r for r in productivity if r["Date (mm-yyyy)"] == "Originations / Open Zone")[month]) / 1000000, 3),
        "kpi_coord35": str(scalar(query(creds, PRODUCT_DASHBOARD, 293, 364))),
        "kpi_nivel2": str(scalar(query(creds, PRODUCT_DASHBOARD, 235, 277))),
        "kpi_universo": str(next(r for r in overview if r["metric"] == "denominador_asesores_flexibles")["value"]),
        "kpi_draws": str(draws),
    }


def growth_kpis(creds, today):
    # The Growth report covers the last complete week, because the current week's
    # numbers only hold the days elapsed so far.
    last_week = today - dt.timedelta(days=today.weekday() + 7)
    # We report the MOB1 activation of the cohort acquired in the month before the report's month.
    cohort = (today.replace(day=1) - dt.timedelta(days=1)).replace(day=1)

    colocacion = query(creds, GROWTH_DASHBOARD, 283, 349, weekly("periodo_colocacion"))
    activation = query(creds, GROWTH_DASHBOARD, 284, 189)
    referidos = query(creds, GROWTH_DASHBOARD, 286, 178, weekly("periodo_referidos"))
    adquisicion = query(creds, GROWTH_DASHBOARD, 325, 301, weekly("periodo_adquisicion"))
    return {
        "kpi_cumplimiento": fixed(row_starting(colocacion, "periodo", last_week)["cumplimiento_pct"], 1),
        "kpi_nuevos": str(row_starting(adquisicion, "periodo_adquisicion", last_week)["asesores_adquiridos"]),
        "kpi_mob1": fixed(row_starting(activation, "mes_adquisicion", cohort)["% activacion"], 1),
        "kpi_referidos": fixed(Decimal(row_starting(referidos, "periodo", last_week)["colocacion_referidos"]) / 1000000, 2),
    }


def load_kpis():
    return json.loads(KPI_FILE.read_text())


def save_kpis(kpis):
    KPI_FILE.write_text(json.dumps(kpis, indent=2, ensure_ascii=False, sort_keys=True) + "\n")


def signed(delta):
    return "0" if delta == 0 else f"{delta:+f}"


def with_deltas(history, week, kpis):
    earlier = [w for w in history if w < week]
    if not earlier:
        return dict(kpis)
    previous = history[max(earlier)]
    deltas = {key.replace("kpi_", "kpid_"): signed(Decimal(value) - Decimal(previous[key]))
              for key, value in kpis.items() if key in previous}
    return {**kpis, **deltas}


Q4_START = dt.date(2026, 10, 1)
Q4_END = dt.date(2026, 12, 31)


def elapsed(start, end, today):
    return Decimal((today - start).days) / Decimal((end - start).days)


def expected_now(today):
    """What each KPI has to be today to be on track for its Q4 goal (Planning Q4 2026).

    Goals reached over the quarter (coordinaciones, draws) are prorated linearly.
    A KPI without a goal is left out, so its color is not set.
    """
    month_days = ((today.replace(day=28) + dt.timedelta(days=4)).replace(day=1) - dt.timedelta(days=1)).day
    cohort_month = (today.replace(day=1) - dt.timedelta(days=1)).month
    expected = {
        "kpi_productividad": {10: "1.312", 11: "1.468", 12: "1.413"}[today.month],
        # 15 coordinaciones were above $3.5M on 2026-09-23, and the goal is 38 by the end of Q4.
        "kpi_coord35": 15 + 23 * elapsed(dt.date(2026, 9, 23), Q4_END, today),
        "kpi_draws": 100 * elapsed(Q4_START, Q4_END, today),
        "kpi_cumplimiento": "100",
        "kpi_nuevos": Decimal({10: 120, 11: 90, 12: 80}[today.month] * 7) / month_days,
        "kpi_referidos": Decimal("19.538403") * 7 / ((Q4_END - Q4_START).days + 1),
    }
    mob1_goal = {9: "36", 10: "39", 11: "33"}.get(cohort_month)
    if mob1_goal:
        expected["kpi_mob1"] = mob1_goal
    return {key: Decimal(value) for key, value in expected.items()}


def colors(kpis, today):
    # A KPI below what its Q4 goal needs by now is never green: yellow within 10%
    # of it, red further away.
    expected = expected_now(today)
    result = {}
    for key, value in kpis.items():
        if key not in expected:
            continue
        ratio = Decimal(value) / expected[key] if expected[key] else Decimal(1)
        result[key.replace("kpi_", "kpic_")] = "🟢" if ratio >= 1 else "🟡" if ratio >= Decimal("0.9") else "🔴"
    return result


def open_form(payload):
    encoded = base64.b64encode(json.dumps(payload, ensure_ascii=False).encode()).decode()
    url = f"file://{FORM}#prefill={encoded}"
    subprocess.run(["osascript", "-e", f'tell application "Google Chrome" to open location "{url}"',
                    "-e", 'tell application "Google Chrome" to activate'], check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--draws", type=int, required=True, help="Línea revolvente draws, which no Metabase card reports")
    parser.add_argument("--keep-text", action="store_true", help="Update the numbers without clearing what was already written")
    args = parser.parse_args()

    creds = credentials()
    today = dt.date.today()
    year, number, _ = today.isocalendar()
    week = f"{year}-W{number:02d}"

    history = load_kpis()
    fetched = {"producto": product_kpis(creds, today, args.draws), "growth": growth_kpis(creds, today)}
    payload = {area: {"draft": {**with_deltas(history[area], week, kpis), **colors(kpis, today)}, "keepText": args.keep_text}
               for area, kpis in fetched.items()}
    for area, kpis in fetched.items():
        history[area][week] = kpis
    save_kpis(history)

    print(json.dumps(payload, indent=2, ensure_ascii=False))
    open_form(payload)


if __name__ == "__main__":
    main()
