FROM python:3.9

ENV LANG=C.UTF-8
ENV PORT=8080

RUN apt-get update

WORKDIR /app

ADD . /app/
WORKDIR /app
RUN pip install -r requirements.txt

EXPOSE 8080
CMD hug -p $PORT -f app.py
