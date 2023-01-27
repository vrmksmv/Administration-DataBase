--1. Получите список всех файлов табличных пространств (перманентных  и временных). 
select * from dba_tablespaces; 
 
--2. Создайте табличное пространство с именем XXX_QDATA (10m). При создании установите его в состояние offline. 
--Затем переведите табличное пространство в состояние online. 
--Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA. 
--От имени XXX в  пространстве XXX_T1создайте таблицу из двух столбцов,  
--один из которых будет являться первичным ключом. В таблицу добавьте 3 строки. 

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
 
--3. Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1.  
--Определите остальные сегменты. 
select * from dba_segments where tablespace_name = 'MVV_QDATA1'; 
 
--4. Удалите (DROP) таблицу XXX_T1. Получите список сегментов табличного пространства  XXX_QDATA. 
--Определите сегмент таблицы XXX_T1. Выполните SELECT-запрос к представлению USER_RECYCLEBIN, поясните результат. 
 
drop table MVV_QTABLE;  
select * from dba_segments where tablespace_name = 'MVV_QDATA1';  
select * from user_recyclebin; 
 
--5. Восстановите (FLASHBACK) удаленную таблицу.  
 
flashback table MVV_QTABLE to before drop; 
 
--6. Выполните PL/SQL-скрипт, заполняющий таблицу XXX_T1 данными (10000 строк).  
begin  
    delete MVV_QTABLE; 
    for k in 1..10000 
    loop 
        insert into MVV_QTABLE values (k, 'd'); 
    end loop; 
    commit; 
end; 
 
--7. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах. Получите перечень всех экстентов. 
select * from user_extents where segment_name = 'MVV_QTABLE'; 
 
--8. Удалите табличное пространство XXX_QDATA и его файл.  
drop tablespace SEV_QDATA1 including contents; 
 
--9. Получите перечень всех групп журналов повтора. Определите текущую группу журналов повтора. 
select * from v$logfile; 
--10. Получите перечень файлов всех журналов повтора инстанса. 
select * from v$log; 
--11. EX. С помощью переключения журналов повтора пройдите полный цикл переключений. 
--Запишите серверное время в момент вашего первого переключения (оно понадобится для выполнения следующих заданий). 
alter system switch logfile; 
 
--12. EX. Создайте дополнительную группу журналов повтора с тремя файлами журнала. Убедитесь в наличии группы и файлов, 
--а также в работоспособности группы (переключением). Проследите последовательность SCN.  
 
alter database add logfile group 4 'C:/5 Laba/BDV_LOG.log' 
size 50m blocksize 512; 
 
--13. EX. Удалите созданную группу журналов повтора. Удалите созданные вами файлы журналов на сервере. 
alter database drop logfile group 4; 
 
--14. Определите, выполняется или нет архивирование журналов повтора (архивирование должно быть отключено, 
--иначе дождитесь, пока другой студент выполнит задание и отключит). 
 
select * from v$DATABASE; 
 
--15. Определите номер последнего архива. 
select * from V$LOG; 
 
--16. EX.  Включите архивирование. 

--ЧЕРЕЗ SQLPLUS
--SYSDBA

--SHUTDOWN IMMEDIATE;
--STARTUP MOUNT;
--ALTER DATABASE ARCHIVELOG;
--ALTER DATABASE OPEN;
--archive log list;

--17. EX. Принудительно создайте архивный файл. Определите его номер. Определите его местоположение и убедитесь в его наличии. 
--Проследите последовательность SCN в архивах и журналах повтора.  
 
-- shutdown immediate; 
-- startup mount; 
-- alter database archivelog; 
-- alter database open; 
 
--18. EX. Отключите архивирование. Убедитесь, что архивирование отключено. 
--startup mount; 
--alter database noarchivelog; 
-- select name, log_mode from v$database; 
 
--19. Получите список управляющих файлов. 
select * from v$controlfile; 
 
--20. Получите и исследуйте содержимое управляющего файла. 
--Поясните известные вам параметры в файле. 
select * from v$controlfile_record_section; 
 
--21. Определите местоположение файла параметров инстанса. 
--Убедитесь в наличии этого файла.  
 
show
parameter control; 
--regedit 
--C:\app\tykty\product\18.0.0\dbhomeXE

--22. Сформируйте PFILE с именем XXX_PFILE.ORA. 
--Исследуйте его содержимое. Поясните известные вам параметры в файле. 
 
create pfile = 'MVV_PFILE.ora' from spfile; 
 
--23. Определите местоположение файла паролей инстанса. 
--Убедитесь в наличии этого файла.  
--SQLPLUS
SHOW PARAMETER CONTROL;
 
--24. Получите перечень директориев для файлов сообщений и диагностики. 
select * From v$diag_info;

