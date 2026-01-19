-- Create backup 
[insert into postgres terminal] 
pg_dump -U choo-c102 -h localhost -p 5432 -F p -d billings -f /data/billings_backup_text.sql

-- To restore backup file
[insert into postgres terminal]
pg_restore -U choo-c102 -h localhost -p 5432 -d billings -v /data/billings_backup_text.s