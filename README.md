# spine_export.sh / spine_export.bat
Example scripts for exporting Spine skeletons with the version specified in the `VERSION` variable. The script searches for Spine projects under the specified folder and if a JSON file with the extension `.export.json` is found at the same level as the Spine project, the script uses it during export, otherwise it uses the default settings. The default export settings can be changed by opening the script and changing the `DEFAULT_FORMAT` variable parameter.

This script allows you to export the Spine projects you want to export without having to specify each one, as long as they are collected under a specific folder. It is especially useful if you want to upgrade the version of the Spine Editor and you need to re-export all your existing Spine projects in that version.

## Script usage scenarios
You can watch a video demonstrating how to use the script here:  
**YouTube**: https://youtu.be/pOEx6r_1MqY
[![Screen-Recording-2023-11-29-at-12 12 11_03407](https://github.com/misaki-eymard/custom-spine-scripts/assets/85478846/cb90d05c-ba7d-4c40-96c8-cfe7397649cc)]('https://youtu.be/pOEx6r_1MqY')

## Why this script was created
Although there is an example export script (https://github.com/EsotericSoftware/spine-runtimes/blob/4.1/examples/export/export.sh), this one requires add the project paths to be exported one by one to the script, so I thought it would be nice to have an example script that can automatically search for the export target and export settings JSON and export it. (I know this would not have been that difficult for people with programming knowledge, but I wanted to have something easy to use for beginners.)

## Requirements

This script requires **jq** to be installed. If you do not install it, you will get an error saying "Error: 'jq' is not installed. Please install 'jq' and retry".

### What is 'jq'?

'jq' is a lightweight and versatile command-line utility for processing and manipulating JSON data. It allows you to extract, filter, format, and transform JSON data in a variety of ways. jq' is often used for tasks such as selecting specific fields from JSON objects, searching and filtering JSON structures, and pretty-printing JSON content for easier human readability. It's a powerful tool for working with JSON data in scripts and command-line environments.

In this script, 'jq' is used to read the contents of JSON at the same level as the Spine project, determine whether or not the JSON is Spine's export settings JSON, and extract the `output` or `cleanUp` property specified in it.

#### For Windows:
**Using [chocolatey](https://chocolatey.org/)(windows package manager)**
1. Open command prompt.
2. Install 'jq' by running the following command:
```
choco install jq
```

**Withouht chocolatey**
1. Visit the official jq website: https://github.com/jqlang/jq/releases
2. Scroll down to `Assets`.
3. Select the appropriate binary version for your system (e.g., 32-bit or 64-bit) to download `jq`.
4. Extract the 'jq.exe' executable from the downloaded archive.
5. Place 'jq.exe' in a directory included in your system's PATH variable. (e.g. C:\bin)


#### For MacOS (via Homebrew):
1. Open your Terminal.
2. Install 'jq' by running the following command:
```
brew install jq
```
This will install 'jq' on your MacOS system using Homebrew. If you have not yet installed Homebrew, please follow this page to install it: https://brew.sh/ja/  
Installing without Homebrew is quite complicated, so this is the recommended way.

## How to use
#### For Windows:

##### Using spine_export.bat:
Click the `spine_export.bat` or open it via command prompt. The script will ask you to "Enter the path to a directory containing the Spine projects to export", so enter the path of the target directory, and then press the Enter key to export.

##### Using spine_export.sh:
You can run "spine_export.sh" in a Bash environment such as Git Bash.

**Run script using GitBash**:  
When Git Bash is installed, it automatically associates itself with Bash shell scripts. As a result, you can conveniently run a Bash shell script by simply double-clicking its file in File Explorer. The script will ask you to "Enter the path to a directory containing the Spine projects to export", so enter the path of the target directory, and then press the Enter key to start exporting.

### For MacOS:
**Make the script executable**:  
In the Terminal.app, navigate to the directory where your script is located. Use the `chmod +x` command to make your script executable. For example:
```
chmod +x <The path to the directory where this script is located>/spine_export.sh
```
This procedure is only required the first time and is not required the next time.  

**Run the script**:  
To run your script, drag and drop the `spine_export.sh` into the Terminal window. This will insert the full path of the script file into the Terminal window. Similarly, specify the path to the directory containing the Spine project you wish to export. Then, press the Enter key to execute the script.

If you didn't specify the path to the directory containing the Spine project you wish to export, the script will ask you to "Enter the path to a directory containing the Spine projects to export", so enter the path of the target directory, and then press the Enter key to start exporting.

