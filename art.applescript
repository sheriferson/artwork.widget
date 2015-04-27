on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

on is_running(appName)
	tell application "System Events" to (name of processes) contains appName
end is_running

set safRunning to is_running("iTunes")

if safRunning then
	run script "tell application \"iTunes\" 
	if player state is playing then
	
		tell artwork 1 of current track
			set artData to raw data
		end tell

		(((path to home folder) as text) & \"Dropbox:Ubersicht:widgets:artwork.widget:currentPlayingCover.png\")
		set deskFile to open for access file result with write permission
		set eof deskFile to 0
		write artData to deskFile
		close access deskFile

	
		set artFileName to (artist of current track) & \" - \" & (album of current track) & \" (\" & year of current track & \").png\"

		set theText to artFileName
		set oldString to \":\"
		set newString to \";\"

		local ASTID, lst
		set ASTID to AppleScript's text item delimiters
		try
			considering case
				set AppleScript's text item delimiters to oldString
				set lst to every text item of theText
				set AppleScript's text item delimiters to newString
				set theText to lst as string
			end considering
			set AppleScript's text item delimiters to ASTID
			set artFileName to theText
		on error eMsg number eNum
			set AppleScript's text item delimiters to ASTID
			error \"Can't replaceString: \" & eMsg number eNum
		end try

		set fullArchivePath to ((path to home folder) as text) & \"Dropbox:albumArt:\" & artFileName
		
		if rating of current track = 100 then
			tell application \"System Events\"
				if exists file fullArchivePath then
					return true
				else
					(fullArchivePath)
					set archiveFile to open for access file result with write permission
					set eof archiveFile to 0
					write artData to archiveFile
					close access archiveFile
				end if
			end tell
		end if
		
	end if
	
	end tell"
end if
