on open droppedFiles
	set scriptPath to POSIX path of (path to resource "open-in-sheets.sh")
	repeat with f in droppedFiles
		try
			do shell script quoted form of scriptPath & " " & quoted form of POSIX path of f
		on error errorText
			display alert "Couldn't open in Google Sheets" message (POSIX path of f) & return & return & errorText
		end try
	end repeat
end open
