--1 задание
--выдать польщователю pdb необходимые привилегии

grant connect, create table, create view, create sequence, create cluster,
create synonym, create public synonym, create materialized view TO USER_MVV_PDB; 
grant drop public synonym to user_mvv_pdb;
commit;
 --connect system/Qwerty123@//localhost:1521/MVV_PDB as sysdba;
--alter pluggable database MVV_PDB open;

--2 задание 
--создайте послдовательность S1 (SEQUENCE), cо след. характеристиками
-- нач. знач 1000
--приращение 10
--нет мин значения
--нет макс знач
--не циклическая 
--знач. не кэшируются в памяти
--хронология не имеет знач
--ПОЛУЧИТЕ НЕСКОЛЬКО ЗНАЧЕНИЙ ПОСЛЕДОВАТЕЛЬНОСТИ
--ПОЛУЧИТЕ ТЕКУЩЕЕ ЗНАЧЕНИЕ ПОСЛЕДОВАТЕЛЬНОСТИ

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
--3 задание
-- создайте последовательность s2
-- нач знач. 10
-- прир. 10
-- макс 100
-- не цикл.
-- получ. все знач. последовательности
-- попытайтесь получить знач выходящее за макс. знач.

create sequence USER_MVV_PDB.S2
start with 10
increment by 10
maxvalue 100
nocycle;

select USER_MVV_PDB.S2.NEXTVAL from DUAL;
select USER_MVV_PDB.S2.CURRVAL from DUAL;

drop sequence S2;
commit;
--4 задание 
-- создать последовательность s3
-- нач знач. 10
-- прир. -10 
-- мин знач. -100
-- не цикл.
-- гарантир. хрон. значений.
-- ПОЛУЧИТЬ ВСЕ ЗНАЧ. ПОСЛЕДОВАТЕЛЬНОСТИ
--попытайтесь получить знач. меньше мин.


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
-- 5 задание 
-- создать последовательность s4
-- нач. знач 1
-- прир. 1
-- мин занч. 10
-- цикл-ая
-- кэшируется в памяти 5 знач.
-- хронология негарантируется
-- ПРОДЕМОНСТРИРОВАТЬ ЦИКЛИЧНОСТЬ ГЕНЕРАЦИИ ЗНАЧЕНИЙ 

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

-- 6 ЗАДАНИЕ
-- ПОЛУЧИТЕ СПИСОК ВСЕХ ПОСЛЕДОВАТЕЛЬНОСТЕЙ
-- В СЛОВАРЕ БД
-- ВЛАДЕЛЬЦЕМ КОТОРЫХ ЯВЛ. MVV


select * from all_sequences where SEQUENCE_OWNER like 'USER_MVV%';
select * from user_sequences;

--7 ЗАДАНИЕ
-- создайте таблицу T1, имеющую столбцы 
-- N1, N2, N3, N4
-- типа Number(20),
-- Кэшируемую
-- Рапсполож. в буферном пуле KEEP
-- Добавить 7 строк
-- вводимое значение для столбцов должно формироваться с помощью
-- последовательностей S1,S2,S3,S4

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

--8 ЗАДАНИЕ
-- создайте кластер  ABC 
-- имеющий hash тип (200) 
-- содержит 2 поля 
-- X (NUMBER (10)), V (VARCHAR(12));

select * from user_tablespaces;-- определить табличные пространства

create cluster USER_MVV_PDB.ABC
(
    X number(10),
    V varchar(12)
)
hashkeys 200
tablespace MVV_TB;
commit;
drop cluster ABC;

--9 ЗАДАНИЕ
-- создайте таблицу А, имеющую столбцы 
-- XA (NUMBER (10)
-- VA (VARCHAR(12))
-- ПРИНАДЛЕЖИТ КЛАСТЕРУ ABC
-- прлизвольный столбец

create TABLE A
(
    XA number(10),
    VA varchar(12),
    PS varchar(10)
)
cluster USER_MVV_PDB.ABC(XA,VA);

commit;
drop table A;

--10 ЗАДАНИЕ
-- создайте таблицу B
-- имеющую столбцы XB (NUMBER (10))
-- VB (VARCHAR(12))
-- принадлежащую кластеру ABC
-- произвлльный столбец

create TABLE B
(
    XB number(10),
    VB varchar(12),
    PS1 varchar(10)
)
cluster USER_MVV_PDB.ABC(XB,VB);
commit;
drop table b;

--11 ЗАДАНИЕ
-- создайте таблицу С
-- имеющую столбцы 
-- XC (NUMBER (10))
-- VC (VARCHAR (12))
-- принадлежащую кластеру ABC
-- произ. столбец
create TABLE C
(
    XC number(10),
    VC varchar(12),
    PS2 varchar(10)
)
cluster USER_MVV_PDB.ABC(XC,VC);
commit;
drop table c;


--12 ЗАДАНИЕ
-- Найдите созданные таблицы и кластер в пресдтавлеиях словаря оракл

--select * from dba_segments where segment_type = 'CLUSTER' order by segment_name;
select * from user_tables where cluster_name = 'ABC';
commit;

-- 13 Задание 
-- Создайте частный синоним для таблицы XXX.C
-- Продемонстрировтаь

create synonym TABLE_C_SYNONYM for C; 
select * from TABLE_C_SYNONYM;
drop synonym TABLE_C_SYNONYM;

commit;
--14 Задание
-- создайте публичный синоним
-- пролемонстрировать применение

create PUBLIC synonym TABLE_B_SYNONYM for B; 
select * from TABLE_B_SYNONYM;

drop public synonym TABLE_B_SYNONYM;
commit;

--15 задание 
-- создайте 2 произвольные табоицы A И B
-- заполнить данными 
-- создайте представление V1
-- основанное на SELECT, FOR, A inner join B
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


-- 16 задание
-- на основе табоиц A и B 
-- созадть материализованное представление MV
-- периодичность обовления 2 минуты.


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









































