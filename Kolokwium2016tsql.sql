declare @info varchar,
		 @c int=(select count(1) from osoby)+1;
		@coun int=(select count(1) from dydaktycy);

if(@coun<10)
	begin
		insert into osoby(osoby.osoba_id,osoby.imie,osoby.nazwisko) values(@c,'richard','hennsey');
		insert into dydaktycy(dydaktycy.osoba_id,	dydaktycy.data_zatrudnienia) values(@c,getdate());
		set @info='liczba dyd:'+cast(@coun as varchar);
	end;
PRINT @info;

--2--------------------------------------------------------------------------------------
create procedure kol3_zad2
	@idD int,
	@iS int,
	@skP varchar(12),
	@nazP varchar(19),
	@oc int
AS
begin
	if( not exists(select 1 from przedmioty where przedmiot_skrot=@skP or przedmiot=@nazP)
	begin
		declare @c int=(select count(1) from Przedmioty)+1;
		insert into Przedmioty(przedmiot_id, przedmiot_skrot,przedmiot) values(@c,@nazP,@skP);
	end;
	declare @idP int=(select przedmiot_id from przedmioty where przedmiot_skrot=@skP or przedmiot=@nazP);
	insert into oceny(student,data_wystawienia,przedmiot_id) values (@idS,getdate(),@idP);
declare kur cursor  for  select ocena from oceny order by data_wystawienia;
declare @o int;
open kur;
	FETCH NEXT FROM kur INTO @o;
	WHILE @@FETCH_STATUS=0
		BEGIN
			print @o;
			FETCH NEXT FROM kur INTO @o;
		END;
	CLOSE kur;
	DEALLOCATE kur;
end;