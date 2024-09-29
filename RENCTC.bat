@ECHO OFF

REM Script information
REM RENCTC: Timecode Workaround for Video Files
REM Version: 0.01 - April 10, 2021
REM By Paolo Rudelli
REM GPL license V3: http://www.gnu.org/licenses/gpl.txt
REM For updates, check: https://github.com/MrWu-at-msv/RENCTC
REM For bugs, email: info@paolorudelli.com

REM Enable delayed expansion for using variables within variables
Setlocal EnableDelayedExpansion

REM Define system path separator
set SYSTEMSLASH=\

REM Define output directory for timecode converted videos
set OUTPUTDIR=TCconverted
mkdir %OUTPUTDIR%  ; Create output directory if it doesn't exist

REM Loop through all MP4 and MOV files in the current directory
for %%a in (*.MP4 *.MOV) do (
  echo Processing: %%a

  REM Set current file as input
  set FILEINPUT=%%a
  echo Input file: !FILEINPUT!

  REM Create output filename with timestamp prefix in TCconverted directory
  set OUTPUTFILE=!OUTPUTDIR!\TC_!FILEINPUT:~0,-4!.mov

  echo Output file: !OUTPUTFILE!

  REM Initialize timecode variable
  set TIMEVIDEO=0
  echo Current timecode: !TIMEVIDEO!

  REM Extract creation time from video file and store in temporary file
  ffprobe -v quiet -select_streams v:0 -show_entries stream_tags=creation_time -of default=noprint_wrappers=1:nokey=1 "!FILEINPUT!" > timetemp.txt

  REM Read creation time from temporary file
  set /p TIMEVIDEO=<timetemp.txt
  echo Extracted time: %!TIMEVIDEO%!

  REM Extract time portion (YYYY-MM-DDTHH:MM:SS.000000Z format)
  set TIMEVIDEO=!TIMEVIDEO:~11,8!
  echo Timecode: !TIMEVIDEO!

  REM Append frame separator (colon for non-drop frame rates)
  set framewithseparator=:00

  ; Uncomment the following line if the video has a drop frame rate (30000/1001 or 60000/1001)
  ; set framewithseparator=;00

  REM Combine timecode with separator
  set TIMEVIDEO=!TIMEVIDEO!!framewithseparator!
  echo Timecode with separator: !TIMEVIDEO!

  REM Re-encapsulate video with timecode using ffmpeg
  ffmpeg.exe -i "!FILEINPUT!" -timecode "!TIMEVIDEO!" -c:v copy -c:a copy "!OUTPUTFILE!"

  echo Finished processing: !FILEINPUT!
)

del timetemp.txt  ; Delete temporary file
echo All files processed!

pause
