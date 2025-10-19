#!/bin/bash

# Vue + TypeScript LSP Diagnostic Script
# Run this script to check if your Vue project is properly configured for TypeScript

echo "=========================================="
echo "Vue + TypeScript LSP Diagnostic Check"
echo "=========================================="
echo ""

# Check if we're in a project directory
if [ ! -f "package.json" ]; then
    echo "❌ ERROR: No package.json found in current directory"
    echo "   Please run this script from your Vue project root"
    exit 1
fi

echo "✓ Found package.json"
echo ""

# Check for TypeScript
echo "Checking for TypeScript..."
if [ -d "node_modules/typescript" ]; then
    TS_VERSION=$(node -p "require('./node_modules/typescript/package.json').version" 2>/dev/null)
    echo "✓ TypeScript found: v$TS_VERSION"
    echo "  Location: $(pwd)/node_modules/typescript/lib"
else
    echo "❌ TypeScript NOT found in node_modules"
    echo "   Install it with: npm install --save-dev typescript"
    echo "   or: yarn add --dev typescript"
fi
echo ""

# Check for Vue
echo "Checking for Vue..."
if [ -d "node_modules/vue" ]; then
    VUE_VERSION=$(node -p "require('./node_modules/vue/package.json').version" 2>/dev/null)
    echo "✓ Vue found: v$VUE_VERSION"
else
    echo "❌ Vue NOT found in node_modules"
    echo "   Install it with: npm install vue"
fi
echo ""

# Check for tsconfig.json
echo "Checking for tsconfig.json..."
if [ -f "tsconfig.json" ]; then
    echo "✓ tsconfig.json found"
    
    # Check if it includes .vue files
    if grep -q "\.vue" tsconfig.json; then
        echo "  ✓ Configured to include .vue files"
    else
        echo "  ⚠ WARNING: tsconfig.json may not include .vue files"
        echo "    Add to 'include': [\"src/**/*.vue\"]"
    fi
else
    echo "⚠ WARNING: No tsconfig.json found"
    echo "   Create one for better TypeScript support"
    echo ""
    echo "   Minimal tsconfig.json for Vue:"
    echo '   {'
    echo '     "compilerOptions": {'
    echo '       "target": "ES2020",'
    echo '       "module": "ESNext",'
    echo '       "moduleResolution": "bundler",'
    echo '       "strict": true,'
    echo '       "jsx": "preserve",'
    echo '       "resolveJsonModule": true,'
    echo '       "isolatedModules": true,'
    echo '       "esModuleInterop": true,'
    echo '       "lib": ["ES2020", "DOM", "DOM.Iterable"],'
    echo '       "skipLibCheck": true'
    echo '     },'
    echo '     "include": ["src/**/*.ts", "src/**/*.d.ts", "src/**/*.tsx", "src/**/*.vue"]'
    echo '   }'
fi
echo ""

# Check for Vue config files
echo "Checking for Vue project config..."
CONFIG_FOUND=false
if [ -f "vite.config.js" ] || [ -f "vite.config.ts" ]; then
    echo "✓ Vite config found"
    CONFIG_FOUND=true
fi
if [ -f "vue.config.js" ]; then
    echo "✓ Vue CLI config found"
    CONFIG_FOUND=true
fi
if [ -f "nuxt.config.js" ] || [ -f "nuxt.config.ts" ]; then
    echo "✓ Nuxt config found"
    CONFIG_FOUND=true
fi
if [ "$CONFIG_FOUND" = false ]; then
    echo "⚠ WARNING: No Vue config file found"
    echo "   This may affect Volar's ability to detect the project"
fi
echo ""

# Summary
echo "=========================================="
echo "Summary"
echo "=========================================="
echo ""
echo "For Volar to provide TypeScript support in .vue files, you need:"
echo "1. ✓ package.json (found)"
if [ -d "node_modules/typescript" ]; then
    echo "2. ✓ TypeScript installed (found)"
else
    echo "2. ❌ TypeScript installed (NOT FOUND - run: npm install --save-dev typescript)"
fi
if [ -d "node_modules/vue" ]; then
    echo "3. ✓ Vue installed (found)"
else
    echo "3. ❌ Vue installed (NOT FOUND)"
fi
if [ -f "tsconfig.json" ]; then
    echo "4. ✓ tsconfig.json (found)"
else
    echo "4. ⚠ tsconfig.json (recommended but not found)"
fi
echo ""

# Check Neovim Mason installation
echo "Neovim LSP Setup:"
MASON_VOLAR="$HOME/.local/share/nvim/mason/packages/volar"
if [ -d "$MASON_VOLAR" ]; then
    echo "✓ Volar is installed in Mason"
else
    echo "❌ Volar NOT found in Mason"
    echo "   Open Neovim and run: :MasonInstall volar"
fi
echo ""

echo "=========================================="
echo "Next Steps:"
echo "=========================================="
echo "1. Ensure all items above are marked with ✓"
echo "2. In Neovim, open a .vue file"
echo "3. Run :LspInfo to verify Volar is attached"
echo "4. Try typing 'const x:' and see if autocomplete works"
echo ""


