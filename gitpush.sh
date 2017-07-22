#!/bin/bash
#arr=$(ls -rt | tail -3) 
echo "--------------------------"
ls -lrt| tail -3 | while read line;do echo "$line"; done
echo "--------------------------"
read -p "Please input .md file you want push:" file
git add $file
git commit -m "add $file"
git push origin master
echo "$file push successed!"

