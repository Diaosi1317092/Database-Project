DROP TABLE IF EXISTS transaction_log;

CREATE TABLE transaction_log (
  id SERIAL PRIMARY KEY,
  transaction_name TEXT,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  details TEXT
);
