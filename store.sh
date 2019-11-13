#!/bin/bash

# The whole LabBook directory system is built within this
# directory. This is defined at the beginning and not changed
PARENT="/user/haugen/LaTeX_LabBook/LabBook"

# Set Date for today
Define_Today() {
	read -r YEAR MONTH DAY <<<$(date +%Y\ %M\ %d)
	DATE="$YEAR-$MONTH-$DAY"
}

# Set Time for now
Define_Now() {
    TIME=$(date +%T)
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
	echo "\\\ " >> $FILENAME
	echo "\\includegraphics[width=15cm]{${LABBOOK_DIR}/${IMAGENAME}} " >> $FILENAME
}



# Test if the parent directory is set. If it is not
# the script will not run.
if [ -z "$PARENT" ]
then
	echo "Set parent directory to wherever you want the Lab Book written"
	exit
fi


# The bulk of the actual macro. Wrapped in a flag system
# flags are described in README and the help file.

while getopts "hL:C:I:" opt; do
	case $opt in
		h)
			echo "help message"
			exit
			;;
		L)
			Define_Today
			Define_Now
			Define_Dir
			Define_LabBook_Filename
			INFILE=$OPTARG
			Write_LabBook
			;;
		C)
			MACRONAME=$OPTARG
			Define_Today
			Define_Dir
			Define_LabBook_Filename
			Append_Image
			mv ${1} ${LABBOOK_DIR}/${1}
			;;
		I)
			MACRONAME=$OPTARG
			Define_Today
			Define_Dir
			Define_LabBook_Filename
			Append_Image
			mv ${1} ${LABBOOK_DIR}/${1}
			;;
	esac
done
