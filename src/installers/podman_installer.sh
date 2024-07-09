#!/bin/bash

install_podman_debian() 
{
    . /etc/os-release

    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$ID/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

    curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$ID/Release.key | sudo apt-key add -

    sudo apt-get update

    sudo apt-get -y install podman
}


install_podman_redhat() 
{
    sudo dnf -y module disable container-tools

    sudo dnf -y install 'dnf-command(copr)'

    sudo dnf -y copr enable rhcontainerbot/container-selinux

    sudo dnf -y install podman
}


install_podman_arch() 
{
    sudo pacman -Syu

    sudo pacman -S podman fuse-overlayfs
}

    if [[ "$OSTYPE" == "linux-gnu"* ]]; 
    then
  
        if [ -f /etc/os-release ]; 
        then
            . /etc/os-release
            
            case $ID in
                debian|ubuntu|devuan)
                    install_podman_debian
                    ;;
        
                centos|fedora|rhel)
                    install_podman_redhat
                    ;;
        
                arch|manjaro)
                    install_podman_arch
                    ;;
                *)
                    echo "Unsupported distribution"
                    ;;
            esac
        else
            echo "Could not detect Linux distribution"
        fi

    else
        echo "Unsupported operating system. Please install jq manually."
    fi

