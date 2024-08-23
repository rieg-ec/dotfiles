#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <process_id>"
    exit 1
fi

process_id="$1"
data_file="/tmp/mem_usage_pid_${process_id}.dat"
output_file="/tmp/mem_usage_pid_${process_id}.png"

# Function to create a plot and open the image
create_plot_and_open() {
    gnuplot -e "set terminal png size 800,600; set output '${output_file}'; set title 'Memory Usage'; set xlabel 'Time'; set ylabel 'RSS (KB)'; set xdata time; set timefmt '%Y-%m-%d %H:%M:%S'; set format x '%H:%M:%S'; plot '${data_file}' using 1:2 with lines title 'Memory Usage'"
    open "${output_file}"
}

# Catch SIGTERM (Ctrl+C) signal
trap "create_plot_and_open; exit" SIGTERM SIGINT

echo "# Time       RSS (in KB)" > "${data_file}"

while true; do
    current_time=$(date '+%Y-%m-%d %H:%M:%S')
    ps -p "${process_id}" -o rss,command | awk -v pid="${process_id}" -v time="${current_time}" 'NR==2 { printf("%s\t%d\n", time, $1); }' >> "${data_file}"
    sleep 5
done

