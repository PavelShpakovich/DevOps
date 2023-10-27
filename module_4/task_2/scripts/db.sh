#!/bin/bash

declare fileName=users.db
declare fileDir=../data
declare filePath=$fileDir/$fileName

if [[ "$1" != "help" && "$1" != "" && ! -f $filePath ]];
then
    read -r -p "${fileName} does not exist. Do you want to create it? [Y/n] " answer

    if [[ $answer =~ ^(yes|y)$ ]];
    then
        touch $filePath
        echo "File ${fileName} is created."
    else
        echo "File ${fileName} must be created to continue. Try again."
        exit 1
    fi
fi

function validateLatinLetters {
  if [[ $1 =~ ^[A-Za-z_]+$ ]]; then return 0; else return 1; fi
}

function add {
    read -p "Enter user name: " username
    
    if ! validateLatinLetters $username
    then
      echo -e "Name must contain only latin letters. Try again. \n"; add
      exit 1
    fi

    read -p "Enter user role: " role
    
    if ! validateLatinLetters $role
    then
      echo -e "Role must contain only latin letters. Try again. \n"; add
      exit 1
    fi

    echo "${username}, ${role}" >> $filePath
    echo "User ${username} with role ${role} has been added to DB."
}

function backup {
  backupFileName=$(date +'%Y-%m-%d-%H-%M-%S')-users.db.backup
  cp $filePath $fileDir/$backupFileName

  echo "Backup is created."
}

function restore {
  latestBackupFile=$(ls $fileDir/*-$fileName.backup | tail -n 1)

  if [[ ! -f $latestBackupFile ]]
  then
    echo "No backup file found."
    exit 1
  fi

  cat $latestBackupFile > $filePath

  echo "Backup is restored."
}

function find {
    read -p "Enter username to search: " username

    awk -F, -v x=$username '$1 ~ x' ../data/users.db

    if [[ "$?" == 1 ]]
    then
        echo "User not found."
        exit 1
    fi
}

inverseParam="$2"
function list {
    if [[ $inverseParam == "--inverse" ]]
    then
      tac -n $filePath 
    else
      cat -n $filePath
    fi
}

function help {
    echo "Manages users in db. It accepts a single parameter with a command name."
    echo
    echo "Syntax: db.sh [command]"
    echo
    echo "List of available commands:"
    echo
    echo "add       Adds a new line to the users.db. Script must prompt user to type a
                    username of new entity. After entering username, user must be prompted to
                    type a role."
    echo "backup    Creates a new file, named" $filePath".backup which is a copy of
                    current" $fileName
    echo "find      Prompts user to type a username, then prints username and role if such
                    exists in users.db. If there is no user with selected username, script must print:
                    “User not found”. If there is more than one user with such username, print all
                    found entries."
    echo "list      Prints contents of users.db in format: N. username, role
                    where N – a line number of an actual record
                    Accepts an additional optional parameter inverse which allows to get
                    result in an opposite order – from bottom to top"
}


case $1 in
  add)            add ;;
  backup)         backup ;;
  restore)        restore ;;
  find)           find ;;
  list)           list ;;
  help | '' | *)  help ;;
esac