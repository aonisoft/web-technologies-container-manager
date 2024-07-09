#!/bin/bash

function check_jq()
{
    echo "Checking package jq"
    
    if ! command -v jq &> /dev/null
    then
    
        echo "jq is not installed. Trying to install..."

        if [[ "$OSTYPE" == "linux-gnu"* ]]; 
        then

            if [ -f /etc/os-release ]; 
            then
                . /etc/os-release

                case $ID in
                    debian|ubuntu|devuan)
                        sudo apt-get install jq
                        ;;

                    centos|fedora|rhel)
                        sudo dnf install jq
                        ;;

                    arch|manjaro)
                        sudo pacman -Syu jq
                        ;;
                    *)
                        echo "Unsupported Linux distribution. Please install jq manually."
                        ;;
                esac
            fi
        else
            echo "Unsupported operating system. Please install jq manually."
        fi
    fi
}