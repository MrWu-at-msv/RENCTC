import subprocess
import os

def main():
    """
    RENCTC: Timecode Workaround for Video Files

    This script adds timecode metadata to video files for improved compatibility with
    some software, particularly BlackMagic Design DaVinci Resolve.

    Usage:
        python renctc.py [options] <video_files>

    Options:
        -h, --help      Show this help message and exit
        -o, --output     Output directory for processed files (default: TCconverted)
        -d, --drop      Use drop frame rate separator (semi-colon) for 30000/1001 and 60000/1001 frame rates

    Example:
        python renctc.py *.mp4 *.mov
    """

    import argparse

    parser = argparse.ArgumentParser(description="RENCTC: Timecode Workaround for Video Files")
    parser.add_argument("video_files", nargs="+", help="Video files to process")
    parser.add_argument("-o", "--output", default="TCconverted", help="Output directory")
    parser.add_argument("-d", "--drop", action="store_true", help="Use drop frame rate separator")
    args = parser.parse_args()

    output_dir = args.output
    os.makedirs(output_dir, exist_ok=True)

    frame_separator = ":" if not args.drop else ";"

    for filename in args.video_files:
        print(f"Processing: {filename}")

        basename = os.path.splitext(filename)[0]
        output_file = os.path.join(output_dir, f"TC_{basename}.mov")

        try:
            creation_time = subprocess.check_output(
                ["ffprobe", "-v", "quiet", "-select_streams", "v:0", "-show_entries", "stream_tags=creation_time", "-of", "default=noprint_wrappers=1:nokey=1", filename],
                text=True
            ).strip()

            # Extract time portion (YYYY-MM-DDTHH:MM:SS.000000Z format)
            timecode = creation_time[11:8]

            # Combine timecode with separator
            timecode_with_separator = timecode + frame_separator

            # Re-encapsulate video with timecode using ffmpeg
            subprocess.run(
                ["ffmpeg", "-i", filename, "-timecode", timecode_with_separator, "-c:v", "copy", "-c:a", "copy", output_file],
                check=True
            )

            print(f"Finished processing: {filename}")
        except subprocess.CalledProcessError as e:
            print(f"Error processing {filename}: {e}")

if __name__ == "__main__":
    main()
