#!/bin/bash
width=500
quality=98 #0-100
rename_to_gif=no
output_dir=~/pix
shopt -s extglob
error_and_exit() {
    case $1 in
        -f ) echo "$2 is not a valid format." 1>&2 ;;
         * ) echo "$1" 1>&2
    esac
    exit 1
}
time_parse() {
    if [[ $1 =~ ^([0-9]{2}:){2}[0-9]{2}\.[0-9]{3}$ ]]; then
        echo $1
    elif [[ $1 =~ ^([0-9]{2}:){2}[0-9]{2}$ ]]; then
        echo ${1}.000
    elif [[ $1 =~ ^([0-9]{1,2}:){2}[0-9]{1,2}$ ]]; then
        IFS=: read F1 F2 F3 <<< $1
        printf '%02d:%02d:%02d.%s\n' $F1 $F2 $F3 000
    elif [[ $1 =~ ^([0-9]{1,2}:){2}[0-9]{1,2}\.[0-9]{1,3}$ ]]; then
        IFS=:. read F1 F2 F3 F4 <<< $1
        printf '%02d:%02d:%02d.%03d\n' $F1 $F2 $F3 $F4
    else
        return 1
    fi
}
if [[ $# -lt 3 ]]; then
    echo "$(basename $0) <video file> <start time> <end time> [options]"
    printf '\n%s\n' Options:
    printf '\e[36m%s\e[0m, \e[36m%-11s\e[0m%s\n' -c --crop     "Set custom crop dimensions"
    printf '\e[36m%s\e[0m, \e[36m%-11s\e[0m%s\n' -t --time     'Set time for auto cropping'
    printf '\e[36m%s\e[0m, \e[36m%-11s\e[0m%s\n' -q --quality  'Set quality (default is 98)'
    printf '\e[36m%s\e[0m, \e[36m%-11s\e[0m%s\n' -p --pendulum 'Reverse the animation back on itself'
    printf '\e[36m%s\e[0m, \e[36m%-11s\e[0m%s\n' -m --morph    'Morph the first and last frame together'
    exit 1
fi
[[ -f $1 ]] && file="$1" || error_and_exit "$1 is not a file."
start=$(time_parse $2) || error_and_exit -f "$2"
  end=$(time_parse $3) || error_and_exit -f "$3"
shift 3
options=$(getopt -l crop:,time:,pendulum,quality:,morph -o c:t:pq:m -- "$@") || exit 1
eval set -- "$options"
while [[ $# -gt 0 ]]; do
    case $1 in
        --crop | -c )
        [[ $2 =~ ^([0-9]{1,4}:){3}[0-9]{1,4}$ ]] || error_and_exit -f "$2"
        crop=crop=${2},
        shift 2
        ;;
        --time | -t )
        detect_time=$(time_parse $2) || error_and_exit -f "$2"
        crop=$(ffmpeg -ss $detect_time -i "$file" -t 1 -filter:v cropdetect -f null - 2>&1 | awk '/crop=/ {print $NF}' | tail -1),
        shift 2
        ;;
        --pendulum | -p )
        pendulum='[0:v]trim=start_frame=1[t];[0:v]reverse[r];[t][r]concat,'
        unset morph frames
        shift
        ;;
        --quality | -q )
        [[ $2 != +([0-9]) || $2 -gt 100 ]] && error_and_exit -f "$2"
        quality=$2
        shift 2
        ;;
        --morph | -m )
        IFS=^ read fps mode < <(mediainfo --Inform='Video;%FrameRate%^%FrameRate_Mode%' "$file")
              [[ $mode ]] || error_and_exit "FPS mode is not defined."
        [[ $mode = CFR ]] || error_and_exit "$mode is not supported."
        awk -F'[:. ]' '
        {
        start = ($1 + 3600 + $2 * 60 + $3) "." $4
          end = ($5 + 3600 + $6 * 60 + $7) "." $8
          fps = $9 "." $10
        print "Estimate: " ((end - start) * fps)
        }
        ' <<< "$start $end $fps"
        read -p 'Frames? ' frames
        [[ $frames = +([0-9]) ]] || error_and_exit -f "$frames"
        start_frame=$((frames - 2))
          end_frame=$frames
        morph="[0:v]trim=end_frame=2[a];[0:v]trim=start_frame=${start_frame}:end_frame=${end_frame}[b];[0:v]trim=end_frame=${end_frame}[c];[b][a]concat,minterpolate=fps=${fps}:scd=none,trim=start_frame=3,setpts=PTS-STARTPTS,[c]concat,"
        unset pendulum
        shift
        ;;
        -- )
        shift
        ;;
        * )
        exit 1
    esac
done
[[ $frames ]] && specs=${quality}_${frames} || specs=$quality
filter="${pendulum}${morph}${crop}scale=w=${width}:h=-1"
  name="${file##*/}"
output="${output_dir}/${name%.*}_${specs}_${start}_${end}.webp"
ffmpeg -v error -y -ss $start -to $end -i "$file" -filter_complex $filter -loop 0 -q:v $quality -compression_level 6 -preset default "$output" || exit 1
[[ $rename_to_gif = yes ]] && mv "$output" "${output%.*}.gif"
