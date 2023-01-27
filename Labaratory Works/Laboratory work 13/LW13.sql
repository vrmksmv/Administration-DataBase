-- ������������ 13
-- ���������� �������� � �������

--1. ������� ������������ ��������� ��������� 
--GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
---��������� ������ �������� ������ �������������� �� ������� TEACHER
--(� ����������� ��������� �����), ���������� �� ������� �������� �����
--� ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
SET SERVEROUTPUT ON SIZE UNLIMITED;
select * from pulpit;
alter pluggable database MVV_PDB open;


create or replace procedure GET_TEACHERS (PCODE TEACHER.PULPIT%type) is
  cursor T_CURS is
    select TEACHER_NAME, TEACHER 
    from TEACHER 
    where PULPIT = PCODE;
  T_NAME TEACHER.TEACHER_NAME%type;
  T_CODE TEACHER.TEACHER%type;
begin
  open T_CURS;
  LOOP
    DBMS_OUTPUT.PUT_LINE(T_CODE||' '||T_NAME);
    FETCH T_CURS into T_NAME, T_CODE;
    EXIT when T_CURS%NOTFOUND;
  end LOOP;
  close T_CURS;
end;


begin
    GET_TEACHERS('����');
end;


--2. ������� ������������ ��������� ������� 
--3. �������  ������� GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--RETURN NUMBER
--������� ������ �������� ���������� �������������� �� ������� TEACHER, 
--���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.


create or replace function GET_NUM_TEACHERS(PCODE TEACHER.PULPIT%type)
  return number is
    TCOUNT number;
begin
  select COUNT(*) 
  into TCOUNT 
  from TEACHER 
  where PULPIT = PCODE;
  
  return TCOUNT;
end;


begin
  DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS('����'));
end;





--4.������� ������������ ���������:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--��������� ������ �������� ������ �������������� �� ������� TEACHER 
--(� ����������� ��������� �����), ���������� �� ����������, �������� ����� � ���������.
--������������ ��������� ���� � ����������������� ���������� ���������.
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--��������� ������ �������� ������ ��������� �� ������� SUBJECT, ������������ �� ��������,
--�������� ����� ������� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������

create or replace procedure VGET_TEACHERS(FCODE FACULTY.FACULTY%type) is
  cursor T_CURS is
    select T.TEACHER_NAME, T.TEACHER, P.FACULTY
    from TEACHER T
    join PULPIT P
      on T.PULPIT = P.PULPIT
    where P.FACULTY = FCODE;
  T_NAME TEACHER.TEACHER_NAME%type;
  T_CODE TEACHER.TEACHER%type;
  T_FACULTY PULPIT.FACULTY%type;
begin
  open T_CURS;
  LOOP
    DBMS_OUTPUT.PUT_LINE(T_NAME || ' ' || rtrim(T_CODE) || ' ' || T_FACULTY);
    FETCH T_CURS into T_NAME, T_CODE, T_FACULTY;
    EXIT when T_CURS%NOTFOUND;
  end LOOP;
  close T_CURS;
end;


begin
    VGET_TEACHERS('����');
end;


create or replace procedure VGET_SUBJECTS (PCODE SUBJECT.PULPIT%type) is
  cursor T_CURS is
    select SUBJECT, SUBJECT_NAME, S.PULPIT
    from SUBJECT S
    where S.PULPIT = PCODE;
  S_SUBJECT SUBJECT.SUBJECT%type;
  S_SUBJECT_NAME SUBJECT.SUBJECT_NAME%type;
  S_PULPIT SUBJECT.PULPIT%type;
begin
  open T_CURS;
  LOOP
    DBMS_OUTPUT.PUT_LINE(S_SUBJECT || ' ' || S_SUBJECT_NAME || ' ' || S_PULPIT);
    FETCH T_CURS into S_SUBJECT, S_SUBJECT_NAME, S_PULPIT;
    EXIT when T_CURS%NOTFOUND;
  end LOOP;
  close T_CURS;
end;


begin
  VGET_SUBJECTS('����');
end;

--5. ������� ������������ ��������� ������� 
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--RETURN NUMBER
--������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� 
--����������, �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
--GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER ������� ������ ��������
--���������� ��������� �� ������� SUBJECT, ������������ �� ��������, �������� ����� ������� ���������.
--������������ ��������� ���� � ����������������� ���������� ���������. 

create or replace function VGET_NUM_TEACHERS(FCODE FACULTY.FACULTY%type)
  return number is
    TCOUNT number;
