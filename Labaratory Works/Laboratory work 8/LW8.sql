--1 
--1. ������� �� ���������� ���������������� ����� SQLNET.ORA � TNSNAMES.ORA � ������������ � �� ����������. 
--C:\app\vera\product\18.0.0\dbhomeXE\network\admin\SQLNET.ORA 
--C:\app\vera\product\18.0.0\dbhomeXE\network\admin\TNSNAMES.ORA 
 
--2 
--����������� ��� ������ sqlplus � Oracle ��� ������������ SYSTEM,
--�������� �������� ���������� ���������� Oracle. 
--connect system/tyt10tyt11@localhost:1521/MVV_PDB

--show parameter instance 
 
--3 
-- ����������� ��� ������ sqlplus � ������������ ����� ������ ��� ������������ SYSTEM,
--�������� ������ ��������� �����������,
--������ ��������� �����������,
--����� � �������������. 
--connect USER_MVV_PDB/1234@localhost:1521/MVV_PDB

--select * from v$pdbs; 
--select * from v$tablespace; 
--select * from dba_data_files; 
--select * from all_users; 
--select * from dba_role_privs; 
 --select * from dba_roles;
--4 
--������������ � ����������� � HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE �� ����� ����������. 
--regedit 
--Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Oracle 
--��������� ������������ ������ ������������� ����������� oracle 
 
 
 
--5 ��������� ������� Oracle NEt manager � ����������� ������ ����������� 
-- � ������ ������ ������������ SID, ��� SID �������������
--����������� ���� ������.

--6 
--������������ � ������� sqlplus
--��� ����������� ������������� � 
--� ����������� �������������� ������ �����������.  
--connect USER_MVV_PDB/1234@vera
--connect USER_MVV_PDB/1234@localhost:1521/MVV_PDB
 
--7 
--��������� select � ����� �������, ������� ������� ��� ������������.  
--create table MVV_TABLE(x number (3), s varchar(50));
--INSERT into MVV_TABLE values(61, 'abc');
--select * from MVV_TABLE; 
 
--8 
--������������ � �������� HELP.�������� ������� �� ������� TIMING. �����������, ������� ������� ������ select � ����� �������. 
help 
help timing 
set timing on; 
select * from MVV_TABLE; 
set timing off; 
 
--9 
--������������ � �������� DESCRIBE.�������� �������� �������� ����� �������. 
help describe 
describe MVV_TABLE; 
 
--10 
--�������� �������� ���� ���������, ���������� ������� �������� ��� ������������. 
--connect USER_MVV_PDB/1234@localhost:1521/MVV_PDB
select * from user_segments;
select * from user_segments where owner = 'USER_MVV_PDB'; 
 
--11 
--�������� �������������, � ������� �������� ���������� ���� ���������, ���������� ���������, ������ ������ � ������ � ����������, ������� ��� ��������. 
--conn sys/Pa$$w0rd@mvv_pdb as sysdba 
create view SEGMENTS_NEW as
select 
count(segment_name) count_of_segs,
sum(extents) count_of_ex,
sum(blocks) count_of_blocks,
sum(bytes) size_bytes
from user_segments; 


--select * from MVV_seg;

commit;
 
 
--






--�������� PDB 



--win + R + dbca
--1) Database operation > Manage Plaggable databases
--2) Manage Plaggable databases > Create plaggable database
--3) Select darabase > ������ ������ � ��� ������
--4) Create pluggable db > Create a new pluggable db
--5) PDB identification -> (Pluggable database name MVV_PDB_ADMIN_NEW\\
-- Administration user name: PDB_ADMIN_NEW\\ Administration password Qwerty123 )
--6) Pluggable Db options > Next
--7) Summary > OK
--8) Finish -> OK


--5. �������
--�������� ������ ���� ������������ PDB � ������ ����������
--ORA12W. ���������, ��� ��������� PDB-���� ������ ����������.



--system
--tyt10tyt11
--connect /as sysdba
show pdbs

--alter session set container = cdb$root;


--6.������� 
--������������ � XXX_PDB c ������� SQL Developer �������� ���������������� �������  
--(��������� ������������, ����, ������� ������������, ������������ � ������ U1_XXX_PDB). 

--������� ����� �����������
--NAME Laba4
--USERNAME PDB_ADMIN_NEW
--Qwerty123
--���������� ������
--Servise name MVV_PDB_ADMIN_NEW

-------------

--������ ����������
--user-name: system
--password: 
-- connect system/Qwerty123@//localhost:1521/MVV_PDB as sysdba;


---------------------------

--�������� � sql

create tablespace MVV_TB  
datafile 'C:\lab/MVV_TB_New.dbf' 
size 5m 
autoextend on next 5m 
maxsize 20m; 
 
