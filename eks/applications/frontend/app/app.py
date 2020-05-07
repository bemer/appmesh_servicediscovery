from flask import Flask
from flask import render_template
from flask import Response
from flask import jsonify
import requests
import os


backend_url=os.getenv('BACKEND_URL')

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")
    
person = {'by': 'Alice', 'feature': 1986}


# @app.route("/api/feature")
# def about():
#     return jsonify(person)

@app.route("/api/feature")
def about():
    x = requests.get("http://%s:5000/api/feature" % (backend_url))
    # x = requests.get(backend_url)
    return jsonify(x.json())


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True) # run application

