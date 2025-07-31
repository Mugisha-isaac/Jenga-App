#!/bin/bash

# Screenshot organization script for Jenga App
# This script helps organize and validate screenshots

SCREENSHOTS_DIR="screenshots"
README_FILE="README.md"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📸 Jenga App Screenshot Manager${NC}"
echo "=================================="

# Create screenshots directory if it doesn't exist
if [ ! -d "$SCREENSHOTS_DIR" ]; then
    mkdir -p "$SCREENSHOTS_DIR"
    echo -e "${GREEN}✅ Created screenshots directory${NC}"
fi

# Function to check if required screenshots exist
check_screenshots() {
    echo -e "\n${BLUE}📋 Checking for required screenshots...${NC}"
    
    required_screenshots=(
        "splash.png"
        "welcome.png"
        "login.png"
        "register.png"
        "home.png"
        "explore.png"
        "solution_detail.png"
        "create_solution.png"
        "profile.png"
        "settings.png"
        "payment.png"
        "premium.png"
        "history.png"
    )
    
    missing_count=0
    
    for screenshot in "${required_screenshots[@]}"; do
        if [ -f "$SCREENSHOTS_DIR/$screenshot" ]; then
            echo -e "${GREEN}✅ $screenshot${NC}"
        else
            echo -e "${RED}❌ $screenshot (missing)${NC}"
            ((missing_count++))
        fi
    done
    
    if [ $missing_count -eq 0 ]; then
        echo -e "\n${GREEN}🎉 All required screenshots are present!${NC}"
    else
        echo -e "\n${YELLOW}⚠️  $missing_count screenshot(s) missing${NC}"
    fi
}

# Function to optimize screenshots
optimize_screenshots() {
    echo -e "\n${BLUE}🔧 Optimizing screenshots...${NC}"
    
    if command -v imagemagick &> /dev/null; then
        for file in "$SCREENSHOTS_DIR"/*.png; do
            if [ -f "$file" ]; then
                # Resize if too large and optimize
                magick "$file" -resize 1080x2400> -quality 85 "$file"
                echo -e "${GREEN}✅ Optimized $(basename "$file")${NC}"
            fi
        done
    else
        echo -e "${YELLOW}⚠️  ImageMagick not found. Install it to optimize screenshots automatically.${NC}"
        echo "   Install with: sudo apt-get install imagemagick (Ubuntu/Debian)"
        echo "   Install with: brew install imagemagick (macOS)"
    fi
}

# Function to generate screenshot list for README
generate_readme_list() {
    echo -e "\n${BLUE}📝 Generating README screenshot list...${NC}"
    
    echo "Available screenshots:"
    for file in "$SCREENSHOTS_DIR"/*.png; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            echo "- ![${filename%.*}](screenshots/$filename)"
        fi
    done
}

# Function to validate screenshot sizes
validate_sizes() {
    echo -e "\n${BLUE}📏 Validating screenshot dimensions...${NC}"
    
    if command -v identify &> /dev/null; then
        for file in "$SCREENSHOTS_DIR"/*.png; do
            if [ -f "$file" ]; then
                dimensions=$(identify -format "%wx%h" "$file")
                size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
                size_kb=$((size / 1024))
                
                echo "$(basename "$file"): $dimensions (${size_kb}KB)"
                
                if [ $size_kb -gt 500 ]; then
                    echo -e "${YELLOW}  ⚠️  Large file size, consider optimizing${NC}"
                fi
            fi
        done
    else
        echo -e "${YELLOW}⚠️  ImageMagick not found. Cannot validate dimensions.${NC}"
    fi
}

# Main menu
case "${1:-menu}" in
    "check")
        check_screenshots
        ;;
    "optimize")
        optimize_screenshots
        ;;
    "list")
        generate_readme_list
        ;;
    "validate")
        validate_sizes
        ;;
    "all")
        check_screenshots
        optimize_screenshots
        validate_sizes
        ;;
    "menu"|*)
        echo -e "\n${BLUE}Available commands:${NC}"
        echo "  ./screenshot_manager.sh check     - Check for required screenshots"
        echo "  ./screenshot_manager.sh optimize  - Optimize screenshot file sizes"
        echo "  ./screenshot_manager.sh list      - Generate README screenshot list"
        echo "  ./screenshot_manager.sh validate  - Validate screenshot dimensions"
        echo "  ./screenshot_manager.sh all       - Run all checks and optimizations"
        echo ""
        echo -e "${YELLOW}💡 Tip: Run 'all' after adding new screenshots${NC}"
        ;;
esac

echo ""
