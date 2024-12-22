BEGIN;

SELECT COUNT(*) FROM test_table WHERE amount > 500;

SELECT AVG(amount) FROM test_table WHERE amount BETWEEN 100 AND 1000;

INSERT INTO test_table (name, amount)
VALUES ('New User', (random() * 1000)::INT);

UPDATE test_table SET amount = amount + 100 WHERE amount < 500;

DELETE FROM test_table
WHERE id IN (SELECT id FROM test_table WHERE amount > 5000 LIMIT 100);

SELECT id, name, amount FROM test_table ORDER BY amount DESC LIMIT 100;

COMMIT;
