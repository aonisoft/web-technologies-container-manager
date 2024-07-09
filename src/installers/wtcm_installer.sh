#!/bin/bash

DIR_MAIN=.wtcm

FILE_CONFIG=config.json

FILE_COMMANDS=commands.json

FILE_DATABASE=db.json

DIR_RM_WTCM_INSTALL=rm

TEMPLE_NAME=temple


PATH_FULL_RM_INSTALL=$DIR_MAIN/$DIR_RM_WTCM_INSTALL

PATH_FULL_CONFIG=$DIR_MAIN/$FILE_CONFIG

PATH_FULL_COMMANDS=$DIR_MAIN/$FILE_COMMANDS

PATH_FULL_PROJECTS_DB=$DIR_MAIN/$FILE_DATABASE

PATH_FULL_TEMPLATE=$DIR_MAIN/$TEMPLATE_NAME


URL_REPOSITORY_WTCM=https://github.com/aonisoft/web-technologies-container-manager.git 

TIMEZONE=$(timedatectl show --property=Timezone)


function create_configuration() 
{
  if [[ ! -e $DIR_MAIN/config.json ]]; then

    cp $PATH_FULL_RM_INSTALL/etc/*.json $DIR_MAIN

    touch $DIR_MAIN/projects_db.json

  fi
}


function clone_temple()
{
  if [[ ! -e $DIR_MAIN/$TEMPLE_NAME ]]; then

   git clone $(jq -r '.config.temple_github' $PATH_FULL_CONFIG) $PATH_FULL_TEMPLATE

  fi
}

function export_vars()
{
  export PATH_FULL_CONFIG PATH_FULL_COMMANDS PATH_FULL_PROJECTS_DB
}


function mov_rm_to_final()
{
  mv $PATH_FULL_RM_INSTALL/src/wtcm.sh $DIR_MAIN/bin

  mv $PATH_FULL_RM_INSTALL/src/functions/* $DIR_MAIN/functions
}


if [[ ! -e $PATH_FULL_RM_INSTALL ]]; then

   git clone $URL_REPOSITORY_WTCM $PATH_FULL_RM_INSTALL

fi


mkdir -p $DIR_MAIN/{bin,functions,services}

create_configuration

clone_temple

export_vars

mov_rm_to_final