--1 
--1. Найдите на компьютере конфигурационные файлы SQLNET.ORA и TNSNAMES.ORA и ознакомьтесь с их содержимым. 
--C:\app\vera\product\18.0.0\dbhomeXE\network\admin\SQLNET.ORA 
--C:\app\vera\product\18.0.0\dbhomeXE\network\admin\TNSNAMES.ORA 
 
--2 
--Соединитесь при помощи sqlplus с Oracle как пользователь SYSTEM,
--получите перечень параметров экземпляра Oracle. 
--connect system/tyt10tyt11@localhost:1521/MVV_PDB

--show parameter instance 
 
--3 
-- Соединитесь при помощи sqlplus с подключаемой базой данных как пользователь SYSTEM,
--получите список табличных пространств,
--файлов табличных пространств,
--ролей и пользователей. 
--connect USER_MVV_PDB/1234@localhost:1521/MVV_PDB

--select * from v$pdbs; 
--select * from v$tablespace; 
--select * from dba_data_files; 
--select * from all_users; 
--select * from dba_role_privs; 
 --select * from dba_roles;
--4 
--Ознакомьтесь с параметрами в HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE на вашем компьютере. 
--regedit 
--Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Oracle 
--указывает расположение файлов универального установщика oracle 
 
 
 
--5 запустите утилиту Oracle NEt manager и подготовьте строку подключения 
-- с именем вашего пользователя SID, Где SID идентификатор
--подключемой базы данных.

--6 
--Подключитесь с помощью sqlplus
--под собственным пользователем и 
--с применением подготовленной строки подключения.  
--connect USER_MVV_PDB/1234@vera
--connect USER_MVV_PDB/1234@localhost:1521/MVV_PDB
 
--7 
--Выполните select к любой таблице, которой владеет ваш пользователь.  
--create table MVV_TABLE(x number (3), s varchar(50));
--INSERT into MVV_TABLE values(61, 'abc');
--select * from MVV_TABLE; 
 
--8 
--Ознакомьтесь с командой HELP.Получите справку по команде TIMING. Подсчитайте, сколько времени длится select к любой таблице. 
help 
help timing 
set timing on; 
select * from MVV_TABLE; 
set timing off; 
 
--9 
--Ознакомьтесь с командой DESCRIBE.Получите описание столбцов любой таблицы. 
help describe 
describe MVV_TABLE; 
 
--10 
--Получите перечень всех сегментов, владельцем которых является ваш пользователь. 
--connect USER_MVV_PDB/1234@localhost:1521/MVV_PDB
select * from user_segments;
select * from user_segments where owner = 'USER_MVV_PDB'; 
 
--11 
--Создайте представление, в котором получите количество всех сегментов, количество экстентов, блоков памяти и размер в килобайтах, которые они занимают. 
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






--СОЗДАНИЕ PDB 



--win + R + dbca
--1) Database operation > Manage Plaggable databases
--2) Manage Plaggable databases > Create plaggable database
--3) Select darabase > Пароль админа и имя админа
--4) Create pluggable db > Create a new pluggable db
--5) PDB identification -> (Pluggable database name MVV_PDB_ADMIN_NEW\\
-- Administration user name: PDB_ADMIN_NEW\\ Administration password Qwerty123 )
--6) Pluggable Db options > Next
--7) Summary > OK
--8) Finish -> OK


--5. задание
--Получите список всех существующих PDB в рамках экземпляра
--ORA12W. Убедитесь, что созданная PDB-база данных существует.



--system
--tyt10tyt11
--connect /as sysdba
show pdbs

--alter session set container = cdb$root;


--6.задание 
--Подключитесь к XXX_PDB c помощью SQL Developer создайте инфраструктурные объекты  
--(табличные пространства, роль, профиль безопасности, пользователя с именем U1_XXX_PDB). 

--Создаем новое подключение
--NAME Laba4
--USERNAME PDB_ADMIN_NEW
--Qwerty123
--Подключить сверху
--Servise name MVV_PDB_ADMIN_NEW

-------------

--Выдать привилегии
--user-name: system
--password: 
-- connect system/Qwerty123@//localhost:1521/MVV_PDB as sysdba;


---------------------------

--действия в sql

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




--7. задание
--Подключитесь к пользователю U1_XXX_PDB, с помощью SQL Developer, 
--создайте таблицу XXX_table, добавьте в нее строки, выполните SELECT-запрос к таблице. 
 
 --PDB identification -> (Pluggable database name MVV_PDB_ADMIN_NEW\\
-- Administration user name: PDB_ADMIN_NEW\\ Administration password Qwerty123 
 
 --нажать плюс
 --NAME: Laba 4.2
 --USERNAME: USER_MVV_PDB
 --PASSWORD 1234
 --SERVICE NAME MVV_PDB_ADMIN_NEW
 
 --ПЕРЕХОДИМ В DEV
 
SELECT * from user_tables;
 
create table MVV_TEST (number_ int, str NVARCHAR2(50)); 
insert into MVV_TEST values (1, 'A'); 
insert into MVV_TEST values (2, 'B'); 
 
select * from MVV_TEST;


commit;

--8. задание
--С помощью представлений словаря базы данных определите, все табличные пространства, 
--все  файлы (перманентные и временные),  
--все роли (и выданные им привилегии), профили безопасности,
--всех пользователей  базы данных XXX_PDB и  назначенные им роли.

--имена всех ... словаря
--структура
--все

select * from dictionary where lower(COMMENTS) like '%role%'; --роль
describe DBA_ROLES;
SELECT * FROM DBA_ROLES;


select * from dba_DATA_FILES; --файлы
select * from dba_temp_files;

select * from dictionary where lower(COMMENTS) LIKE '%priv%';--привилегии
describe ROLE_SYS_PRIVS;--структура
select * FROM ROLE_SYS_PRIVS where ROLE like '%MVV%'; --MVV-PDB_USER прив роли


select * from DBA_USERS;-- пользователи
select * from dictionary where lower(COMMENTS) LIKE '%users%';


select * from dba_tablespaces;-- все пространства

select * from dictionary where lower(COMMENTS) LIKE '%prof%'; -- безоапсность





--  9.задание
-- Подключитесь к CDB - Базе данных, создайте общего пользователя
-- с именем C##XXX Назначтте ему привилегию, позволяющую подключиться к бд XXX_PDB.
--Создайте 2 подключения пользователя C##XXX в SQL Developer к CDB - базе данных
-- и XXX PDB -- базе данных . Проверьте работоспособность.


alter session set container = MVV_PDB_ADMIN_NEW; -- переключиться на PDB
alter session set container = CDB$ROOT; -- переключиться на CDB
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') FROM DUAL; -- посмотреть где я

--СНАЧАДА ROOT

CREATE user C##MVV identified by 5678
account unlock;

DROP user C#MVV;

grant create session to C##MVV; -- через SQL PLUS

SELECT * FROM ALL_USERS;







--  10.задание
--Назначте привилегию, разрешающую подключение к XXX_PDB общему
--пользователю С##YYY? Созданному другим студентом. Убедитесь в
--Работоспособности этого пользователя в базе данных XXX_PDB;


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


