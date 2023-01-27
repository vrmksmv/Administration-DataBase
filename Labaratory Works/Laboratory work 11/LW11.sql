--1. ������������ ��, ��������������� ������ 
--��������� SELECT � ������ ��������. 
SET SERVEROUTPUT ON SIZE UNLIMITED;
select * from pulpit;
alter pluggable database MVV_PDB open;


declare
  p pulpit%rowtype;
begin
  select * into p from pulpit where faculty = '����';
  DBMS_OUTPUT.PUT_LINE(rtrim(p.pulpit) || ': ' || p.pulpit_name);
exception when others then
  DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;

--2. ������������ ��,
--��������������� ������ ��������� SELECT
--� �������� ������ ��������. ����������� ����������� WHEN OTHERS ������ ����������
--� ���������� ������� SQLERRM, SQLCODE ��� ���������������� �������� �������. 


--���������: ������ ������� ����������....
declare
  p pulpit%rowtype;
begin
  select * into p from pulpit;   
  DBMS_OUTPUT.PUT_LINE(rtrim(p.pulpit) || ': ' || p.pulpit_name);
exception when others then 
  dbms_output.put_line('[ERROR] When others: ' || sqlerrm || sqlcode);
end;


---3. ������������ ��, ��������������� ������ �����������
--WHEN TO_MANY_ROWS ������ ���������� ��� ���������������� �������� �������. 


--������ ����� ���� �� ��������������

declare
  p pulpit%rowtype;
begin
  select * into p from pulpit; 
  DBMS_OUTPUT.PUT_LINE(p.pulpit ||' '||p.pulpit_name);
  exception
    when too_many_rows
    then DBMS_OUTPUT.PUT_LINE('[ERROR] When too_many_rows: '|| sqlerrm || sqlcode);
end;

---4. ������������ ��, ��������������� ������������� 
--� ��������� ���������� NO_DATA_FOUND. ������������ ��, 
--��������������� ���������� ��������� �������� �������.


declare
  p pulpit%rowtype;
begin
  select * into p from pulpit where pulpit = '����'; 
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

---5. ������������ ��, ��������������� ���������� ��������� UPDATE ��������� � ����������� COMMIT/ROLLBACK. 
---6. ����������������� �������� UPDATE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.

select * from pulpit;
select * from pulpit order by pulpit;
commit;
begin
  update PULPIT set 
    pulpit ='��',
    pulpit_name = '������������ �����',
    faculty = '���'
  where pulpit = '��';   
  --rollback;
  dbms_output.put_line('SUCCESS!');
  exception when others then
    dbms_output.put_line('[error]' || sqlerrm);
end;



---7. ������������ ��, ��������������� ���������� ��������� INSERT ��������� � ����������� COMMIT/ROLLBACK.
---8. ����������������� �������� INSERT, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.

select * from pulpit;
 rollback;
 commit;
begin
  insert into pulpit(pulpit, pulpit_name, faculty)
  values('NEW', 'NEW', '���');
  commit;
  --rollback;
  end;
  exception when others then
    dbms_output.put_line('[ERROR] ' || sqlerrm);
end;
-----��� -----

---9. ������������ ��, ��������������� ���������� ��������� DELETE ��������� � ����������� COMMIT/ROLLBACK.
---10. ����������������� �������� DELETE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
--����� �������


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


---11. �������� ��������� ����,
--��������������� ������� TEACHER � ����������� ������ 
--������� LOOP-�����. ��������� ������ ������ ���� �������� � ����������, ����������� � ����������� ����� %TYPE.

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
  DBMS_OUTPUT.PUT_LINE('���������� ����� = '|| TEACHER_C%ROWCOUNT);
    loop
    fetch TEACHER_C into v_teacher, v_teacher_name, v_pulpit;
    exit when TEACHER_C%notfound;
      DBMS_OUTPUT.PUT_LINE('�' || ' '|| TEACHER_C%ROWCOUNT||' ' ||v_teacher||' ' ||v_teacher_name|| ' ' ||v_pulpit);
    end loop;
  DBMS_OUTPUT.PUT_LINE('���������� ����� = '||TEACHER_C%rowcount);
  close TEACHER_C;
exception when others then
  DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;

---12. �������� ��, ��������������� ������� 
--SUBJECT � ����������� ������ ������� � WHILE-�����. 
--��������� ������ ������ ���� �������� � ������ (RECORD), ����������� � ����������� ����� %ROWTYPE.

declare
  cursor SUBJECT_C is
    select subject, subject_name, pulpit 
    from subject;
    s subject%rowtype;
begin
  open SUBJECT_C;
  DBMS_OUTPUT.PUT_LINE('���������� ����� = '||SUBJECT_C%ROWCOUNT);
  fetch SUBJECT_C into s;
  while (SUBJECT_C%found)
  loop
    DBMS_OUTPUT.PUT_LINE('�' || ' '||SUBJECT_C%ROWCOUNT||' ' ||s.subject || ' ' || s.subject_name || ' ' || s.pulpit);
    fetch SUBJECT_C into s;
  end loop;
  DBMS_OUTPUT.PUT_LINE('���������� ����� = '|| SUBJECT_C%ROWCOUNT);
  close SUBJECT_C;
  exception when others then
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;

