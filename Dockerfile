FROM jupyter/datascience-notebook

LABEL maintainer="Simone Roberto Nunzi <simone.roberto.nunzi@gmail.com>"

USER $NB_UID

# SQL magic
RUN pip install sql_magic

# Postgres
RUN pip install psycopg2-binary

# Themes
# RUN pip install jupyterthemes
# RUN jt -t onedork -f hack

# Useful plugins
RUN pip install hide_code

RUN pip install jupyter_contrib_nbextensions yapf

USER root

RUN apt update && \
    apt install -y wkhtmltopdf python-pdfkit

# Fix missing X server for hide_code PDF wkhtmltopdf export
RUN apt-get install xvfb && \
	printf '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf -q $*' > /usr/bin/wkhtmltopdf.sh && \
	chmod a+x /usr/bin/wkhtmltopdf.sh && \
	ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf

RUN jupyter nbextension install --py hide_code && \
    jupyter nbextension enable --py hide_code && \
    jupyter serverextension enable --py hide_code

RUN jupyter contrib nbextension install --system
    
RUN jupyter nbextension enable --system codefolding/main && \
    jupyter nbextension enable --system ruler/main && \
    jupyter nbextension enable --system table_beautifier/main && \
    jupyter nbextension enable --system code_prettify/code_prettify && \
    jupyter nbextension enable --system freeze/main

RUN fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter
