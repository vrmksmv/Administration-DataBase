--12 ЛАБОРАТОРНАЯ 
-- ВСТРОЕННЫЕ ФУНКЦИИИ

alter session set nls_date_format = 'DD-MM-YYYY';

--1. Задание Добавьте в таблицу TEACHERS два столбца BIRTHDAYи SALARY, заполните их значениями.

alter table TEACHER add BIRTHDAY date;
alter table TEACHER add SALARY number;


commit;


--2.Задание Список преподов в виде Фамилия И.О.


select teacher_name from TEACHER;
select regexp_substr(teacher_name,'(\S+)',1, 1) || ' ' || substr(regexp_substr(teacher_name,'(\S+)',1, 2),1, 1)|| '.' || substr(regexp_substr(teacher_name,'(\S+)',1, 3),1, 1)||'. ' as V
from teacher;


--3.Задание  Список преподов с днем рождения в понедельник
    
SELECT * FROM teacher where TO_CHAR((birthday), 'd') = 2;

--4. Задание Создайте представление, в котором поместите список преподавателей, которые родились в следующем месяце.

create or replace view NEXT_M as select * FROM teacher
    where TO_CHAR(birthday, 'mm') =  (select substr(to_char(trunc(last_day(sysdate)) + 1), 4, 2) from dual);
SELECT * FROM NEXT_M;


--5. Задание Создайте представление, в котором поместите количество преподавателей, которые родились в каждом месяце.

create or replace view NUM_TEACHER as  select to_char(birthday, 'Month') MONTH_, count(*) CAPACITY_ from teacher
    group by to_char(birthday, 'Month')
    having count(*) >= 1
    order by CAPACITY_ desc;
select * from NUM_TEACHER;


--6.Задание Создать курсор и вывести список преподавателей, у которых в следующем году юбилей.

cursor ANNIVERSARY(teacher%rowtype) 
    return teacher%rowtype is
    select * from teacher
where MOD((TO_CHAR(sysdate,'yyyy') - TO_CHAR(birthday, 'yyyy') + 1), 10) = 0;
    

--7. Задание  Создать курсор и вывести среднюю заработную плату по кафедрам с округлением вниз до целых,
--вывести средние итоговые значения для каждого факультета и для всех факультетов в целом.

cursor AVERANGE(teacher.salary%type,teacher.pulpit%type) 
    return teacher.salary%type,teacher.pulpit%type is
    select pulpit, floor(avg(salary)) as AVG_SALARY
    from teacher
group by pulpit;
  
-- Средняя з/п на факультетах
select 
    P.faculty, 
    round(AVG(S.salary)) as AVG_SALARY
from teacher S
    join pulpit P on S.pulpit = P.pulpit
    group by P.faculty
union
    select teacher.pulpit, floor(avg(salary))
    from teacher
    group by teacher.pulpit
order by faculty;

-- Сердняя з/п во всем универе

select 
round(avg(salary)) as AVG_SALARY 
from teacher;

--8. Задание Создайте собственный тип PL/SQL-записи (record) и продемонстрируйте работу с ним. 
--Продемонстрируйте работу с вложенными записями. Продемонстрируйте и объясните операцию присвоения.
select * from teacher;
declare
    type RANG__ is record
    (
        science nvarchar2(50),
        study   nvarchar2(50)
    );
    type rang is record
    (
        name teacher.teacher_name%type,
        pulp teacher.pulpit%type,
        HUMAN_RANG RANG__
    );
    rang_1 rang;
    rang_2 rang;
    begin
select teacher_name, pulpit into rang_1.name, rang_1.PULP
from teacher
where teacher = 'УРБ';
      
