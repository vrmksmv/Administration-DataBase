--1.	���������� ����� ������ ������� SGA.

select sum(value) from v$sga;

--2.	���������� ������� ������� �������� ����� SGA.

select * from v$sga_dynamic_components where current_size > 0;


--3.	���������� ������� ������� ��� ������� ����.
select component, granule_size from v$sga_dynamic_components where current_size > 0;


--4.	���������� ����� ��������� ��������� ������ � SGA.
select current_size from v$sga_dynamic_free_memory;

--5.	���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����.
select * from v$sga_dynamic_components where component like '%cache%';

--6.	�������� �������, ������� ����� ���������� � ��� ���P. ����������������� ������� �������.
create table MVV_KEEP(
  num int primary key,
  str varchar(150)) storage(buffer_pool KEEP);

select * from user_segments where segment_name = 'MVV_KEEP';

--7.	�������� �������, ������� ����� ������������ � ���� default. ����������������� ������� �������. 
create table MVV_CACHE_DEFAULT(
  num int primary key,
  str varchar(150))cache storage(buffer_pool default);

select * from user_segments where segment_name = 'MVV_CACHE_DEFAUL';

--8.	������� ������ ������ �������� �������.
show parameter log_buffer;

--9.	������� 10 ����� ������� �������� � ����������� ����.

select * from (select * from v$sgastat where pool='shared pool' order by bytes desc) where rownum <= 10;

--10.	������� ������ ��������� ������ � ������� ����.
select * from v$sgastat where pool = 'large pool' and name = 'free memory';

--11.	�������� �������� ������� ���������� � ���������. 
--12.	���������� ������ ������� ���������� � ��������� (dedicated, shared)
select username, service_name, server from v$session where username is not null;

--13.	*������� ����� ����� ������������ ������� � ���� ������.
select * from v$db_object_cache Order by executions desc;