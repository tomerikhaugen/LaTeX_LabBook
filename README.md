# LaTeX Lab Book
This is a collection of scripts to write and compile a Lab Book on a remote server. It generates the appropriate wrapper files and linking between macros and text. The user needs to only write the text they want, and use the store script to append that text to the relevant day. 

## Installation
Currently this Lab Book works with a strict directory system. There is the parent working directory. This needs to be specified in the store.sh script, or else it will not run.

The parent directory must contain the store.sh script, and the LabBook directory. The LabBook directory contains the compile script which takes the LabBook source code and compiles into a pdf.

Recommended installation is to decide which directory is the parent directory, then pulling this git project. That will create the necessary subdirectory system, along with the header and footer files.

## store.sh Usage
The bulk of the work is carried in this macro. It currently does 2 functions,

List of flags:

-T store plain text as a lab book entry
	Takes string of text as argument

-L store a lab book entry from text document
	Takes document name as argument 

-C store a root image macro
	( NOT IMPLEMENTED YET )

-I store an image (move it to directory and link in text)
	Takes name of image as argument

-i copy an image  (copy it to directory and link in text)
	Takes name of image as argument

-s subflag for -C and -I to also specify the size of image (otherwise image is 15 cm)

### Store Lab Book text:

Write in any directory a text document that has the latex text you want to add as an entry. This does not require any include commands or begin document commands. It can however handle equations. Any special characters need to be treated through regular LaTeX mark ups. The extension on the filename does not matter.

Call the store.sh command with the -L flag from the directory the text document is in and supply the document name as an argument.

```
$ > $PARENT/store.sh -L LabBook.tex
```

This will create the neccessary directories and files so that in the LabBook directory under src there will be a year, month directory with a txt file for that day. This text will be added with a timestamp. This also deletes the original text document that you have now stored.

### Store an Image:

Add a reference to todays entry in the lab book to the image supplied. The image is then moved from the current file to the subdirectory for this months lab book.

Call this with the -I flag. the -s subflag can also be specified to list a size (in cm) for the image. If no size is given it is defaulted to 15 cm. This also must be run in the directory that the image exists in.

```
$ > $PARENT/store.sh -I image.eps
```

or

``` 
$ > $PARENT/store.sh -I image.eps -s 12
```

## compile\_month.sh Usage

Using the store.sh script will create a messy directory with a .txt file for each day, and many many image files. Using the compile\_month.sh script will combine all of these text files along with adding the header and the footer so that it is one proper compile-able LaTeX document. This is created as $MONTH_$YEAR.tex and is the given to pdflatex to compile into one document. 

Run this macro from the LabBook directory. It requires 2 arguments, one is the year, the next is the abbreviation for the month.

```
$ > compile_month.sh 2019 Nov
```

Some technical notes: to generate the table of contents pdflatex is run twice. The first time it creates a .toc and .lof file that is needed to make the table of contents and the list of figures. The output of the first run is forwarded to /dev/null. 

pdflatex creates a lot of extra files like .log .aux etc. These are currently just deleted.
