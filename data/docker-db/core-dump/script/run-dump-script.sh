#!/bin/bash
echo "%%%%%%%%%%%% START %%%%%%%%%%%%%%%%%%%%%"
mysql -hcore-mariadb -P3306 -uroot -p'!root*00' < /home/db_user_grant_2019-01-04.sql
echo "%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%"
