# spine_export.sh / spine_export.bat
These scripts enable efficient Spine skeleton export by searching for Spine projects and export settings JSON files under a specified directory, including sub-folders. They provide the capability to export multiple Spine projects in a single script run.

For Windows, the batch script "spine_export.bat" is available. For macOS/Linux, the Bash shell script "spine_export.sh" is provided, and it can also be utilized on Windows if you have a Bash-capable environment, such as GitBash, installed.

These scripts support all the export formats available in the Spine editor, including JSON (+ pack texture atlas), Binary (+ pack texture atlas), GIF, PNG, APNG, WEBP, AWEBP, PSD, JPEG, AVI, MOV, and WEBM.

---

## Script usage
You can watch a video demonstrating how to use the script here:  
**YouTube**: https://youtu.be/pOEx6r_1MqY
[![Screen-Recording-2023-11-29-at-12 12 11_03407](https://github.com/misaki-eymard/custom-spine-scripts/assets/85478846/cb90d05c-ba7d-4c40-96c8-cfe7397649cc)]('https://youtu.be/pOEx6r_1MqY')

---

## How to use
### Customize:
This script has a Customization Section at the beginning. You can use the script after replacing the values of the customizations as needed. The following is the code in the `spine_export.sh`, but a similar customization section is also in `spine_export.bat`:
```
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
```

**There are five customizations is available:**

1. **Path to the Spine executable:** By default, a path is specified, assuming the default installation location on a Windows PC. If not found, it will search for other potential paths or the default installation destination on macOS. If Spine is installed to a different location, replace this with the correct path.

2. **Version of Spine to launch:** You can specify the version you would like to use. By default, the latest Spine 4.1 will be launched.

3. **Default export format:** This script uses the export settings JSON file in the same directory as the Spine project if available; otherwise it exports in the format specified here. The default setting is "binary+pack," exporting in binary format and packing textures. You can specify a specific .export.json file path. For example, if you want to export all animations as PNG sequence images with the same settings, save the export settings as an .export.json file and replace this value with the path to that file, avoiding the need to place an export settings JSON file for each Spine project.

4. **Name of the output directory when exporting with default settings:** By default, a directory named "export" is created in the same hierarchy as the Spine project to be exported, and the output is placed there.

5. **Whether to clean up the animation or not:** Even if set to false, cleanup is performed if “cleanUp” is true in the export settings JSON file.

---

### Using spine_export.bat (For Windows):
Click the `spine_export.bat` or open it via command prompt. The script will ask you to "Enter the path to a directory containing the Spine projects to export", so enter the path of the target directory, and then press the Enter key to export.

---

### For MacOS:
**1.Make the script executable**:  
Open Terminal.app, navigate to the directory where your script is located. Use the `chmod +x` command to make your script executable. For example:
```
chmod +x spine_export.sh
```

**2.Run the script**:  
To run your script, drag and drop the `spine_export.sh` into the Terminal window. This will insert the full path of the script file into the Terminal window. Similarly, specify the path to the directory containing the Spine project you wish to export. Then, press the Enter key to execute the script.

If you didn't specify the path to the directory containing the Spine project you wish to export, the script will ask you to "Enter the path to a directory containing the Spine projects to export", so enter the path of the target directory, and then press the Enter key to start exporting.

