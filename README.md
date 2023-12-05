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
#### Customize:

#### Using spine_export.bat (For Windows):
Click the `spine_export.bat` or open it via command prompt. The script will ask you to "Enter the path to a directory containing the Spine projects to export", so enter the path of the target directory, and then press the Enter key to export.


### For MacOS:
**1.Make the script executable**:  
Open Terminal.app, navigate to the directory where your script is located. Use the `chmod +x` command to make your script executable. For example:
```
chmod +x spine_export.sh
```

**2.Run the script**:  
To run your script, drag and drop the `spine_export.sh` into the Terminal window. This will insert the full path of the script file into the Terminal window. Similarly, specify the path to the directory containing the Spine project you wish to export. Then, press the Enter key to execute the script.

If you didn't specify the path to the directory containing the Spine project you wish to export, the script will ask you to "Enter the path to a directory containing the Spine projects to export", so enter the path of the target directory, and then press the Enter key to start exporting.

