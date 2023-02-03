# pull from official base image
FROM python:3.10.3-slim-buster

# create working directory
RUN mkdir -p /usr/src/app

# set working directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV POETRY_VERSION 1.2.2

# install system dependencies
RUN apt-get update \
  && apt-get -y install netcat gcc postgresql \
  && apt-get clean

# install poetry
RUN pip install "poetry==$POETRY_VERSION"

# copy poetry files
COPY poetry.lock pyproject.toml /usr/src/app/

# add and install requirements
RUN poetry config virtualenvs.create false && poetry install --no-root

# # add and install requirements
# COPY ./requirements.txt .
# RUN pip install -r requirements.txt

# add app
COPY . .

# run server via entrypoint.sh
# add entrypoint.sh
COPY ./entrypoint.sh .
RUN chmod +x /usr/src/app/entrypoint.sh
RUN chmod 777 /usr/src/app/entrypoint.sh