---13. �������� ��, ��������������� ��� ������� (������� PULPIT) 
--� ������� ���� �������������� (TEACHER) �����������, 
--���������� (JOIN) PULPIT � TEACHER � � ����������� ������ ������� � FOR-�����.


declare
  cursor PULPIT_C is
    select pulpit.pulpit, teacher.teacher_name 
    from pulpit join teacher 
    on pulpit.pulpit = teacher.pulpit;
    p PULPIT_C%rowtype;
begin
  for p in PULPIT_C
  loop
    dbms_output.put_line('�' || ' ' ||PULPIT_C%ROWCOUNT || ' ' || p.pulpit || ' ' || p.teacher_name);
  end loop;
  exception when others then 
    dbms_output.put_line(sqlerrm);
end;


---14. �������� ��, ��������������� ��������� ������ 
--���������: ��� ��������� (������� AUDITORIUM) 
--
--� ������������ ������ 20, �� 21-30, �� 31-60, �� 61 �� 80, �� 
--81 � ����. ��������� ������ � ����������� � ��� ������� ����������� ����� �� ������� �������.

declare
  cursor AUDIM_C(MINcapacity number, MAXcapacity number) is 
    select auditorium, auditorium_capacity 
    from auditorium
    where auditorium_capacity >= MINcapacity 
    and auditorium_capacity <= MAXcapacity;
  a AUDIM_C%rowtype;
begin
  dbms_output.put_line('����������� < 20');
  for AUD in AUDIM_C(0,20)
  loop
    dbms_output.put_line(' '||AUD.auditorium||' '||AUD.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('����������� ����� 20 � 30');
  for AUD in AUDIM_C(20,30)
  loop
    dbms_output.put_line(' '||AUD.auditorium||' '||AUD.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('����������� ����� 30 � 60 ');
  for AUD in AUDIM_C(30,60)
  loop
    dbms_output.put_line(' '||AUD.auditorium||' '||AUD.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('����������� ����� 60 � 80 ');
  for AUD in AUDIM_C(60,80)
  loop
    dbms_output.put_line(' '||AUD.auditorium||' '||AUD.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('����������� > 80 ');
  for AUD in AUDIM_C(80,1000)
  loop
    dbms_output.put_line(' ' || AUD.auditorium || ' ' || AUD.auditorium_capacity);
  end loop;
  
  exception when others then
    dbms_output.put_line(sqlerrm);
end;

---15. �������� A�. �������� ��������� ���������� �
--������� ���������� ���� refcursor. ����������������� �� ���������� ��� ������� c �����������. 

declare
  type AUDIT_R is ref cursor return auditorium%ROWTYPE;
  RCURS AUDIT_R;
  RCURS_ROWS RCURS%rowtype;
begin
  open RCURS for select * from auditorium;
  fetch RCURS into  RCURS_ROWS;
  loop
    exit when RCURS%notfound;
    dbms_output.put_line('� '||RCURS_ROWS.auditorium||' ����������� '||RCURS_ROWS.auditorium_capacity);
    fetch RCURS into RCURS_ROWS;
  end loop;
  close RCURS;
  
  exception when others then
    dbms_output.put_line(sqlerrm);
end;



---16. �������� A�. ����������������� ������� ��������� ���������?

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


---17. �������� A�. ��������� ����������� ���� ��������� (������� AUDITORIUM)
--������������ �� 40 �� 80 �� 10%. ����������� ����� ������ � �����������, ���� FOR, ����������� UPDATE CURRENT OF. 

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


---18. �������� A�. ������� ��� ��������� (������� AUDITORIUM) ������������ �� 0 �� 20. ����������� ����� ������ � �����������, ���� WHILE, ����������� UPDATE CURRENT OF. 

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
    dbms_output.put_line('����� ��������� '|| A.auditorium|| ' ��������������� '|| A.auditorium_capacity);
  end loop;
  --rollback;
  exception
  when others then
    dbms_output.put_line(sqlerrm);
end;

---19. �������� A�. ����������������� ���������� ������������� ROWID � ���������� UPDATE � DELETE. 

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
    dbms_output.put_line(rtrim(A.auditorium) || ' ���������������  ' || rtrim(A.auditorium_capacity) || '   ' || A.rowid);
  end loop;
  rollback;
  exception when others then
    dbms_output.put_line(sqlerrm);
end;


---20. ������������ � ����� ����� ���� �������������� (TEACHER), �������� �������� �� ��� (�������� ������ ������ -------------). 
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
    DBMS_OUTPUT.PUT_LINE('� '|| T_CURS%ROWCOUNT ||' ' || v_teacher ||' ' || v_teacher_name || ' ' || v_pulpit);
    if (v mod 3 = 0) then DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------');
    end if;
    v := v + 1;
  end loop;
  close T_CURS;
  exception when others then
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;

