--1 �������
--������ ������������ pdb ����������� ����������

grant connect, create table, create view, create sequence, create cluster,
create synonym, create public synonym, create materialized view TO USER_MVV_PDB; 
grant drop public synonym to user_mvv_pdb;
commit;
 --connect system/Qwerty123@//localhost:1521/MVV_PDB as sysdba;
--alter pluggable database MVV_PDB open;

--2 ������� 
--�������� ����������������� S1 (SEQUENCE), c� ����. ����������������
-- ���. ���� 1000
--���������� 10
--��� ��� ��������
--��� ���� ����
--�� ����������� 
--����. �� ���������� � ������
--���������� �� ����� ����
--�������� ��������� �������� ������������������
--�������� ������� �������� ������������������

create sequence USER_MVV_PDB.S1
start with 1000
increment by 10
NOMINVALUE
nomaxvalue
nocycle
nocache
noorder;

select USER_MVV_PDB.S1.NEXTVAL from DUAL;
select USER_MVV_PDB.S1.CURRVAL from DUAL;

drop sequence S1;
commit;
--3 �������
-- �������� ������������������ s2
-- ��� ����. 10
-- ����. 10
-- ���� 100
-- �� ����.
-- �����. ��� ����. ������������������
-- ����������� �������� ���� ��������� �� ����. ����.

create sequence USER_MVV_PDB.S2
start with 10
increment by 10
maxvalue 100
nocycle;

select USER_MVV_PDB.S2.NEXTVAL from DUAL;
select USER_MVV_PDB.S2.CURRVAL from DUAL;

drop sequence S2;
commit;
--4 ������� 
-- ������� ������������������ s3
-- ��� ����. 10
-- ����. -10 
-- ��� ����. -100
-- �� ����.
-- ��������. ����. ��������.
-- �������� ��� ����. ������������������
--����������� �������� ����. ������ ���.


create sequence USER_MVV_PDB.S3
start with 10
increment by -10
minvalue -100
maxvalue 10
nocycle
order;

select USER_MVV_PDB.S3.NEXTVAL from DUAL;
select USER_MVV_PDB.S3.CURRVAL from DUAL;

drop sequence S3;
commit;
-- 5 ������� 
-- ������� ������������������ s4
-- ���. ���� 1
-- ����. 1
-- ��� ����. 10
-- ����-��
-- ���������� � ������ 5 ����.
-- ���������� ���������������
-- ������������������ ����������� ��������� �������� 

create sequence USER_MVV_PDB.S4
start with 10
increment by -10
minvalue -100
maxvalue 10
nocycle
order;

select USER_MVV_PDB.S3.NEXTVAL from DUAL;
select USER_MVV_PDB.S3.CURRVAL from DUAL;


drop sequence S4;

commit;

-- 6 �������
-- �������� ������ ���� �������������������
-- � ������� ��
-- ���������� ������� ���. MVV


select * from all_sequences where SEQUENCE_OWNER like 'USER_MVV%';
select * from user_sequences;

--7 �������
-- �������� ������� T1, ������� ������� 
-- N1, N2, N3, N4
-- ���� Number(20),
-- ����������
-- ���������. � �������� ���� KEEP
-- �������� 7 �����
-- �������� �������� ��� �������� ������ ������������� � �������
-- ������������������� S1,S2,S3,S4

create table T1
(
    N1 number(20),
    N2 number(20),
    N3 number(20),
    N4 number(20)
) cache storage (buffer_pool keep);

begin 
    for i in 1..7 loop
        insert into T1(N1, N2, N3, N4) values
        (   
            USER_MVV_PDB.S1.NEXTVAL, USER_MVV_PDB.S2.NEXTVAL,
            USER_MVV_PDB.S3.NEXTVAL, USER_MVV_PDB.S4.NEXTVAL
        );
    end loop;
end;
commit;
select * from T1;

drop table T1;
commit;

