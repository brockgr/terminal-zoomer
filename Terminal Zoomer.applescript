--
-- Terminal Zoomer - ©2010 Gavin Brock
-- http://code.google.com/p/terminal-zoomer
--
-- 
-- To use, this must be saved as an AppleScript "application" with "Stay Open" enabled.
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--

global zoom_pt
set zoom_pt to 3

global last_tab
set last_tab to "none"

on shrink()
	if last_tab is not "none" then
		try
			set font size of last_tab to (font size of last_tab) - zoom_pt
		end try
		set last_tab to "none"
	end if
	return true
end shrink

on idle
	tell application "System Events" to set app_name to name of the first process whose frontmost is true
	
	if app_name is "Terminal" then
		tell application "Terminal"
			
			set new_tab to first tab of front window whose selected is true
			
			if new_tab is not last_tab then
				my shrink()
				
				if (count of tabs of front window) is 1 then -- Tabbed widows don't work
					
					-- Break link between tab and it's settings set, 
					set normal text color of new_tab to normal text color of new_tab
					-- otherwise the next line affects all windows!
					
					-- Set font size for the window
					set font size of new_tab to (font size of new_tab) + zoom_pt
					
					set last_tab to new_tab
				end if
				
			end if
			
		end tell
	else
		-- Shrink when other app is focussed
		my shrink()
	end if
	
	return 1
end idle
