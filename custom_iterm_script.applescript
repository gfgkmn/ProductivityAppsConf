use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

-- For the latest version:
-- https://github.com/vitorgalvao/custom-alfred-iterm-scripts

-- Set this property to true to always open in a new window
property open_in_new_window : false

-- Set this property to false to reuse current tab
property open_in_new_tab : true

-- Handlers
on new_window()
	tell application "iTerm" to create window with default profile
end new_window

on new_tab()
	tell application "iTerm" to tell the first window to create tab with default profile
end new_tab

on call_forward()
	tell application "iTerm" to activate
end call_forward

on is_running()
	application "iTerm" is running
end is_running

on has_windows()
	if not is_running() then return false
	if windows of application "iTerm" is {} then return false
	-- modified by gfgkmn
	true
end has_windows

on focus_input()
	if open_in_new_tab then
		new_tab()
	else
		-- Reuse current tab
	end if
end focus_input

on send_text(custom_text)
	tell application "iTerm"
		tell the first window
			tell current session
				write text custom_text
			end tell
			if is hotkey window is true then
				reveal hotkey window
			end if
		end tell
	end tell
end send_text


on alfred_script(query)
    if has_windows() then
        focus_input()
    else
        -- If iTerm is not running and we tell it to create a new window, we get two
        -- One from opening the application, and the other from the command
        new_window()
    end if

    -- Make sure a window exists before we continue, or the write may fail
    repeat until has_windows()
        delay 0.01
    end repeat

    send_text(query)
end alfred_script
