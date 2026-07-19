-- query_second_place.sql
SELECT c.class
FROM class c
JOIN (
    SELECT name, score, 
           DENSE_RANK() OVER (ORDER BY score DESC) as ranking
    FROM score
) s ON c.name = s.name
WHERE s.ranking = 2;