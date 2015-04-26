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
