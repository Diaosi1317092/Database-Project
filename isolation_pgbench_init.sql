BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
INSERT INTO transaction_log (transaction_name, details)
VALUES ('Dirty Read Test', 'Transaction A reads uncommitted data from test_table.');
SELECT * FROM test_table WHERE amount > 1000;
SELECT * FROM test_table WHERE amount > 5000;
COMMIT;

BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
INSERT INTO transaction_log (transaction_name, details)
VALUES ('Non-repeatable Read Test', 'Transaction B reads data and modifies it.');
SELECT * FROM test_table WHERE amount BETWEEN 500 AND 1000;
UPDATE test_table SET amount = amount + 100 WHERE amount BETWEEN 500 AND 1000;
INSERT INTO transaction_log (transaction_name, details)
VALUES ('Non-repeatable Read Test', 'Transaction B reads modified data after update.');
SELECT * FROM test_table WHERE amount BETWEEN 500 AND 1000;
COMMIT;

BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
INSERT INTO transaction_log (transaction_name, details)
VALUES ('Phantom Read Test', 'Transaction C reads data set based on amount between 100 and 1000.');
SELECT * FROM test_table WHERE amount BETWEEN 100 AND 1000;
INSERT INTO test_table (name, amount) VALUES ('Phantom User', 600);
INSERT INTO transaction_log (transaction_name, details)
VALUES ('Phantom Read Test', 'Transaction C reads new phantom data inserted by Transaction D.');
SELECT * FROM test_table WHERE amount BETWEEN 100 AND 1000;
COMMIT;