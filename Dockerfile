FROM jupyter/datascience-notebook

LABEL maintainer="Simone Roberto Nunzi <simone.roberto.nunzi@gmail.com>"

USER root

# SQL magic
RUN pip install sql_magic

# Postgres
RUN pip install psycopg2-binary

# Themes
RUN pip install jupyterthemes
RUN jt -t monokai -f hack
