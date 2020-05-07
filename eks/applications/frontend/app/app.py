from flask import Flask, render_template, Response, jsonify
from flask_api import status
import requests
import os


backend_url=os.getenv('BACKEND_URL')

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")
    
@app.route("/api/feature")
def api():
    response = requests.get("http://%s:5000/api/feature" % (backend_url))
    return jsonify(response.json())

@app.route("/health")
def health():
    content = {'Status': 'ok'}
    return content, status.HTTP_200_OK


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True) # run application

