#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Usage: $0 <directory>"
    exit 1
fi

for dir in "$@"
 do
    if [ -d "$dir" ]
     then
        file_count=$(find "$dir" -type f | wc -l)
        echo "Directory: $dir"
        echo "Number of files: $file_count"
        echo "--------------------"
    else
        echo "Error: $dir is not a directory."
    fi
done