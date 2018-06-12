FROM jupyter/datascience-notebook

LABEL maintainer="Simone Roberto Nunzi <simone.roberto.nunzi@gmail.com>"

USER $NB_UID

# SQL magic
RUN pip install sql_magic

# Postgres
RUN pip install psycopg2-binary

# Themes
RUN pip install jupyterthemes
RUN jt -t monokai -f hack

# Useful plugins
RUN pip install hide_code

USER root
RUN jupyter nbextension install --py hide_code
RUN jupyter nbextension enable --py hide_code
RUN jupyter serverextension enable --py hide_code

RUN fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter
