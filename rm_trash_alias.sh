#!/bin/bash
#Described: Command rm to trash alias
#Author: Kim
#Version: v1.1
#Date: 2017.2.1
#Required: Centos5.0+

# user can specify base_dir here!
BASE_DIR=/opt
read -p "Input base dir('/opt' by default): " tmpbase
if [ ! -z $tmpbase ]; then
    BASE_DIR="$tmpbase"
fi
echo "Base dir of .trash/ : ${BASE_DIR}"

# BASE_DIR should be writable!
if [ ! -d "${BASE_DIR}" ] || [ ! -x "${BASE_DIR}" ]; then
    echo "Base dir should be writable!"
    exit 0;
fi

# the default trash dir!
TRASH_DIR="${BASE_DIR}/.trash"
echo "Trash dir : ${TRASH_DIR}"
mkdir -p "${TRASH_DIR}"

# remove rm alias
#sed -i '/alias.*rm/d' ~/.bashrc

# remove old trash alias
ALIAS_START_LINE=`sed -n '/start rm alias/=' ~/.bashrc`
ALIAS_END_LINE=`sed -n '/end rm alias/=' ~/.bashrc`
if [ $ALIAS_START_LINE ] && [ $ALIAS_END_LINE ] && [ $ALIAS_END_LINE -gt $ALIAS_START_LINE ]; then
    sed -i $ALIAS_START_LINE','$ALIAS_END_LINE'd' ~/.bashrc
fi

# add rm to trash alias
cat >> ~/.bashrc <<EOF
## start rm alias ======================================

alias rm=trash
alias rml=list_trash
alias rmc=clear_trash

trash()
{
    for i in \$@; do
        if [ -f \$i ] || [ -d \$i ]; then 
            STAMP=\`date +%s\`
            FILENAME=\`basename \$i\`
            mv \$i "${TRASH_DIR}/\$FILENAME.\$STAMP"
        fi
    done
}

list_trash()
{
    echo -e "${TRASH_DIR} :\n"
    ls -l ${TRASH_DIR}
}

clear_trash()
{
    read -p "Clear trash?(y/n)" confirm
    if [ \$confirm == 'y' ] || [ \$confirm == 'Y' ]; then
        /bin/rm -rf $TRASH_DIR/*
    fi
}

## end rm alias ========================================
EOF

source ~/.bashrc

# clear trash at 4:00 a.m. every 3 days
CRONTAB_CMD="0 4 */3 * * /bin/rm -rf $TRASH_DIR/* &" 
(crontab -l 2>/dev/null | grep -Fv ".trash"; echo -e "${CRONTAB_CMD}") | crontab -
COUNT=`crontab -l | grep ".trash" | grep -v "grep" | wc -l`
if [ $COUNT -lt 1 ]; then 
    echo "Fail to add trash auto-clean to crontab!" 
else
    echo "Trash auto-clean added! You may need to restart crontab!"
    sudo service crond restart 2>/dev/null
fi

echo "Command rm to trash alias done."
echo "You may need to re-login."

exit 1;
