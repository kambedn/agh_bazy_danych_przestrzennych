CREATE EXTENSION postgis;

-- Zadanie 1
CREATE TABLE obiekty(
	name TEXT,
	geom GEOMETRY
);

-- a
INSERT INTO obiekty (name, geom)
VALUES (
    'obiekt1',
    ST_Collect(
        ARRAY[
            ST_GeomFromText('LINESTRING(0 1, 1 1)'),
            ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1)'),
            ST_GeomFromText('CIRCULARSTRING(3 1, 4 2, 5 1)'),
            ST_GeomFromText('LINESTRING(5 1, 6 1)')
        ]
    )
);

-- b
INSERT INTO obiekty (name, geom)
VALUES (
    'obiekt2',
    ST_Collect(
        ARRAY[
            ST_GeomFromText('LINESTRING(10 6, 14 6)'),
            ST_GeomFromText('CIRCULARSTRING(14 6, 16 4, 14 2)'),
            ST_GeomFromText('CIRCULARSTRING(14 2, 12 0, 10 2)'),
            ST_GeomFromText('LINESTRING(10 2, 10 6)'),
			ST_GeomFromText('CIRCULARSTRING(11 2, 12 3, 13 2)'),
            ST_GeomFromText('CIRCULARSTRING(11 2, 10 1, 13 2)')
        ]
    )
);

-- c
INSERT INTO obiekty (name, geom)
VALUES (
    'obiekt3',
    ST_GeomFromText('POLYGON((7 15, 10 17, 12 13, 7 15))')
);

-- d
INSERT INTO obiekty (name, geom)
VALUES (
    'obiekt4',
    ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)')
);

-- e
INSERT INTO obiekty (name, geom)
VALUES (
	'obiekt5',
	ST_Collect(
		ARRAY[
			ST_GeomFromText('POINT(38 32 234)'),
            ST_GeomFromText('POINT(30 30 59)')
		]
	)
);

-- f
INSERT INTO obiekty (name, geom)
VALUES (
	'obiekt6',
	ST_Collect(
		ARRAY[
			ST_GeomFromText('POINT(4 2)'),
            ST_GeomFromText('LINESTRING(1 1, 3 2)')
		]
	)
);


-- Zadanie 2
SELECT ST_Area(ST_Buffer(ST_ShortestLine(ob3.geom, ob4.geom), 5)) AS buffer_area
FROM obiekty ob3, obiekty ob4
WHERE ob3.name = 'obiekt3' AND ob4.name = 'obiekt4';

-- Zadanie 3
-- Geometria musi byc zamknieta, czyli pierwszy i ostatni punkt musza byc takie same, aby moc stworzyc polygon.
UPDATE obiekty
SET geom = ST_MakePolygon(
    ST_AddPoint(
        geom,
        ST_StartPoint(geom)
    )
)
WHERE name = 'obiekt4';

-- Zadanie 4
INSERT INTO obiekty (name, geom)
SELECT 
    'obiekt7', 
    ST_Collect(ob3.geom, ob4.geom)
FROM 
    obiekty ob3, obiekty ob4
WHERE 
    ob3.name = 'obiekt3' AND ob4.name = 'obiekt4';

-- Zadanie 5
SELECT SUM(ST_Area(ST_Buffer(geom, 5))) AS total_area
FROM obiekty
WHERE ST_HasArc(geom) IS FALSE;