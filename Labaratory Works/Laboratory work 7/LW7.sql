
--1. �������� ������ ������ ������� ���������.  
select * from v$bgprocess; 
 
--2 
--���������� ������� ��������, ������� �������� � �������� � ��������� ������. 
select * from v$bgprocess where paddr != '00'; 
 
--3 
--����������, ������� ��������� DBWn �������� � ��������� ������. 
select count(*) from v$bgprocess where paddr!= '00' and name like 'DBW%'; 
 
--4. �������� �������� ������� ���������� � �����������. 
--5. ���������� ������ ���� ����������. 
select username, status, server from v$session where username is not null; 
 
--6 ���������� ������� (����� ����������� ����������). 
select * from v$services; 
 
--7 �������� ��������� ��� ��������� ���������� � �� ��������. 
show parameter dispatcher; 
 
--8 ������� � ������ Windows-�������� ������, ����������� ������� LISTENER. 
select * from v$services; 
-
 
--9  
-- �������� �������� ������� ���������� � ���������. (dedicated, shared).  
select * from v$session where username is not null; 
 
--10 
-- ����������������� � �������� ���������� ����� LISTENER.ORA.  
--C:\app\tykty\product\18.0.0\dbhomeXE\network\admin\listener.ora 
 
--11-- 
--��������� ������� lsnrctl � �������� �� �������� �������.  
--LSNRCTL start
--�� ��������
 
--12-- 
-- �������� ������ ����� ��������, ������������� ��������� LISTENER.  
--�������� ���
--LSNRCTL -> services