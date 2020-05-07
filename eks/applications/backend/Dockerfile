FROM python:3-alpine

RUN mkdir /app
COPY ./app /app
WORKDIR /app
RUN python -mpip install -r requirements.txt

EXPOSE 5000

CMD ["python", "main.py"]
