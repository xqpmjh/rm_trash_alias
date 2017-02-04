Usage:  
1. Execute the script directly  
2. Select the base dir where the trash dir is located  
3. Use command rm(alias of trash now) to delete the files/dirs
4. Use command rml to list trash
5. Use command rmc to clear trash

# sh rm_trash_alias.sh  

Input base dir('/opt' by default): /data  
Base dir of .trash/ : /data  
Trash dir : /data/.trash  
Trash auto-clean added! You may need to restart crontab!  
Stopping crond:                                            [  OK  ]  
Starting crond:                                            [  OK  ]  
Command rm to trash alias done.  
You may need to re-login.  

# rm file1 dir1

# rml
/data/.trash :

total 4
drwxr-xr-x 2 root root 4096 Feb  4 17:57 dir1.1486208014
-rw-r--r-- 1 root root    0 Feb  4 17:57 file1.1486208014

# rmc
Clear trash?(y/n)y

