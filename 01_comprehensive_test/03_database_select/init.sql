-- init.sql
CREATE TABLE score (name VARCHAR(50), score INT);
CREATE TABLE class (name VARCHAR(50), class VARCHAR(10));

INSERT INTO score VALUES ('John', 97), ('Mary', 100), ('David', 83), ('Sara', 89);
INSERT INTO class VALUES ('John', 'A'), ('David', 'C'), ('Sara', 'B'), ('Mary', 'A');