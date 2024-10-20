-- DROP DATABASE IF EXISTS firma;
CREATE DATABASE firma;

DROP SCHEMA IF EXISTS ksiegowosc CASCADE;
CREATE SCHEMA ksiegowosc;

CREATE TABLE ksiegowosc.pracownicy(
	id_pracownika SERIAL PRIMARY KEY,
	imie VARCHAR(40) NOT NULL,
	nazwisko VARCHAR(70) NOT NULL,
	adres VARCHAR(200) NOT NULL,
	telefon VARCHAR(15) NOT NULL
);
COMMENT ON TABLE pracownicy IS 'Tabela zawierająca informacje o pracownikach.';
COMMENT ON COLUMN pracownicy.id_pracownika IS 'Unikalny identyfikator pracownika.';
COMMENT ON COLUMN pracownicy.imie IS 'Imię pracownika.';
COMMENT ON COLUMN pracownicy.nazwisko IS 'Nazwisko pracownika.';
COMMENT ON COLUMN pracownicy.adres IS 'Adres zamieszkania pracownika.';
COMMENT ON COLUMN pracownicy.telefon IS 'Numer telefonu pracownika.';

CREATE TABLE ksiegowosc.godziny(
	id_godziny SERIAL PRIMARY KEY,
	data DATE NOT NULL,
	liczba_godzin INT NOT NULL,
	id_pracownika INT,
	FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika) ON DELETE CASCADE
);
COMMENT ON TABLE ksiegowosc.godziny IS 'Tabela rejestrująca godziny pracy pracowników.';

CREATE TABLE ksiegowosc.pensja(
	id_pensji SERIAL PRIMARY KEY,
	stanowisko VARCHAR(50) NOT NULL,
	kwota NUMERIC(10, 2) NOT NULL
);
COMMENT ON TABLE ksiegowosc.pensja IS 'Tabela zawierająca informacje o wynagrodzeniach dla stanowisk.';

CREATE TABLE ksiegowosc.premia(
	id_premii SERIAL PRIMARY KEY,
	rodzaj VARCHAR(100) NOT NULL,
	kwota NUMERIC(10, 2) NOT NULL
);
COMMENT ON TABLE ksiegowosc.premia IS 'Tabela zawierająca informacje o premiach przyznawanych pracownikom.';

CREATE TABLE ksiegowosc.wynagrodzenie(
	id_wynagrodzenia SERIAL PRIMARY KEY,
	data DATE NOT NULL,
	id_pracownika INT,
	id_godziny INT,
	id_pensji INT,
	id_premii INT,
	FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika) ON DELETE CASCADE,
	FOREIGN KEY (id_godziny) REFERENCES godziny(id_godziny) ON DELETE CASCADE,
	FOREIGN KEY (id_pensji) REFERENCES pensja(id_pensji) ON DELETE CASCADE,
	FOREIGN KEY (id_premii) REFERENCES premia(id_premii) ON DELETE CASCADE
);
COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 'Tabela zawierająca informacje o wynagrodzeniach dla pracowników, w tym godziny pracy, pensje i premie.';

INSERT INTO ksiegowosc.pracownicy (imie, nazwisko, adres, telefon) VALUES
('Jan', 'Kowalski', 'ul. Kwiatowa 1, Warszawa', '123456789'),
('Anna', 'Nowak', 'ul. Słoneczna 5, Kraków', '987654321'),
('Marek', 'Zieliński', 'ul. Leśna 10, Gdańsk', '555123456'),
('Katarzyna', 'Wójcik', 'ul. Morska 15, Poznań', '444987654'),
('Piotr', 'Kamiński', 'ul. Wiosenna 20, Wrocław', '666789123'),
('Tomasz', 'Kaczmarek', 'ul. Brzozowa 25, Lublin', '333456789'),
('Monika', 'Maj', 'ul. Letnia 30, Łódź', '222654321'),
('Ewa', 'Szymczak', 'ul. Stawna 35, Bydgoszcz', '777321654'),
('Jakub', 'Jankowski', 'ul. Lechitów 40, Katowice', '888654987'),
('Agata', 'Kwiatkowska', 'ul. Cicha 45, Szczecin', '999987654');

INSERT INTO ksiegowosc.godziny (data, liczba_godzin, id_pracownika) VALUES
('2024-10-01', 8, 1),
('2024-10-02', 7, 2),
('2024-10-03', 6, 10),
('2024-10-04', 8, 3),
('2024-10-05', 5, 4),
('2024-10-06', 9, 5),
('2024-10-07', 4, 6),
('2024-10-08', 8, 7),
('2024-10-09', 7, 8),
('2024-10-10', 6, 9);

INSERT INTO ksiegowosc.pensja (stanowisko, kwota) VALUES
('Programista', 8000.00),
('Tester', 6000.00),
('Analityk', 7000.00),
('Project Manager', 10000.00),
('Grafik', 5500.00);

INSERT INTO ksiegowosc.premia (rodzaj, kwota) VALUES
('Wydajność', 1000.00),
('Święta', 500.00),
('Nowy Rok', 300.00),
('Zakończenie Projektu', 1200.00),
('Urodziny', 200.00);

