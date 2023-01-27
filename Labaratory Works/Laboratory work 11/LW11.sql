--1. Разработайте АБ, демонстрирующий работу 
--оператора SELECT с точной выборкой. 
SET SERVEROUTPUT ON SIZE UNLIMITED;
select * from pulpit;
alter pluggable database MVV_PDB open;


declare
  p pulpit%rowtype;
begin
  select * into p from pulpit where faculty = 'ИДиП';
  DBMS_OUTPUT.PUT_LINE(rtrim(p.pulpit) || ': ' || p.pulpit_name);
exception when others then
  DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;

--2. Разработайте АБ,
--демонстрирующий работу оператора SELECT
--с неточной точной выборкой. Используйте конструкцию WHEN OTHERS секции исключений
--и встроенную функции SQLERRM, SQLCODE для диагностирования неточной выборки. 


--РЕЗУЛЬТАТ: ТОЧНАЯ ВЫБОРКА ВОЗВРАЩАЕТ....
declare
  p pulpit%rowtype;
begin
  select * into p from pulpit;   
  DBMS_OUTPUT.PUT_LINE(rtrim(p.pulpit) || ': ' || p.pulpit_name);
exception when others then 
  dbms_output.put_line('[ERROR] When others: ' || sqlerrm || sqlcode);
end;


---3. Разработайте АБ, демонстрирующий работу конструкции
--WHEN TO_MANY_ROWS секции исключений для диагностирования неточной выборки. 


--ОШИБКА БУДЕТ ТАЖЕ НО ТИПИЗИРОВАННАЯ

declare
  p pulpit%rowtype;
begin
  select * into p from pulpit; 
  DBMS_OUTPUT.PUT_LINE(p.pulpit ||' '||p.pulpit_name);
  exception
    when too_many_rows
    then DBMS_OUTPUT.PUT_LINE('[ERROR] When too_many_rows: '|| sqlerrm || sqlcode);
end;

---4. Разработайте АБ, демонстрирующий возникновение 
--и обработку исключения NO_DATA_FOUND. Разработайте АБ, 
--демонстрирующий применение атрибутов неявного курсора.


declare
  p pulpit%rowtype;
begin
  select * into p from pulpit where pulpit = 'ИСиТ'; 
  DBMS_OUTPUT.PUT_LINE(rtrim(p.pulpit)||': '|| p.pulpit_name);
  if sql%found then
    dbms_output.put_line('%found:true');
  else
    dbms_output.put_line('%found:false');
  end if;
  if sql%isopen then
    dbms_output.put_line('$isopen:true');
  else
    dbms_output.put_line('$isopen:false');
  end if;
  if sql%notfound then
    dbms_output.put_line('%notfound:true');
  else
    dbms_output.put_line('%notfound:false');
  end if;
  dbms_output.put_line('%rowcount:'||sql%rowcount);
  exception
    when no_data_found then
      dbms_output.put_line('[ERROR] When no_data_found:' || sqlerrm || '-' || sqlcode);
    when others then
      dbms_output.put_line(sqlerrm);
end;

---5. Разработайте АБ, демонстрирующий применение оператора UPDATE совместно с операторами COMMIT/ROLLBACK. 
---6. Продемонстрируйте оператор UPDATE, вызывающий нарушение целостности в базе данных. Обработайте возникшее исключение.

select * from pulpit;
select * from pulpit order by pulpit;
commit;
begin
  update PULPIT set 
    pulpit ='ОХ',
    pulpit_name = 'Органической химии',
    faculty = 'ТОВ'
  where pulpit = 'ОХ';   
  --rollback;
  dbms_output.put_line('SUCCESS!');
  exception when others then
    dbms_output.put_line('[error]' || sqlerrm);
end;



---7. Разработайте АБ, демонстрирующий применение оператора INSERT совместно с операторами COMMIT/ROLLBACK.
---8. Продемонстрируйте оператор INSERT, вызывающий нарушение целостности в базе данных. Обработайте возникшее исключение.

