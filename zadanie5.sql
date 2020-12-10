create EXTENSIon postgis;
create EXTENSIon postgis_raster;

--1
create table maleta.intersects as
select a.rast, b.municipality
from rasters.dem as a, vectors.porto_parishes as b
where ST_Intersects(a.rast, b.geom) and b.municipality ilike 'porto';

-- 
alter table maleta.intersects
add column rid SERIAL primary key;

-- 
create index idx_intersects_rast_gist on maleta.intersects
using gist (ST_ConvexHull(rast));

--
select AddRasterConstraints('maleta'::name, 'intersects'::name,'rast'::name);

--2
create table maleta.clip as
select ST_Clip(a.rast, b.geom, true), b.municipality
from rasters.dem as a, vectors.porto_parishes as b
where ST_Intersects(a.rast, b.geom) and b.municipality like 'PORTO';

--3
create table maleta.union as
select ST_Union(ST_Clip(a.rast, b.geom, true))
from rasters.dem as a, vectors.porto_parishes as b
where b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast);

--1
create table maleta.porto_parishes as
with r as (select rast from rasters.dem limit 1)
select ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767) as rast
from vectors.porto_parishes as a, r
where a.municipality ilike 'porto';

--2
drop table maleta.porto_parishes; 
create table maleta.porto_parishes as

with r as 
(select rast from rasters.dem limit 1)
select st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)) as rast
from vectors.porto_parishes as a, r
where a.municipality ilike 'porto';

--3
drop table maleta.porto_parishes; 
create table maleta.porto_parishes as
with r as (
	select rast from rasters.dem
	limit 1 )
select st_tile(st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)),128,128,true,-32767) as rast
from vectors.porto_parishes as a, r
where a.municipality ilike 'porto';

--1
create table maleta.intersection as
select a.rid,(ST_Intersection(b.geom,a.rast)).geom,(ST_Intersection(b.geom,a.rast)).val
from rasters.landsat8 as a, vectors.porto_parishes as b
where b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--2
create table maleta.dumppolygons as
select a.rid,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).geom,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).val
from rasters.landsat8 as a, vectors.porto_parishes as b
where b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--1
create table maleta.landsat_nir as
select rid, ST_Band(rast,4) as rast
from rasters.landsat8;

--2
create table maleta.paranhos_dem as
select a.rid,ST_Clip(a.rast, b.geom,true) as rast
from rasters.dem as a, vectors.porto_parishes as b
where b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--3
create table maleta.paranhos_slope as
select a.rid,ST_Slope(a.rast,1,'32BF','PERCENTAGE') as rast
from maleta.paranhos_dem as a;

--4
create table maleta.paranhos_slope_reclass as
select a.rid,ST_Reclass(a.rast,1,']0-15]:1, (15-30]:2, (30-9999:3', '32BF',0)
from maleta.paranhos_slope as a;

--5
select st_summarystats(a.rast) as stats
from sliwka.paranhos_dem as a;

-6
select st_summarystats(ST_Union(a.rast))
from maleta.paranhos_dem as a;

--7
with t as (
select st_summarystats(ST_Union(a.rast)) as stats
from maleta.paranhos_dem as a
)
select (stats).min,(stats).max,(stats).mean from t;

--8
with t as (
select b.parish as parish, st_summarystats(ST_Union(ST_Clip(a.rast, b.geom,true))) as stats
from rasters.dem as a, vectors.porto_parishes as b
where b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
group by b.parish)
select parish,(stats).min,(stats).max,(stats).mean from t;

--9
select b.name,st_value(a.rast,(ST_Dump(b.geom)).geom) 
from
rasters.dem a, vectors.places as b
where ST_Intersects(a.rast,b.geom)
order by b.name;

--10
create table maleta.tpi30 as
select ST_TPI(a.rast,1) as rast
from rasters.dem a;
--
create index idx_tpi30_rast_gist on sliwka.tpi30
using gist (ST_ConvexHull(rast));
--
select AddRasterConstraints('schema_name'::name, 'tpi30'::name,'rast'::name);
--
create table maleta.tpi30_porto as
select ST_TPI(a.rast,1) as rast
from rasters.dem as a, vectors.porto_parishes as b
where ST_Intersects(a.rast, b.geom) and b.municipality ilike 'porto'
--
create index idx_tpi30_porto_rast_gist on maleta.tpi30_porto
using gist (ST_ConvexHull(rast));
--
select AddRasterConstraints('sliwka'::name, 'tpi30_porto'::name,'rast'::name);
--1
create table maleta.porto_ndvi as
with r as (select a.rid,ST_Clip(a.rast, b.geom,true) as rast
from rasters.landsat8 as a, vectors.porto_parishes as b
where b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast))
select r.rid,
ST_MapAlgebra(r.rast, 1, r.rast, 4, 
'([rast2.val] - [rast1.val]) / ([rast2.val] + [rast1.val])::float','32BF') as rast from r;
--
create index idx_porto_ndvi_rast_gist on maleta.porto_ndvi
using gist (ST_ConvexHull(rast));
--
select AddRasterConstraints('maleta'::name, 'porto_ndvi'::name,'rast'::name);
--2
create OR REPLACE FUNCTIon maleta.ndvi
(value double precision [] [] [], pos integer [][], VARIADIC userargs text []) 
RETURNS double precision as $$ BEGIN
--
RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1]+value [1][1][1]); 
$$ LANGUAGE 'plpgsql' IMMUtable COST 1000;
--
create table maleta.porto_ndvi2 as with r as ( select a.rid,ST_Clip(a.rast, b.geom,true) as rast
from rasters.landsat8 as a, vectors.porto_parishes as b 
where b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast))
select r.rid,ST_MapAlgebra( r.rast, array[1,4],
'maleta.ndvi(double precision[], integer[],text[])'::regprocedure, '32BF'::text
from r;
--
create index idx_porto_ndvi2_rast_gist on maleta.porto_ndvi2
using gist (ST_ConvexHull(rast));
--
select AddRasterConstraints('maleta'::name, 'porto_ndvi2'::name,'rast'::name);
--1
select ST_AsTiff(ST_Union(rast))
from maleta.porto_ndvi;

--2
select ST_AsGDALRaster(ST_Union(rast), 'GTiff', array['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
from maleta.porto_ndvi;

select ST_GDALDrivers();
--3
create table tmp_out as
select lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', array['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
) as loid from maleta.porto_ndvi;
--
select lo_export(loid, 'D:\myraster.tiff')
from tmp_out;
--
select lo_unlink(loid)
from tmp_out;
--4
gdal_translate -co COMPRESS=DEFLATE -co PREDICTOR=2 -co ZLEVEL=9 
PG:"host=localhost port=5432 dbname=postgis_raster user=postgres 
password= schema=maleta table=porto_ndvi mode=2" porto_ndvi.tiff
