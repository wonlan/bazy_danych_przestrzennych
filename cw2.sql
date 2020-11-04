Create Extension postgis;

Create table budynki
(
	id INT primary key not null,
	geometria GEOMETRY,
	nazwa char[20]
);
Create table drogi
(
	id INT primary key not null,
	geometria GEOMETRY,
	nazwa char[20]
);
Create table punkty_informacyjne
(
	id INT primary key not null,
	geometria GEOMETRY,
	nazwa char[20]
);
insert into budynki values(1, ST_GeomFromText('POLYGON((8 1.5,10.5 1.5,10.5 4,8 4,8 1.5))',0), 'BuildingA');
insert into budynki values(2, ST_GeomFromText('POLYGON((4 7,4 5,6 5,6 7,4 7))',0),'BuildingB');
insert into budynki values(3, ST_GeomFromText('POLYGON((3 8,3 6,5 6,5 8,3 8))',0),'BuildingC');
insert into budynki values(4, ST_GeomFromText('POLYGON((9 9,9 8,10 8, 10 9,9 9))',0),'BuildingD');
insert into budynki values(5, ST_GeomFromText('POLYGON((1 2,1 1,2 1,2 2,1 2))',0), 'BuildingF');

insert into drogi values(1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0), 'RoadX');
insert into drogi values(2, ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)',0), 'RoadY');

insert into punkty_informacyjne values(1, ST_GeomFromText('POINT(1 3.5)',0), 'G');
insert into punkty_informacyjne values(2, ST_GeomFromText('POINT(5.5 1.5)',0), 'H');
insert into punkty_informacyjne values(3, ST_GeomFromText('POINT(9.5 6)',0), 'I');
insert into punkty_informacyjne values(4, ST_GeomFromText('POINT(6.5 6)',0), 'J');
insert into punkty_informacyjne values(5, ST_GeomFromText('POINT(6 9.5)',0), 'K');

select sum(ST_Length(geometria)) from drogi;
select ST_AsText(geometria), ST_Area(geometria), ST_Perimeter(geometria) from budynki where nazwa like 'BulidingA';
select nazwa, ST_Area(geometria) from budynki order by nazwa asc;
select nazwa, ST_Area(geometria) as PP from budynki order by PP desc limit 2;
select ST_Distance(budynki.geometria,punkty_informacyjne.geometria) from budynki,punkty_informacyjne where budynki.nazwa like 'BuildingC' and punkty_informacyjne.nazwa like 'G';
select ST_Area(ST_Difference(budynki.geometria,(select ST_Buffer(geometria,0.5) from budynki where nazwa like 'BuildingB')) ) from budynki where nazwa like 'BuildingC';
select nazwa, ST_AsText(ST_Centroid(geometria)) from budynki where ST_Y(ST_Centroid(geometria)) > (select ST_Y(ST_Centroid(geometria)) from drogi where nazwa like 'RoadX');
select ST_AREA(ST_SymDifference(geometria,ST_GeomFromText('POLYGON((4 7,6 7,6 8,4 8,4 7))',0))) as PP from budynki where nazwa='BuildingC';