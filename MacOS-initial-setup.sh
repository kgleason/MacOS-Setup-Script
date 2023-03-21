#!/bin/bash

# Homebrew casks to install
CASKS=("postman" "heroku" "microsoft-remote-desktop" "dotnet-sdk" "vlc" "alfred" "kitty" "krisp" "microsoft-teams" "microsoft-office" "visual-studio-code" "zoom" "foxit-pdf-editor" "sqlpro-studio" "intune-company-portal" "microsoft-edge" "tailscale")
ROSETTA_CASKS=("pgadmin4" "duo-device-health")
# Homebrew packages to install
HBPKGS=("postgresql@14" "wget" "pyenv" "imagemagick" "coreutils")
TAPS=("kgleason/duo-device-health" "heroku/brew")

get_response() {
    unset INPUT
    local msg=$1
    echo "${msg}\nEnter Y to proceed, anything else to skip"
    read INPUT
    [ -z ${INPUT} ] && return 1
    [ $(echo ${INPUT} | tr "[:lower:]" "[:upper:]") = 'Y' ] || return 1 && return 0
}

if grep ohmy ${HOME}/.zshrc; then
    :
else
    if get_response "About to install Oh My ZSH."; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        cp ./zshrc ${HOME}/.zshrc
        source ~/.zshrc
    fi
fi

if which -s brew; then 
    :
else
    # Install Homebrew
    if get_response "About to install homebrew."; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        echo "Homebrew installed. Adding some taps."
        for TAP in ${TAPS[*]}; do
            brew tap ${TAP}
        done
    else
        echo "Can't proceed without Homebrew. Exiting."
        exit 1
    fi
fi

for CASK in ${CASKS[*]}; do
    get_response "About to install ${CASK}" && brew install --cask ${CASK}
done

for CASK in ${ROSETTA_CASKS[*]}; do
    if get_response "About to install ${CASK}. Which may require installing rosetta"; then
        # Make sure rosetta is installed before moving forward
        [ -e /usr/libexec/rosetta ] || sudo softwareupdate --install-rosetta
        brew install --cask ${CASK}
    fi
done

for PKG in ${HBPKGS[*]}; do
    get_response "About to install ${PKG}." && brew install ${PKG}
done

cp config ${HOME}/.config

echo "Some additional steps to take: "
echo "- Use pyenv to install some python versions."
echo "- Log in to foxit."