begin
  select COUNT(*) 
  into TCOUNT 
  from TEACHER T
  join PULPIT P
    on T.PULPIT = P.PULPIT
  where P.FACULTY = FCODE;
  
  return TCOUNT;
end;


begin
  DBMS_OUTPUT.PUT_LINE('���-�� �������������� �� ����������: ' || VGET_NUM_TEACHERS('����'));
end;

create or replace function V1GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%type)
  return number is
    TCOUNT number := 0;
begin
    select COUNT(*) 
    into TCOUNT
    from SUBJECT
    where SUBJECT.PULPIT = PCODE;
    
    return TCOUNT;
end;


begin
  DBMS_OUTPUT.PUT_LINE('���-�� ��������� �� �������: ' || V1GET_NUM_SUBJECTS('����'));
end;
commit;
--6. ������� ������������ ����� TEACHERS, ���������� ��������� � �������:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER GET_NUM_SUBJECTS
--(PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 

create or replace package TEACHERS_NEW_ as
  FCODE FACULTY.FACULTY%type;
  PCODE SUBJECT.PULPIT%type;
  procedure VGET_TEACHERS(FCODE FACULTY.FACULTY%type);
  procedure VGET_SUBJECTS (PCODE SUBJECT.PULPIT%type);
  function VGET_NUM_TEACHERS(FCODE FACULTY.FACULTY%type) return number;
  function V1GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%type) return number;
end TEACHERS_NEW_;


create or replace package body TEACHERS_NEW_ as
  function VGET_NUM_TEACHERS(FCODE FACULTY.FACULTY%type) return number
    is TCOUNT number;
      begin
        select COUNT(*) 
        into TCOUNT 
        from TEACHER T
        join PULPIT P
          on T.PULPIT = P.PULPIT
        where P.FACULTY = FCODE;
        return TCOUNT;
      end VGET_NUM_TEACHERS;
      
  function V1GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%type)
    return number is
    TCOUNT number:=0;
    begin
      select COUNT(*) 
      into TCOUNT
      from SUBJECT
      where SUBJECT.PULPIT = PCODE;
      return TCOUNT;
    end V1GET_NUM_SUBJECTS;
    
  procedure VGET_SUBJECTS (PCODE SUBJECT.PULPIT%type) is
    cursor T_CURS is
      select SUBJECT, SUBJECT_NAME, S.PULPIT
      from SUBJECT S
      where S.PULPIT = PCODE;
      S_SUBJECT SUBJECT.SUBJECT%type;
      S_SUBJECT_NAME SUBJECT.SUBJECT_NAME%type;
      S_PULPIT SUBJECT.PULPIT%type;
    begin
      open T_CURS;
      LOOP
        DBMS_OUTPUT.PUT_LINE(S_SUBJECT || ' ' || S_SUBJECT_NAME || ' ' || S_PULPIT);
        FETCH T_CURS into S_SUBJECT, S_SUBJECT_NAME, S_PULPIT;
        EXIT when T_CURS%NOTFOUND;
      end LOOP;
      close T_CURS;
    end VGET_SUBJECTS;
    
  procedure VGET_TEACHERS(FCODE FACULTY.FACULTY%type) is
    cursor T_CURS is
      select T.TEACHER_NAME, T.TEACHER, P.FACULTY
      from TEACHER T
      join PULPIT P
        on T.PULPIT = P.PULPIT
      where P.FACULTY = FCODE;
      T_NAME TEACHER.TEACHER_NAME%type;
      T_CODE TEACHER.TEACHER%type;
      T_FACULTY PULPIT.FACULTY%type;
    begin
      open T_CURS;
      LOOP
        DBMS_OUTPUT.PUT_LINE(T_NAME || ' ' || rtrim(T_CODE) || ' ' || T_FACULTY);
        FETCH T_CURS into T_NAME, T_CODE, T_FACULTY;
        EXIT when T_CURS%NOTFOUND;
      end LOOP;
      close T_CURS;
    end VGET_TEACHERS;
end TEACHERS_NEW_;

commit;
--7. ������� 
---������������ ��������� ���� � ����������������� 
--���������� �������� � ������� ������ TEACHERS.


begin
  DBMS_OUTPUT.PUT_LINE('���-�� �������������� �� ����������: ' || TEACHERS_NEW_.VGET_NUM_TEACHERS('����'));
  DBMS_OUTPUT.PUT_LINE('���-�� ��������� �� �������: ' || TEACHERS_NEW_.V1GET_NUM_SUBJECTS('����'));
  TEACHERS_NEW_.VGET_TEACHERS('����');
  TEACHERS_NEW_.VGET_SUBJECTS('����');
end;
