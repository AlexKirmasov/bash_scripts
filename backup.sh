#!/bin/bash

# load oracle user profile
. /home/oracle/.bash_profile

# set variables
name=`date +%d%m%y`

echo "===================="
echo -e "= \e[1;31mBackup is begin!\e[0m ="
echo "===================="
echo ""
echo "===================================="
echo -e "= \e[1;31mDeleting old datafiles from temp\e[0m ="
echo "===================================="
echo ""
cd /opt/ora10g/
rm -rf temp/
mkdir temp
echo "================================================"
echo -e "= \e[1;31mMoving archivelogs to archive temp directory\e[0m ="
echo "================================================"
echo ""
cd /opt/ora10g/archive

tar czvf archive-$name.tar.gz *.dbf
mv archive-$name.tar.gz ../arc_temp/
rm -rf *.dbf

cd /opt/ora10g/scripts/
echo "====================================================="
echo -e "= \e[1;31mBackup tablespace from database to temp directory\e[0m ="
echo "====================================================="
echo ""
sqlplus @ /opt/ora10g/scripts/archive.sql
mkdir /opt/ora10g/arc_base/$name
echo "======================================="
echo -e "= \e[1;31mArchiving datafiles and archivelogs\e[0m ="
echo "======================================="
echo ""
tar -cvzf /opt/ora10g/arc_base/$name/base-$name.tar.gz /opt/ora10g/temp
tar -cvzf /opt/ora10g/arc_base/$name/dbs-$name.tar.gz /opt/ora10g/product/10.2.0/db_1/dbs/
tar -cvzf /opt/ora10g/arc_base/$name/admin-$name.tar.gz  /opt/ora10g/admin/
tar -cvzf /opt/ora10g/arc_base/$name/archive-$name.tar.gz /opt/ora10g/archive/
echo "================================================"
echo -e "= \e[1;31mArchiving datafiles and archivelogs finished\e[0m ="
echo "================================================"
echo ""
echo "====================================="
echo -e "= \e[1;31mCopying archive to backup-servers\e[0m ="
echo "====================================="
echo ""
cd /opt/ora10g/arc_base/
       
    if [ -d /mnt/store/backup/oracle/server ];
	then
	    echo "================================"
	    echo -e "= \e[1;31mCopying archive to store\e[0m ="
	    echo "================================"
	    echo ""
	    cp -r $name /mnt/store/backup/oracle/server/base/
	else
	    echo -e "\e[1;31mStore unavailable!\e[0m"
	    echo ""
    fi
    
    if [ -d /mnt/store2/backup/oracle/server ];
	then
	    echo "================================"
	    echo -e "= \e[1;31mCopying archive to store2\e[0m ="
	    echo "================================"
	    echo ""
	    cp -r $name /mnt/store2/backup/oracle/server/base/
	else
	    echo -e "\e[1;31mStore2 unavailable!\e[0m"
	    echo ""
    fi
    
    
echo "===================="
echo -e "= \e[1;31mBackup finished!\e[0m ="
echo "===================="
