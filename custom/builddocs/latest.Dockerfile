FROM debian:12-slim

RUN apt-get update \
    && apt-get install -y build-essential git fontconfig inkscape lsb-release rclone rsync make texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-xetex latexmk poppler-utils libcurl4-openssl-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*
