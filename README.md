# docker-jupyter-sql-notebook

```
docker run --rm -p 8080:8888 -v /host/workfolder:/home/jovyan/work --name notebook stockmind/docker-jupyter-sql-notebook
```

# Launch with a PostgreSQL db

An example script to setup a PostgreSQL env is provided in `examples/postgres.sh` script.

The script will launch and setup containers required to a fully working Jupyter and PostgreSQL env.
