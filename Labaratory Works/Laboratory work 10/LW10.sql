--10 Лабораторная работа
commit;
-- ВЫВОД АНОНИМНЫХ БЛОКОВ В SQLPLUS
-- SET SERVEROUTPUT ON;
-- BEGIN
DBMS_OUTPUT.PUT_LINE();
END:
--/
--connect USER_MVV_PDB/4321@vera;

--1 задание
--Разработайте простейший анонимный блок не содержащий операторов 

begin
 null;
end;

--2 задание
-- Разработайте аб. Выводящий "Hello world"
-- выполните его в SQLPLUS и в SQLDEV

begin 
  dbms_output.put_line('Hello world');
end;

--3 задание
--Продемонстрируйте работу исключения и встроенных функций sqlerrm, sqlcode

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
   

-- 4 задание 
-- Разработайте вложенный бло. Продемонстрируйте принцип обработки 
--исключений во вложенных блоках
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

--5 задание
--Выясните какие типы предупреждения компилятора поддерживаются в данный момент 

show parameter plsql_warnings;
select name, value from v$parameter
where name = 'plsql_warnings';

--6 задание
--разработайте скрипт, позволяющий просмотреть все спец. символы PL/sql

select keyword from 
v$reserved_words where length = 1 and keyword != 'A';

--7 задание 
--разработайте скрипт позволяющий просмотреть все ключевые слова PL/SQL


select keyword from  v$reserved_words where length > 2 and keyword != 'A' order by keyword;


--8 задание 
--Разработайте скрипт позволяющий просмотреь все параметры Oracle Server,
--связанные с PL/SQL. Просмотрите эти же параметры в SQL+ комнадой Show

show parameter plsql;

--9 Задание - 17 Задание 
--Разрабоатйте анонимынй блок, демонстрирующий (выводящий и выходной серверный поток результаты):
-- Объявление и инициализацию целых number - переменных 
-- Арифметичские действия над двумя целыми number переменных, включая деление с остатком
-- Объявление и инициализаци. number переменных с фиксированной точкой. 
-- Объявлеение и инициализация num-переменных с фикс. точкой и отрицательным масштабом (округление)
-- Объявлеение и инициализация BINARY-FLOAT переменной
-- Объявлеение и инициализация BINARY-DOUBLE переменной
-- Объявление number переменных с точкой и применением символа E (степень 10) при инициализации/прсивоении.
-- Объявление и инициалиация BOOLEAN перемнных


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
    dbms_output.put_line('a =' || first__);--вывод переменых
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


--18 Задание 
-- разработайте анонимынй блок PL/SQL содержащий объявление констант 
-- (VARCHAR2, CHAR, NUMBER). Продемонстрируйте возможные операции константами.
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

--19 Задание 
-- Разработайте АБ, содержащий объявления с опцией %TYPE
-- Продемонстрируйте действие опции
select* from pulpit;

declare 
    m_pulpit pulpit.pulpit%type;
    pulpit_row pulpit%rowtype;
begin 
    m_pulpit := 'ИСиТ';
    pulpit_row.faculty := 'ИДиП';
    dbms_output.put_line('pulpit = ' || m_pulpit);
    dbms_output.put_line('pulpit_row = ' || pulpit_row.faculty);
exception 
    when others
    then
        dbms_output.put_line(sqlerrm);
end;
-- 20 Задание 
-- Разработайте АБ, содержащий объявления с опцией %ROWTYPE
-- Продемонстрируйте действие опции


-- 21 Заданиее 
-- Разрабоатйте АБ. Демоснтрирующий все возможные конструкции оператора IF

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
    
    
-- 22 Заданиее 
-- Разрабоатйте АБ. Демоснтрирующий все возможные конструкции оператора CASE

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

-- 24 Заданиее 
-- Разрабоатйте АБ. Демоснтрирующий все возможные конструкции оператора LOOP
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


-- 25 Заданиее 
-- Разрабоатйте АБ. Демоснтрирующий все возможные конструкции оператора WHILE
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


-- 26 Заданиее 
-- Разрабоатйте АБ. Демоснтрирующий все возможные конструкции оператора FOR

declare 
    a number(1) := 1;
begin
    dbms_output.put_line('FOR:');
    for a in 1..10
    loop
        dbms_output.put_line(a);
    end loop;
end;





 