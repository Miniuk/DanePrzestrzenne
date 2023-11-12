CREATE EXTENSION postgis;

SELECT * FROM t2019_kar_buildings;

--Zadanie 1

CREATE TABLE new_buildings AS
SELECT t2019_kar_buildings.*
FROM karlsruhe.t2019_kar_buildings
LEFT JOIN karlsruhe.t2018_kar_buildings
ON karlsruhe.t2019_kar_buildings.geom = karlsruhe.t2018_kar_buildings.geom
WHERE karlsruhe.t2018_kar_buildings.gid IS NULL; 

SELECT*FROM new_buildings;

--Zadanie 2

CREATE TABLE new_poi AS
SELECT karlsruhe.t2019_kar_poi_table.type, COUNT(*) AS count
FROM karlsruhe.t2019_kar_poi_table
WHERE EXISTS (
    SELECT 1
    FROM new_buildings
    WHERE ST_DWithin(new_buildings.geom, karlsruhe.t2019_kar_poi_table.geom, 500)
)
GROUP BY karlsruhe.t2019_kar_poi_table.type;

SELECT * FROM new_poi;

--Zadanie 3

CREATE TABLE streets_reprojected AS 
(SELECT gid, link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, fr_speed_l, to_speed_l, dir_travel, ST_Transform(geom,3068) AS geom
FROM karlsruhe.t2019_kar_streets);
	 
SELECT * FROM streets_reprojected;

--Zadanie 4

CREATE TABLE input_points(id INTEGER PRIMARY KEY, geom GEOMETRY);

INSERT INTO input_points VALUES (1, ST_GeomFromText('POINT(8.36093 49.03174)', 4326));
INSERT INTO input_points VALUES (2, ST_GeomFromText('POINT(8.39876 49.00644)', 4326));
	   
SELECT * FROM input_points;

--Zadanie 5

UPDATE input_points SET geom=ST_Transform(geom, 3068);

SELECT ST_AsText(geom) FROM input_points;

--Zadanie 6

SELECT * FROM karlsruhe.t2019_kar_street_nodeee
WHERE ST_DWithin(ST_Transform(karlsruhe.t2019_kar_street_nodeee.geom, 3068),
(SELECT ST_MakeLine(input_points.geom) FROM input_points), 200);

--Zadanie 7

SELECT COUNT(DISTINCT(sklep.geom))
FROM karlsruhe.t2019_kar_poi_table AS sklep, karlsruhe.t2019_kar_land_use_a AS park
WHERE sklep.type = 'Sporting Goods Store' AND park.type = 'Park (City/County)'
AND ST_DWithin(sklep.geom, park.geom, 300);

--Zadanie 8

CREATE TABLE T2019_KAR_BRIDGES AS
SELECT DISTINCT(ST_Intersection(railways.geom, waterlines.geom))
FROM karlsruhe.t2019_kar_railways AS railways, karlsruhe.t2019_kar_water_lines AS waterlines

SELECT * FROM T2019_KAR_BRIDGES;



