--15 ����������� ������ ��������


--1.	�������� �������, ������� ��������� ���������, ���� �� ������� ��������� ����.
create table TBL_NEW (A varchar(30) primary key, B varchar(30));

drop table TBL_NEW;
--2.	��������� ������� �������� (10 ��.).


insert into TBL_NEW values ('1a', '1b');
insert into TBL_NEW values ('2a', '2b');
insert into TBL_NEW values ('3a', '3b');
insert into TBL_NEW values ('4a', '4b');
insert into TBL_NEW values ('5a', '5b');
insert into TBL_NEW values ('6a', '6b');
insert into TBL_NEW values ('7a', '7b');
insert into TBL_NEW values ('8a', '8b');
insert into TBL_NEW values ('9a', '9b');
insert into TBL_NEW values ('10a', '10b');


select A, B  from TBL_NEW;


--3.	�������� BEFORE � ������� ������ ��������� �� ������� INSERT, DELETE � UPDATE. -
--4.	���� � ��� ����������� �������� ������ �������� ��������� �� ��������� ������� 
--(DMS_OUTPUT) �� ����� ����������� ������. 

create or replace trigger TBL_NEW_BEFORE_INSERT_TR
before insert on TBL_NEW
begin DBMS_OUTPUT.PUT_LINE('TBL_NEW BEFORE INSERT'); 
end;
    
create or replace trigger TBL_NEW_BEFORE_UPDATE_TR
before update on TBL_NEW
begin DBMS_OUTPUT.PUT_LINE('TBL_NEW BEFORE UPDATE'); 
end;
    
create or replace trigger TBL_NEW_BEFORE_DELETE_TR
before delete on TBL_NEW
begin DBMS_OUTPUT.PUT_LINE('TBL_NEW BEFORE DELETE'); 
end;
    
      
       
-- 5.	�������� BEFORE-������� ������ ������ �� ������� INSERT, DELETE � UPDATE
    
create or replace trigger TBL_NEW_BEFORE_INSERT_ROW
before insert on TBL_NEW
    for each row
    begin DBMS_OUTPUT.PUT_LINE('ROW INSERT'); 
end;

create or replace trigger TBL_NEW_BEFORE_UPDATE_ROW
before update on TBL_NEW
    for each row
    begin DBMS_OUTPUT.PUT_LINE('ROW UPDATE'); 
end;

create or replace trigger  TBL_NEW_BEFORE_DELETE_ROW
before delete on TBL_NEW
    for each row
    begin DBMS_OUTPUT.PUT_LINE('ROW DELETE');
end;
    
    
    
--6.	��������� ��������� INSERTING, UPDATING � DELETING.

create or replace trigger TBL_NEW_PREDICATES
before insert or update or delete on TBL_NEW
    begin
    if INSERTING then
        DBMS_OUTPUT.PUT_LINE('PREDICATES INSERT');
    ELSIF UPDATING then
        DBMS_OUTPUT.PUT_LINE('PREDICATES UPDATE');
    ELSIF DELETING then
        DBMS_OUTPUT.PUT_LINE('PREDICATES DELETE');
end if;
end;    
    
    
    
--7. ������������ AFTER-�������� ������ ��������� �� ������� INSERT, DELETE � UPDATE.
    
create or replace trigger TBL_NEW_AFTER_INSERT
    after insert on TBL_NEW
    begin DBMS_OUTPUT.PUT_LINE('TBL_NEW AFTER INSERT'); 
end;

create or replace trigger TBL_NEW_AFTER_UPDATE
    after update on TBL_NEW
    begin DBMS_OUTPUT.PUT_LINE('TBL_NEW AFTER UPDATE'); 
end;
    
create or replace trigger TBL_NEW_AFTER_DELETE
    after delete on TBL_NEW
    begin DBMS_OUTPUT.PUT_LINE('TBL_NEW AFTER DELETE'); 
end;



--8.	������������ AFTER-�������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
    
create or replace trigger TBL_NEW_AFTER_INSERT_ROW
    after insert on TBL_NEW
    for each row
    begin DBMS_OUTPUT.PUT_LINE('TBL_NEW AFTER_ROW INSERT'); 
end;
    
