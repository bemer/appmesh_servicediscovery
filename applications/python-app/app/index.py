import pycurl
from io import BytesIO 
from flask import Flask
import os
import json

metadata_uri = os.getenv('ECS_CONTAINER_METADATA_URI')
metadata_uri = metadata_uri + '/task'
print(metadata_uri)

b_obj = BytesIO() 
crl = pycurl.Curl() 

crl.setopt(crl.URL, str(metadata_uri))
crl.setopt(crl.WRITEDATA, b_obj)
crl.perform() 
crl.close()
get_body = b_obj.getvalue()

ecs_metadata = json.loads(get_body.decode('utf8'))
private_ip = ecs_metadata['Containers'][1]['Networks'][0]['IPv4Addresses'][0]


app = Flask(__name__)
@app.route("/")
def hello():
    return "Server IP Address is: %s \n" % private_ip
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5000"), debug=True)
