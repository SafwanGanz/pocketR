#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Setting up Pocket R API and Tool...${NC}"

if ! command -v pkg &> /dev/null; then
    echo -e "${RED}Error: Termux environment not detected. Please run in Termux.${NC}"
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Installing Node.js and npm...${NC}"
    pkg install nodejs -y
fi

if ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}Installing curl...${NC}"
    pkg install curl -y
fi

if ! command -v nano &> /dev/null; then
    echo -e "${YELLOW}Installing nano...${NC}"
    pkg install nano -y
fi

if ! command -v netstat &> /dev/null; then
    echo -e "${YELLOW}Installing net-tools...${NC}"
    pkg install net-tools -y
fi

if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}Installing npm packages...${NC}"
    npm install express r-integration
fi

if [ ! -f "server.js" ]; then
    echo -e "${RED}Error: server.js not found. Please ensure it exists in the current directory.${NC}"
    exit 1
fi

if [ ! -f "pocketR.sh" ]; then
    echo -e "${RED}Error: pocketR.sh not found. Please ensure it exists in the current directory.${NC}"
    exit 1
fi

if [ ! -x "pocketR.sh" ]; then
    echo -e "${YELLOW}Making pocketR.sh executable...${NC}"
    chmod +x pocketR.sh
fi

echo -e "${YELLOW}Starting Pocket R API on localhost:3000...${NC}"
pkill -f "node server.js"
node server.js &

sleep 2

if ! netstat -tuln | grep ":3000" > /dev/null; then
    echo -e "${RED}Error: API failed to start on port 3000. Check for port conflicts or errors.${NC}"
    exit 1
fi

echo -e "${GREEN}API is running at http://localhost:3000${NC}"
echo -e "${YELLOW}Starting Pocket R Tool...${NC}"
./pocketR.sh
