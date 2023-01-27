
--1. Получите полный список фоновых процессов.  
select * from v$bgprocess; 
 
--2 
--Определите фоновые процессы, которые запущены и работают в настоящий момент. 
select * from v$bgprocess where paddr != '00'; 
 
--3 
--Определите, сколько процессов DBWn работает в настоящий момент. 
select count(*) from v$bgprocess where paddr!= '00' and name like 'DBW%'; 
 
--4. Получите перечень текущих соединений с экземпляром. 
--5. Определите режимы этих соединений. 
select username, status, server from v$session where username is not null; 
 
--6 Определите сервисы (точки подключения экземпляра). 
select * from v$services; 
 
--7 Получите известные вам параметры диспетчера и их значений. 
show parameter dispatcher; 
 
--8 Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER. 
select * from v$services; 
-
 
--9  
-- Получите перечень текущих соединений с инстансом. (dedicated, shared).  
select * from v$session where username is not null; 
 
--10 
-- Продемонстрируйте и поясните содержимое файла LISTENER.ORA.  
--C:\app\tykty\product\18.0.0\dbhomeXE\network\admin\listener.ora 
 
--11-- 
--Запустите утилиту lsnrctl и поясните ее основные команды.  
--LSNRCTL start
--НЕ РАБОТАЕТ
 
--12-- 
-- Получите список служб инстанса, обслуживаемых процессом LISTENER.  
--ПРИМЕРНО ТАК
--LSNRCTL -> services