psql -U postgres
ALTER ROLE pgbench WITH CREATEDB;
\q

psql -U pgbench 
DROP DATABASE IF EXISTS puppies;
CREATE DATABASE puppies;
\c puppies;
CREATE TABLE pups (
   ID SERIAL PRIMARY KEY,
   name VARCHAR,
   breed VARCHAR,
   age INTEGER,
   sex VARCHAR
);

INSERT INTO pups (name, breed, age, sex)  VALUES ('Tyler', 'Retrieved', 3, 'M');
\q

