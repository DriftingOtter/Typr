#!/bin/bash



# Introductory Message
echo "============================================================"
echo "Typr: Your Personal Typing Tutor :keyboard:."
echo ""
echo "Description 📜"
echo "> typr is a Python-based application that utilizes the *'rich'* module to provide you with a simple yet satisfying tui when typing, typr is designed to be simple & easy to use; Whenever you want a simple but satisfying typing test tool."
echo "============================================================"
echo ""



# Confirmation Prompt
read -p "Do you want to start the installation? (y/n): " START_INSTALLATION

if [[ "$START_INSTALLATION" != "y" && "$START_INSTALLATION" != "Y" ]]; then
    echo "Installation aborted."
    exit 0
fi



# Function to Restore Backup Files
restore_backup_files() {
    echo "Restoring backup files..."
    if [ -f "$HOME/.bashrc.backup" ]; then
        mv "$HOME/.bashrc.backup" "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc.backup" ]; then
        mv "$HOME/.zshrc.backup" "$HOME/.zshrc"
    fi
    if [ -f "$HOME/.config/fish/config.fish.backup" ]; then
        mv "$HOME/.config/fish/config.fish.backup" "$HOME/.config/fish/config.fish"
    fi
    if [ -f "$HOME/.xonshrc.backup" ]; then
        mv "$HOME/.xonshrc.backup" "$HOME/.xonshrc"
    fi
    if [ -f "$HOME/.config/nu/config.toml.backup" ]; then
        mv "$HOME/.config/nu/config.toml.backup" "$HOME/.config/nu/config.toml"
    fi
}



# Backup Shell Configuration Files
echo "Backing up shell configuration files..."
if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$HOME/.bashrc.backup"
fi
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
if [ -f "$HOME/.config/fish/config.fish" ]; then
    cp "$HOME/.config/fish/config.fish" "$HOME/.config/fish/config.fish.backup"
fi
if [ -f "$HOME/.xonshrc" ]; then
    cp "$HOME/.xonshrc" "$HOME/.xonshrc.backup"
fi
if [ -f "$HOME/.config/nu/config.toml" ]; then
    cp "$HOME/.config/nu/config.toml" "$HOME/.config/nu/config.toml.backup"
fi



# Check Python Version
echo "Checking Python Version..."
if ! command -v python3 &>/dev/null; then
    echo "Error: Python 3.8 or higher is required. Please install it from https://www.python.org/."
    exit 1
elif [[ $(python3 -c 'import sys; print(sys.version_info >= (3,8))') != "True" ]]; then
    echo "Error: Python 3.8 or higher is required. Your current Python version is $(python3 --version)."
    exit 1
else
    echo "Python 3.8 or higher is installed."
fi



# Check and Install rich Python Module
echo "Checking rich Python Module..."
if ! python3 -c 'import rich' &>/dev/null; then
    echo "Installing rich Python Module..."
    pip install rich
else
    echo "rich Python Module is already installed."
fi



# Determine Current Folder
CURRENT_DIR=$(pwd)
echo "Current folder is: $CURRENT_DIR"



# Determine Available Shells
echo "Determining available shells..."
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
if [ -f "$HOME/.config/nu/config.toml" ]; then
    AVAILABLE_SHELLS+=("Nu")
fi



# Choose Shells to Install Aliases (with Validation)
SHELL_CHOICES=""
while [[ -z "$SHELL_CHOICES" ]]; do
    echo "Available shells: ${AVAILABLE_SHELLS[@]}"
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
        echo "alias typr=\"python3 $CURRENT_DIR/src/main.py\"" >>~/.bashrc
        ;;
    2)
        echo "Setting up Zsh alias..."
        echo "alias typr=\"python3 $CURRENT_DIR/src/main.py\"" >>~/.zshrc
        ;;
    3)
        echo "Setting up Fish alias..."
        echo "alias typr=\"python3 $CURRENT_DIR/src/main.py\"" >>~/.config/fish/config.fish
        ;;
    4)
        echo "Setting up Xonsh alias..."
        echo "aliases['typr'] = 'python3 $CURRENT_DIR/src/main.py'" >>~/.xonshrc
        ;;
    5)
        echo "Setting up Nu alias..."
        echo "alias \"typr\" {\"python3 $CURRENT_DIR/src/main.py\"}" >>~/.config/nu/config.toml
        ;;
    *)
        echo "Invalid choice: $choice"
        # Restore backup files
        restore_backup_files
        exit 1
        ;;
    esac
done



echo "Installation completed. Please restart your shell or run 'source ~/.bashrc' (or respective rc files) for the changes to take effect."

