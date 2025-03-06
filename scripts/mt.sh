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

# Define paths
base_todo_dir="_TODO"
base_meeting_dir="_Inbox/Meeting Notes"
todo_file="$base_todo_dir/$month/Week $week/${year}${month_num}$(printf "%02d" $day)-todo.md"
template_file="$base_meeting_dir/_template-date-meetingnotes.md"

# Ensure the TODO file exists
if [[ ! -f "$todo_file" ]]; then
    echo "TODO file not found: $todo_file"
    exit 1
fi

# Extract meeting names from the '## Scheduled' section
meetings=()
while IFS= read -r line; do
    meeting_name=$(echo "$line" | sed -n 's/- \[ \] \(.*\)/\1/p')
    if [[ -n "$meeting_name" ]]; then
        meetings+=("$meeting_name")
    fi
done < <(awk '/## Scheduled/{flag=1; next} /## /{flag=0} flag' "$todo_file")

# Process each meeting
for meeting in "${meetings[@]}"; do
    # Format directory and file names
    meeting_slug=$(echo "$meeting" | tr ' ' '-' | tr -cd '[:alnum:]-')
    meeting_dir="$base_meeting_dir/$month/Week $week/${year}${month_num}$(printf "%02d" $day)-$meeting_slug"
    meeting_file="$meeting_dir/$meeting.md"
    
    # Create directory and copy template
    mkdir -p "$meeting_dir"
    if [[ -f "$template_file" ]]; then
        echo "# $formatted_date - $meeting" > "$meeting_file"
        cat "$template_file" >> "$meeting_file"
    fi
    
    # Update TODO file with link - this needs fixing later
    # meeting_link="[$meeting](../_Inbox/Meeting Notes/$month/Week $week/${year}${month_num}$(printf "%02d" $day)-$meeting_slug/$meeting.md)"
    # sed -i "" "s|- \[ \] $meeting|- \[ \] $meeting_link|" "$todo_file"
done
