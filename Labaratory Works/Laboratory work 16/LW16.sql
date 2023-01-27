--16 ЛАБОРАТОНАЯ РАБОТА 
-- СЕКЦИОНИРОВАИЕ ТАБЛИЦ



--1.	Создайте таблицу T_RANGE c диапазонным секционированием. Используйте ключ секционирования типа NUMBER. 

DROP TABLE T_RANGE;

CREATE TABLE T_RANGE
(
  PER NUMBER
)
PARTITION BY RANGE (PER)
(
PARTITION rang_1 VALUES LESS THAN (12),
PARTITION rang_2 VALUES LESS THAN (15),
PARTITION max_rang VALUES LESS THAN (MAXVALUE)
);
INSERT INTO T_RANGE VALUES(2);
INSERT INTO T_RANGE VALUES(3);
INSERT INTO T_RANGE VALUES(50);

select * from T_RANGE;
drop table T_RANGE;
------
--ПЕРЕМЕЩЕНИЕ СТОЛБЦОВ
ALTER TABLE T_RANGE ENABLE ROW MOVEMENT;
UPDATE  T_RANGE PARTITION(rang_1)
SET PER=PER-1;

--8.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE SPLIT.
ALTER TABLE T_RANGE SPLIT PARTITION rang_2
AT (13) INTO
(
PARTITION rang2_A,
PARTITION rang2_B
)


--2.	Создайте таблицу T_INTERVAL c интервальным секционированием. Используйте ключ секционирования типа DATE.

create table T_Interval(
    date_val date primary key,
    val number
)
partition by range(date_val)
interval (NUMTOYMINTERVAL(1, 'YEAR'))
(
    PARTITION p0 VALUES LESS THAN (TO_DATE('1-1-2000', 'DD-MM-YYYY'))
);

SELECT * FROM T_Interval;



INSERT INTO T_Interval VALUES('25-03-2018',3);

SELECT * FROM T_INTERVAL;


ALTER DATABASE 
DATAFILE 'C:\lab\MVV_TB_NEW.DBF'
resize 3000M;

--3.	Создайте таблицу T_HASH c хэш-секционированием. Используйте ключ секционирования типа VARCHAR2.

CREATE TABLE T_HASH (STR VARCHAR2(15))
PARTITION BY HASH(STR)
PARTITIONS 16

INSERT INTO T_HASH VALUES('aaa');
INSERT INTO T_HASH VALUES('bbb');
INSERT INTO T_HASH VALUES('ccc');

SELECT * FROM T_HASH;

--4.	Создайте таблицу T_LIST со списочным секционированием. Используйте ключ секционирования типа CHAR.

CREATE TABLE T_LIST
(
    STR char(20)
)
PARTITION BY LIST (STR)
(
PARTITION part1 VALUES('A'),
PARTITION part2 VALUES('AA'),
PARTITION part3 VALUES(DEFAULT)
)
 
INSERT INTO T_LIST VALUES('A');
INSERT INTO T_LIST VALUES('B');
INSERT INTO T_LIST VALUES('A');

select * from T_LIST;
--MERGE
ALTER TABLE T_LIST MERGE PARTITIONS
 part1, part2 INTO PARTITION part_12;

drop TABLE T_LIST;

--5.	Введите с помощью операторов INSERT данные в таблицы T_RANGE, T_INTERVAL, T_HASH, T_LIST.
--Данные должны быть такими, чтобы они разместились по всем секциям. Продемонстрируйте это с помощью SELECT запроса.

--выше



--7.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE MERGE.





--9.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE EXCHANGE.



























