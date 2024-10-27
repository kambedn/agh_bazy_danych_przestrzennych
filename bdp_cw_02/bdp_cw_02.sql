-- 3
CREATE EXTENSION postgis;

-- 4
CREATE TABLE buildings(
	id SERIAL PRIMARY KEY,
	geometry GEOMETRY,
	name VARCHAR(200)
);

CREATE TABLE roads(
	id SERIAL PRIMARY KEY,
	geometry GEOMETRY,
	name VARCHAR(200)
);

CREATE TABLE poi(
	id SERIAL PRIMARY KEY,
	geometry GEOMETRY,
	name VARCHAR(200)
);

-- 5

INSERT INTO roads(name, geometry) VALUES
('RoadX', 'LINESTRING(0 4.5, 12 4.5)'),
('RoadY', 'LINESTRING(7.5 0, 7.5 10.5)');

-- SELECT name, ST_AsText(geometry) FROM roads;

INSERT INTO poi(name, geometry) VALUES
('G', 'POINT(1 3.5)'),
('H', 'POINT(5.5 1.5)'),
('I', 'POINT(9.5 6)'),
('J', 'POINT(6.5 6)'),
('K', 'POINT(6 9.5)');

-- SELECT name, ST_AsText(geometry) FROM poi;

INSERT INTO buildings(name, geometry) VALUES
('BuildingA', 'POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))'),
('BuildingB', 'POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))'),
('BuildingC', 'POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))'),
('BuildingD', 'POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))'),
('BuildingF', 'POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))');

-- SELECT name, ST_AsText(geometry) FROM buildings;

-- 6
-- a
SELECT 
	SUM(ST_Length(geometry)) AS total_road_length
FROM 
	roads 

-- b
SELECT
	ST_AsText(geometry) AS WKT,
	ST_Area(geometry) AS area,
	ST_Perimeter(geometry) AS perimeter
FROM
	buildings
WHERE
	name LIKE 'BuildingA'

-- c
SELECT
	name,
	ST_Area(geometry) AS area
FROM 
	buildings
ORDER BY
	name;

-- d
SELECT
	name,
	ST_Perimeter(geometry) AS perimeter
FROM 
	buildings
ORDER BY
	ST_Area(geometry) DESC
LIMIT 2;

-- e 
SELECT 
    ST_Distance(
        (SELECT geometry FROM poi WHERE name = 'K'),
        (SELECT geometry FROM buildings WHERE name = 'BuildingC')
    ) AS distance_K_and_B

-- f
SELECT 
	ST_Area(ST_Difference(b.geometry, ST_Buffer(b2.geometry, 0.5)))
FROM 
	buildings AS b
CROSS JOIN 
	buildings AS b2
WHERE 
	b.name = 'BuildingC' AND b2.name = 'BuildingB';

-- g
SELECT
	name,
	geometry
FROM
	buildings
WHERE
	ST_Y(ST_Centroid(geometry)) > ST_Y((SELECT ST_Centroid(geometry) FROM roads WHERE name = 'RoadX'));
	
-- h
SELECT 
	ST_Area(ST_SymDifference(geometry, 'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')) AS area_not_shared
FROM 
	buildings
WHERE 
	name = 'BuildingC';