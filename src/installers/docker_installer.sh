#!/bin/bash


install_docker_debian() 
{
    sudo apt-get update

    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose
}


install_docker_redhat() 
{
    local name_distro=$1

    sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
    
    sudo yum install -y yum-utils
    
    sudo yum-config-manager --add-repo https://download.docker.com/linux/${name_distro}/docker-ce.repo
        
    sudo yum install docker-ce docker-ce-cli containerd.io \
                     docker-buildx-plugin docker-compose-plugin    
}


install_docker_arch() 
{
    sudo pacman -Syu

    sudo pacman -S docker

    sudo pacman -S docker-compose
}

    if [[ "$OSTYPE" == "linux-gnu"* ]]; 
    then
  
        if [ -f /etc/os-release ]; 
        then
            . /etc/os-release
        
            case $ID in
                debian|ubuntu|devuan)
                    install_docker_debian
                    ;;

                centos|fedora|rhel)
                    install_docker_redhat $ID
                    ;;

                arch|manjaro)
                    install_docker_arch
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