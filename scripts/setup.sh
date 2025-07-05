#!/bin/bash

# Flutter App Automated Screenshot Testing Setup
echo "🚀 Setting up Flutter App Automated Screenshot Testing System..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check dependencies
check_dependencies() {
    print_status "Checking dependencies..."
    
    local missing_deps=()
    
    # Check Flutter
    if command_exists flutter; then
        print_success "Flutter found: $(flutter --version | head -n 1)"
    else
        print_error "Flutter not found"
        missing_deps+=("flutter")
    fi
    
    # Check Node.js
    if command_exists node; then
        print_success "Node.js found: $(node --version)"
    else
        print_error "Node.js not found"
        missing_deps+=("node")
    fi
    
    # Check ADB (optional but recommended)
    if command_exists adb; then
        print_success "ADB found: $(adb version | head -n 1)"
    else
        print_warning "ADB not found - Android testing will not be available"
    fi
    
    # Check Chrome/Chromium
    if command_exists google-chrome || command_exists chromium; then
        if command_exists google-chrome; then
            print_success "Google Chrome found: $(google-chrome --version)"
        else
            print_success "Chromium found: $(chromium --version)"
        fi
    else
        print_warning "Chrome/Chromium not found - Web testing may not work"
    fi
    
    # Check Git
    if command_exists git; then
        print_success "Git found: $(git --version)"
    else
        print_error "Git not found"
        missing_deps+=("git")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_status "Please install the missing dependencies and run this script again."
        exit 1
    fi
}

# Install Node.js dependencies
install_node_dependencies() {
    print_status "Installing Node.js dependencies..."
    
    if [ ! -f "package.json" ]; then
        print_error "package.json not found. Please run this script from the project root."
        exit 1
    fi
    
    npm install
    
    if [ $? -eq 0 ]; then
        print_success "Node.js dependencies installed successfully"
    else
        print_error "Failed to install Node.js dependencies"
        exit 1
    fi
}

# Install Flutter dependencies
install_flutter_dependencies() {
    print_status "Installing Flutter dependencies..."
    
    if [ ! -f "pubspec.yaml" ]; then
        print_error "pubspec.yaml not found. Please run this script from the project root."
        exit 1
    fi
    
    # Add necessary dependencies to pubspec.yaml if not present
    if ! grep -q "integration_test:" pubspec.yaml; then
        print_status "Adding integration_test dependency..."
        echo "  integration_test:" >> pubspec.yaml
        echo "    sdk: flutter" >> pubspec.yaml
    fi
    
    if ! grep -q "flutter_driver:" pubspec.yaml; then
        print_status "Adding flutter_driver dependency..."
        echo "  flutter_driver:" >> pubspec.yaml
        echo "    sdk: flutter" >> pubspec.yaml
    fi
    
    flutter pub get
    
    if [ $? -eq 0 ]; then
        print_success "Flutter dependencies installed successfully"
    else
        print_error "Failed to install Flutter dependencies"
        exit 1
    fi
}

# Create directory structure
create_directories() {
    print_status "Creating directory structure..."
    
    local dirs=(
        "screenshots"
        "screenshots/web"
        "screenshots/android"
        "screenshots/integration"
        "screenshots/baseline"
        "reports"
        "reports/web"
        "reports/android"
        "reports/integration"
        "scripts"
        "test_driver"
        "integration_test"
    )
    
    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            print_success "Created directory: $dir"
        fi
    done
}

# Create gitignore entries
setup_gitignore() {
    print_status "Setting up .gitignore..."
    
    local gitignore_entries=(
        "# Screenshot testing"
        "screenshots/"
        "reports/"
        "node_modules/"
        "*.log"
        "# Temporary files"
        ".tmp/"
        "temp/"
    )
    
    if [ ! -f ".gitignore" ]; then
        touch .gitignore
    fi
    
    for entry in "${gitignore_entries[@]}"; do
        if ! grep -q "$entry" .gitignore; then
            echo "$entry" >> .gitignore
        fi
    done
    
    print_success ".gitignore updated"
}

# Test the setup
test_setup() {
    print_status "Testing the setup..."
    
    # Test Node.js script
    print_status "Testing Node.js dependencies..."
    node -e "
        try {
            require('puppeteer');
            console.log('✅ Puppeteer available');
        } catch (e) {
            console.log('❌ Puppeteer not available');
        }
        
        try {
            require('chalk');
            console.log('✅ Chalk available');
        } catch (e) {
            console.log('❌ Chalk not available');
        }
    "
    
    # Test Flutter commands
    print_status "Testing Flutter commands..."
    flutter doctor
    
    print_success "Setup test completed"
}

# Create a sample configuration file
create_config() {
    print_status "Creating configuration file..."
    
    cat > screenshot_config.json << EOF
{
  "web": {
    "port": 8080,
    "headless": true,
    "viewport": {
      "width": 1920,
      "height": 1080
    },
    "timeout": 30000
  },
  "android": {
    "device": "auto",
    "timeout": 60000
  },
  "integration": {
    "timeout": 120000,
    "platforms": ["android", "ios", "web"]
  },
  "output": {
    "screenshotDir": "./screenshots",
    "reportDir": "./reports",
    "format": "png"
  },
  "comparison": {
    "threshold": 0.1,
    "includeAA": false
  }
}
EOF
    
    print_success "Configuration file created: screenshot_config.json"
}

# Main setup function
main() {
    echo "🎨 Flutter App Screenshot Testing Setup"
    echo "========================================"
    echo
    
    check_dependencies
    echo
    
    create_directories
    echo
    
    install_node_dependencies
    echo
    
    install_flutter_dependencies
    echo
    
    setup_gitignore
    echo
    
    create_config
    echo
    
    test_setup
    echo
    
    print_success "🎉 Setup completed successfully!"
    echo
    echo "📋 Next steps:"
    echo "  1. Run 'npm run test:web' to test web screenshot automation"
    echo "  2. Run 'npm run test:integration' to test integration screenshots"
    echo "  3. Run 'npm run test:all' to run all screenshot tests"
    echo "  4. Run 'node scripts/screenshot_orchestrator.js --interactive' for interactive mode"
    echo
    echo "📁 Directory structure:"
    echo "  screenshots/     - Generated screenshots"
    echo "  reports/         - Test reports"
    echo "  scripts/         - Automation scripts"
    echo "  test_driver/     - Flutter driver tests"
    echo "  integration_test/ - Integration tests"
    echo
    echo "📖 For more information, check the README.md file"
}

# Check if script is run from project root
if [ ! -f "pubspec.yaml" ] && [ ! -f "package.json" ]; then
    print_error "This script should be run from the Flutter project root directory"
    print_status "Please cd to your Flutter project directory and run this script again"
    exit 1
fi

# Run main setup
main