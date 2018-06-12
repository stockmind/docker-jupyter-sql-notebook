# docker-jupyter-sql-notebook

```
docker run --rm -p 8080:8888 -v /host/workfolder:/home/jovyan/work --name notebook stockmind/docker-jupyter-sql-notebook
```

# Launch with a PostgreSQL db

An example script to setup a PostgreSQL env is provided in `examples/postgres.sh` script.

The script will launch and setup containers required to a fully working Jupyter and PostgreSQL env.

Then into notebook use to connect:
```
%load_ext sql_magic
import pandas.io.sql as psql
import psycopg2
connect_credentials = {
                       'host': 'postgresdb',
                       'database': 'postgres',
                       'user': 'postgres',
                       'password': 'root',
                       }

# connect to postgres connection object
conn = psycopg2.connect(**connect_credentials)
conn.autocommit = True
schema_name = 'public'
psql.execute('SET search_path TO {}'.format(schema_name), conn)
%config SQL.conn_name='conn'
```

And test with:
```
%%read_sql -n

DROP TABLE IF EXISTS my_table;
CREATE TABLE my_table (
  column1 INT,
  column2 text
);

INSERT INTO my_table 
VALUES  (1,'hello');

SELECT *
FROM my_table
WHERE column2 like '%ello';
```
