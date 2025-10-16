#!/bin/bash

# Native LSP Installation Script
# This script helps you install all necessary dependencies for the new LSP setup

echo "🚀 Native LSP Installation Script"
echo "================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Neovim is installed
echo -e "${BLUE}Checking Neovim installation...${NC}"
if ! command -v nvim &> /dev/null; then
    echo -e "${YELLOW}Neovim is not installed. Please install it first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Neovim found${NC}"
echo ""

# Check required external tools
echo -e "${BLUE}Checking external dependencies...${NC}"

# Solargraph for Ruby
if command -v solargraph &> /dev/null; then
    echo -e "${GREEN}✓ Solargraph (Ruby LSP) found${NC}"
else
    echo -e "${YELLOW}! Solargraph not found. Install with: gem install solargraph${NC}"
fi

# Python and black
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓ Python3 found${NC}"
    if command -v black &> /dev/null; then
        echo -e "${GREEN}✓ Black (Python formatter) found${NC}"
    else
        echo -e "${YELLOW}! Black not found. Install with: pip install black${NC}"
    fi
else
    echo -e "${YELLOW}! Python3 not found${NC}"
fi

# Clangd for C/C++
if [ -f "/opt/homebrew/opt/llvm/bin/clangd" ]; then
    echo -e "${GREEN}✓ Clangd (C/C++ LSP) found${NC}"
else
    echo -e "${YELLOW}! Clangd not found. Install with: brew install llvm${NC}"
fi

# Node.js for various LSPs (installed via Mason)
if command -v node &> /dev/null; then
    echo -e "${GREEN}✓ Node.js found (needed for TypeScript, Vue, etc.)${NC}"
else
    echo -e "${YELLOW}! Node.js not found. Some LSPs may not work. Install with: brew install node${NC}"
fi

echo ""
echo -e "${BLUE}Starting Neovim plugin installation...${NC}"
echo ""

# Open Neovim and run PlugInstall
nvim +PlugInstall +qall

echo ""
echo -e "${GREEN}✓ Plugins installed${NC}"
echo ""

echo -e "${BLUE}Next steps:${NC}"
echo "1. Open Neovim: nvim"
echo "2. Run :Mason to verify language servers are installing"
echo "3. Open a file in your language to test LSP"
echo "4. Check :LspInfo to see active servers"
echo ""
echo -e "${GREEN}Installation complete! 🎉${NC}"
echo ""
echo "For detailed instructions, see: LSP_MIGRATION_GUIDE.md"
echo "For troubleshooting, run: :LspInfo or :Mason"

