import datetime
import json
import os
from dotenv import load_dotenv
from flask import Flask, make_response, render_template
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator
from ibmcloudant.cloudant_v1 import CloudantV1

# All necessary imports


load_dotenv()


SERVICE_URL = os.getenv("SERVICE_URL")
API_KEY = os.getenv("API_KEY")
authenticator = IAMAuthenticator(API_KEY)

service = CloudantV1(authenticator=authenticator)

service.set_service_url(SERVICE_URL)

# All private kets from the .env file

app = Flask(__name__)

i = 0  # Index variable for logging mb3 data
j = 0  # Index variable for logging mb4 data

responses_mb3 = service.post_all_docs(
    db="muskan",
    include_docs=True,
).get_result()

responses_mb4 = service.post_all_docs(
    db="jxtin",
    include_docs=True,
).get_result()


i = len(responses_mb3["rows"]) - 10  # To use last 5 documents from mb3 database
j = len(responses_mb4["rows"]) - 10  # To use last 5 documenrs from mb4 data


def get_data():
    responses_mb3 = service.post_all_docs(
        db="muskan",
        include_docs=True,
    ).get_result()

    responses_mb4 = service.post_all_docs(
        db="jxtin",
        include_docs=True,
    ).get_result()
    return responses_mb3, responses_mb4


@app.route("/", methods=["GET", "POST"])
# Home page for the app
def main():
    return render_template("index.html")


@app.route("/data", methods=["GET", "POST"])
def data():
    # Create an API which will be used by javascript to get data
    global i
    global j
    all_responses = get_data()  # Get all the data from the databases
    responses_mb3 = all_responses[0]  # Get the mb3 data
    responses_mb4 = all_responses[1]  # Get the mb4 data

    output = {}  # Create an empty dictionary to store the data

    if i >= len(
        responses_mb3["rows"]
    ):  # If the index is greater than the length of the mb3 database, we are running out of data
        pass
    else:
        response = responses_mb3["rows"][i]["doc"]  # Get the data from the mb3 database
        timedate_raw = response["_id"]  # Get the time and date from the mb3 database
        date_obj = datetime.datetime.strptime(
            timedate_raw, "%d/%m/%y %H:%M:%S"
        )  # Convert the time and date to a datetime object
        hr_value = response["value"]  # Get the value from the mb3 database
        data1 = [
            date_obj.timestamp() * 1000,
            int(hr_value),
        ]  # Create a list of the time and value
        print(data1)
        i = i + 1  # Increment the index variable
        output["mb3"] = data1  # Add the data to the dictionary

    if j >= len(
        responses_mb4["rows"]
    ):  # If the index is greater than the length of the mb4 database, we are running out of data
        pass
    else:
        # Repeating the same steps for the mb4 database
        response = responses_mb4["rows"][j]["doc"]
        timedate_raw = response["_id"]
        date_obj = datetime.datetime.strptime(timedate_raw, "%d/%m/%y %H:%M:%S")
        hr_value = response["value"]
        data1 = [date_obj.timestamp() * 1000, int(hr_value)]
        print(data1)
        j = j + 1
        output["mb4"] = data1

    json_dump = json.dumps(output)
    print(json_dump)
    response = make_response(json_dump)
    response.content_type = "application/json"
    print(response)
    return response


if __name__ == "__main__":
    app.run(debug=True)
