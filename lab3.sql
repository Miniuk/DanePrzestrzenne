--Zadanie 4:

SELECT "Alaska".popp.* INTO tableB FROM "Alaska".popp, "Alaska".majrivers
WHERE ST_Distance("Alaska".popp.geom, "Alaska".majrivers.geom)<1000 AND "Alaska".popp.f_codedesc='Building';

SELECT * FROM tableB;

--Zadanie 5:

CREATE TABLE airportsNew AS
(SELECT name, geom, elev FROM "Alaska".airports);

--a)

SELECT name as WestAirport, ST_X(geom) FROM airportsNew
ORDER BY ST_X(geom) DESC 
LIMIT 1;

SELECT name as EastAirport, ST_X(geom) FROM airportsNew
ORDER BY ST_X(geom)
LIMIT 1;

--b)

INSERT INTO airportsNew(name, geom, elev) VALUES
('airportB',
	(SELECT ST_Centroid(ST_Makeline (
			(SELECT geom FROM airportsNew WHERE name LIKE 'ANNETTE ISLAND'), 
			(SELECT geom FROM airportsNew WHERE name LIKE 'ATKA')))), 200);
			
--Zadanie 6:

SELECT ST_Area(ST_Buffer(ST_ShortestLine("Alaska".lakes.geom,airportsNew.geom), 1000)) 
FROM "Alaska".lakes, airportsNew
WHERE "Alaska".lakes.names = 'Iliamna Lake' AND airportsNew.name='AMBLER';

--Zadanie 7:

SELECT SUM(ST_Area("Alaska".trees.geom)), "Alaska".trees.vegdesc
FROM "Alaska".trees, "Alaska".tundra, "Alaska".swamp
WHERE ST_Within("Alaska".trees.geom,"Alaska".tundra.geom) OR ST_Within("Alaska".trees.geom,"Alaska".swamp.geom)
GROUP BY "Alaska".trees.vegdesc;