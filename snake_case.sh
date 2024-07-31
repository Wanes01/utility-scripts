#!/bin/bash

OLDIFS=${IFS}
IFS=$'\n'

# Executable explanation
if [[ $* == *"--help"* ]] ; then
    bold=$(tput bold)
    normal=$(tput sgr0)

    echo "
    Changes the name of the items of PATH replacing all the spaces with _
    By default applies changes only to directories.

    ${bold}snake_case [PATH] [OPTIONS]${normal}
        ${bold}
        PATH:${normal} the path of the starting directory. Only its subdirectories
              get affected, not PATH itself.
        ${bold}
        OPTIONS:${normal}
            -type c : the type of element to consider
                where c can be
                d : change name only to directories.
                f : change name only to files
                d,f/f,d : change name to both directories and files
                If this option is omitted the default type are directories 

            -recursive n : specify the depth of recursion from PATH.
                n can be an integer value to clarify the depth of recursion
                or can be "max" to actuate the max depth of recursion.
                Omitting this option is the same as doing --recursive 1:
                only the immediate son items of PATH will be affected 
                "
    exit
fi

STARTDIR=""
RECURSIVE=""
TYPES="d"

# Set the starting directory to recursevly apply the script
if [[ ! -d $1 ]] ; then
    echo "Insert a valid starting directory as the first parameter."
    exit 1
fi

STARTDIR=$1

# Get the options values (if present)
for (( ARG=2 ; ARG<=$# ; ARG=${ARG}+2 )) ; do
    NEXTARG=$((${ARG}+1))
    if [[ ${!ARG} == "-recursive" ]] ; then
        # The value must be an integer >= 1 or "max"
        if [[ ${!NEXTARG} =~ ^[1-9]+$ || ${!NEXTARG} == "max" ]] ; then
            RECURSIVE=${!NEXTARG}
        else
            echo ${!NEXTARG}
            echo "Insert a valid level of recursion. See snake_case --help."
            exit 1
        fi

    elif [[ ${!ARG} == "-type" ]] ; then
        if [[ ${!NEXTARG} == "f" || ${!NEXTARG} == "d" 
           || ${!NEXTARG} == "f,d" || ${!NEXTARG} == "d,f" ]] ; then
            TYPES=${!NEXTARG}
        else
            echo "Insert a valid type. See snake_case --help."
            exit 1
        fi
    else
        echo "Insert valid options. See snake_case --help."
        exit 1
    fi  
done

ITEMS=`find ${STARTDIR} -mindepth 1 -maxdepth 1 -type f,d -name "[A-Za-z0-9]*"`

for ITEM in ${ITEMS} ; do

    # Replaces the spaces with _
    NEWPATH=${ITEM}
    if [[ ( -d ${ITEM} && ${TYPES} == *d* ) || ( -f ${ITEM} && ${TYPES} == *f* ) ]] ; then
        NEWNAME=`echo ${NEWPATH##*/} | sed 's/ /_/g'`
        NEWPATH="${NEWPATH%/*}/${NEWNAME}"
    fi

    # The name is already "snake cased"
    if [[ ${ITEM} != ${NEWPATH} ]] ; then
        mv ${ITEM} ${NEWPATH}
    fi

    # Repeat the process to all subdirectories
    if [[ ${RECURSIVE} != "" && -d ${NEWPATH} ]] ; then

        SUBDIRS=`find ${NEWPATH} -mindepth 1 -maxdepth 1 -type d -name "[A-Za-z0-9]*"`

        NEWRECLVL=${RECURSIVE}
            
        if [[ ${RECURSIVE} != "max" ]] ; then
            NEWRECLVL=$((${RECURSIVE}-1))
        fi

        if [[ ${SUBDIRS} != "" && ( ${NEWRECLVL} == "max" || ${NEWRECLVL} -ge 1 ) ]] ; then
            ./snake_case.sh ${NEWPATH} -type ${TYPES} -recursive ${NEWRECLVL}
        fi
    fi
done

IFS=${OLDIFS}