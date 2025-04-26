# Pocket R

A colorful, user-friendly terminal tool for R programming in Termux, powered by SyntaxTrail. Create, edit, run, and debug R scripts, start an R REPL, or interact with a Node.js API for R execution.

## Installation

1. Ensure Termux is installed on your Android device from F-Droid (Google Play version is outdated).
2. Update Termux and install required packages:
   ```bash
   pkg update && pkg upgrade
   pkg install root-repo
   pkg install x11-repo
   pkg install git nodejs curl nano net-tools
   ```
   Verify R installation (should be installed via `run.sh` if not present):
   ```bash
   R --version
   ```
3. Clone the Pocket R repository:
   ```bash
   git clone https://github.com/SafwanGanz/pocketR
   ```
4. Navigate to the cloned repository:
   ```bash
   cd pocketR
   ```
5. Make scripts executable:
   ```bash
   chmod +x pocketR.sh run.sh
   ```

## Running the Tool

### Option 1: Automated Setup with API and Tool
1. Run the setup script to install dependencies, start the API, and launch the tool:
   ```bash
   ./run.sh
   ```
   - Installs `r-base`, `nodejs`, `curl`, `nano`, `net-tools`, and npm packages (`express`, `r-integration`).
   - Starts the Node.js API on `http://localhost:3000`.
   - Automatically launches `pocketR.sh`, displaying the menu:
     ```
     ======= Pocket R ======= (in cyan)
      Powered by SyntaxTrail  (in cyan)
     1. New R Script        (in yellow)
     2. Edit R Script       (in yellow)
     3. Run R Script        (in yellow)
     4. Debug R Script      (in yellow)
     5. Start R REPL        (in yellow)
     6. Run API Command     (in yellow)
     7. Exit                (in yellow)
     ======================= (in cyan)
     Choose an option [1-7]: (in blue)
     ```

### Option 2: Run the Tool Without API
1. Run the interactive tool directly:
   ```bash
   ./pocketR.sh
   ```
2. Options 1-5 and 7 are available; option 6 (Run API Command) requires the API to be running via `run.sh`.

## API Usage

The Node.js API (powered by `r-integration`) runs on `http://localhost:3000` and provides two endpoints:
- **POST /run-command**: Execute an R command.
  ```bash
  curl -X POST -H "Content-Type: application/json" -d '{"command":"max(1,2,3)"}' http://localhost:3000/run-command
  ```
  Response: `{"result":["3"]}`
- **POST /run-script**: Execute an R script.
  ```bash
  curl -X POST -H "Content-Type: application/json" -d '{"scriptPath":"myscript.R"}' http://localhost:3000/run-script
  ```

## Features

- Colorful interface with cyan headers, yellow options, blue prompts, green success messages, and red errors.
- Optimized for Termux with correct Rscript path (`/data/data/com.termux/files/usr/bin/Rscript`).
- Uses `nano` as default editor (change via `EDITOR` variable, e.g., `export EDITOR=vi`).
- API integration with Node.js and `r-integration` for remote R execution.
- Automated setup and hosting via `run.sh`, which launches `pocketR.sh` upon success.
- Powered by SyntaxTrail for enhanced script execution.

## Requirements

- Termux on Android (F-Droid version recommended).
- R (installed via `run.sh` or manually).
- Node.js and npm (`pkg install nodejs`).
- Curl (`pkg install curl`).
- Nano (`pkg install nano`).
- Net-tools (`pkg install net-tools`).

## Notes

- Grant storage permissions in Termux if needed: `termux-setup-storage`.
- Debug mode temporarily adds `browser()` to scripts for interactive debugging.
- Ensure `server.js`, `pocketR.sh`, and `run.sh` are in the `pocketR` directory.
- API requires `run.sh` to be executed first to start the server.
- If port 3000 is in use, check and kill conflicting processes:
  ```bash
  lsof -i :3000
  kill <pid>
  ```
- If `npm install` fails, clear the cache and retry:
  ```bash
  npm cache clean --force
  npm install express r-integration
  ```

## Troubleshooting

- **R Installation Issues**:
  If R is not installed, `run.sh` will attempt to install it. Manually install if needed:
  ```bash
  pkg install r-base
  ```
- **API Not Starting**:
  Verify the API is running:
  ```bash
  netstat -tuln | grep ":3000"
  ```
  If not, restart with `./run.sh`.
- **Termux Version**:
  Use the F-Droid version of Termux for the latest package support.

## License

MIT License