rang_1.HUMAN_RANG.science := 'Доктор наук';
rang_1.HUMAN_RANG.study := 'Профессор';
rang_2 := rang_1;
dbms_output.put_line( rang_2.name || ' ' || rtrim(rang_2.pulp) || ': ' || rang_2.HUMAN_RANG.science || ', ' || rang_2.HUMAN_RANG.study);
end;
    
    
    
    
    
    
    
    
--update TEACHER set BIRTHDAY = '12-02-1959' where TEACHER = 'СМЛВ';
--update TEACHER set BIRTHDAY = '30-01-1987' where TEACHER = 'АКНВЧ';
--update TEACHER set BIRTHDAY = '19-04-1991' where TEACHER = 'КЛСНВ';
--update TEACHER set BIRTHDAY = '16-04-1964' where TEACHER = 'ГРМН';
--update TEACHER set BIRTHDAY = '19-11-1988' where TEACHER = 'ЛЩНК';
--update TEACHER set BIRTHDAY = '05-10-1966' where TEACHER = 'БРКВЧ';
--update TEACHER set BIRTHDAY = '10-08-1976' where TEACHER = 'ДДК';
--update TEACHER set BIRTHDAY = '11-09-1989' where TEACHER = 'КБЛ';
--update TEACHER set BIRTHDAY = '24-12-1983' where TEACHER = 'УРБ';
--update TEACHER set BIRTHDAY = '03-06-1990' where TEACHER = 'РМНК';
--update TEACHER set BIRTHDAY = '10-05-1970' where TEACHER = 'ПСТВЛВ';
--update TEACHER set BIRTHDAY = '26-10-1999' where TEACHER = '?';
--update TEACHER set BIRTHDAY = '30-07-1984' where TEACHER = 'ГРН';
--update TEACHER set BIRTHDAY = '11-03-1975' where TEACHER = 'ЖЛК';
--update TEACHER set BIRTHDAY = '12-07-1969' where TEACHER = 'БРТШВЧ';
--update TEACHER set BIRTHDAY = '26-02-1983' where TEACHER = 'ЮДНКВ';
--update TEACHER set BIRTHDAY = '13-12-1991' where TEACHER = 'БРНВСК';
--update TEACHER set BIRTHDAY = '20-01-1968' where TEACHER = 'НВРВ';
--update TEACHER set BIRTHDAY = '21-12-1969' where TEACHER = 'РВКЧ';
--update TEACHER set BIRTHDAY = '28-01-1975' where TEACHER = 'ДМДК';
--update TEACHER set BIRTHDAY = '10-07-1983' where TEACHER = 'МШКВСК';
--update TEACHER set BIRTHDAY = '08-10-1988' where TEACHER = 'ЛБХ';
--update TEACHER set BIRTHDAY = '30-07-1984' where TEACHER = 'ЗВГЦВ';
--update TEACHER set BIRTHDAY = '16-04-1964' where TEACHER = 'БЗБРДВ';
--update TEACHER set BIRTHDAY = '12-05-1985' where TEACHER = 'ПРКПЧК';
--update TEACHER set BIRTHDAY = '20-10-1980' where TEACHER = 'НСКВЦ';
--update TEACHER set BIRTHDAY = '21-08-1990' where TEACHER = 'МХВ';
--update TEACHER set BIRTHDAY = '13-08-1966' where TEACHER = 'ЕЩНК';
--update TEACHER set BIRTHDAY = '11-11-1978' where TEACHER = 'ЖРСК';



--update TEACHER set SALARY = 9999 where TEACHER = 'СМЛВ';
--update TEACHER set SALARY = 1030 where TEACHER = 'АКНВЧ';
--update TEACHER set SALARY = 980 where TEACHER = 'КЛСНВ';
--update TEACHER set SALARY = 1050 where TEACHER = 'ГРМН';
--update TEACHER set SALARY = 590 where TEACHER = 'ЛЩНК';
--update TEACHER set SALARY = 870 where TEACHER = 'БРКВЧ';
--update TEACHER set SALARY = 815 where TEACHER = 'ДДК';
--update TEACHER set SALARY = 995 where TEACHER = 'КБЛ';
--update TEACHER set SALARY = 1460 where TEACHER = 'УРБ';
--update TEACHER set SALARY = 1120 where TEACHER = 'РМНК';
--update TEACHER set SALARY = 1250 where TEACHER = 'ПСТВЛВ';
--update TEACHER set SALARY = 333 where TEACHER = '?';
--update TEACHER set SALARY = 1520 where TEACHER = 'ГРН';
--update TEACHER set SALARY = 1430 where TEACHER = 'ЖЛК';
--update TEACHER set SALARY = 900 where TEACHER = 'БРТШВЧ';
--update TEACHER set SALARY = 875 where TEACHER = 'ЮДНКВ';
--update TEACHER set SALARY = 970 where TEACHER = 'БРНВСК';
--update TEACHER set SALARY = 780 where TEACHER = 'НВРВ';
--update TEACHER set SALARY = 1150 where TEACHER = 'РВКЧ';
--update TEACHER set SALARY = 805 where TEACHER = 'ДМДК';
--update TEACHER set SALARY = 905 where TEACHER = 'МШКВСК';
--update TEACHER set SALARY = 1200 where TEACHER = 'ЛБХ';
--update TEACHER set SALARY = 1500 where TEACHER = 'ЗВГЦВ';
--update TEACHER set SALARY = 905 where TEACHER = 'БЗБРДВ';
--update TEACHER set SALARY = 715 where TEACHER = 'ПРКПЧК';
--update TEACHER set SALARY = 880 where TEACHER = 'НСКВЦ';
--update TEACHER set SALARY = 735 where TEACHER = 'МХВ';
--update TEACHER set SALARY = 595 where TEACHER = 'ЕЩНК';
--update TEACHER set SALARY = 850 where TEACHER = 'ЖРСК';