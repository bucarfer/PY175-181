-- SUBQUERIES EXERCISES 

-- Set Up the Database using \copy
-- This set of exercises will focus on an auction. Create a new database called auction. In this database there will be three tables, bidders, items, and bids.

CREATE TABLE bidders (
  id SERIAL PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  name text NOT NULL,
  initial_price numeric(6,2) NOT NULL CHECK(initial_price BETWEEN 0.01 AND 1000.00),
  sales_price numeric(6,2) CHECK (sales_price BETWEEN 0.01 AND 1000.00)
);

CREATE TABLE bids (
  id SERIAL PRIMARY KEY,
  bidder_id int NOT NULL REFERENCES bidders(id) ON DELETE CASCADE,
  item_id int NOT NULL REFERENCES items(id) ON DELETE CASCADE,
  amount numeric(6,2) NOT NULL
);

CREATE INDEX ON bids(bidder_id, item_id);

\copy bidders FROM bidders.csv WITH (FORMAT CSV, HEADER);
\copy items FROM items.csv WITH (FORMAT CSV, HEADER);
\copy bids FROM bids.csv WITH (FORMAT CSV, HEADER);

-- IN - Write a SQL query that shows all items that have had bids put on them. Use the logical operator IN for this exercise, as well as a subquery.

SELECT name AS "Bid on Items" FROM items 
WHERE id IN (SELECT DISTINCT item_id FROM bids);

-- NOT IN - Write a SQL query that shows all items that have not had bids put on them. Use the logical operator NOT IN for this exercise, as well as a subquery.

SELECT name AS "Not Bid On" FROM items
WHERE id NOT IN (SELECT item_id FROM bids);

-- EXISTS. Write a SELECT query that returns a list of names of everyone who has bid in the auction. While it is possible (and perhaps easier) to do this with a JOIN clause, we're going to do things differently: use a subquery with the EXISTS clause instead. Here is the expected output:

SELECT name FROM bidders 
WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id);

-- More often than not, we can get an equivalent result by using a JOIN clause, instead of a subquery. Can you figure out a SELECT query that uses a JOIN clause that returns the same output as our solution above?

SELECT DISTINCT bidders.name FROM bidders JOIN bids
ON bidders.id = bids.bidder_id;

-- TRANSIENT TABLE. In this exercise, we will build that filtering into the table that we will query. Write an SQL query that finds the largest number of bids from an individual bidder.
-- For this exercise, you must use a subquery to generate a result table (or transient table), and then query that table for the largest number of bids.

SELECT MAX(bid_counts.count) FROM (SELECT count(bidder_id) FROM bids GROUP BY bidder_id AS bid_counts);

-- For this exercise, use a scalar subquery to determine the number of bids on each item. The entire query should return a table that has the name of each item along with the number of bids on an item.

SELECT items.id, items.name, 
    (SELECT count(item_id) FROM bids WHERE item_id = items.id)
FROM items;

-- simplification of the table above
SELECT name, 
    (SELECT count(item_id) FROM bids WHERE item_id = items.id)
FROM items;

-- We want to check that a given item is in our database. There is one problem though: we have all of the data for the item, but we don't know the id number. Write an SQL query that will display the id for the item that matches all of the data that we know, but does not use the AND keyword. Here is the data we know: 'Painting', 100.00, 250.00

SELECT id FROM items WHERE 
ROW('Painting', 100.00, 250.00) = ROW(name, initial_price, sales_price);

-- For this exercise, let's explore the EXPLAIN PostgreSQL statement. It's a very useful SQL statement that lets us analyze the efficiency of our SQL statements. More specifically, use EXPLAIN to check the efficiency of the query statement we used in the exercise on EXISTS:

EXPLAIN (SELECT name FROM bidders
WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id));

-- Hash Join  (cost=33.38..66.47 rows=635 width=32)
--    Hash Cond: (bidders.id = bids.bidder_id)
--    ->  Seq Scan on bidders  (cost=0.00..22.70 rows=1270 width=36)
--    ->  Hash  (cost=30.88..30.88 rows=200 width=4)
--          ->  HashAggregate  (cost=28.88..30.88 rows=200 width=4)
--                Group Key: bids.bidder_id
--                ->  Seq Scan on bids  (cost=0.00..25.10 rows=1510 width=4)

EXPLAIN ANALYZE (SELECT name FROM bidders

-- WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id));
-- Hash Join  (cost=33.38..66.47 rows=635 width=32) (actual time=0.065..0.068 rows=6.00 loops=1)
--    Hash Cond: (bidders.id = bids.bidder_id)
--    Buffers: shared hit=2
--    ->  Seq Scan on bidders  (cost=0.00..22.70 rows=1270 width=36) (actual time=0.015..0.016 rows=7.00 loops=1)
--          Buffers: shared hit=1
--    ->  Hash  (cost=30.88..30.88 rows=200 width=4) (actual time=0.044..0.044 rows=6.00 loops=1)
--          Buckets: 1024  Batches: 1  Memory Usage: 9kB
--          Buffers: shared hit=1
--          ->  HashAggregate  (cost=28.88..30.88 rows=200 width=4) (actual time=0.024..0.026 rows=6.00 loops=1)
--                Group Key: bids.bidder_id
--                Batches: 1  Memory Usage: 32kB
--                Buffers: shared hit=1
--                ->  Seq Scan on bids  (cost=0.00..25.10 rows=1510 width=4) (actual time=0.006..0.009 rows=26.00 loops=1)
--                      Buffers: shared hit=1
--  Planning Time: 0.194 ms
--  Execution Time: 0.108 ms
-- (16 rows)

-- Comparing SQL Statements
-- In this exercise, we'll use EXPLAIN ANALYZE to compare the efficiency of two SQL statements. These two statements are actually from the "Query From a Transient Table" exercise in this set. In that exercise, we stated that our subquery-based solution:

EXPLAIN ANALYZE SELECT MAX(bid_counts.count) FROM
  (SELECT COUNT(bidder_id) FROM bids GROUP BY bidder_id) AS bid_counts;

EXPLAIN ANALYZE SELECT COUNT(bidder_id) AS max_bid FROM bids
GROUP BY bidder_id
ORDER BY max_bid DESC
LIMIT 1;


ALTER TABLE tab_name ADD [CONSTRAINT cont_name] CHECK(col_name >= value);
ALTER TABLE tab_name DROP CONSTRAINT cont_name;