#!/bin/bash

# The whole LabBook directory system is built within this
# directory. This is defined at the beginning and not changed
PARENT=""

# Set Date for today
Define_Today() {
    DATETIME=$(date)
    YEAR=$(echo $DATETIME | cut -f6 -d ' ')
    MONTH=$(echo $DATETIME | cut -f2 -d ' ')
    DAY=$(echo $DATETIME | cut -f3 -d ' ')
	DATE=$(date +%F)
}

# Set Time for now
Define_Now() {
    TIME=$(echo $DATETIME | cut -f4 -d ' ')
}

# Create the needed directory for the Date
Define_Dir() {
	LABBOOK_DIR=${PARENT}/src/${YEAR}/${MONTH}
	mkdir -p ${LABBOOK_DIR}
}

# Define Filename for the LabBook
Define_LabBook_Filename() {
	FILENAME=${LABBOOK_DIR}/${DATE}.txt
}

# Append the text from LabBook.tex into the LabBook
# file for that day. Also adds a timestamp along
# with creating file if it does not exist. Also
# deletes the original file given as an argument
Write_LabBook() {
    if [ -f "$FILENAME" ]; then
        echo "appending to $FILENAME"
    else
        touch $FILENAME
        echo "created $FILENAME"
    fi

    echo "\\subsection*{${TIME}} " >> $FILENAME
    cat $INFILE >> $FILENAME
    rm $INFILE
}

Append_Image() {
	echo "\\\ " >> $FILENAME
	echo "\\includegraphics[${SIZEMESSAGE}]{${LABBOOK_DIR}/${IMAGEFILE}} " >> $FILENAME
}



# Test if the parent directory is set. If it is not
# the script will not run.
if [ -z "$PARENT" ]
then
	echo "Set parent directory to wherever you want the Lab Book written"
	exit
fi


# Internal variables. They hold the flag arguments to allow
# for multiple flags at once. Each flag variable will hold one
# value at most so multiple of the same flags will give only
# the final value given.

LABFILE=""
IMAGEFILE=""
IMAGESIZE=""

# Captures the user flags
while getopts "hL:C:I:s:" opt; do
	case $opt in
		h)
			echo "this message will be helpful in the future"
			exit
			;;
		L)
			LABFILE=$OPTARG
			if [ -z "$LABFILE" ]
			then
				echo "this is empty!"
			fi
			echo $LABFILE
			;;
		C)
			echo "This is not implemented yet"
			echo "I don't even know whey this"
			echo "flag is coded in."
			;;
		I)
			IMAGEFILE=$OPTARG
			;;
		s)
			IMAGESIZE=$OPTARG
	esac
done


# Check which flag variables have been given values

# Store the LabBook
if [ -z "$LABFILE" ]
then
	echo > /dev/null
else
	Define_Today
	Define_Now
	Define_Dir
	Define_LabBook_Filename
	INFILE=$LABFILE
	Write_LabBook
fi


# Store the image
if [ -z "$IMAGEFILE" ]
then
	echo > /dev/null
else
	IMMAGENAME=$IMAGEFILE
	SIZEMESSAGE=""

	# Check if Imagesize is specified
	if [ -z "$IMAGESIZE" ]
	then
		SIZEMESSAGE="width=15cm"
	else
		SIZEMESSAGE="width=${IMAGESIZE}cm"
	fi

	Define_Today
	Define_Dir
	Define_LabBook_Filename
	Append_Image

	mv ${IMAGEFILE} ${LABBOOK_DIR}/${IMAGEFILE}
fi