create role MVV_RL;  
grant create session, create table, create view, create procedure to  MVV_RL; 
 
create profile MVV_PROF limit 
password_life_time 20 
sessions_per_user 5 
failed_login_attempts 8 
password_lock_time 8 
password_reuse_time 8 
password_grace_time default 
connect_time 180 
idle_time 30; 
 
 
create user USER_MVV_PDB identified by 1234 
default tablespace MVV_TB   quota unlimited on  MVV_TB   
profile MVV_PROF
account unlock ;

grant MVV_RL to USER_MVV_PDB; 
select * from dba_users;
commit;




--7. �������
--������������ � ������������ U1_XXX_PDB, � ������� SQL Developer, 
--�������� ������� XXX_table, �������� � ��� ������, ��������� SELECT-������ � �������. 
 
 --PDB identification -> (Pluggable database name MVV_PDB_ADMIN_NEW\\
-- Administration user name: PDB_ADMIN_NEW\\ Administration password Qwerty123 
 
 --������ ����
 --NAME: Laba 4.2
 --USERNAME: USER_MVV_PDB
 --PASSWORD 1234
 --SERVICE NAME MVV_PDB_ADMIN_NEW
 
 --��������� � DEV
 
SELECT * from user_tables;
 
create table MVV_TEST (number_ int, str NVARCHAR2(50)); 
insert into MVV_TEST values (1, 'A'); 
insert into MVV_TEST values (2, 'B'); 
 
select * from MVV_TEST;


commit;

--8. �������
--� ������� ������������� ������� ���� ������ ����������, ��� ��������� ������������, 
--���  ����� (������������ � ���������),  
--��� ���� (� �������� �� ����������), ������� ������������,
--���� �������������  ���� ������ XXX_PDB �  ����������� �� ����.

--����� ���� ... �������
--���������
--���

select * from dictionary where lower(COMMENTS) like '%role%'; --����
describe DBA_ROLES;
SELECT * FROM DBA_ROLES;


select * from dba_DATA_FILES; --�����
select * from dba_temp_files;

select * from dictionary where lower(COMMENTS) LIKE '%priv%';--����������
describe ROLE_SYS_PRIVS;--���������
select * FROM ROLE_SYS_PRIVS where ROLE like '%MVV%'; --MVV-PDB_USER ���� ����


select * from DBA_USERS;-- ������������
select * from dictionary where lower(COMMENTS) LIKE '%users%';


select * from dba_tablespaces;-- ��� ������������

select * from dictionary where lower(COMMENTS) LIKE '%prof%'; -- ������������





--  9.�������
-- ������������ � CDB - ���� ������, �������� ������ ������������
-- � ������ C##XXX ��������� ��� ����������, ����������� ������������ � �� XXX_PDB.
--�������� 2 ����������� ������������ C##XXX � SQL Developer � CDB - ���� ������
-- � XXX PDB -- ���� ������ . ��������� �����������������.


alter session set container = MVV_PDB_ADMIN_NEW; -- ������������� �� PDB
alter session set container = CDB$ROOT; -- ������������� �� CDB
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') FROM DUAL; -- ���������� ��� �

--������� ROOT

CREATE user C##MVV identified by 5678
account unlock;

DROP user C#MVV;

grant create session to C##MVV; -- ����� SQL PLUS

SELECT * FROM ALL_USERS;







--  10.�������
--�������� ����������, ����������� ����������� � XXX_PDB ������
--������������ �##YYY? ���������� ������ ���������. ��������� �
--����������������� ����� ������������ � ���� ������ XXX_PDB;


--create tablespace TEST10_TABLESPACE  
--datafile 'C:/4 Laba/TEST10_TABLESPACE.dbf' 
--size 5m 
--autoextend on next 5m 
--maxsize 20m; 
-- 
--create role TEST10_ROLE;  
--grant create session, create table, create view, create procedure to TEST10_ROLE; 
-- 
--create profile TEST10_PROFILE limit 
--password_life_time 20 
--sessions_per_user 5 
--failed_login_attempts 8 
--password_lock_time 8 
--password_reuse_time 8 
--password_grace_time default 
--connect_time 180 
--idle_time 30; 
-- 
-- 
------------------------------------------------------- 
-- 
--create user TEST10_user identified by 8844
--default tablespace MVV_TABLESPACE quota unlimited on TEST10_TABLESPACE 
--profile TEST10_PROFILE 
--account unlock;
--
--grant TEST10_ROLE to TEST10_user; 



/*
Enter user-name: system
Enter password:
Last Successful login time: Mon Oct 03 2022 18:19:58 +03:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0



SQL> connect /as sysdba;
Connected.
SQL> connect system/Qwerty123@//localhost:1521/MVV_PDB as sysdba;
Connected.
SQL>
SQL> grant create session to TEST10_user;
*/


