from flask import Flask, render_template, make_response
import json
from time import sleep
from random import random
from flask import Flask, render_template, make_response
import datetime
from ibmcloudant.cloudant_v1 import CloudantV1
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator
import os
from dotenv import load_dotenv

load_dotenv()


SERVICE_URL = os.getenv("SERVICE_URL")
API_KEY = os.getenv("API_KEY")
authenticator = IAMAuthenticator(API_KEY)

service = CloudantV1(authenticator=authenticator)

service.set_service_url(SERVICE_URL)


app = Flask(__name__)

response = service.post_all_docs(
    db="coband",
    include_docs=False,
).get_result()

i = response["total_rows"] - 10


def get_data():
    response = service.post_all_docs(
        db="coband",
        include_docs=True,
    ).get_result()
    return response


@app.route("/", methods=["GET", "POST"])
def main():
    return render_template("index.html")


@app.route("/data", methods=["GET", "POST"])
def data():
    global i
    responses = get_data()
    if i >= len(responses["rows"]):
        return {}
    else:
        response = responses["rows"][i]["doc"]
        timedate_raw = response["_id"]
        date_obj = datetime.datetime.strptime(timedate_raw, "%d/%m/%y %H:%M:%S")
        hr_value = response["value"]
        data1 = [date_obj.timestamp() * 1000, int(hr_value)]
        print(data1)
        response = make_response(json.dumps(data1))
        response.content_type = "application/json"
        print(response)
        i = i + 1
        return response


if __name__ == "__main__":
    app.run(debug=True)
