#!/bin/bash


###########################
## Customization Section ##
###########################

# Enter the path to the Spine executable.
# On Windows this should be the Spine.com file.
SPINE_EXE="C:/Program Files/Spine/Spine.com"

# Specify the version of Spine Editor you want to use.
# End with ".XX" to use the latest patch version. For example: 4.1.XX
VERSION="4.1.XX"

# Specify the default export format.
# If "json" or "binary" is specified: JSON or binary export will be performed with default settings.
# If "json+pack" or "binary+pack" is specified: Texture packing will also be performed with default settings.
# Alternatively, you can specify the path to an export settings JSON file to use it for the default export settings.
DEFAULT_FORMAT="binary+pack"

# Specify the default output directory when exporting in the default format.
# If the export settings JSON file is found, the output path in it will be used.
DEFAULT_OUTPUT_DIR="export"

# Define whether to perform animation cleanup (true/false).
# Even if set to 'false,' cleanup will be performed if 'cleanUp' is set to 'true' in the export settings JSON file.
CLEANUP="false"

# Enter the path to the jq executable.
JQ_EXE="/usr/bin/jq"

##################
## Begin Script ##
##################

set -e

if [ ! -f "$SPINE_EXE" ]; then
   SPINE_EXE="/mnt/c/Program Files/Spine/Spine.com"
	if [ ! -f "$SPINE_EXE" ]; then
		SPINE_EXE="/cygdrive/C/Program Files/Spine/Spine.com"
		if [ ! -f "$SPINE_EXE" ]; then
			SPINE_EXE="/Applications/Spine.app/Contents/MacOS/Spine"
		fi
	fi
fi

# Check if the Spine editor executable was found.
if [ ! -f "$SPINE_EXE" ]; then
	echo "Error: Spine editor executable was not found."
	echo "Edit the script and set the 'SPINE_EXE' path."
	exit 1
fi

# Check if 'jq' is available.
jq_names=("jq" "jq-win64" "jq-win32")
if [ ! -f "$JQ_EXE" ]; then
	for jq_name in "${jq_names[@]}"; do
		if command -v $jq_name &> /dev/null; then
			JQ_EXE=`command -v $jq_name`
			break
		fi
	done
fi
if [ ! -f "$JQ_EXE" ]; then
	jq_dirs=("/usr/bin/" "C:/Program Files/Git/usr/bin/")
	for dir in "${jq_dirs[@]}"; do
		for name in "${jq_names[@]}"; do
			if [ -f "$dir$name" ]; then
				JQ_EXE="$dir$name"
				break 2
			fi
		done
	done
fi
if [ ! -f "$JQ_EXE" ]; then
	echo "Error: JQ executable was not found."
	echo "Install JQ or edit the script and set the 'JQ_EXE' path."
	exit 1
fi

search_dir="$1"
if [ "$#" -eq 0 ]; then
	echo "Enter the path to a directory containing the Spine projects to export:"
	read search_dir
fi

echo "Spine: $SPINE_EXE"
echo "JQ: $JQ_EXE"
echo "Path: $search_dir"

exportUsingJsonSettings () {
	local json_file=$1
	local file_path=$2

	# Extract the value of the "output" parameter within JSON data using 'jq'.
	output_path=$("$JQ_EXE" -r '.output' "$json_file")

	# Check if the output path exists.
	if [ ! -e "$output_path" ]; then
		directory_path="$(dirname "$file_path")"
		output_path=$directory_path/$DEFAULT_OUTPUT_DIR
    	echo "The path specified in the "output" parameter within JSON data does not exist. Export to default output directory: $output_path"
	fi

	# Add the appropriate parameters to the 'command_args' array.
	command_args=("--update" "$VERSION" "--input" "$file_path")

	# Add the -m option if CLEANUP is set to "true".
	if [ "$CLEANUP" = "true" ]; then
		command_args+=("--clean")
	else
		# Even if CLEANUP is set to 'false,' cleanup will be performed if 'cleanUp' is set to 'true' in the export settings JSON file.
		cleanUp=$("$JQ_EXE" -r '.cleanUp' "$json_file")
		if [ "$cleanUp" = "true" ]; then
		command_args+=("--clean")
		fi
	fi

	# Add other options
	command_args+=("--output" "$output_path" "--export" "$json_file")

	"$SPINE_EXE" "${command_args[@]}"
	echo "Exported to the following directory: $output_path"
}

