REM RENCapsulate with TimeCode
REM very simple script to rencapsulate video file adding time code based on the original encoding data using ffprobe and ffmpeg By Paolo Rudelli - Version 0.01 - 10 Aprile 2021
REM GPL license V3 : http://www.gnu.org/licenses/gpl.txt
REM for update check https://github.com/MrWu-at-msv/RENCTC
REM if you find a bug please email me at info /at/ paolorudelli /dot/ com

@ECHO OFF
REM avoid %% inside a for or if statement solution read here: http://stackoverflow.com/questions/17601473/using-set-p-inside-an-if-statement
Setlocal EnableDelayedExpansion
CLS

REM variables 
set SYSTEMSLASH=\
set OUTPUTDIR=TCconverted
mkdir %OUTPUTDIR%


for %%a in ("*.MP4" "*.MTS" "*.MOV") do (
echo %%a
set  FILEINPUT=%%a
ECHO !FILEINPUT!
REM remove the extension
set OUTPUTFILE=!OUTPUTDIR!!SYSTEMSLASH!TC_!FILEINPUT:~0,-4!.mov
rem set OUTPUTFILE=%%~na
echo !OUTPUTFILE!

set TIMEVIDEO=0
echo !TIMEVIDEO!

REM retreive creation data and save to a temp file
ffprobe -v quiet -select_streams v:0  -show_entries stream_tags=creation_time -of default=noprint_wrappers=1:nokey=1 !FILEINPUT! > timetemp.txt
REM retreive the saved time into a variable
set /p TIMEVIDEO=<timetemp.txt
echo %!TIMEVIDEO!

REM extract only the time
set TIMEVIDEO=!TIMEVIDEO:~11,8!

REM append data only ff : for nopn drop ; for drop
REM TODO check FPS for drop or not drop frame syntax 
set framewithseparator=:00
set TIMEVIDEO=!TIMEVIDEO!!framewithseparator!
echo !TIMEVIDEO!

REM rencapsulate the original file with the TC
ffmpeg.exe -i !FILEINPUT! -timecode !TIMEVIDEO! -c:v copy -c:a copy !OUTPUTFILE!
ECHO !FILEINPUT! DONE!!
)

del timetemp.txt
ECHO all done!!
pause
