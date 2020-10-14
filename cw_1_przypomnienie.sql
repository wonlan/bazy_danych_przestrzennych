--Zadanie1
create database s304182;
--Zadanie 2
create schema firma;
--Zadanie 3
create role ksiegowosc;
grant select on all tables in schema firma to ksiegowosc;
--Zadanie 4
create table firma.pracownicy
(
id_pracownika INT not null primary key;
imie VARCHAR(15),
nazwisko VARCHAR(30),
adres VARCHAR(50),
telefon VARCHAR(9)
);
comment on table firma.pracownicy is 'Tabela z pracownikami w schemacie firma';

create table firma.godziny
(
id_godziny INT not null primary key,
"data" DATE,
liczba_godzin INT,
id_pracownika INT not null
);
alter table firma.godziny add foreign key (id_pracownika) references firma.pracownicy(id_pracownika);
comment on table firma.godziny is ' Tabela z godzinami w schemacie firma';

create table firma.pensja_stanowisko
(
id_pensji INT not null primary key,
stanowisko VARCHAR(20),
kwota INT
);
comment on table firma.pensja_stanowisko is 'Tabela z pensjami w schemacie firma';

create table firma.premia
(
id_premii INT not null primary key,
rodzaj VARCHAR(20),
kwota INT
);
comment on table firma.premia is 'Tabela z premiami w schemacie firma';

create table firma.wynagrodzenie
(
id_wynagrodzenie INT not null primary key,
"data" DATE,
id_pracownika INT not null,
id_godziny INT not null,
id_pensji INT not null,
id_premii INT
);
alter table firma.wynagrodzenie add foreign key (id_pracownika) references firma.pracownicy(id_pracownika);
alter table firma.wynagrodzenie add foreign key (id_godziny) references firma.godziny(id_godziny);
alter table firma.wynagrodzenie add foreign key (id_pensji) references firma.pensja(id_pensji);
alter table firma.wynagrodzenie add foreign key (id_premii) references firma.premia(id_premii);
comment on table firma.wynagrodzenie is 'Tabela z wynagrodzeniami w schemacie firma';

--Zadanie 5
alter table firma.godziny add column miesiac INT;
update firma.godziny set miesiac=DATE_PART('month',data)
select DATE_PART('month',data) from firma.godziny;

alter table firma.wynagrodzenie alter column data type VARCHAR(20);
insert into firma.pracownicy values(1,'Anna','Jarosz','Szczecin','891042091');
insert into firma.pracownicy values(2,'Adam','Sikora','Warszawa','791143098');
insert into firma.pracownicy values(3,'Robert','Zarêba','Wroc³aw','429871204');
insert into firma.pracownicy values(4,'Katarzyna','Madej','Kraków','567876231');
insert into firma.pracownicy values(5,'Jaros³aw','Groszkowski','Gdañsk','886992441');
insert into firma.pracownicy values(6,'Mi³osz','Koszak','Poznañ','474902206');
insert into firma.pracownicy values(7,'Jacek','Robak','Kraków','501912832');
insert into firma.pracownicy values(8,'Krzysztof','Kononowicz','Bia³ystok','518888014');
insert into firma.pracownicy values(9,'Wojciech','Suchodolski','Bia³ystok','721982335');
insert into firma.pracownicy values(10,'Ewa','Lipka','Kielce','640022871');


insert into firma.godziny values(1,'2020-05-04',8,1);
insert into firma.godziny values(2,'2020-05-04',4,2);
insert into firma.godziny values(3,'2020-05-04',1,3);
insert into firma.godziny values(4,'2020-05-05',10,4);
insert into firma.godziny values(5,'2020-05-05',6,5);
insert into firma.godziny values(6,'2020-05-06',6,6);
insert into firma.godziny values(7,'2020-05-07',2,7);
insert into firma.godziny values(8,'2020-05-07',5,8);
insert into firma.godziny values(9,'2020-05-08',7,9);
insert into firma.godziny values(10,'2020-05-10',8,10);

insert into firma.pensja values(1,'kierownik dzia³u',7500);
insert into firma.pensja values(2,'programista',6000);
insert into firma.pensja values(3,'grafik',5500);
insert into firma.pensja values(4,'konsenwator',2500);
insert into firma.pensja values(5,'wsparcie IT',4500);
insert into firma.pensja values(6,'sekretarka',5500);
insert into firma.pensja values(7,'grafik',5500);
insert into firma.pensja values(8,'sprzedawca',4200);
insert into firma.pensja values(9,'grafik',5500);
insert into firma.pensja values(10,'prezes',12000);

insert into firma.premia values(1,'zapomoga',500);
insert into firma.premia values(2,'premia za wyniki',1000);
insert into firma.premia values(3,'dodatek funkcyjny',300);
insert into firma.premia values(4,'dodatek œwi¹teczny',500);
insert into firma.premia values(5,'pracownik tygodnia',100);
insert into firma.premia values(6,'pracownik miesi¹ca',450);
insert into firma.premia values(7,'premia motywacyjna',200);
insert into firma.premia values(8,'nadgodziny',50);
insert into firma.premia values(9,'dodatek socjalny',250);
insert into firma.premia values(10,'punktualnoœæ',50);
insert into firma.premie values (11,'brak',0)

