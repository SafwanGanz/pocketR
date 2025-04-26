#!/bin/bash

EDITOR=${EDITOR:-nano}
R_BIN=$(which R)
RSCRIPT_BIN=$(which Rscript)

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

if [ -z "$R_BIN" ] || [ -z "$RSCRIPT_BIN" ]; then
    echo -e "${RED}Error: R is not installed. Install R with 'pkg install R'.${NC}"
    exit 1
fi

show_menu() {
    clear
    echo -e "${CYAN}======= Pocket R =======${NC}"
    echo -e "${YELLOW}1. New R Script${NC}"
    echo -e "${YELLOW}2. Edit R Script${NC}"
    echo -e "${YELLOW}3. Run R Script${NC}"
    echo -e "${YELLOW}4. Debug R Script${NC}"
    echo -e "${YELLOW}5. Start R REPL${NC}"
    echo -e "${YELLOW}6. Exit${NC}"
    echo -e "${CYAN}=======================${NC}"
    echo -e -n "${BLUE}Choose an option [1-6]: ${NC}"
}

new_script() {
    echo -e -n "${BLUE}Enter script name (e.g., myscript.R): ${NC}"
    read filename
    if [ -f "$filename" ]; then
        echo -e "${RED}Error: File '$filename' already exists.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    cat << EOF > "$filename"
#!/data/data/com.termux/files/usr/bin/Rscript
main <- function() {
    cat("Hello from Pocket R!\n")
}
if (!interactive()) {
    tryCatch({
        main()
    }, error = function(e) {
        cat("Error:", conditionMessage(e), "\n")
        traceback()
        quit(status=1)
    })
}
EOF
    chmod +x "$filename"
    echo -e "${GREEN}Created: $filename${NC}"
    $EDITOR "$filename"
    read -p "Press Enter to continue..."
}

edit_script() {
    echo -e -n "${BLUE}Enter script name: ${NC}"
    read filename
    if [ ! -f "$filename" ]; then
        echo -e "${RED}Error: File '$filename' does not exist.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    $EDITOR "$filename"
    echo -e "${GREEN}Finished editing: $filename${NC}"
    read -p "Press Enter to continue..."
}

run_script() {
    echo -e -n "${BLUE}Enter script name: ${NC}"
    read filename
    if [ ! -f "$filename" ]; then
        echo -e "${RED}Error: File '$filename' does not exist.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    echo -e "${YELLOW}Running $filename...${NC}"
    $RSCRIPT_BIN "$filename"
    read -p "Press Enter to continue..."
}

debug_script() {
    echo -e -n "${BLUE}Enter script name: ${NC}"
    read filename
    if [ ! -f "$filename" ]; then
        echo -e "${RED}Error: File '$filename' does not exist.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    echo "browser()" >> "$filename"
    echo -e "${YELLOW}Debugging $filename...${NC}"
    $RSCRIPT_BIN -e "source('$filename')"
    sed -i '$ d' "$filename"
    read -p "Press Enter to continue..."
}

repl() {
    echo -e "${YELLOW}Starting R REPL...${NC}"
    $R_BIN
    read -p "Press Enter to continue..."
}

while true; do
    show_menu
    read choice
    case $choice in
        1) new_script ;;
        2) edit_script ;;
        3) run_script ;;
        4) debug_script ;;
        5) repl ;;
        6) echo -e "${CYAN}Exiting Pocket R...${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid option. Choose 1-6.${NC}"; read -p "Press Enter to continue..." ;;
    esac
done
```

### How to Use in Termux
1. Save the script as `pocketR.sh` in Termux (e.g., in `/data/data/com.termux/files/home`).
2. Make it executable: `chmod +x pocketR.sh`.
3. Run it: `./pocketR.sh`.
4. Ensure R is installed in Termux:
   - Run `pkg install R` to install R.
   - Ensure `nano` is installed (`pkg install nano`) or set `EDITOR=vi` if preferred.
5. The colorful menu will display:
   ```
   ======= Pocket R ======= (in cyan)
   1. New R Script        (in yellow)
   2. Edit R Script       (in yellow)
   3. Run R Script        (in yellow)
   4. Debug R Script      (in yellow)
   5. Start R REPL        (in yellow)
   6. Exit                (in yellow)
   ======================= (in cyan)
   Choose an option [1-6]: (in blue)
   ```
6. Colors used:
   - **Cyan**: Header and footer
   - **Yellow**: Menu options and action messages
   - **Blue**: Input prompts
   - **Green**: Success messages
   - **Red**: Error messages
7. Select options by entering 1-6. The tool prompts for filenames with colored text and pauses after each action.

### Termux-Specific Notes
- The shebang in new R scripts uses `/data/data/com.termux/files/usr/bin/Rscript`, matching Termux's R installation path.
- The script checks for R and provides a Termux-specific installation command (`pkg install R`) in the error message.
- `nano` is set as the default editor, as it’s user-friendly for Termux users, but you can change it to `vi` or another editor by setting the `EDITOR` environment variable.
- Debugging uses R’s `browser()` function, temporarily added to scripts, as Termux supports R’s interactive debugging.

This script is optimized for Termux, providing a colorful, interactive R development environment on Android.
