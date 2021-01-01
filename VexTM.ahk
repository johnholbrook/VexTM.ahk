; VexTM.ahk

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
        ; select "Skills Challenges" tab in main TM main window
        ControlClick, X550 Y100, VEX Tournament Manager

        ; make sure "Show all field sets in dropdown" is selected
        ControlGet, _vextm_tmp, Checked,, Show all field sets in dropdown, VEX Tournament Manager
        if (!_vextm_tmp){
            ControlClick, Show all field sets in dropdown, VEX Tournament Manager
        }
        
        ; Select this field set in the dropdown
        name := this.name
        Control, ChooseString, %name%, ComboBox23, VEX Tournament Manager

        StringLower, type, type
        switch type{
            Case "driving", "driver":
                ControlClick, Queue Driving Skills, VEX Tournament Manager
            Case "programming", "programmer":
                ControlClick, Queue Programming Skills, VEX Tournament Manager
        } 
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
            ; MsgBox, % _vextm_tmp
            
            ; ControlClick, % _vextm_tmp, name
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
}
