DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    amount INT,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO test_table (name, amount)
SELECT 'Test User ' || i, i * 10
FROM generate_series(1, 100000) AS s(i);

BEGIN;

SELECT COUNT(*)
FROM test_table
WHERE amount > 500;

SELECT AVG(amount)
FROM test_table
WHERE amount BETWEEN 100 AND 1000;

SELECT id, amount
FROM test_table
WHERE amount > 5000
ORDER BY amount DESC
LIMIT 100;

UPDATE test_table
SET amount = amount + 100
WHERE amount < 500;

INSERT INTO test_table (name, amount)
VALUES ('New User', 1000);

DELETE FROM test_table
WHERE id IN (
    SELECT id
    FROM test_table
    WHERE amount > 5000
    LIMIT 100
);

SELECT *
FROM test_table
WHERE id BETWEEN 10000 AND 20000;

SELECT
    CASE
        WHEN amount <= 500 THEN 'Low'
        WHEN amount <= 2000 THEN 'Medium'
        ELSE 'High'
    END AS amount_range,
    AVG(amount)
FROM test_table
GROUP BY amount_range;

SELECT COUNT(*)
FROM test_table
WHERE amount > 500 AND amount < 1000;

COMMIT;