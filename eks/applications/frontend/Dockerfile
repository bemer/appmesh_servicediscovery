FROM python:3-alpine

# Creates a directory in /usr/src/app
RUN mkdir /app
COPY ./app /app
WORKDIR /app

RUN pip install -r requirements.txt

# Expose the port
EXPOSE 80

# Start the application
CMD ["python", "app.py"]
