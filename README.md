
# Backup Gitlab and Restore Gitlab

This dockumentation only for Gitlab self managed-ee on centos 7





## BACKUP
we recomend to backup file in `/etc/gitlab/gitlab-config.json`,  to run backup use this comand 
```
sudo gitlab-backup create 
```
after backup completed, file backup will store in folder 
`/var/opt/gitlab/backups/<uniq id>-ee_gitlab_backup.tar`






### Change default backup location

all backup automate save in folder `/var/opt/gitlab/backups`

if you want to change default folder please add folowing configuration in file `/etc/gitlab/gitlab.rb`
```
gitlab_rails['backup_path'] = '<backup-location>'
``` 
save it and run this folowing comand to update your gitlab config `sudo gitlab-ctl reconfigure`




### Create automatically backup 

to Create automatically backup you need create some bash file, please add following step like this

`nano /root/backupGitlab.sh`
```
#!/usr/bin/env bash

#date +"%Y-%m-%d %T"
echo '==========' $(date +"%Y-%m-%d %T")' Start Daily Backup =========='
gitlab-backup create

echo 'copy to NAS'
cp /var/opt/gitlab/backups/*_gitlab_backup.tar /mnt/BACKUP_GIT_MOTION/dailyBackup

echo 'delet data'
rm -f /var/opt/gitlab/backups/*_gitlab_backup.tar

echo '==========' $(date +"%Y-%m-%d %T")' Done Daily Backup  =========='
```
save file and change permision to executable with following comand `chmod +x backupGitlab.sh` 

add this file to crontab system 
```
30 3 * * * /opt/scrip/gitlab-daily-backup.sh >> /var/log/gitlab-daily-backup.log
```

in this comand create cronjob everyday on 03:00 and save job log to  `/var/log/gitlab-daily-backup.log`

## RESTORE

**Make usere gitlab version form old sever and new server is same**

This prosesdure will make step to restore data to new server (server clone form old gitlab) 


in previous step we backup file gitlab-config.json so wee need copy this file to new server on folder `/etc/gitlab/`

copy backup file to new server and save it to `/var/opt/gitlab/backup/` and change permission to git user with this comand 
```
sudo chown git:git /var/opt/gitlab/backups/11493107454_2018_04_25_10.6.4-ce_gitlab_backup.tar
```
and run this comand to restore gitlab

run this following  
```
## stop service 
sudo gitlab-ctl stop puma
sudo gitlab-ctl stop sidekiq

## check gitlab status 
sudo gitlab-ctl status

## this commant to restore 
# change 11493107454_2018_04_25_10.6.4-ce_gitlab_backup.tar to correct file name 
sudo gitlab-backup restore BACKUP=11493107454_2018_04_25_10.6.4-ce_gitlab_backup.tar
```
after finish dont forget to run again stoped services 

