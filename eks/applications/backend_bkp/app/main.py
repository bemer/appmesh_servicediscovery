from flask import Flask
from flask import jsonify
import random

FEATURES_FILE = "./features.txt" # quote file
features = [] # stores all feature

# a feature
class Feature(object):
    def __init__(self, feature, title):
        self.feature = feature
        self.title = title

# Loads features from a file
def loadFeatures():
    with open(FEATURES_FILE) as file:
        lines = file.readlines()
        lines = [x.strip() for x in lines] 
        for line in lines:
            feature, by = line.split("-")
            features.append(Feature(by, feature))
            
app = Flask(__name__)

# Gets a random quote 
@app.route("/api/feature")
def feature():
    q = random.choice(features) # selects a random quote from file
    return jsonify({"feature": q.feature, "by": q.title}) # return a quote

# 404 Error for unknown routes
@app.errorhandler(404)
def page_not_found(e):
    return jsonify({"message": "Resource not found"}), 404

if __name__ == '__main__':
    loadFeatures() # load features
    app.run(host='0.0.0.0', port=5000, debug=True) # run application
    