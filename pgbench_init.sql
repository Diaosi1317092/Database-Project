DROP TABLE IF EXISTS test_table;
DROP TABLE IF EXISTS another_table;

CREATE TABLE test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    amount INT,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO test_table (name, amount)
SELECT 'Test User ' || i, i * 10
FROM generate_series(1, 100000) AS s(i);