select * from pulpit;
 rollback;
 commit;
begin
  insert into pulpit(pulpit, pulpit_name, faculty)
  values('NEW', 'NEW', 'ЛХФ');
  commit;
  --rollback;
  end;
  exception when others then
    dbms_output.put_line('[ERROR] ' || sqlerrm);
end;
-----ЧТО -----

---9. Разработайте АБ, демонстрирующий применение оператора DELETE совместно с операторами COMMIT/ROLLBACK.
---10. Продемонстрируйте оператор DELETE, вызывающий нарушение целостности в базе данных. Обработайте возникшее исключение.
--Явные курсоры


select * from pulpit;

rollback;
commit;
begin
  delete from pulpit where pulpit_name = 'NEW';
  if(sql%rowcount= 0) then
    raise no_data_found;
  end if;
  commit;
  --rollback;
  exception when others then
    dbms_output.put_line('[ERROR] ' || sqlerrm);
end;


---11. Создайте анонимный блок,
--распечатывающий таблицу TEACHER с применением явного 
--курсора LOOP-цикла. Считанные данные должны быть записаны в переменные, объявленные с применением опции %TYPE.

select * from teacher;
declare
  cursor TEACHER_C is 
    select teacher, teacher_name, pulpit 
    from teacher;
  v_teacher teacher.teacher%type;
  v_teacher_name teacher.teacher_name%type;
  v_pulpit teacher.pulpit%type;
begin
  open TEACHER_C;
  DBMS_OUTPUT.PUT_LINE('КОЛИЧЕСТВО СТРОК = '|| TEACHER_C%ROWCOUNT);
    loop
    fetch TEACHER_C into v_teacher, v_teacher_name, v_pulpit;
    exit when TEACHER_C%notfound;
      DBMS_OUTPUT.PUT_LINE('№' || ' '|| TEACHER_C%ROWCOUNT||' ' ||v_teacher||' ' ||v_teacher_name|| ' ' ||v_pulpit);
    end loop;
  DBMS_OUTPUT.PUT_LINE('КОЛИЧЕСТВО СТРОК = '||TEACHER_C%rowcount);
  close TEACHER_C;
exception when others then
  DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;

---12. Создайте АБ, распечатывающий таблицу 
--SUBJECT с применением явного курсора и WHILE-цикла. 
--Считанные данные должны быть записаны в запись (RECORD), объявленную с применением опции %ROWTYPE.

declare
  cursor SUBJECT_C is
    select subject, subject_name, pulpit 
    from subject;
    s subject%rowtype;
begin
  open SUBJECT_C;
  DBMS_OUTPUT.PUT_LINE('КОЛИЧЕСТВО СТРОК = '||SUBJECT_C%ROWCOUNT);
  fetch SUBJECT_C into s;
  while (SUBJECT_C%found)
  loop
    DBMS_OUTPUT.PUT_LINE('№' || ' '||SUBJECT_C%ROWCOUNT||' ' ||s.subject || ' ' || s.subject_name || ' ' || s.pulpit);
    fetch SUBJECT_C into s;
  end loop;
  DBMS_OUTPUT.PUT_LINE('КОЛИЧЕСТВО СТРОК = '|| SUBJECT_C%ROWCOUNT);
  close SUBJECT_C;
  exception when others then
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;

---13. Создайте АБ, распечатывающий все кафедры (таблица PULPIT) 
--и фамилии всех преподавателей (TEACHER) использовав, 
--соединение (JOIN) PULPIT и TEACHER и с применением явного курсора и FOR-цикла.


declare
  cursor PULPIT_C is
    select pulpit.pulpit, teacher.teacher_name 
    from pulpit join teacher 
    on pulpit.pulpit = teacher.pulpit;
    p PULPIT_C%rowtype;
begin
  for p in PULPIT_C
  loop
    dbms_output.put_line('№' || ' ' ||PULPIT_C%ROWCOUNT || ' ' || p.pulpit || ' ' || p.teacher_name);
  end loop;
  exception when others then 
    dbms_output.put_line(sqlerrm);
