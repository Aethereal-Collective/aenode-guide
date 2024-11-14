**# Nwaku Node Auto Installation Script

This script automate the installation nWaku Node

## Hardware Specification 

| **Component**                     | **Specification**                         |
|------------------------------------|-------------------------------------------|
| **Operating System**               | Ubuntu 20.04 or later                    |
| **CPU**                            | 2vCPU (Better with 4vCPU+)               |
| **RAM**                            | At least 2GB (Recommended 4GB+)          |
| **Disk Space**                     | At least 50GB free disk space            |
| **Sepolia Testnet RPC URL**        | e.g., from Infura                        |
| **Testnet Private Key**            | With some Sepolia ETH                    |
| **Sepolia Faucet**                 | Atleast 0.6 ETH                          |

## Quick Installation

Choose one of these methods to install:

### Method 1: Using `curl`

```bash
curl -fsSL https://raw.githubusercontent.com/Aethereal-Collective/aenode-guide/refs/heads/main/nwaku/nwaku.sh -o nwaku.sh && chmod +x nwaku.sh && ./nwaku.sh
```
### Method 2: Using `wget`
```bash
wget https://raw.githubusercontent.com/Aethereal-Collective/aenode-guide/refs/heads/main/nwaku/nwaku.sh && chmod +x nwaku.sh && ./nwaku.sh
```

## Configuration
During installation, you'll need to provide the following:

- Sepolia RPC URL
- Private key (without the 0x prefix)
- RLN membership password (minimum 8 characters)

Optional advanced settings:

Custom Port
- Node key
- Domain
- Extra arguments
- Storage size

### Help Command
## Send Test Message
```bash
curl -X POST "http://127.0.0.1:8645/relay/v1/auto/messages" \
 -H "content-type: application/json" \
 -d '{"payload":"'$(echo -n "Hello Waku Network - from Anonymous User" | base64)'","contentTopic":"/my-app/2/chatroom-1/proto"}'
```

## Check Node Version
```bash
curl http://127.0.0.1:8645/debug/v1/version
```

## Check Node Info
```bash
curl http://127.0.0.1:8645/debug/v1/info
```

## Disclaimer
This is an unofficial installation script. Use at your own risk.
