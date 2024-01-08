# spine_export.sh / spine_export.bat
These scripts can be used for exporting images, video, or skeleton data in JSON or binary format. The scripts look for an export settings file in the same folder as the project file, so each project can be exported differently.

Using a shell script to export many projects at once has many advantages:

- Export any number of project files all at once.
- Your exports always use the correct settings. No need to rely on animators to use the right settings every time.
- Your software's build process can run the export scripts, ensuring every build always has the latest export files. Animators don't need to remember to perform exports after every change to the project files.
- When updating to a newer Spine version, all your projects must be re-exported. When you have scripts setup, this is super easy!

The batch script `spine-export.bat` is for Windows and the Bash shell script `spine-export.sh` is for macOS and Linux.

---

## Script usage
You can watch a video demonstrating how to use the script here:  
**YouTube**: https://youtu.be/pOEx6r_1MqY
[![Screen-Recording-2023-11-29-at-12 12 11_03407](https://github.com/misaki-eymard/custom-spine-scripts/assets/85478846/cb90d05c-ba7d-4c40-96c8-cfe7397649cc)]('https://youtu.be/pOEx6r_1MqY')

---

## How to use
### Make customizations
If you open the script with a text editor, you'll find a "Customization Section" at the top. Here is an excerpt from `spine-export.bat` ( `spine-export.sh` is very similar):
```
:::::::::::::::::::::::::::
:: Customization Section ::
:::::::::::::::::::::::::::


:: Enter the path to the Spine executable.
:: This should be the Spine.com file.
SET SPINE_EXE="C:\Program Files\Spine\Spine.com"


:: Specify the version of Spine Editor you want to use.
:: End with ".XX" to use the latest patch version. For example: 4.1.XX
SET VERSION=4.1.XX


:: Specify the default export format.
:: If "json" or "binary" is specified: JSON or binary export will be performed with default settings.
:: If "json+pack" or "binary+pack" is specified: Texture packing will also be performed with default settings.
:: Alternatively, you can specify the path to an export settings JSON file to use it for the default export settings.
SET DEFAULT_EXPORT=binary+pack


:: Specify the default output directory when exporting in the default format.
:: If the export settings JSON file is found, the output path in it will be used.
SET DEFAULT_OUTPUT_DIR=export


:: Decide whether to perform animation cleanup (true/false).
:: Even if set to 'false,' cleanup will be performed if 'cleanUp' is set to 'true' in the export settings JSON file.
SET CLEANUP=false
```

There are five customizations is available, and the first three settings should be reviewed before running the script:

1. **Path to the Spine executable file:** The path where Spine is installed. By default, a path is specified that assumes the default installation location. If Spine is not found here, the script will look in other common locations. If you have installed Spine in a location other than the default, replace this with the correct path.

2. **Version of the Spine editor to launch:** The version of the Spine editor that you want to use for performing the exports. You can specify the version you want to use. By default, the latest Spine 4.1 will be launched.

3. **Default export:** This script looks for an export settings JSON file in the same folder as the Spine project. If that is not found, it uses the export setting specified here. The default setting is `binary+pack` which exports in binary format and packs a texture atlas. You can specify a specific .export.json file path. For example, if you want to export all animations as PNG sequence images with the same settings, save the export settings as an `.export.json` file and replace this value with the path to that file, avoiding the need to place an export settings JSON file for each Spine project.

5. **Name of the output directory for default export:** By default, a directory named "export" is created in the same hierarchy as the Spine project to be exported, and the output is placed there.

6. **Whether to clean up the animation or not:** Even if set to false, cleanup will be performed if “cleanUp” is true in the export settings JSON file.

---

### Running spine-export.bat
On Windows there are a few ways to run the script:

- Drag and drop a folder on the `spine-export.bat` file.
- Double click the `spine-export.bat` file to open a CMD window, then type or paste a path, or drag and drop a folder on to the CMD window.
- Run the `spine-export.bat` file from a CMD prompt, then type or paste a path, or drag and drop a folder on to the CMD window.
- Run the `spine-export.bat` file from a CMD prompt with a path as the first parameter.
```
spine-export.bat path\to\spine\project\folder
```

The script searches the specified folder and all subfolders. If it finds a `.spine` file it performs an export.

---

### Running spine-export.sh
**1.Make the script executable**:  
Open Terminal, navigate to the directory where it is located, and then grant it permission with this command:
```
chmod +x spine_export.sh
```

**2.Run the script**:  
To run the script, specify "./spine-export.sh" and then the path to the directory containing the Spine project you wish to export. For example:
```
./spine-export.sh /path/to/spine/project/directory/
```

If you do not specify a path when executing the script, the script will prompt for a path to be entered.

The script searches the specified directory and all subdirectories. If it finds a `.spine` file it performs an export.

---

# Script Details

You are welcome to modify the script to meet your needs. We have written comments in the script to describe everything it does and more details can also be found below.

## Find .spine projects
In this script, the following code generates a temporary file and stores the path in “tmp_file”:
```
# Save .spine files to a temporary file.
tmp_file=$(mktemp)
```

The subsequent code recursively searches for files with a ".spine" extension and records them in the temporary file created earlier:
```
# Search recursively for files with extension ".spine".
find "$search_dir" -type f -name "*.spine" > "$tmp_file"
```

This process compiles a list of discovered Spine projects.

Then, encapsulating the export procedure, the script reads the contents of the temporary file line by line into `file_path`. The operations within the while...do block are repeated until all Spine projects listed in the temporary file have been processed:
```
while IFS= read -r file_path; do
　　　　...
done < "$tmp_file"
```

The initial segment of the while statement outputs a message, updating the script executor on the number of processed Spine projects and the location of the current export:
```
	spine_file_count=$((spine_file_count + 1))

	# Calculate the relative path from $search_dir.
	relative_path="${file_path#$search_dir/}"

	echo "================================================================================"
	echo "#$spine_file_count : $relative_path"
```

Then, the parent directory of the `.spine` file is stored in `parent_path`:
```
	# Set parent_path to the .spine file's parent directory.
	parent_path="$(dirname "$file_path")"
```

The following part finds for files with the extension `.export.json` in the same directory as the `.spine file`, and if found, adds them to the `json_files` array:
```
	# Initialize the json_files array.
	json_files=()

	# Enable nullglob.
	shopt -s nullglob

	# Find .export.json files within the specified directory and add them to the json_files array.
	for json_file in "$parent_path"/*.export.json; do
		json_files+=("$json_file")
	done

	# Disable nullglob.
	shopt -u nullglob
```

The reason nullglob is enabled before the loop process of adding the `json_file` to the `json_files` array is that if no `.export.json` file is found in that directory, the loop will proceed leaving it empty.

After that, the process diverges depending on whether the contents of the json_files array are 2 or more, one, or zero. If 2 or more, the script informs that multiple `.export.json` files were found and the export is performed, counting the number of times the export was performed.
If zero, the script informs that the export will be performed with default settings and the export is performed.
```
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
			echo "The '.export.json' file does not appear to be export settings JSON. Default settings ('$DEFAULT_EXPORT') will be used for export."
			exportUsingDefaultSettings "$parent_path" "$file_path"
		fi
	else
		echo "No '.export.json' files were found in the same directory as the Spine project. Default settings ('$DEFAULT_EXPORT') will be used for export."
		exportUsingDefaultSettings "$parent_path" "$file_path"
	fi
```

If one or more `.export.json` files are found, the contents of the JSON file are checked with the function `isValidExportJson`:
```
isValidExportJson () {
	local json_file="$1"
	local export_type=$(grep 'class":\s*"export-.*"' "$json_file")
	# Check if '"class": "export-"' is found, return 1 if not.
	if [[ -z "$export_type" ]] ; then
		return 1
	else
		return 0
	fi
}
```

This process checks that the parameter "class" exists in the `.export.json` file and that the value begins with "export-". It returns 0 (success) if the parameter is found, and 1 (error) if not.

If it is not a valid `.export.json`, skip that export if more than one `.export.json` is found. If only that `.export.json` is found, the export is performed with default settings.

## Exporting a found .spine project
The script contains two primary functions: `exportUsingJsonSettings()` and `exportUsingDefaultSettings()`.
Upon finding a file with a `.spine` extension,  `exportUsingJsonSettings()` is called when a valid `.export.json` file is present in the same directory. Conversely, if the file is not found, `exportUsingDefaultSettings()` is called.

### exportUsingDefaultSettings()
```
exportUsingDefaultSettings () {
	local parent_path="$1"
	local file_path="$2"

	local command_args=("--update" "$VERSION" "--input" "$file_path")

	# Add the -m option if CLEANUP is set to "true".
	if [ "$CLEANUP" = "true" ]; then
		command_args+=("--clean")
	fi

	# Add other output and export options.
	command_args+=("--output" "$parent_path/$DEFAULT_OUTPUT_DIR" "--export" "$DEFAULT_EXPORT")
	if "$SPINE_EXE" "${command_args[@]}"; then
		echo "Exported to the following directory: $parent_path/$DEFAULT_OUTPUT_DIR"
	else
		export_error_count=$((export_error_count + 1))
		echo "Export failed."
	fi
}
```

This function requires the arguments `parent_path` and `file_path` when called. `parent_path` is the path to the parent directory of the found `.spine` file. `file_path` is the path of the `.spine` file.

The array `command_args` stores the Spine version, the path to the Spine project for export, the output directory path, and the export settings JSON path. This means that the bolded segments in the following commands are grouped together in `command_args`:

Spine **--update (Version number) -i (Path to the SpineProject file) -o (Path to the output directory) -e (Export settings)**

The command "${command_args[@]}" passes these commands to the Spine executable for the execution of the export process.

Upon completion of the export, the script notifies that it has exported in the same directory as the Spine project and then concludes the loop.

### exportUsingJsonSettings()
*The same parts as in exportUsingDefaultSettings() are omitted in this explanation.

The following line extracts the value of the "output" parameter from the `.export.json` file and stores it in the `output_path` variable:
```
	output_path=$(sed -n 's/"output".*"\([^"]*\)"/\1/p' "$json_file" | sed -r 's/\\\\/\\/g' | sed -r 's/,$//g' )
```

If the output path specified in the `.export.json` file is invalid, Spine will return an error. The following part counts this error, finds an alternative possible output path, and performs the export:
```
	if "$SPINE_EXE" "${command_args[@]}"; then
		echo "Exported to the following directory: $output_path"
	else
		export_error_count=$((export_error_count + 1))
		parent_path=$(dirname "$file_path")
		output_path="$parent_path/$DEFAULT_OUTPUT_DIR"
		echo "Export failed. Exporting to default output directory $output_path."

		command_args_fallback+=("--output" "$output_path" "--export" "$json_file")
		if "$SPINE_EXE" "${command_args_fallback[@]}"; then
			echo "Exported to the following default output directory: $output_path"
		else
			echo "Export to default output directory failed."
		fi
	fi
```

Upon completion of the export, the script notifies the specified output directory in the .export.json file that the file has been exported, and then exits the loop.

### End of loop
By default, the script waits for a keystroke, but if you do not need this, comment out the following line:
```
read -n 1 -s -r -p "Press any key to exit."
```
