--17 ������������ ������

--������ ������������ �������
--1.	������������ ����� ���������� �������, � �������:
--2.	��� � ������ � ������������ ����� ����������� ����������� ����� ������ �� ������� �� ����� ������� � ������, ����� ���� ��� ������ �� ������ ������� ���������. 
--3.	���������� ���������, ���� �� ��������� �������, � � �����-���� ������� ��������� �������� � �������� ����������, ��� ��������, ��� � ����������.
--4.	���������� ���������, ����������� �� ������ ��� �������.
--5.	���������� ���� ����������� ��������� ������� � ������ �����, ������������� ��� �������� ������.



--
--6.	������������ �����, ������������� ����������� ������ �� ������� 1-5. ����������� ����� DBMS_SHEDULER. 

SET SERVEROUTPUT ON SIZE UNLIMITED;
create table table1
(
aa number,
bb varchar(15)
)

insert into table1 values(11,'111');
insert into table1 values(0,'222');
delete from table2;

create table table2
(
aa number,
bb varchar(15)
)

create or replace procedure do_job is
begin
insert into table2 select aa,bb from table1;
delete from table2;
commit;
end do_job;

begin
do_job;
end;

select * from table1;
select * from table2;
commit;

delete from table2;

create or replace procedure job_call as
JobNo user_jobs.job%type;
begin
dbms_job.submit(JobNo,'begin do_job(); end;',sysdate,'sysdate+10/86400');
commit;
end;

begin job_call; end;

select * from dba_jobs;


commit;


exec dbms_job.run(228);
exec dbms_job.remove(47);
exec dbms_job.next_date(26,sysdate+10/86400);
--exec dbms_job.isubmit(228,'begin do_job; end;',sysdate);
exec dbms_job.change(228,null,null,'sysdate+10/86400');
-----------------------------
BEGIN
DBMS_SCHEDULER.CREATE_JOB
(
JOB_NAME=>'JOBS',
JOB_TYPE=>'PLSQL_BLOCK',
REPEAT_INTERVAL=>'SYSDATE+10/86400',
JOB_ACTION=>'insert into table2 select aa,bb from table1; delete from table1;',
ENABLED=>TRUE
);
END;
