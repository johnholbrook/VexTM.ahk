# VexTM.ahk
[AutoHotkey](http://autohotkey.org/) library for automating [VEX Tournament Manager](https://vextm.dwabtech.com/).

## Installation
Copy `VexTM.ahk` and `ExtListView.ahk` to your AHK library folder (typically `Documents\AutoHotkey\lib`).

`VexTM.ahk` is the library itself; `ExtListView.ahk` (a slightly modified version of the [orignial library by cyruz](https://www.autohotkey.com/boards/viewtopic.php?t=3513)) is a dependency of `VexTM.ahk`.

## Known issues
This is very much a work in progress - some known issues include:
* `ExtListView.ahk` claims to work with 64-bit versions of AHK, but in our experience it only works with 32-bit versions.
* The library may behave in strange ways if you have multiple displays running at different DPIs - or, more specifically, if the main TM window is on a display with a different DPI than that of the main display.
* TM does strange things to its `ClassNN`s when many winows are open. I've tried to find and squash most of these bugs but things may start breaking if you have an unusual combination of open windows (e.g., multiple field set control windows at the same time, or having the "inspection" or "mobile devices" windows open while trying to do other things).

## Disclaimer
This library is not written, reviewed, or endorsed by DWABtech or anyone else affiliated with VEX TM in any official capacity. Use it at your own risk.