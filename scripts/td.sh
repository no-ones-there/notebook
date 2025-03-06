#!/bin/bash

# Get the current date information
day_name=$(date +"%A")
day=$(date +"%-d")
month=$(date +"%B")
year=$(date +"%Y")
month_num=$(date +"%m")

# Determine the ordinal suffix
case "$day" in
    1|21|31) suffix="st" ;;
    2|22) suffix="nd" ;;
    3|23) suffix="rd" ;;
    *) suffix="th" ;;
esac

# Format the date string
formatted_date="$day_name $day$suffix $month"

# Calculate the week number
week=$(( ($(date +"%-d") - 1) / 7 + 1 ))

# Define folder structure
base_dir="_TODO"
month_folder="$base_dir/$month"
week_folder="$month_folder/Week $week"
mkdir -p "$week_folder"

# Define file paths
template_file="$base_dir/_template-date-todo.md"
target_file="$week_folder/${year}${month_num}$(printf "%02d" $day)-todo.md"

# Copy and modify template
if [[ -f "$template_file" ]]; then
    echo "# $formatted_date" > "$target_file"
    cat "$template_file" >> "$target_file"
fi