end;


---14. Создайте АБ, распечатывающий следующие списки 
--аудиторий: все аудитории (таблица AUDITORIUM) 
--
--с вместимостью меньше 20, от 21-30, от 31-60, от 61 до 80, от 
--81 и выше. Примените курсор с параметрами и три способа организации цикла по строкам курсора.

declare
  cursor AUDIM_C(MINcapacity number, MAXcapacity number) is 
    select auditorium, auditorium_capacity 
    from auditorium
    where auditorium_capacity >= MINcapacity 
    and auditorium_capacity <= MAXcapacity;
  a AUDIM_C%rowtype;
begin
  dbms_output.put_line('вместимость < 20');
  for AUD in AUDIM_C(0,20)
  loop
    dbms_output.put_line(' '||AUD.auditorium||' '||AUD.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('Вместимость между 20 и 30');
  for AUD in AUDIM_C(20,30)
  loop
    dbms_output.put_line(' '||AUD.auditorium||' '||AUD.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('Вместимость между 30 и 60 ');
  for AUD in AUDIM_C(30,60)
  loop
    dbms_output.put_line(' '||AUD.auditorium||' '||AUD.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('Вместимость между 60 и 80 ');
  for AUD in AUDIM_C(60,80)
  loop
    dbms_output.put_line(' '||AUD.auditorium||' '||AUD.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('Вместимость > 80 ');
  for AUD in AUDIM_C(80,1000)
  loop
    dbms_output.put_line(' ' || AUD.auditorium || ' ' || AUD.auditorium_capacity);
  end loop;
  
  exception when others then
    dbms_output.put_line(sqlerrm);
end;

---15. Создайте AБ. Объявите курсорную переменную с
--помощью системного типа refcursor. Продемонстрируйте ее применение для курсора c параметрами. 

declare
  type AUDIT_R is ref cursor return auditorium%ROWTYPE;
  RCURS AUDIT_R;
  RCURS_ROWS RCURS%rowtype;
begin
  open RCURS for select * from auditorium;
  fetch RCURS into  RCURS_ROWS;
  loop
    exit when RCURS%notfound;
    dbms_output.put_line('№ '||RCURS_ROWS.auditorium||' Вместимость '||RCURS_ROWS.auditorium_capacity);
    fetch RCURS into RCURS_ROWS;
  end loop;
  close RCURS;
  
  exception when others then
    dbms_output.put_line(sqlerrm);
end;



---16. Создайте AБ. Продемонстрируйте понятие курсорный подзапрос?

declare
  cursor CURS_A
  is 
    select auditorium_type, cursor
    (
      select auditorium
      from auditorium A
      where B.auditorium_type = A.auditorium_type
    )
    from auditorium_type B;
  CURS_B sys_refcursor;
  B auditorium_type.auditorium_type%type;
  txt varchar2(1000);
  A auditorium.auditorium%type;
begin
  open CURS_A;
  fetch CURS_A into B, CURS_B;
  while(CURS_A%found)
  loop
    txt := rtrim(B)||': ';
    
    loop
      fetch CURS_B into A;
      exit when CURS_B%notfound;
      txt := txt||rtrim(A)||'; ';
    end loop;
    dbms_output.put_line(txt);
    fetch CURS_A into B, CURS_B;
  end loop;
  close CURS_A;
  exception when others then
    dbms_output.put_line(sqlerrm);
end;


---17. Создайте AБ. Уменьшите вместимость всех аудиторий (таблица AUDITORIUM)
--вместимостью от 40 до 80 на 10%. Используйте явный курсор с параметрами, цикл FOR, конструкцию UPDATE CURRENT OF. 

select * from auditorium;
commit;

declare
  cursor CURS_A(capacity auditorium.auditorium%type, capac auditorium.auditorium%type)
  is 
    select auditorium, auditorium_capacity  from auditorium
    where auditorium_capacity >=capacity 
    and AUDITORIUM_CAPACITY <= capacity
    for update;
  aum auditorium.auditorium%type;
  cty auditorium.auditorium_capacity%type;
begin
  open CURS_A(40,80);
  fetch CURS_A into aum, cty;
  
  while(CURS_A%found)
  loop
    cty := cty * 0.9;
      update auditorium 
      set auditorium_capacity = cty 
      where current of CURS_A;
    dbms_output.put_line(' '||aum||' '||cty);
    fetch CURS_A into aum, cty;
  end loop;
  close CURS_A;
  rollback;
  exception when others then
   dbms_output.put_line(sqlerrm);
end;


---18. Создайте AБ. Удалите все аудитории (таблица AUDITORIUM) вместимостью от 0 до 20. Используйте явный курсор с параметрами, цикл WHILE, конструкцию UPDATE CURRENT OF. 

select * from auditorium;
commit;


declare
  cursor CURS_A(minCapacity auditorium.auditorium%type, maxCapacity auditorium.auditorium%type)
  is 
    select auditorium, auditorium_capacity 
    from auditorium
    where auditorium_capacity >= minCapacity 
    and AUDITORIUM_CAPACITY <= maxCapacity 
    for update;
  aum auditorium.auditorium%type;
  cty auditorium.auditorium_capacity%type;
begin
  open CURS_A(0,20);
  fetch CURS_A into aum, cty;
  
  while(CURS_A%found)
  loop
    delete auditorium 
    where current of CURS_A;
    fetch CURS_A into aum, cty;
  end loop;
  close CURS_A;
  for A in CURS_A(0,120)
  loop
    dbms_output.put_line('Номер аудитории '|| A.auditorium|| ' Вместительность '|| A.auditorium_capacity);
  end loop;
  --rollback;
  exception
  when others then
    dbms_output.put_line(sqlerrm);
end;

---19. Создайте AБ. Продемонстрируйте применение псевдостолбца ROWID в операторах UPDATE и DELETE. 

select * from auditorium;

commit;
declare
  cursor CURS_A(capacity auditorium.auditorium%type)
  is 
    select auditorium, auditorium_capacity, rowid from auditorium
    where auditorium_capacity >= capacity
    and rownum <= 3
    for update;
  aum auditorium.auditorium%type;
  cty auditorium.auditorium_capacity%type;
begin
  for aud in CURS_A(50)
  loop
    case
      when aud.auditorium_capacity >= 90 then
        delete auditorium where rowid = aud.rowid;
      when aud.auditorium_capacity >=50 then
        update auditorium 
        set auditorium_capacity = auditorium_capacity + 10
        where rowid = aud.rowid;
    end case;
  end loop;
  for A in CURS_A(50)
  loop
    dbms_output.put_line(rtrim(A.auditorium) || ' Вместительность  ' || rtrim(A.auditorium_capacity) || '   ' || A.rowid);
  end loop;
  rollback;
  exception when others then
    dbms_output.put_line(sqlerrm);
end;


---20. Распечатайте в одном цикле всех преподавателей (TEACHER), разделив группами по три (отделите группы линией -------------). 
commit;
declare
  cursor T_CURS is
    select teacher, teacher_name, pulpit 
    from teacher;
    v_teacher teacher.teacher%type;
    v_teacher_name teacher.teacher_name%type;
    v_pulpit teacher.pulpit%type;
    v int := 1;
begin
  open T_CURS;
  loop
    fetch T_CURS into v_teacher, v_teacher_name, v_pulpit;
    exit when T_CURS%notfound;
    DBMS_OUTPUT.PUT_LINE('№ '|| T_CURS%ROWCOUNT ||' ' || v_teacher ||' ' || v_teacher_name || ' ' || v_pulpit);
    if (v mod 3 = 0) then DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------');
    end if;
    v := v + 1;
  end loop;
  close T_CURS;
  exception when others then
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;

