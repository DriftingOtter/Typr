#!/bin/bash

# Introductory Message
echo "============================================================"
echo "Typr: Your Personal Typing Tutor."
echo ""
echo "Description"
echo "> typr is a Python-based application that utilizes the *'rich'* module to provide you with a simple yet satisfying tui when typing, typr is designed to be simple & easy to use; Whenever you want a simple but satisfying typing test tool."
echo "============================================================"
echo ""

# Confirmation Prompt
read -p "Do you want to start the installation? (y/n): " START_INSTALLATION

if [[ "$START_INSTALLATION" != "y" && "$START_INSTALLATION" != "Y" ]]; then
    echo "Installation aborted."
    exit 0
fi

# Check Python Version
echo "Checking Python Version..."
if ! command -v python3 &>/dev/null || [[ $(python3 -c 'import sys; print(sys.version_info >= (3,8))') != "True" ]]; then
    echo "Error: Python 3.8 or higher is required. Please install it from https://www.python.org/."
    exit 1
else
    echo "Python 3.8 or higher is installed."
fi

# Check and Install rich Python Module
echo "Checking rich Python Module..."
if ! python3 -c 'import rich' &>/dev/null; then
    echo "Installing rich Python Module..."
    pip install rich
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install the rich Python module. Please check your internet connection and try again."
        exit 1
    else
        echo "rich Python Module is installed successfully."
    fi
else
    echo "rich Python Module is already installed."
fi

# Determine Available Shells
AVAILABLE_SHELLS=()
if [ -f "$HOME/.bashrc" ]; then
    AVAILABLE_SHELLS+=("Bash")
fi
if [ -f "$HOME/.zshrc" ]; then
    AVAILABLE_SHELLS+=("Zsh")
fi
if [ -f "$HOME/.config/fish/config.fish" ]; then
    AVAILABLE_SHELLS+=("Fish")
fi
if [ -f "$HOME/.xonshrc" ]; then
    AVAILABLE_SHELLS+=("Xonsh")
fi

# Print Available Shells
echo "Available shells: ${AVAILABLE_SHELLS[@]}"
echo ""

# Choose Shells to Install Aliases (with Validation)
SHELL_CHOICES=""
while [[ -z "$SHELL_CHOICES" ]]; do
    read -p "Enter the numbers corresponding to the shells you want to install the alias (e.g., '1 2' for Bash and Zsh): " SHELL_CHOICES

    # Validate user input
    invalid_choices=0
    for choice in $SHELL_CHOICES; do
        if ((choice < 1 || choice > ${#AVAILABLE_SHELLS[@]})); then
            echo "Invalid choice: $choice. Please enter valid numbers separated by space."
            invalid_choices=1
            break
        fi
    done

    if [ "$invalid_choices" -eq 0 ]; then
        break
    else
        SHELL_CHOICES=""
    fi
done

# Set up Aliases based on User's Choice
for choice in $SHELL_CHOICES; do
    case $choice in
    1)
        echo "Setting up Bash alias..."
        echo "alias typr=\"python3 $CURRENT_DIR/src/typr/main.py\"" >>~/.bashrc
        ;;
    2)
        echo "Setting up Zsh alias..."
        echo "alias typr=\"python3 $CURRENT_DIR/src/typr/main.py\"" >>~/.zshrc
        ;;
    3)
        echo "Setting up Fish alias..."
        echo "alias typr=\"python3 $CURRENT_DIR/src/typr/main.py\"" >>~/.config/fish/config.fish
        ;;
    4)
        echo "Setting up Xonsh alias..."
        echo "aliases['typr'] = 'python3 $CURRENT_DIR/src/typr/main.py'" >>~/.xonshrc
        ;;
    *)
        echo "Invalid choice: $choice"
        exit 1
        ;;
    esac
done

echo "Installation completed. Please restart your shell or run 'source ~/.bashrc' (or respective rc files) for the changes to take effect."
