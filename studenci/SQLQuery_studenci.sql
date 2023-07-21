USE studenci;

SELECT * FROM dbo.biblioteka;
SELECT * FROM dbo.kierunki;
SELECT * FROM dbo.oceny;
SELECT * FROM dbo.student;
SELECT * FROM dbo.wydzialy;
SELECT * FROM dbo.zaliczenia_warunkowe;

SELECT * FROM dbo.biblioteka;


--- suma nieoddanych ksiazek w podziale na wydzial i kierunek studiow

SELECT SUM(t1.liczba_nieoddanych_ksiazek) AS suma_nieoddanych_ksiazek,
t2.kierunek_studiow,
t2.wydzial
FROM biblioteka t1 
INNER JOIN student t2 ON t1.numer_indeksu = t2.numer_indeksu
GROUP BY t2.kierunek_studiow,t2.wydzial
ORDER BY suma_nieoddanych_ksiazek DESC;



--- Liczebnosc plci oraz ich udzial w liczebnosci studentow w podziale na wydzialy i kierunki studiow
--- Uwaga: w bazie danych, na kazdym kierunku na danym wydziale studiuje po 512 studentow - wynik w query nie jest bledem
SELECT t3.wydzial,
t3.kierunek_studiow,
t3.plec,
t3.liczebnosc_plci,
t3.suma_plci_wydzial_kierunek,
CAST(ROUND(t3.udzial_ogolem,2) AS DECIMAL(8,2)) AS udzial
FROM (
SELECT t2.*, CAST(t2.liczebnosc_plci AS DECIMAL(8,2))/ CAST(t2.suma_plci_wydzial_kierunek AS DECIMAL(8,2)) AS udzial_ogolem
FROM (
SELECT t1.*, SUM(liczebnosc_plci) OVER(PARTITION BY t1.wydzial, t1.kierunek_studiow) AS suma_plci_wydzial_kierunek
FROM (
SELECT wydzial, kierunek_studiow,plec, COUNT(plec) AS liczebnosc_plci FROM student
GROUP BY plec,kierunek_studiow, wydzial) t1) t2) t3;

--- Średnia ocen wgrała się w formacie np. 335 zamiast 3,35, dlatego konieczne było zaktualizowanie tej kolumny
UPDATE oceny
SET srednia_ocen_w_poprzednim_semestrze = srednia_ocen_w_poprzednim_semestrze / 100;


--- Średnia ocen w podziale na danym kierunku, na danym wydziale
SELECT t3.kierunek_studiow,
t3.wydzial,
CAST(AVG(t3.srednia_ocen_w_poprzednim_semestrze) AS DECIMAL(8,2)) AS srednia_ocen_kierunek_wydzial
FROM (
SELECT t1.*,
t2.kierunek_studiow,
t2.wydzial 
FROM oceny t1
INNER JOIN student t2 ON t1.numer_indeksu = t2.numer_indeksu) t3
GROUP BY t3.kierunek_studiow, t3.wydzial;


--- Zaliczenia warunkowe na danym kierunku, na danym wydziale oraz udział

SELECT DISTINCT t6.kierunek_studiow,
t6.wydzial,
t6.liczba_studentow_kierunek_wydzial,
t6.liczba_warunkow_kierunek_wydzial,
CAST(ROUND(t6.udzial_studentow_warunek_kierunek_wydzial,4) As DECIMAL(8,4)) as udzial_warunkow
FROM (
SELECT t5.kierunek_studiow,
t5.wydzial,
t5.liczba_studentow_kierunek_wydzial,
t5.liczba_warunkow_kierunek_wydzial,
CAST(t5.liczba_warunkow_kierunek_wydzial AS DECIMAL(8,4)) / CAST(t5.liczba_studentow_kierunek_wydzial AS DECIMAL(8,4)) AS udzial_studentow_warunek_kierunek_wydzial
FROM (
SELECT t4.*,
SUM(t4.liczba_warunkow) OVER(PARTITION BY kierunek_studiow, wydzial) AS liczba_warunkow_kierunek_wydzial
FROM (
SELECT t3.*,
COUNT(t3.numer_indeksu) OVER(PARTITION BY kierunek_studiow, wydzial) AS liczba_studentow_kierunek_wydzial
FROM (
SELECT t1.numer_indeksu,
t1.liczba_warunkow,
t2.kierunek_studiow,
t2.wydzial
FROM zaliczenia_warunkowe t1
INNER JOIN student t2 ON t1.numer_indeksu = t2.numer_indeksu) t3) t4) t5) t6
ORDER BY udzial_warunkow DESC;


