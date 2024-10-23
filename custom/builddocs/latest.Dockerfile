FROM python:3.10-slim-bookworm

RUN apt-get update \
    && apt-get install -y build-essential git python3-venv fontconfig inkscape lsb-release rclone rsync make texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-xetex latexmk poppler-utils libcurl4-openssl-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*