--8 �������
-- �������� �������  ABC 
-- ������� hash ��� (200) 
-- �������� 2 ���� 
-- X (NUMBER (10)), V (VARCHAR(12));

select * from user_tablespaces;-- ���������� ��������� ������������

create cluster USER_MVV_PDB.ABC
(
    X number(10),
    V varchar(12)
)
hashkeys 200
tablespace MVV_TB;
commit;
drop cluster ABC;

--9 �������
-- �������� ������� �, ������� ������� 
-- XA (NUMBER (10)
-- VA (VARCHAR(12))
-- ����������� �������� ABC
-- ������������ �������

create TABLE A
(
    XA number(10),
    VA varchar(12),
    PS varchar(10)
)
cluster USER_MVV_PDB.ABC(XA,VA);

commit;
drop table A;

--10 �������
-- �������� ������� B
-- ������� ������� XB (NUMBER (10))
-- VB (VARCHAR(12))
-- ������������� �������� ABC
-- ������������ �������

create TABLE B
(
    XB number(10),
    VB varchar(12),
    PS1 varchar(10)
)
cluster USER_MVV_PDB.ABC(XB,VB);
commit;
drop table b;

--11 �������
-- �������� ������� �
-- ������� ������� 
-- XC (NUMBER (10))
-- VC (VARCHAR (12))
-- ������������� �������� ABC
-- �����. �������
create TABLE C
(
    XC number(10),
    VC varchar(12),
    PS2 varchar(10)
)
cluster USER_MVV_PDB.ABC(XC,VC);
commit;
drop table c;


--12 �������
-- ������� ��������� ������� � ������� � ������������� ������� �����

--select * from dba_segments where segment_type = 'CLUSTER' order by segment_name;
select * from user_tables where cluster_name = 'ABC';
commit;

-- 13 ������� 
-- �������� ������� ������� ��� ������� XXX.C
-- ������������������

create synonym TABLE_C_SYNONYM for C; 
select * from TABLE_C_SYNONYM;
drop synonym TABLE_C_SYNONYM;

commit;
--14 �������
-- �������� ��������� �������
-- ������������������ ����������

create PUBLIC synonym TABLE_B_SYNONYM for B; 
select * from TABLE_B_SYNONYM;

drop public synonym TABLE_B_SYNONYM;
commit;

--15 ������� 
-- �������� 2 ������������ ������� A � B
-- ��������� ������� 
-- �������� ������������� V1
-- ���������� �� SELECT, FOR, A inner join B
drop table A_TABLE;
drop table B_TABLE;

create table A_TABLE (IDA number(20) primary key);
commit;
create table B_TABLE (IDA number(20), foreign key (IDA) references A_TABLE(IDA));
commit;

begin 
    for i in 1..100 loop
        insert into A_TABLE(IDA) values (USER_MVV_PDB.S1.NEXTVAL);
        insert into B_TABLE(IDA) values (USER_MVV_PDB.S1.CURRVAL);
    end loop;
end;

select * from  A_TABLE;
select * from  B_TABLE;


create view AB_TABLE_VIEW 
as select A_TABLE.IDA A_IDA, B_TABLE.IDA B_IDA
from A_TABLE inner join B_TABLE
on A_TABLE.IDA = B_TABLE.IDA;

select * FROM AB_TABLE_VIEW;

drop view AB_TABLE_VIEW;


-- 16 �������
-- �� ������ ������ A � B 
-- ������� ����������������� ������������� MV
-- ������������� ��������� 2 ������.


create materialized VIEW AB_VIEW_M
build immediate
refresh force on demand
start with sysdate
next sysdate + numtodsinterval (2, 'minute')
as select A_TABLE.IDA AIDA , B_TABLE.IDA BIDA
from A_TABLE inner join B_TABLE 
on A_TABLE.IDA = B_TABLE.IDA;


select * from AB_VIEW_M;
drop materialized view AB_VIEW_M;

commit;









































