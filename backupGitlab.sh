#!/usr/bin/env bash

#date +"%Y-%m-%d %T"
echo '==========' $(date +"%Y-%m-%d %T")' Start Daily Backup =========='
gitlab-backup create

echo 'copy to NAS'
cp /var/opt/gitlab/backups/*_gitlab_backup.tar /mnt/BACKUP_GIT_MOTION/dailyBackup

echo 'delet data'
rm -f /var/opt/gitlab/backups/*_gitlab_backup.tar

echo '==========' $(date +"%Y-%m-%d %T")' Done Daily Backup  =========='
