#!/bin/bash

# The whole LabBook directory system is built within this
# directory. This is defined at the beginning and not changed
PARENT="/user/haugen/LaTeX_LabBook/LabBook"

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
	IMAGENAME=$(echo $MACRONAME | cut -f1 -d ".")
	echo $IMAGENAME
	echo "\\\ " >> $FILENAME
	echo "\\includegraphics[width=15cm]{${LABBOOK_DIR}/${IMAGENAME}} " >> $FILENAME
}


#if [$PARENT == ""]
#then
#	echo "Set parent directory"
#	exit
#fi


if [ $# == 0 ]
then
	echo "Input a file name to store"
else
	case $1 in
		"LabBook.tex")
			Define_Today
			Define_Now
			Define_Dir
			Define_LabBook_Filename
			INFILE=$1
			Write_LabBook
			;;
		*".C")
			MACRONAME=$1
			Define_Today
			Define_Dir
			Define_LabBook_Filename
			Append_Image
			mv ${1} ${LABBOOK_DIR}/${1}
			;;
		*".png")
			MACRONAME=$1
			Define_Today
			Define_Dir
			Define_LabBook_Filename
			Append_Image
			mv ${1} ${LABBOOK_DIR}/${1}
			;;
		*)
			echo "Did not recognize input"
			;;
	esac
fi

