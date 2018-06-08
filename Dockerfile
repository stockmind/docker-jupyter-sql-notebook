FROM jupyter/datascience-notebook

LABEL maintainer="Simone Roberto Nunzi <simone.roberto.nunzi@gmail.com>"

USER root

RUN pip install sql_magic
