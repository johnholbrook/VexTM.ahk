; VexTM.ahk

#Include <ExtListView>

class VexTM_MainWindow{

}

class VexTM_FieldSet{
    __New(name){
        this.name := name
    }

    _confirm_window_open(){
        if !WinExist(this.name){
            name := this.name
            MsgBox % Format("Please open the control window for {}", name) 
			return 0
        }
        return 1
    }

    ; make this field set the selected field set for skills challenge matches
    _set_skills_fs(){
         ; select "Skills Challenges" tab in main TM main window
        ControlClick, X550 Y100, VEX Tournament Manager

        ; make sure "Show all field sets in dropdown" is selected
        ControlGet, _vextm_tmp, Checked,, Show all field sets in dropdown, VEX Tournament Manager
        if (!_vextm_tmp){
            ControlClick, Show all field sets in dropdown, VEX Tournament Manager
        }
        
        ; Select this field set in the dropdown
        name := this.name

        ; if there isn't a field set control window open...
        if (!WinExist("ahk_exe TM.exe", "Queue Next Match", "VEX Tournament Manager")){
            ; open a field set control window (not necessarily the one for this set, just the first in the list
            WinMenuSelectItem, VEX Tournament Manager, Field Set Control, 1&
            ; Sleep, 
            ; this is a hack to make sure the ClassNN of the dropdown we're looking for is what we expect it to be
        }

        Control, ChooseString, %name%, ComboBox23, VEX Tournament Manager
    }

    start_match(){
        if (this._confirm_window_open()){
            name := this.name
            _vextm_tmp := A_TitleMatchMode
            SetTitleMatchMode, RegEx
            ControlClick, Start Match|Resume Match, %name%
            SetTitleMatchMode, %_vextm_tmp%
        }
    }

    resume_match(){
        this.start_match()
    }

    end_early(){
        if (this._confirm_window_open()){
            name := this.name
            ControlClick, End Early, %name%
        }
    }

    abort_match(){
        if (this._confirm_window_open()){
            name := this.name
            ControlClick, Abort Match, %name%
        }
    }

    reset_timer(){
        if (this._confirm_window_open()){
            name := this.Name
            ControlClick, Reset Timer, %name%
        }
    }

    abort_or_reset(){
        if (this._confirm_window_open()){
            name := this.name
            _vextm_tmp := A_TitleMatchMode
            SetTitleMatchMode, RegEx
            ControlClick, Abort Match|Reset Timer, %name%
            SetTitleMatchMode, %_vextm_tmp%
        }
    }

    queue_next_match(){
        if (this._confirm_window_open()){
            name := this.name
            ControlClick, Queue Next Match, %name%
        }
    }

    queue_skills(type){
        this._set_skills_fs()

        StringLower, type, type
        switch type{
            Case "driving", "driver":
                ControlClick, Queue Driving Skills, VEX Tournament Manager
            Case "programming", "programmer":
                ControlClick, Queue Programming Skills, VEX Tournament Manager
        } 
    }

    show_latest_skills_score(){
        ; Select "Skills Challenges" tab
		; (this tab is in a slightly different place for IQ tournaments)
		if (_VexTM_is_IQ()){
			LocSkillsTab := _VexTM_correct_for_dpi(200, 60)
		}
		else {
			LocSkillsTab := _VexTM_correct_for_dpi(300,60)
		}

;	    LocX300Y60 := _VexTM_correct_for_dpi(300, 60)
	    ControlClick, %LocSkillsTab%, VEX Tournament Manager
        Sleep, 20

        ; Select "Driving Skills" Tab
	    LocX40Y80 := _VexTM_correct_for_dpi(40, 80)
	    ControlClick, %LocX40Y80% , VEX Tournament Manager

        ; get last driving skills match
        driver_list_view := ExtListView_InitializeFromHwnd(_VexTM_get_score_hwnd())
        driver_table_contents := ExtListView_GetAllItems(driver_list_view)
        largest_driver_index := 0
        largest_driver_value := 0
        for index, value in driver_table_contents{
            if (value[1] > largest_driver_value){
                largest_driver_index := index
                largest_driver_value := value[1]
            }
        }

        ; Select "Programming Skills" Tab
        LocX125Y85 := _VexTM_correct_for_dpi(125,85)
        ControlClick, %LocX125Y85%, VEX Tournament Manager
        
        ;get last programming skills match
        prog_list_view := ExtListView_InitializeFromHwnd(_VexTM_get_score_hwnd())
        prog_table_contents := ExtListView_GetAllItems(prog_list_view)
        largest_prog_index := 0
        largest_prog_value := 0
        for index, value in prog_table_contents{
            if (value[1] > largest_prog_value){
                largest_prog_index := index
                largest_prog_value := value[1]
            }
        }

        ; get location of list view
        ControlGetPos, ctlx, ctly,,,, % "ahk_id" _VexTM_get_score_hwnd()
        
        if (largest_prog_value > largest_driver_value){ ; last run was programming
            ; make sure row is visible
            ExtListView_EnsureVisible(prog_list_view, largest_prog_index-1)
        
            ; get location of row
            target := ExtListView_GetItemRect(prog_list_view, largest_prog_index-1)
        }
        else{ ; last run was driving
            ; switch to driving skills tab
            ControlClick, %LocX40Y80%, VEX Tournament Manager
        
            ; make sure row is visible
            ExtListView_EnsureVisible(driver_list_view, largest_driver_index-1)
        
            ; get location of row
            target  := ExtListView_GetItemRect(driver_list_view, largest_driver_index-1)
        }

        this._set_skills_fs()

        ; Save current mouse coordinates to move the cursor back there later
        MouseGetPos, mouse_pos_x, mouse_pos_y
        
        ; Block user input while we move the mouse
        BlockInput, On

        ; Right click latest skills match and send to results screen
        WinActivate, VEX Tournament Manager
        MouseClick, RIGHT, ctlx + target[1]*A_ScreenDPI/96 + 5, ctly + target[2]*A_ScreenDPI/96 + 5, 1, 0
        Sleep, 50
        Send, {Up}{Enter}
        
        ; move mouse back to previous position
        MouseMove, mouse_pos_x, mouse_pos_y
        
        ; Stop blocking input
        BlockInput, Off

        ; deinitialize ExtListView objects
        ExtListView_DeInitialize(driver_list_view)
        ExtListView_DeInitialize(prog_list_view)
    }


    set_display(disp){
        if (this._confirm_window_open()){
            StringLower, disp, disp
            name := this.name
            switch disp {
                Case "none":
                    ControlClick, None, % name
                Case "logo":
                    ControlClick, Logo, % name
                Case "intro":
                    ControlClick, Intro, % name
                Case "in-match", "match":
                    ControlClick, % "In-Match",  name
                Case "saved match results", "results":
                    ControlClick, Saved Match Results, % name
                Case "schedule":
                    ControlClick,  Schedule, % name
                Case "rankings":
                    ControlClick, Rankings, % name
                Case "skills rankings", "skills":
                    ControlClick, Skills Rankings, % name
                Case "alliance selection", "alliances":
                    ControlClick, Alliance Selection, % name
                Case "elim bracket", "bracket":
                    ControlClick, Elim Bracket, % name
                Case "slides":
                    ControlClick, Slides, % name
                Case "inspection":
                    ControlClick, Inspection, % name
            }
        }
    }

    set_auton_winner(winner){
        if(this._confirm_window_open()){
            name := this.name
            StringLower, winner, winner
            switch winner{
                Case "none":
                    ControlClick, None, % name
                Case "tie":
                    ControlClick, Tie, % name
                Case "red":
                    ControlClick, Red, % name
                Case "blue":
                    ControlClick, Blue, % name
            }
        }
    }
}

class VexTM_PitDisplay{
    __New(name){
        this.name := name
    }

