#!/bin/bash

EDITOR=${EDITOR:-nano}
CURL_BIN=$(which curl)

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

if [ -z "$CURL_BIN" ]; then
    echo -e "${RED}Error: curl is not installed. Run ./run.sh to install dependencies.${NC}"
    exit 1
fi

show_menu() {
    clear
    echo -e "${CYAN}======= Pocket R =======${NC}"
    echo -e "${CYAN} Powered by SyntaxTrail ${NC}"
    echo -e "${YELLOW}1. New R Script${NC}"
    echo -e "${YELLOW}2. Edit R Script${NC}"
    echo -e "${YELLOW}3. Run R Script${NC}"
    echo -e "${YELLOW}4. Debug R Script${NC}"
    echo -e "${YELLOW}5. Start R REPL${NC}"
    echo -e "${YELLOW}6. Run API Command${NC}"
    echo -e "${YELLOW}7. Exit${NC}"
    echo -e "${CYAN}=======================${NC}"
    echo -e -n "${BLUE}Choose an option [1-7]: ${NC}"
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
main <- function() {
    cat("Hello from Pocket R!\n")
}
main()
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
    echo -e "${YELLOW}Running $filename via API...${NC}"
    response=$($CURL_BIN -s -X POST -H "Content-Type: application/json" -d "{\"scriptPath\":\"$filename\"}" http://localhost:3000/run-script)
    echo -e "${GREEN}Result: $response${NC}"
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
    echo -e "${YELLOW}Debugging $filename via API...${NC}"
    response=$($CURL_BIN -s -X POST -H "Content-Type: application/json" -d "{\"scriptPath\":\"$filename\"}" http://localhost:3000/run-script)
    sed -i '$ d' "$filename"
    echo -e "${GREEN}Result: $response${NC}"
    read -p "Press Enter to continue..."
}

repl() {
    echo -e "${YELLOW}Starting R REPL via API...${NC}"
    while true; do
        echo -e -n "${BLUE}Enter R command (or 'quit' to exit): ${NC}"
        read command
        if [ "$command" = "quit" ]; then
            break
        fi
        if [ -z "$command" ]; then
            echo -e "${RED}Error: Command cannot be empty.${NC}"
            continue
        fi
        response=$($CURL_BIN -s -X POST -H "Content-Type: application/json" -d "{\"command\":\"$command\"}" http://localhost:3000/run-command)
        echo -e "${GREEN}Result: $response${NC}"
    done
    read -p "Press Enter to continue..."
}

run_api_command() {
    echo -e -n "${BLUE}Enter R command (e.g., max(1,2,3)): ${NC}"
    read command
    if [ -z "$command" ]; then
        echo -e "${RED}Error: Command cannot be empty.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    echo -e "${YELLOW}Sending command to API...${NC}"
    response=$($CURL_BIN -s -X POST -H "Content-Type: application/json" -d "{\"command\":\"$command\"}" http://localhost:3000/run-command)
    echo -e "${GREEN}Result: $response${NC}"
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
        6) run_api_command ;;
        7) echo -e "${CYAN}Exiting Pocket R...${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid option. Choose 1-7.${NC}"; read -p "Press Enter to continue..." ;;
    esac
done
