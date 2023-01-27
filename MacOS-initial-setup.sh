#!/bin/bash

# Homebrew casks to install
CASKS=("dotnet-sdk" "vlc" "alfred" "kitty" "krisp" "microsoft-teams" "microsoft-office" "visual-studio-code" "zoom" "foxit-pdf-editor" "sqlpro-studio" "intune-company-portal")
ROSETTA_CASKS=("pgadmin4")
# Homebrew packages to install
HBPKGS=("postgresql@14" "wget" "pyenv" "imagemagick")

get_response() {
    unset INPUT
    local msg=$1
    echo "${msg}\nEnter Y to proceed, anything else to skip"
    read INPUT
    [ -z ${INPUT} ] && return 1
    [ $(echo ${INPUT} | tr "[:lower:]" "[:upper:]") = 'Y' ] || return 1 && return 0
}

if which -s brew; then 
    :
else
    # Install Homebrew
    if get_response "About to install homebrew."; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add homebrew to the path
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ${HOME}.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Can't proceed without Homebrew. Exiting."
        exit 1
    fi
fi

if grep ohmy ${HOME}/.zshrc; then
    :
else
    if get_response "About to install Oh My ZSH."; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        source ~/.zshrc
    fi
fi

for CASK in ${CASKS[*]}; do
    get_response "About to install ${CASK}" && brew install --cask ${CASK}
done

for CASK in ${ROSETTA_CASKS[*]}; do
    if get_response "About to install ${CASK}."; then
        # Make sure rosetta is installed before moving forward
        [ -e /usr/libexec/rosetta ] || sudo softwareupdate --install-rosetta
        brew install --cask ${CASK}
    fi
done

for PKG in ${HBPKGS[*]}; do
    get_response "About to install ${PKG}." && brew install ${PKG}
done

if get_response "About to install Duo Device Health"; then
    # Download the Duo Device Health pkg
    curl -o /tmp/DuoDeviceHealth.pkg https://dl.duosecurity.com/DuoDeviceHealth-latest.pkg

    # Install the Duo Device Health pkg
    sudo installer -pkg /tmp/Desktop/DuoDeviceHealth.pkg -target /Applications/
fi

echo "Some additional steps to take: "
echo "1. Install tailscale."
echo "2. Use pyenv to install some python versions."
echo "3. Log in to foxit."
echo "4. Log in to SQL Pro Studio."