    _confirm_window_open(){
        if !WinExist(this.name){
            name := this.name
            MsgBox % Format("Please open the control window for {}", name) 
            return 0
        }
        return 1
    }

    set_display(disp){
        if (this._confirm_window_open()){
            StringLower, disp, disp
            name := this.name
            switch disp {
                Case "none":
                    ControlClick, None, % name
                Case "logo":
                    ControlClick, Logo, % name
                Case "schedule":
                    ControlClick,  Schedule, % name
                Case "rankings":
                    ControlClick, Rankings, % name
                Case "skills rankings", "skills":
                    ControlClick, Skills Rankings, % name
                Case "alliance selection", "alliances":
                    ControlClick, Alliance Selection, % name
                Case "elim bracket", "bracket":
                    ControlClick, Elim Bracket, % name
                Case "inspection":
                    ControlClick, Inspection, % name
                Case "upcoming matches", "queueing":
                    ControlClick, Upcoming Matches, % name
            }
        }
    }

}

; returns true if the current torunament is VIQC
_VexTM_is_IQ(){
	; save the currently active window title
	WinGetActiveTitle, currently_active

	; activate TM and try to select the second item from the "Matches" menu
	; (which only has more than one item if we're running a VIQC event)
	WinActivate, VEX Tournament Manager
	WinMenuSelectItem, VEX Tournament Manager,, Matches, 2&

	; close the window that might've just opened
	Send, {Esc}

	; re-activate the previosu window
	WinActivate, %currently_active%

	; if the manu option we tried to select existed, ErrorLevel will be 0; if it didn't, it'll be 1.
	return ErrorLevel == 0
}

_VexTM_correct_for_dpi(x, y){
	scale := A_ScreenDPI/96
	tmp := "X" . Floor(x*scale) . " Y" . Floor(y*scale)
	; MsgBox, %tmp%
	return tmp
}

_VexTM_get_score_hwnd(){
	tm := WinExist("VEX Tournament Manager")
	hwnd := tm
	loop
	{
		old_hwnd := hwnd
		hwnd := DllCall("RealChildWindowFromPoint", "Ptr", hwnd, "Int64", (200<<32)|200, "Ptr")
	}
	until hwnd == old_hwnd
	return hwnd
}