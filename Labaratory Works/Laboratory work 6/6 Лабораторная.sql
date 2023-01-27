--1.	Определите общий размер области SGA.

select sum(value) from v$sga;

--2.	Определите текущие размеры основных пулов SGA.

select * from v$sga_dynamic_components where current_size > 0;


--3.	Определите размеры гранулы для каждого пула.
select component, granule_size from v$sga_dynamic_components where current_size > 0;


--4.	Определите объем доступной свободной памяти в SGA.
select current_size from v$sga_dynamic_free_memory;

--5.	Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша.
select * from v$sga_dynamic_components where component like '%cache%';

--6.	Создайте таблицу, которая будут помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.
create table MVV_KEEP(
  num int primary key,
  str varchar(150)) storage(buffer_pool KEEP);

select * from user_segments where segment_name = 'MVV_KEEP';

--7.	Создайте таблицу, которая будут кэшироваться в пуле default. Продемонстрируйте сегмент таблицы. 
create table MVV_CACHE_DEFAULT(
  num int primary key,
  str varchar(150))cache storage(buffer_pool default);

select * from user_segments where segment_name = 'MVV_CACHE_DEFAUL';

--8.	Найдите размер буфера журналов повтора.
show parameter log_buffer;

--9.	Найдите 10 самых больших объектов в разделяемом пуле.

select * from (select * from v$sgastat where pool='shared pool' order by bytes desc) where rownum <= 10;

--10.	Найдите размер свободной памяти в большом пуле.
select * from v$sgastat where pool = 'large pool' and name = 'free memory';

--11.	Получите перечень текущих соединений с инстансом. 
--12.	Определите режимы текущих соединений с инстансом (dedicated, shared)
select username, service_name, server from v$session where username is not null;

--13.	*Найдите самые часто используемые объекты в базе данных.
select * from v$db_object_cache Order by executions desc;