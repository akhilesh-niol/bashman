#!/bin/bash

# === CONFIGURATION ===
CONFIG_FILE="$HOME/.api_client_envs"

# === COLOR CODES ===
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# === FUNCTIONS ===

function print_banner() {
    echo -e "${CYAN}==================== API CLIENT ====================${NC}"
}

function print_help() {
    echo -e "${YELLOW}Usage:${NC} ./api-client.sh METHOD URL [OPTIONS]"
    echo
    echo -e "${GREEN}Examples:${NC}"
    echo "  ./api-client.sh GET https://jsonplaceholder.typicode.com/posts"
    echo "  ./api-client.sh POST https://example.com/api -d '{\"name\":\"John\"}' -H 'Authorization: Bearer token'"
    echo
    echo -e "${BLUE}Options:${NC}"
    echo "  -d | --data         JSON body for POST/PUT"
    echo "  -H | --header       Custom header(s), can be used multiple times"
    echo "  -q | --query        Query parameters in key=value format"
    echo "  -e | --env          Use saved environment"
    echo "  --save-env         Save environment (base_url + token)"
    echo "  --list-envs        List saved environments"
}

function save_env() {
    read -p "Environment name: " env
    read -p "Base URL: " base
    read -p "Auth token (leave empty if none): " token
    echo "$env|$base|$token" >> "$CONFIG_FILE"
    echo -e "${GREEN}Environment '$env' saved successfully.${NC}"
    exit 0
}

function list_envs() {
    echo -e "${CYAN}Saved Environments:${NC}"
    if [[ -f "$CONFIG_FILE" ]]; then
        awk -F "|" '{ print "- " $1 " (" $2 ")" }' "$CONFIG_FILE"
    else
        echo "No environments saved."
    fi
    exit 0
}

function load_env() {
    env_name="$1"
    line=$(grep "^$env_name|" "$CONFIG_FILE")
    if [[ -z "$line" ]]; then
        echo -e "${RED}Environment '$env_name' not found.${NC}"
        exit 1
    fi
    IFS="|" read -r _ BASE_URL TOKEN <<< "$line"
}

# === MAIN SCRIPT ===

print_banner

# Check for --desc or -desc before shifting
if [[ "$1" == "--desc" || "$1" == "-desc" ]]; then
  echo -e "${GREEN}API Client — A Postman-style interactive REST API tool for your terminal.${NC}"
  echo "Supports headers, tokens, environments, pretty JSON responses, and much more."
  exit 0
fi

METHOD="$1"
URL="$2"
shift 2 || true

DATA=""
HEADERS=()
QUERY=()
USE_ENV=""
USE_TOKEN=""

# === PARSE ARGS ===

while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--data)
            DATA="$2"
            shift 2
            ;;
        -H|--header)
            HEADERS+=("-H" "$2")
            shift 2
            ;;
        -q|--query)
            QUERY+=("$2")
            shift 2
            ;;
        -e|--env)
            USE_ENV="$2"
            shift 2
            ;;
        --save-env)
            save_env
            ;;
        --list-envs)
            list_envs
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown argument: $1${NC}"
            exit 1
            ;;
    esac
done

# === ENV HANDLING ===
if [[ -n "$USE_ENV" ]]; then
    load_env "$USE_ENV"
    [[ "$URL" != http* ]] && URL="${BASE_URL}${URL}"
    [[ -n "$TOKEN" ]] && HEADERS+=("-H" "Authorization: Bearer $TOKEN")
fi

# === QUERY PARAMS ===
if [[ ${#QUERY[@]} -gt 0 ]]; then
    URL+="?"
    for param in "${QUERY[@]}"; do
        URL+="${param}&"
    done
    URL=${URL::-1} # Remove trailing &
fi

# === CURL COMMAND ===
CMD=("curl" "-s" "-X" "$METHOD" "${HEADERS[@]}" "$URL")

if [[ "$DATA" != "" ]]; then
    CMD+=("-H" "Content-Type: application/json" -d "$DATA")
fi

echo -e "${BLUE}>> $METHOD $URL${NC}"
echo -e "${YELLOW}Executing...${NC}"

# === EXECUTE & PRETTY PRINT ===
RESPONSE=$("${CMD[@]}")
if command -v jq &> /dev/null; then
    echo "$RESPONSE" | jq
else
    echo "$RESPONSE"
    echo -e "${YELLOW}(Tip: Install jq for pretty JSON output)${NC}"
fi
