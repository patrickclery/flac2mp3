# Coded by @patrickclery
# MIT License

#!/bin/sh

# Allow env vars
if [ -z "$lame_opts" ]
then
	lame_opts="-b 320"
fi

echo $1

if [ -z "$1" ]
then
	echo "$0: Usage: $0 <flac dir> <output dir>"
	exit 1
fi

# Check dirs
if [ ! -d "$1" ]
then
    echo "$0: $1: Folder doesn't exist"
	exit 1
fi

# Result: DIRNAME [V2]
lame_tag=`echo $lame_opts | tr a-z A-Z| sed 's,-,,g'`
output_dir="`basename "$1"` [$lame_tag]"
mkdir -p "$output_dir" || exit 1

# Loop through and output them all
for flac in "$1"/*.flac
do
	mp3="$output_dir/`basename "$flac" | sed 's,\.flac,\.mp3,g'`"
	flac -c -d "$flac" | lame $lame_opts - "$mp3"
done

# Create SFV/Playlist
cd "$output_dir" || exit 1

cfv -C -f "00 - $output_dir.sfv" *.mp3
ls -1 *.mp3 > "00 - $output_dir.m3u"

