--10 ������������ ������
commit;
-- ����� ��������� ������ � SQLPLUS
-- SET SERVEROUTPUT ON;
-- BEGIN
DBMS_OUTPUT.PUT_LINE();
END:
--/
--connect USER_MVV_PDB/4321@vera;

--1 �������
--������������ ���������� ��������� ���� �� ���������� ���������� 

begin
 null;
end;

--2 �������
-- ������������ ��. ��������� "Hello world"
-- ��������� ��� � SQLPLUS � � SQLDEV

begin 
  dbms_output.put_line('Hello world');
end;

--3 �������
--����������������� ������ ���������� � ���������� ������� sqlerrm, sqlcode

declare 
a number(2) := 10;
b number(2) := 0;
c number(22,2);
begin 
    dbms_output.put_line('a = ' || a || ', b:=' || b);
    c:= a / b;
    dbms_output.put_line('c = ' || c);
    exception
      when others
      then dbms_output.put_line('error: ' || sqlerrm || ', code' || sqlcode);
end;
   

-- 4 ������� 
-- ������������ ��������� ���. ����������������� ������� ��������� 
--���������� �� ��������� ������
declare
a number(2) := 2;
b number(2) := 0;
c number(22,2) := null;
begin 
    dbms_output.put_line('a = ' || a || ', b = ' || b);
    begin 
        c := a/b;
        exception 
            when others 
            then dbms_output.put_line('error = ' || sqlerrm || ', code ' ||  sqlcode);
    end;
    dbms_output.put_line('c:=' || c);
end;

--5 �������
--�������� ����� ���� �������������� ����������� �������������� � ������ ������ 

show parameter plsql_warnings;
select name, value from v$parameter
where name = 'plsql_warnings';

--6 �������
--������������ ������, ����������� ����������� ��� ����. ������� PL/sql

select keyword from 
v$reserved_words where length = 1 and keyword != 'A';

--7 ������� 
--������������ ������ ����������� ����������� ��� �������� ����� PL/SQL


select keyword from  v$reserved_words where length > 2 and keyword != 'A' order by keyword;


--8 ������� 
--������������ ������ ����������� ���������� ��� ��������� Oracle Server,
--��������� � PL/SQL. ����������� ��� �� ��������� � SQL+ �������� Show

show parameter plsql;

--9 ������� - 17 ������� 
--������������ ��������� ����, ��������������� (��������� � �������� ��������� ����� ����������):
-- ���������� � ������������� ����� number - ���������� 
-- ������������� �������� ��� ����� ������ number ����������, ������� ������� � ��������
-- ���������� � ������������. number ���������� � ������������� ������. 
-- ����������� � ������������� num-���������� � ����. ������ � ������������� ��������� (����������)
-- ����������� � ������������� BINARY-FLOAT ����������
-- ����������� � ������������� BINARY-DOUBLE ����������
-- ���������� number ���������� � ������ � ����������� ������� E (������� 10) ��� �������������/����������.
-- ���������� � ������������ BOOLEAN ���������


declare 
    first__ number(4) := 20;
    second__ number(4) := 9;
    third__ number(3,2);
    aq number(6,2) := 100.1;
    bq number (8,-2):= 100.11;
    bf binary_float := 321.1234;
    bd binary_double := 321.1234;
    e_num number(6,2) := 1e2;
    bol boolean := false;
begin 
    third__ := first__/second__;
    dbms_output.put_line('a =' || first__);--����� ���������
    dbms_output.put_line('b =' || second__);
    dbms_output.put_line('c =' || third__);
    dbms_output.put_line('aq =' || aq);
    dbms_output.put_line('bq =' || bq);
    dbms_output.put_line('bf =' || bf);
    dbms_output.put_line('e_num =' || e_num);
    if bol
        then dbms_output.put_line('bol = true');
        else dbms_output.put_line('bol = false');
    end if;
end;


--18 ������� 
-- ������������ ��������� ���� PL/SQL ���������� ���������� �������� 
-- (VARCHAR2, CHAR, NUMBER). ����������������� ��������� �������� �����������.
declare 
    varchar_const constant varchar2(5) := 'ABC';
    char_const constant char(5) := 'abc';
    num_const constant number(4) := 1234;
begin 
    dbms_output.put_line('VARCHAR2 CONSTANT = ' || varchar_const || 'length of VARCHAR2 CONSTANT = ' || length(varchar_const));
    dbms_output.put_line('CHAR CONSTANT = ' || char_const || 'length of CHAR CONSTANT = '  || length(varchar_const));
    dbms_output.put_line('NUM' || (num_const * 10 + 4));
end;

--alter user USER_MVV_PDB identified by 1234;
--PDB_ADMIN_NEW
--grant ALTER USER TO MVV_ADMIN_NEW;
--select * from all_users;
--select * from MVV_PDB;

--19 ������� 
-- ������������ ��, ���������� ���������� � ������ %TYPE
-- ����������������� �������� �����
select* from pulpit;

declare 
    m_pulpit pulpit.pulpit%type;
    pulpit_row pulpit%rowtype;
begin 
    m_pulpit := '����';
    pulpit_row.faculty := '����';
    dbms_output.put_line('pulpit = ' || m_pulpit);
    dbms_output.put_line('pulpit_row = ' || pulpit_row.faculty);
exception 
    when others
    then
        dbms_output.put_line(sqlerrm);
end;
-- 20 ������� 
-- ������������ ��, ���������� ���������� � ������ %ROWTYPE
-- ����������������� �������� �����


-- 21 �������� 
-- ������������ ��. ��������������� ��� ��������� ����������� ��������� IF

declare 
    varable_char varchar2(10) = '111';
begin 
   begin
    if  0 > length(varable_char)
        then dbms_output.put_line('0 > ' || length(varable_char));
    elsif 10 < length(varable_char)
        then dbms_output.put_line('10 = '|| length(varable_char));
    elsif 0 = length(varable_char)
        then dbms_output.put_line('0 = ' || length(varable_char));
    elsif 10 = length(varable_char)
        then dbms_output.put_line('10 = ' || length(varable_char));
    else dbms_output.put_line('unknone length ' || varable_char);
    end if;
end;
    
    
-- 22 �������� 
-- ������������ ��. ��������������� ��� ��������� ����������� ��������� CASE

declare
a number(3) := 100;
begin
    case
        when 100 > a
            then dbms_output.put_line('100 > ' || a);
        when a between 10 and 20
            then dbms_output.put_line('10 =< ' || a || ' <= 20');
        else dbms_output.put_line('NOTHING OF CASES');
    end case;
end;

-- 24 �������� 
-- ������������ ��. ��������������� ��� ��������� ����������� ��������� LOOP
--loops
declare
    a number(3) := 100;
begin
    dbms_output.put_line('number + 10 (LOOP)');
    loop
        a := a + 10;
        dbms_output.put_line(a);
        exit when a > 200;
    end loop;
end


-- 25 �������� 
-- ������������ ��. ��������������� ��� ��������� ����������� ��������� WHILE
declare 
    a number(1) := 8;
begin
    dbms_output.put_line('WHILE:');
    while a > 0
    loop
        a := a - 1;
        dbms_output.put_line(a);
    end loop;
end;


-- 26 �������� 
-- ������������ ��. ��������������� ��� ��������� ����������� ��������� FOR

declare 
    a number(1) := 1;
begin
    dbms_output.put_line('FOR:');
    for a in 1..10
    loop
        dbms_output.put_line(a);
    end loop;
end;





 