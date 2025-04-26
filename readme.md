# Pocket R

A user-friendly terminal tool for R programming in Termux. Create, edit, run, and debug R scripts, or start an R REPL, all from a simple menu interface.

## Installation

1. Ensure Termux is installed on your Android device from the Google Play Store or F-Droid.
2. Update Termux and install required packages:
   ```bash
   pkg update && pkg upgrade
   pkg install R nano
   ```
3. Download or save `pocketR.sh` to your Termux home directory (`/data/data/com.termux/files/home`):
   - Copy the script content from the source and save it as `pocketR.sh` using a text editor, or
   - Use `wget` or `curl` if available (e.g., `wget <script-url> -O pocketR.sh`).
4. Make the script executable:
   ```bash
   chmod +x pocketR.sh
   ```

## Running the Tool

1. Navigate to your Termux home directory (if not already there):
   ```bash
   cd ~
   ```
2. Run the script:
   ```bash
   ./pocketR.sh
   ```
3. The menu will appear:
   ```
   ======= Pocket R ======= (in cyan)
         Powered by SyntaxTrail
   1. New R Script        
   2. Edit R Script       
   3. Run R Script        
   4. Debug R Script      
   5. Start R REPL        
   6. Exit                
   ======================= 
   Choose an option [1-6]: 
   ```
4. Select an option by entering a number (1-6):
   - **1. New R Script**: Create a new R script with a template.
   - **2. Edit R Script**: Edit an existing R script using nano.
   - **3. Run R Script**: Execute an R script.
   - **4. Debug R Script**: Run an R script with R's `browser()` for debugging.
   - **5. Start R REPL**: Open an interactive R session.
   - **6. Exit**: Quit the tool.

## Features

- Colorful interface with cyan headers, yellow options, blue prompts, green success messages, and red errors.
- Optimized for Termux with correct Rscript path (`/data/data/com.termux/files/usr/bin/Rscript`).
- Uses `nano` as default editor (change via `EDITOR` environment variable, e.g., `export EDITOR=vi`).
- Simple error handling and user prompts.

## Requirements

- Termux on Android.
- R (`pkg install R`).
- Text editor (`nano` recommended, `pkg install nano`).

## Notes

- Grant storage permissions in Termux if needed: `termux-setup-storage`.
- Debug mode temporarily adds `browser()` to scripts for interactive debugging.
- Menu pauses after each action for user confirmation.

## License

MIT License
