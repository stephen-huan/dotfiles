on run {input, parameters}	
	# seem to need the full path at least in some cases
	set vimCommand to "/usr/local/bin/kitty --single-instance fish -c \"/usr/local/bin/vim "
	
	set filepaths to ""
	if input is not {} then
		repeat with currentFile in input
			set filepaths to filepaths & quoted form of POSIX path of currentFile & " "
		end repeat
	end if
	
	do shell script vimCommand & filepaths & "\""
	
end run