create or replace trigger TBL_NEW_AFTER_UPDATE_ROW
after update on TBL_NEW
    for each row
    begin DBMS_OUTPUT.PUT_LINE('TBL_NEW AFTER_ROW UPDATE'); 
end;

create or replace trigger TBL_NEW_AFTER_DELETE_ROW
after delete on TBL_NEW
    for each row
    begin DBMS_OUTPUT.PUT_LINE('TBL_NEW AFTER_ROW DELETE'); 
end;
    


-- 9.	�������� ������� � ������ AUDIT. ������� ������ ��������� ����: OperationDate, 
--OperationType (�������� �������, ���������� � ��������),
--TriggerName(��� ��������),
--Data (������ � ���������� ����� �� � ����� ��������).

create table AUDIT_NEW
(
    OPERATIONDATE timestamp, 
    OPERATIONTYPE varchar2(100), 
    TRIGGERNAME varchar2(100),
    DATA varchar2(300)   
);

drop table AUDIT_NEW;

-- 10 �������� �������� ����� �������, ����� ��� �������������� ��� �������� � �������� �������� � ������� AUDIT.
--11.	��������� ��������, ���������� ����������� ������� �� ���������� �����. ��������,
--��������������� �� ������� ��� �������. ��������� ���������.
    
create or replace trigger TR_AUDIT_NEW
    before insert or update or delete on TBL_NEW
    for each row
    begin
        if INSERTING then
        DBMS_OUTPUT.PUT_LINE('BEFORE INSERT AUDIT' );
        insert into AUDIT_NEW(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, data) values
        (
            localtimestamp,
            'Insert', 
            'TRIGGER_DML_AUDIT_NEW',
            :new.A || ' ' || :new.B
        );
        elsif UPDATING then
        DBMS_OUTPUT.PUT_LINE('BEFORE UPDATE AUDIT');
        insert into AUDIT_NEW(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
        values
        (
            localtimestamp, 
            'Update', 
            'TRIGGER_DML_AUDIT_NEW',
            :old.A || ' ' ||  :old.B || ' -> ' || :new.A || ' ' ||  :new.B
        );    
        elsif DELETING then
        DBMS_OUTPUT.PUT_LINE('BEFORE DELETE AUDIT');
        insert into AUDIT_NEW(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, data)
        values
        (
            localtimestamp, 
            'Delete', 
            'TRIGGER_DML_AUDIT_NEW',
            :old.A || ' ' ||  :old.B
        );
        end if;
end;
    
--subject A

-- 12.	������� (drop) �������� �������. ��������� ���������. 
--�������� �������, ����������� �������� �������� �������.
    
create table TBL_NEW (A varchar(30) primary key, B varchar(30));
drop table TBL_NEW;

create or replace trigger STOP_DELETE_
before drop on schema
begin
    if ORA_DICT_OBJ_NAME = 'TBL_NEW' AND ORA_DICT_OBJ_TYPE = 'TABLE'
    then
    RAISE_APPLICATION_ERROR (-20000, '[ERROR] YOU CANT TBL_NEW.');
    end if;
end; 

drop trigger STOP_DELETE_;
    
commit;

--13.	������� (drop) ������� AUDIT. 
--����������� ��������� ��������� � ������� SQL-DEVELOPER. ��������� ���������. �������� ��������.

drop table AUDIT_NEW;

-- 14.	�������� ������������� ��� �������� ��������. ������������ INSTEADOF INSERT-�������. 
--������� ������ ��������� ������ � �������.
drop view VIEW_TBL_NEW;
create view VIEW_TBL_NEW as 
select * from TBL_NEW;
    
create or replace trigger TR_INSTEAD_OF_TBL_NEW
instead of insert on VIEW_TBL_NEW
    begin
    if INSERTING then
        DBMS_OUTPUT.PUT_LINE('INSTEAD OF INSERTING');
        insert into TBL_NEW values ('111', '222');
    end if;
end TR_INSTEAD_OF_TBL_NEW;
    
insert into VIEW_TBL_NEW values('888', '999');
select * from VIEW_TBL_NEW;
    
    
    


select OBJECT_NAME, STATUS from USER_OBJECTS where OBJECT_TYPE = 'TRIGGER';--��� ����
alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';
