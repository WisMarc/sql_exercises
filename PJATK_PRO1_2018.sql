--1.	Wypisz wszystkie rezerwacje Ferdynanda Kiepskiego.
select Rezerwacja.IdRezerwacja
from Rezerwacja
join Gosc on Rezerwacja.IdGosc=Gosc.IdGosc
where Gosc.Imie='Ferdynand' and Gosc.Nazwisko='Kiepski';
--2.	Wypisz dane wszystkich gości, wraz z rezerwacjami. Uwzględnij osoby, które nie miały ani jednej rezerwacji.
select Gosc.IdGosc
		,Gosc.Imie
		,Gosc.Nazwisko
		,Rezerwacja.IdRezerwacja
from Rezerwacja
right join Gosc on Rezerwacja.IdGosc=Gosc.IdGosc;
--3.	Wypisz gości, którzy nie posiadają rabatu. Posortuj według nazwisk.
select Gosc.IdGosc
		,Gosc.Imie
		,Gosc.Nazwisko
		,Gosc.Procent_rabatu
from Gosc
where gosc.Procent_rabatu is null;
--4.	Wypisz klientów, którzy co najmniej raz wynajęli pokój luksusowy.
select Gosc.IdGosc
		,Gosc.Imie
		,Gosc.Nazwisko
from Gosc
where Gosc.IdGosc in (
						select Rezerwacja.IdGosc
						from Rezerwacja
						join Pokoj on Pokoj.NrPokoju=Rezerwacja.NrPokoju
						join Kategoria on Kategoria.IdKategoria=Pokoj.IdKategoria
						where Kategoria.Nazwa='Luksusowy'
						)
--5.	Wypisz numery pokoi wynajmowanych przez Andrzeja Nowaka.
select Pokoj.NrPokoju
from Rezerwacja
join Pokoj on Pokoj.NrPokoju=Rezerwacja.NrPokoju
join Kategoria on Kategoria.IdKategoria=Pokoj.IdKategoria
where Rezerwacja.IdGosc=(	select Gosc.IdGosc
							from Gosc
							where Gosc.Imie='Andrzej' and Gosc.Nazwisko='Nowak')
--6.	Policz, ile zarobił hotel na Marianie Paździochu biorąc pod uwagę cenę za dobę, liczbę dni oraz rabat.
select *
from Rezerwacja
join Gosc on Rezerwacja.IdGosc=Gosc.IdGosc
join Pokoj on Rezerwacja.NrPokoju=Pokoj.NrPokoju
join Kategoria on Pokoj.IdKategoria=Kategoria.IdKategoria
where Gosc.Imie='Marian' and Gosc.Nazwisko='PaYdzioch';
--7.	Znajdź pokój z największą liczbą miejsc.
select Pokoj.NrPokoju
from Pokoj
where Pokoj.Liczba_miejsc=(select max(Pokoj.Liczba_miejsc)
							from Pokoj)
--8.	Wypisz imiona i nazwiska gości wraz z liczbą rezerwacji. Nie wypisuj gości, którzy mają mniej niż 3 rezerwacje.
select Gosc.Imie, Gosc.Nazwisko, COUNT(Rezerwacja.IdRezerwacja)
from Gosc
join Rezerwacja on Gosc.IdGosc=Rezerwacja.IdGosc
group by Gosc.Imie,Gosc.Nazwisko
having COUNT(Rezerwacja.IdRezerwacja)>2;
--9.	Znajdź najdłużej trwającą rezerwację. Podaj imię i nazwisko klienta.

select rezerwacja.IdRezerwacja
		,Gosc.Imie
		,Gosc.Nazwisko
from Rezerwacja
join Gosc on Rezerwacja.IdGosc=Gosc.IdGosc
where datediff(DAY, Rezerwacja.DataOd, Rezerwacja.DataDo)=(select max(datediff(DAY, Rezerwacja.DataOd, Rezerwacja.DataDo)) from Rezerwacja)

--10.	Wypisz, ile maksymalnie osób może przyjąć hotel jednocześnie.
select SUM(pokoj.liczba_miejsc) as 'Suma miejsc'
from Pokoj;
--11.	Wypisz, ile maksymalnie osób w pokojach luksusowych może przyjąć hotel jednocześnie.
select SUM(pokoj.liczba_miejsc) as 'Suma miejsc luksusowych'
from Pokoj
where Pokoj.IdKategoria=(select Kategoria.IdKategoria from Kategoria where Kategoria.Nazwa='Luksusowy')
--12.	Podaj liczbę pokoi w każdej kategorii.
select Pokoj.IdKategoria, sum(pokoj.liczba_miejsc)
from Pokoj
group by Pokoj.IdKategoria
--13.	Znajdź pokój, który nie był nigdy wynajmowany.
select Pokoj.NrPokoju
from pokoj
where Pokoj.NrPokoju not in(
							select pokoj.NrPokoju
							from pokoj
							join Rezerwacja on Pokoj.NrPokoju=Rezerwacja.NrPokoju);

--14.	Znajdź klientów, którzy korzystali z usług hotelu tylko raz.
select Rezerwacja.IdGosc, count(rezerwacja.idrezerwacja)
from Rezerwacja
group by Rezerwacja.IdGosc
having count(rezerwacja.idrezerwacja)=1;
--15.	Znajdź klientów, którzy nie korzystali z usług hotelu w 2008 roku, a korzystali w 2009 roku.
--select r.IdGosc
--from Rezerwacja r
--where not exists(select 1 from Rezerwacja where DATEPART(year, rezerwacja.DataOd)=2008) and exists(select 1 from Rezerwacja where DATEPART(year, rezerwacja.DataOd)=2009)

select Rezerwacja.IdGosc
from Rezerwacja
where DATEPART(year, rezerwacja.DataOd)=2009
except
select Rezerwacja.IdGosc
from Rezerwacja
where DATEPART(year, rezerwacja.DataOd)=2008

--16.	Dla każdego gościa wypisz, który pokój ostatnio wynajmował
select g.IdGosc,(select top 1 Rezerwacja.NrPokoju from Rezerwacja where Rezerwacja.IdGosc=g.IdGosc order by Rezerwacja.DataOd desc)
from Gosc g
where (select top 1 Rezerwacja.NrPokoju from Rezerwacja where Rezerwacja.IdGosc=g.IdGosc order by Rezerwacja.DataOd desc) is not null;