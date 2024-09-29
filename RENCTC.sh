#!/bin/bash

# Script information
echo "RENCTC: Timecode Workaround for Video Files"
echo "Version: 0.01 - April 10, 2021"
echo "By Paolo Rudelli"
echo "GPL license V3: http://www.gnu.org/licenses/gpl.txt"
echo "For updates, check: https://github.com/MrWu-at-msv/RENCTC"
echo "For bugs, email: info@paolorudelli.com"

# Set variables
OUTPUT_DIR="TCconverted"
mkdir -p "$OUTPUT_DIR"  # Create directory with -p flag for parents

# Loop through video files
for file in *.MP4 *.MOV; do
  echo "Processing: $file"

  # Extract filename without extension
  filename="${file%.*}"
  output_file="$OUTPUT_DIR/TC_$filename.mov"

  # Get creation time
  creation_time=$(ffprobe -v quiet -select_streams v:0 -show_entries stream_tags=creation_time -of default=noprint_wrappers=1:nokey=1 "$file")

  # Extract time portion (YYYY-MM-DDTHH:MM:SS.000000Z format)
  time_video=${creation_time:11:8}

  # Append separator for non-drop frame rates
  frame_separator=:00

  # Set separator for drop frame rates (30000/1001, 60000/1001) - uncomment if needed
  #frame_separator=;00

  time_video="$time_video$frame_separator"

  # Re-encapsulate with timecode
  ffmpeg -i "$file" -timecode "$time_video" -c:v copy -c:a copy "$output_file"

  echo "$file processed successfully!"
done

# Clean up
rm -f timetemp.txt  # Remove temporary file (assuming it's not needed)

echo "All files processed!"
