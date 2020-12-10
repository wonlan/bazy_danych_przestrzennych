--4
select count(*) from (select popp.* from popp, majrivers
where ST_DWithin (majrivers.geom, popp.geom, 100000) = true and popp.f_codedesc = 'Building' group by popp.gid) as l_bud

create table tableB as select popp.* from popp, majrivers 
where ST_DWithin (majrivers.geom, popp.geom, 100000) = true and popp.f_codedesc = 'Building' group by popp.gid

--5
create table airportsNew as select name, geom, elev from airports
--a
	select ST_X(geom),name from airports order by ST_X(geom) desc limit 1;
	select ST_X(geom),name from airports order by ST_X(geom) limit 1;
--b
	insert into airportsnew(name, geom, elev) values
	('AirportB',(select ST_Centroid(ST_Makeline((select geom from airportsnew order by ST_X(geom) limit 1),(select geom from airportsnew ordedr order by ST_X(geom) desc limit 1)))),0)
	
--6
select ST_Area(ST_Buffer(ST_ShortestLine(lakes.geom, airports.geom)), 1000) from lakes, airports where lakes."names" = 'Iliamna Lake' and airports.name = 'AMBLER'
--7
select ST_Area(ST_Intersection(ST_Union(trees.geom), ST_Intersection(ST_Union(tundra.geom), ST_Union(swamp.geom)))) from tundra, swamp, trees group by trees.vegdesc, trees.geom, tundra.geom, swamp.geom