INSERT INTO ksiegowosc.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
('2024-10-31', 1, 1, 1, 1),  
('2024-10-31', 2, 2, 2, NULL),
('2024-10-31', 3, 4, 3, 3),  
('2024-10-31', 4, 5, 4, NULL),
('2024-10-31', 5, 6, 1, 5),
('2024-10-31', 6, 7, 2, NULL), 
('2024-10-31', 7, 8, 3, 2),   
('2024-10-31', 8, 9, 4, NULL), 
('2024-10-31', 9, 10, 1, 4),  
('2024-10-31', 10, 3, 2, NULL); 

-- Zadanie 5
-- a) Wyswietl tylko id pracownika oraz jego nazwisko
SELECT id_pracownika, nazwisko
FROM ksiegowosc.pracownicy;

-- b) Wyswietl id pracownikow, ktorych placa jest wieksza niz 1000
SELECT a.id_pracownika, b.kwota
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pensja AS b
	USING(id_pensji)
WHERE kwota > 1000;

-- c) Wyswietl id pracowniko nieposiadajacych premii, ktorych placa jest wieksza niz 2000
SELECT a.id_pracownika, b.kwota, a.id_premii
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pensja AS b
	USING(id_pensji)
WHERE kwota > 2000 AND id_premii IS NULL;

-- d) Wyswietl pracownikow, ktorych pierwsza litera imienia zaczyna sie na litere "J"
SELECT * FROM ksiegowosc.pracownicy
WHERE imie LIKE 'J%';

-- e) Wyswietl praconikow, ktorych naziwsko zawierea litere "n" oraz imie konczy sie na litere 'a'
SELECT * FROM ksiegowosc.pracownicy
WHERE LOWER(nazwisko) LIKE '%n%' AND imie LIKE '%a';

-- f) Wyswietl imie i nazwisko pracownikow oraz ich liczbe nadgodzin (dzien pracy to 8h)
SELECT a.imie || ' ' || a.nazwisko AS pracownik, 
	SUM(CASE 
			WHEN b.liczba_godzin > 8 THEN b.liczba_godzin - 8
			ELSE 0 END
	) AS suma_nadgodzin
FROM ksiegowosc.pracownicy AS a
LEFT JOIN ksiegowosc.godziny AS b
	USING(id_pracownika)
GROUP BY 1
ORDER BY 2 DESC;

-- g) Wyswietl imie i nazwisko pracownikow, ktorych pensa zawiera sie przedziale [7000, 9000]
SELECT b.imie, b.nazwisko, c.kwota
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pracownicy AS b
	USING(id_pracownika)
JOIN ksiegowosc.pensja AS c
	USING(id_pensji)
WHERE c.kwota BETWEEN 7000 AND 9000;

-- h) Wyswietl imie i nazwisko pracownikow, ktorzy pracowali w nadgodzinach i nie otrzymali premii
SELECT b.imie || ' ' || b.nazwisko AS pracownik
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pracownicy AS b
	USING(id_pracownika)
JOIN ksiegowosc.godziny AS c
	USING(id_godziny)
WHERE c.liczba_godzin > 8 AND a.id_premii IS NULL; 


-- i) Uszereguj pracowników według pensji
SELECT b.imie || ' ' || b.nazwisko AS pracownik, c.kwota
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pracownicy AS b
	USING(id_pracownika)
JOIN ksiegowosc.pensja AS c
	USING(id_pensji)
ORDER BY c.kwota;

-- j) Uszereguj pracowników według pensji i premii malejąco
SELECT b.imie || ' ' || b.nazwisko AS pracownik, c.kwota AS pensja, d.kwota AS premia
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pracownicy AS b
	USING(id_pracownika)
JOIN ksiegowosc.pensja AS c
	USING(id_pensji)
LEFT JOIN ksiegowosc.premia AS d
	USING(id_premii)
ORDER BY pensja DESC, premia DESC;

-- k) Zlicz i pogrupuj pracowników według pola 'stanowisko'
SELECT b.stanowisko, COUNT(b.stanowisko) AS liczba_pracownikow
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pensja AS b
	USING(id_pensji)
GROUP BY 1;

-- l) Policz srednia, minimalna i maksymalna place dla stanowiska Project Manager
SELECT AVG(b.kwota) AS srednia, MIN(b.kwota) AS minimum, MAX(b.kwota) AS maximum
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pensja AS b
	USING(id_pensji)
WHERE b.stanowisko = 'Project Manager';

-- m) Policz sume wszystkich wynagrodzen
SELECT SUM(b.kwota + COALESCE(c.kwota, 0)) AS suma_wynagrodzen
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pensja AS b
	USING(id_pensji)
LEFT JOIN ksiegowosc.premia AS c
	USING(id_premii);

-- n) Policz sume wynagrodzen w ramach danego stanowiska
SELECT b.stanowisko, SUM(b.kwota + COALESCE(c.kwota, 0)) AS suma_wynagrodzen
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pensja AS b
	USING(id_pensji)
LEFT JOIN ksiegowosc.premia AS c
	USING(id_premii)
GROUP BY b.stanowisko;

-- o) Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska
SELECT b.stanowisko, COUNT(a.id_premii) AS liczba_premii
FROM ksiegowosc.wynagrodzenie AS a
JOIN ksiegowosc.pensja AS b
	USING(id_pensji)
GROUP BY 1;

-- p) Usun wszystkich pracownikow majacych pensje mniejsza niz 6500
DELETE FROM ksiegowosc.pracownicy
WHERE id_pracownika IN
	(
		SELECT a.id_pracownika
		FROM ksiegowosc.wynagrodzenie AS a
		JOIN ksiegowosc.pensja AS b
			USING(id_pensji)
		WHERE b.kwota < 6500
);