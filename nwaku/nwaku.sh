#!/bin/bash

CYAN='\033[1;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo " █████╗ ███████╗████████╗██╗  ██╗███████╗██████╗ ███████╗ █████╗ ██╗     "
echo "██╔══██╗██╔════╝╚══██╔══╝██║  ██║██╔════╝██╔══██╗██╔════╝██╔══██╗██║     "
echo "███████║█████╗     ██║   ███████║█████╗  ██████╔╝█████╗  ███████║██║     "
echo "██╔══██║██╔══╝     ██║   ██╔══██║██╔══╝  ██╔══██╗██╔══╝  ██╔══██║██║     "
echo "██║  ██║███████╗   ██║   ██║  ██║███████╗██║  ██║███████╗██║  ██║███████ "
echo "╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝"
echo "     https://discord.gg/aetherealco      https://x.com/aethereal_co       "
echo " +-+  +-++------+   +-+   +-+  +-++------++-+  +-++------++-+  +-++------+"
echo -e "${NC}"

DEFAULT_PORTS=("30304" "9005" "3000" "5432" "4000" "8000")

install_prerequisites() {
    echo "Updating system and installing prerequisites..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y git screen ufw

    sudo ufw allow 30304/tcp && sudo ufw allow 30304/udp
    sudo ufw allow 9005/udp && sudo ufw allow 3000/tcp
    sudo ufw allow 5432/tcp && sudo ufw allow 4000/tcp && sudo ufw allow 8000/tcp
    echo "Prerequisites installed and firewall configured."

    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        sudo apt install -y docker.io
        sudo systemctl start docker
        sudo systemctl enable docker
    else
        echo "Docker is already installed."
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo "Installing Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo "Docker Compose installed."
    else
        echo "Docker Compose is already installed."
    fi
}

setup_nwaku() {
    if [ ! -d "nwaku-compose" ]; then
        echo "Cloning nWaku repository..."
        git clone https://github.com/waku-org/nwaku-compose
        cd nwaku-compose || exit
    else
        echo "nWaku repository already exists."
        cd nwaku-compose || exit
    fi

    echo "Updating ports in docker-compose.yml..."
    for i in "${!DEFAULT_PORTS[@]}"; do
        echo "Current port ${DEFAULT_PORTS[i]}. Enter new port or press Enter to keep the same:"
        read -r new_port
        if [ -n "$new_port" ]; then
            sed -i "s/${DEFAULT_PORTS[i]}/${new_port}/g" docker-compose.yml
            echo "Updated port ${DEFAULT_PORTS[i]} to ${new_port}."
        fi
    done
    echo "Ports updated."

    cp .env.example .env
    echo "Please enter your Infura or Alchemy RPC URL:"
    read -r rpc_url
    echo "Please enter your ETH testnet private key (without 0x):"
    read -r eth_key
    echo "RLN_RELAY_ETH_CLIENT_ADDRESS=$rpc_url" >> .env
    echo "ETH_TESTNET_KEY=$eth_key" >> .env
    echo 'RLN_RELAY_CRED_PASSWORD="12345678910"' >> .env

    echo "Please enter storage allocation size (e.g., 10GB):"
    read -r storage_size
    echo "STORAGE_SIZE=${storage_size}" >> .env
    echo "Storage allocation set to ${storage_size}."

    echo "Registering RLN membership..."
    ./register_rln.sh
    echo "RLN membership registered. Keystore file saved to keystore/keystore.json."

    echo "Environment and RLN membership configured."
}

start_nwaku() {
    docker-compose up -d
    docker-compose logs -f nwaku
}

stop_nwaku() {
    docker-compose down
    echo "nWaku node stopped."
}

while true; do
    echo "Select an option:"
    echo "1) Install Prerequisites"
    echo "2) Setup nWaku and Register RLN Membership"
    echo "3) Start nWaku Node"
    echo "4) Stop nWaku Node"
    echo "0) Exit"
    read -r option

    case $option in
        1) install_prerequisites ;;
        2) setup_nwaku ;;
        3) start_nwaku ;;
        4) stop_nwaku ;;
        0) echo "Exiting..."; exit ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