insert into firma.wynagrodzenie values(1,'2020-05-25',1,1,9,2);
insert into firma.wynagrodzenie values(2,'2020-05-25',2,2,10,8);
insert into firma.wynagrodzenie values(3,'2020-05-25',3,3,2,9);
insert into firma.wynagrodzenie values(4,'2020-05-25',4,4,1,4);
insert into firma.wynagrodzenie values(5,'2020-05-25',5,5,4,7);
insert into firma.wynagrodzenie values(6,'2020-05-25',6,6,5,6);
insert into firma.wynagrodzenie values(7,'2020-05-25',7,7,6,5);
insert into firma.wynagrodzenie values(8,'2020-05-25',8,8,7,1);
insert into firma.wynagrodzenie values(9,'2020-05-25',9,9,2,1);
insert into firma.wynagrodzenie values(10,'2020-05-25',10,10,5,10);

--Zadanie 6
--zapytanie a
select id_pracownika, nazwisko from firma.pracownicy;
--zapytanie b
select id_pracownika from firma.wynagrodzenie, firma.pensja where firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji and kwota> 1000;
--zapytanie c
select id_pracownika from firma.wynagrodzenie, firma.pensja where firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji and kwota> 2000 and firma.wynagrodzenie.id_premii is null;
--zapytanie d
select * from firma.pracownicy where imie like 'J%';
--zapytanie e
select * from firma.pracownicy where nazwisko like '%n%' and imie like '%a';
--zapytanie f
select imie, nazwisko from firma.pracownicy, firma.wynagrodzenie, firma.godziny where firma.wynagrodzenie.id_godziny=firma.godziny.id_godziny and firma.wynagrodzenie.id_pracownika=firma.pracownicy.id_pracownika and (firma.godziny.liczba_godzin*20)>160;
--zapytanie g
select imie, nazwisko from firma.pracownicy, firma.wynagrodzenie, firma.pensja where firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji and firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika and kwota between 1500 and 3000;
--zapytanie h
select imie, nazwisko from firma.pracownicy, firma.wynagrodzenie, firma.godziny where firma.wynagrodzenie.id_godziny=firma.godziny.id_godziny and firma.wynagrodzenie.id_pracownika=firma.pracownicy.id_pracownika and (firma.godziny.liczba_godzin*20)>160 and firma.wynagrodzenie.id_premii is null;

--Zadanie 7
--polecenie a
select pracownicy.* from firma.pracownicy, firma.pensja, firma.wynagrodzenie where firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika and firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji order by kwota;
--polecenie b
select pracownicy.*,pensja.kwota,premia.kwota from firma.pracownicy, firma.pensja, firma.wynagrodzenie, firma.premia where firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika and firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji and firma.wynagrodzenie.id_premii = firma.premia.id_premii order by pensja.kwota desc, premia.kwota desc;
--polecenie c
select stanowisko, count(stanowisko) from firma.pensja,firma.wynagrodzenie,firma.pracownicy where firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika and firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji group by stanowisko;
--polecenie d
select avg(pensja.kwota+premia.kwota), min(pensja.kwota+premia.kwota), max(pensja.kwota+premia.kwota) from firma.wynagrodzenie ,firma.pensja , firma.premia, firma.pracownicy where firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji and firma.wynagrodzenie.id_premii = firma.premia.id_premii and firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika and pensja.stanowisko like 'programista';
--polecenie e
select sum(pensja.kwota+premia.kwota) from firma.pensja,firma.premia,firma.wynagrodzenie,firma.pracownicy where firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji and firma.wynagrodzenie.id_premii = firma.premia.id_premii and firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika;
--polecenie f
select stanowisko, sum(pensja.kwota+premia.kwota) from firma.pensja,firma.premia,firma.wynagrodzenie,firma.pracownicy where firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji and firma.wynagrodzenie.id_premii = firma.premia.id_premii and firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika group by stanowisko;
--polecenie g
select stanowisko, count(premia.id_premii) from firma.pensja,firma.premia,firma.wynagrodzenie,firma.pracownicy where firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji and firma.wynagrodzenie.id_premii = firma.premia.id_premii and firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika group by stanowisko;
--polecenie h
delete from firma.pracownicy where id_pracownika in (select pracownicy.id_pracownika from firma.pracownicy,firma.pensja,firma.wynagrodzenie where firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika and firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji and pensja.kwota < 1200);

--Zadanie 8
--zadanie a
alter table firma.pracownicy alter column telefon type varchar(16) using telefon::varchar;
update firma.pracownicy set telefon ='(+48)' || pracownicy.telefon;
--zadanie b
update firma.pracownicy set telefon=substring(telefon,0,9) || '-' || substring(telefon,9,3) || '-' || substring(telefon,12,3);
--zadanie c
select * from firma.pracownicy order by char_length(nazwisko) desc limit 1;
--zadanie d
select pracownicy.*, md5(firma.pensja.kwota::text) as kwota from firma.pracownicy,firma.wynagrodzenie,firma.pensja where firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika and firma.pensja.id_pensji = firma.wynagrodzenie.id_pensji;

--zadanie 9
select 'Pracownik ' || pracownicy.imie ||' '|| pracownicy.nazwisko ||',w dniu '|| wynagrodzenie."data" || ' otrzyma³ pensjê ca³kowitš na kwotê ' ||
pensja.kwota+premia.kwota || 'z³, gdzie wynagrodzenie zasadnicze wynosi³o: '|| pensja.kwota ||'z³, premia: '|| premia.kwota ||'z³, nadgodziny : 0 z³' as Raport
from firma.pracownicy
join firma.wynagrodzenie on firma.wynagrodzenie.id_pracownika = firma.pracownicy.id_pracownika
join firma.pensja on firma.wynagrodzenie.id_pensji = firma.pensja.id_pensji
join firma.premia on firma.wynagrodzenie.id_premii = firma.premia.id_premii
where imie = 'Adam' and nazwisko = 'Sikora';