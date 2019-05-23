--1

declare
v_ile int;
v_cnt int;
info varchar2(40);
begin
  select count(*) into v_ile from studenci;
  info:='jest '||v_ile||' studentow';
  dbms_output.put_line(info);
  if v_ile<15 then
    select count(*) into v_cnt from osoba;
    insert into osoba(osoba_id,nazwisko,imie) values(v_cnt+1,'johnston','alex');
    insert into studenci(osoba_id,nr_indeksu) values(v_cnt+1,'9696');
  
  end if;
end;
--2
create or replace procedure kol3_zad2
(wej int,wyj out int)
is
v_ile int;
begin
  if wej=0 then
    select count(*) into v_ile from studenci; 
    wyj:=v_ile;
  else
    select count(*) into v_ile from osoba;
    wyj:=v_ile;
  end if;
end;


--3
create or replace procedure kol3_zad3
(idDydaktyka int,NrIndeksu varchar2,sP varchar2,nP varchar2,oce number )
is
v_ile int;
cnt int;
v_pId number;
info varchar2(50);
v_oce number;
v_nazD varchar2(30);
v_imiD varchar2(30);
cursor kur is select oceny.ocena,osoba.nazwisko,osoba.imie from oceny
              join dydaktycy on oceny.dydaktyk=dydaktycy.osoba_id
              join osoba on dydaktycy.osoba_id=osoba.osoba_id 
              where oceny.przedmiot_id=np
              order by oceny.data_wystawienia;
begin
  SELECT count(*) into cnt FROM przedmioty WHERE przedmiot=nP;
  IF cnt=1 THEN
    SELECT przedmiot_id INTO v_pId FROM przedmioty WHERE przedmiot=nP;
  ELSE 
    insert into przedmioty(przedmiot,przedmiot_skrot) values (nP,sP);
    SELECT przedmiot_id INTO v_pId FROM przedmioty WHERE przedmiot=nP;
  END IF;
  insert into oceny(przedmiot_id,data_wystawienia,student,dydaktyk,ocena) values(v_pId,sysdate,NrIndeksu,idDydaktyka,oce);
  
  open kur;
  loop
    fetch kur into v_oce,v_nazD,v_imiD;
    exit when kur%NOTFOUND;
    info:= v_oce ||' '|| ' wystawil '||v_nazD||' '||v_imiD;
    dbms_output.put_line(info);
  end loop;
  close kur;
end;

call kol3_zad3(1,s2121,'Mat','Matematyka',5);