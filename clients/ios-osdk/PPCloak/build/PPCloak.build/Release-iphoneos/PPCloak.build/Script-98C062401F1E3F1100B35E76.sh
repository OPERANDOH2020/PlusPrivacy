#!/bin/sh
pathToCopy="$BUILT_PRODUCTS_DIR"
pathToCopy+="/$EXECUTABLE_FOLDER_PATH"
echo "$pathToCopy"


cd "$SRCROOT"

echo "Current directory is $PWD"

inputPathList="$SCRIPT_INPUT_FILE_0"
while read -r line
do

if [ -d "$line" ]
then
cp -r "$pathToCopy" "$line"
echo "Did copy to $line"
else
echo "Could not copy, ($line) may not be a valid directory!"
fi
done < "$inputPathList"
