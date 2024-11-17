#!/bin/bash 

targetPath="" ;
green="\033[0;32m"
nc="\033[0m"
ugreen="\033[4;32m"
bwhite='\033[1;37m'
red='\033[0;31m'

while read cur 
    do 
        echo -e "Creating classes in :${ugreen} $cur\n${nc}"
        targetPath=$cur
    done 

for arg in $@ 
    do 
        arg=${arg,,}
        arg=${arg^}
        {
        mkdir -p $targetPath/$arg && echo -e "${bwhite}   $arg:" 
        } 2>> "$targetPath/errors.txt" || { echo -e "${red}ERROR:${nc} failed to create class ${bwhite}$arg${nc}" 
                                            date >> errors.txt 
                                            continue 
                                            }

        { 
            {
            touch "$targetPath/$arg/$arg.h"
            echo -e "#ifndef ${arg^^}_H\n#define ${arg^^}_H\n" > "$targetPath/$arg/$arg.h"
            echo -e "class $arg{\n\n\tprivate:\n\n\tpublic:\n\t\t\t$arg();\n};" >> "$targetPath/$arg/$arg.h"
            echo -e "#endif" >> "$targetPath/$arg/$arg.h" 
            #echo "errrrrrrrr" >&2 && false
            } 2>> "$targetPath/errors.txt" && echo -e "\t${nc}$arg.h : ${green}✓" 
         } || {
            date >> errors.txt
            rm "$targetPath/$arg/$arg.h"
            echo -e "\t${nc}$arg.h : ${red}✗" 
         }
         {
            {
            touch "$targetPath/$arg/$arg.cpp" 
            echo "#include\"$arg.h\"" > "$targetPath/$arg/$arg.cpp" 
            #echo "errrrrrrrr" >&2 && false
            } 2>> "$targetPath/errors.txt" &&  echo -e "\t${nc}$arg.cpp : ${green}✓\n"
         } || {
            date >> errors.txt
            rm "$targetPath/$arg/$arg.cpp"
            echo -e "\t${nc}$arg.cpp : ${red}✗" 
         }
       
       
    done  
