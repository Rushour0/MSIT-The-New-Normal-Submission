import time
from datetime import datetime
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


class databases:
    def __init__(self, db):
        self.db = db
        response = service.post_all_docs(
            db=db,
            include_docs=False,
        ).get_result()
        self.length = response["total_rows"]
        self.current_val = self.length - 10
        print(self.length)
        print(self.current_val)

    def print_all(self):
        print(self.db)
        print(self.length)
        print(self.current_val)


database_list = ["jatin", "testinglol"]  # Enter databases to be tracked

db_obj_list = []

for database in database_list:
    db_obj_list.append(databases(database))

print(db_obj_list)

for database in db_obj_list:
    database.print_all()

# i = len(responses_mb3["rows"]) - 5  # To use last 5 documents from mb3 database
app = Flask(__name__)


def get_data(db):
    responses = service.post_all_docs(
        db=db,
        include_docs=True,
    ).get_result()
    return responses


@app.route("/", methods=["GET", "POST"])
# Home page for the app
def main():
    return render_template("index.html")


@app.route("/data", methods=["GET", "POST"])
def data():
    data_list = {}
    count = 0

    for database in db_obj_list:
        try:
            responses = get_data(database.db)
            cur_data = responses["rows"][database.current_val]["doc"]
            print(cur_data["_id"])
            cur_data["_id"] = (
                datetime.strptime(cur_data["_id"], "%d/%m/%y %H:%M:%S")
            ).timestamp() * 1000
            data_list[count] = cur_data
            database.current_val += 1
            count += 1
        except IndexError:
            time.sleep(2)
        time.sleep(0.2)
    # print(data_list)
    return data_list


if __name__ == "__main__":
    app.run(debug=True)
