--1. �������� ������ ���� ������ ��������� ����������� (������������  � ���������). 
select * from dba_tablespaces; 
 
--2. �������� ��������� ������������ � ������ XXX_QDATA (10m). ��� �������� ���������� ��� � ��������� offline. 
--����� ���������� ��������� ������������ � ��������� online. 
--�������� ������������ XXX ����� 2m � ������������ XXX_QDATA. 
--�� ����� XXX �  ������������ XXX_T1�������� ������� �� ���� ��������,  
--���� �� ������� ����� �������� ��������� ������. � ������� �������� 3 ������. 

create tablespace MVV_QDATA1  
datafile 'C:/5 Laba/MVV_QDATA1.dbf' 
size 10m 
autoextend on next 5m 
maxsize 20m 
offline; 
 
alter tablespace MVV_QDATA1 online;  
 
create table MVV_QTABLE (num int primary key, string NVARCHAR2(50)) tablespace MVV_QDATA1; 
insert into MVV_QTABLE values (1, 'a'); 
insert into MVV_QTABLE values (2, 'b'); 
insert into MVV_QTABLE values (3, 'c'); 
 
--3. �������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1.  
--���������� ��������� ��������. 
select * from dba_segments where tablespace_name = 'MVV_QDATA1'; 
 
--4. ������� (DROP) ������� XXX_T1. �������� ������ ��������� ���������� ������������  XXX_QDATA. 
--���������� ������� ������� XXX_T1. ��������� SELECT-������ � ������������� USER_RECYCLEBIN, �������� ���������. 
 
drop table MVV_QTABLE;  
select * from dba_segments where tablespace_name = 'MVV_QDATA1';  
select * from user_recyclebin; 
 
--5. ������������ (FLASHBACK) ��������� �������.  
 
flashback table MVV_QTABLE to before drop; 
 
--6. ��������� PL/SQL-������, ����������� ������� XXX_T1 ������� (10000 �����).  
begin  
    delete MVV_QTABLE; 
    for k in 1..10000 
    loop 
        insert into MVV_QTABLE values (k, 'd'); 
    end loop; 
    commit; 
end; 
 
--7. ���������� ������� � �������� ������� XXX_T1 ���������, �� ������ � ������ � ������. �������� �������� ���� ���������. 
select * from user_extents where segment_name = 'MVV_QTABLE'; 
 
--8. ������� ��������� ������������ XXX_QDATA � ��� ����.  
drop tablespace SEV_QDATA1 including contents; 
 
--9. �������� �������� ���� ����� �������� �������. ���������� ������� ������ �������� �������. 
select * from v$logfile; 
--10. �������� �������� ������ ���� �������� ������� ��������. 
select * from v$log; 
--11. EX. � ������� ������������ �������� ������� �������� ������ ���� ������������. 
--�������� ��������� ����� � ������ ������ ������� ������������ (��� ����������� ��� ���������� ��������� �������). 
alter system switch logfile; 
 
--12. EX. �������� �������������� ������ �������� ������� � ����� ������� �������. ��������� � ������� ������ � ������, 
--� ����� � ����������������� ������ (�������������). ���������� ������������������ SCN.  
 
alter database add logfile group 4 'C:/5 Laba/BDV_LOG.log' 
size 50m blocksize 512; 
 
--13. EX. ������� ��������� ������ �������� �������. ������� ��������� ���� ����� �������� �� �������. 
alter database drop logfile group 4; 
 
--14. ����������, ����������� ��� ��� ������������� �������� ������� (������������� ������ ���� ���������, 
--����� ���������, ���� ������ ������� �������� ������� � ��������). 
 
select * from v$DATABASE; 
 
--15. ���������� ����� ���������� ������. 
select * from V$LOG; 
 
--16. EX.  �������� �������������. 

--����� SQLPLUS
--SYSDBA

--SHUTDOWN IMMEDIATE;
--STARTUP MOUNT;
--ALTER DATABASE ARCHIVELOG;
--ALTER DATABASE OPEN;
--archive log list;

--17. EX. ������������� �������� �������� ����. ���������� ��� �����. ���������� ��� �������������� � ��������� � ��� �������. 
--���������� ������������������ SCN � ������� � �������� �������.  
 
-- shutdown immediate; 
-- startup mount; 
-- alter database archivelog; 
-- alter database open; 
 
--18. EX. ��������� �������������. ���������, ��� ������������� ���������. 
--startup mount; 
--alter database noarchivelog; 
-- select name, log_mode from v$database; 
 
--19. �������� ������ ����������� ������. 
select * from v$controlfile; 
 
--20. �������� � ���������� ���������� ������������ �����. 
--�������� ��������� ��� ��������� � �����. 
select * from v$controlfile_record_section; 
 
--21. ���������� �������������� ����� ���������� ��������. 
--��������� � ������� ����� �����.  
 
show
parameter control; 
--regedit 
--C:\app\tykty\product\18.0.0\dbhomeXE

--22. ����������� PFILE � ������ XXX_PFILE.ORA. 
--���������� ��� ����������. �������� ��������� ��� ��������� � �����. 
 
create pfile = 'MVV_PFILE.ora' from spfile; 
 
--23. ���������� �������������� ����� ������� ��������. 
--��������� � ������� ����� �����.  
--SQLPLUS
SHOW PARAMETER CONTROL;
 
--24. �������� �������� ����������� ��� ������ ��������� � �����������. 
select * From v$diag_info;