exportUsingDefaultSettings () {
	local directory_path="$1"
	local file_path="$2"

	local command_args=("--update" "$VERSION" "--input" "$file_path")

	# Add the -m option if CLEANUP is set to "true".
	if [ "$CLEANUP" = "true" ]; then
		command_args+=("--clean")
	fi

	# Add other output and export options.
	command_args+=("--output" "$directory_path/$DEFAULT_OUTPUT_DIR" "--export" "$DEFAULT_FORMAT")
	"$SPINE_EXE" "${command_args[@]}"
	echo "Exported to the following directory: $directory_path/$DEFAULT_OUTPUT_DIR"
}

isValidExportJson () {
	local json_file="$1"
	if "$JQ_EXE" -e '.class | contains("export-")' "$json_file" >/dev/null; then
		return 0
	else
		return 1
	fi
}

# Count the .spine files found.
spine_file_count=0

# Save .spine files to a temporary file.
tmp_file=$(mktemp)

# Search recursively for files with extension ".spine".
find "$search_dir" -type f -name "*.spine" > "$tmp_file"

# Check if there are files with extension ".spine" within the specified directory.
while IFS= read -r file_path; do
	spine_file_count=$((spine_file_count + 1))

	# Calculate the relative path from $search_dir.
	relative_path="${file_path#$search_dir/}"

	echo "================================================================================"
	echo "#$spine_file_count : $relative_path"

	# Set directory_path to the .spine file's parent directory.
	directory_path="$(dirname "$file_path")"

	# Initialize the json_files array.
	json_files=()

	# Enable nullglob.
	shopt -s nullglob

	# Find .export.json files within the specified directory and add them to the json_files array.
	for json_file in "$directory_path"/*.export.json; do
		json_files+=("$json_file")
	done

	# Disable nullglob.
	shopt -u nullglob

	if [ ${#json_files[@]} -ge 2 ]; then
		echo "Multiple '.export.json' files were found:"

		# Get the length of the json_files array.
		json_file_count=${#json_files[@]}

		# Count the export operations.
		export_count=0
		# Process each .export.json.
		for json_file in "${json_files[@]}"; do
			if isValidExportJson "$json_file"; then
				echo "--------------------------------------------------------------------------------"
				export_count=$((export_count + 1))

				# Calculate the relative path from $search_dir.
				relative_json_path="${json_file#$search_dir/}"
				echo "($export_count/$json_file_count) Exporting with the export settings JSON file: $relative_json_path"
				exportUsingJsonSettings "$json_file" "$file_path"
			else
				echo "The '.export.json' file does not appear to be export settings JSON. This file will be skipped."
			fi
		done
	elif [ ${#json_files[@]} -eq 1 ]; then
		# Process the .export.json file.
		json_file=${json_files[0]}
		if isValidExportJson "$json_file"; then
			relative_json_path="${json_file#$search_dir/}"
			echo "Exporting with the export settings JSON file: $relative_json_path"
			exportUsingJsonSettings "$json_file" "$file_path"
		else
			echo "The '.export.json' file does not appear to be export settings JSON. Default settings ('$DEFAULT_FORMAT') will be used for export."
			exportUsingDefaultSettings "$directory_path" "$file_path"
		fi
	else
		echo "No '.export.json' files were found in the same directory as the Spine project. Default settings ('$DEFAULT_FORMAT') will be used for export."
		exportUsingDefaultSettings "$directory_path" "$file_path"
	fi
done < "$tmp_file"

# Delete the temporary file.
rm "$tmp_file"

echo "================================================================================"

if [ $spine_file_count -eq 0 ]; then
	echo "Error: No files with the '.spine' extension were found."
	echo "================================================================================"
	exit 1
else
	echo "Exporting complete."
	echo "================================================================================"
fi

# Wait 1 second before script completes.
sleep 1