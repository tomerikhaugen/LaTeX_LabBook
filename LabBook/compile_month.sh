#!/bin/bash

if [ $# != 2 ]
then
	echo "Input a year and month"
else
	# TAKE INPUT FILE WITH YEAR THEN MONTH SPECIFIED
	DIR="src/${1}/${2}"
	TEXFILE="${2}_${1}.tex"
	rm ${DIR}/${TEXFILE}
	cat "src/Wrapper_Files/Header.head" >> "${DIR}/${TEXFILE}"

	# LOOP THROUGH ALL .TXT FILES IN DIRECTORY COMBINE INTO ONE .TEX FILE
	for NAME in $( ls $DIR/*.txt )
	do
		NAME=$(echo $NAME | cut -f4 -d '/')
		DAY=$(echo $NAME | cut -f1 -d '.')
		DAY=$(echo $DAY | cut -f3 -d '-')
		echo $DAY
		echo "\\section{${2} ${DAY} ${1}} " >> ${DIR}/${TEXFILE}
		cat ${DIR}/${NAME} >> "${DIR}/${TEXFILE}"
		#echo " \\\ " >> ${DIR}/${TEXFILE}
	done
	cat "src/Wrapper_Files/Footer.foot" >> "${DIR}/${TEXFILE}"

	# COMPILE THE LATEX CODE INTO PDF
	pdflatex "${DIR}/${TEXFILE}">/dev/null
	pdflatex "${DIR}/${TEXFILE}"
	mv ${2}_${1}.pdf Output/
	rm *.log
	rm *.out
	rm *.aux
	rm *.toc
	rm *.lof
fi
