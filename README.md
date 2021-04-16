# RENCTC
!!!!ATTENTION - this is not replacement for a proper timecode on your fottage, is just a workaround for compatibility with some software.
If you need sync or a proper timecode use cameras that make proper TC or Timecode generators.!!!!

A simple batch script to re encapsulate a video file adding Time Code into  metadata using FFMPEG
RENCapsulate with TimeCode
very simple script to rencapsulate video file adsding time code based on the original encoding data using ffprobe and ffmpeg 
working on Windows Batch with ffprobe and ffmpeg (must be in the same directory than the the script)

only work with non drop time code,
for drop time code (frame rate  30000/1001 and 60000/1001) separator must be changed from : to ; in line 41 as describet on ffmpeg documentation: http://ffmpeg.org/ffmpeg.html#toc-Advanced-options

This is very useful to avoid many issues in BlackMagic Design DaVinci Resolve Software with footage that don't have the metadata TimeCode like most of DSRL, mirrorless, smartphone, drone camera and more.
