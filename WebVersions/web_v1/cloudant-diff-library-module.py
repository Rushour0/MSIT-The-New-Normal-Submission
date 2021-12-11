import time
from datetime import datetime
from ibmcloudant.cloudant_v1 import CloudantV1
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator
import pandas as pd
from ibm_cloud_sdk_core import ApiException
from ibmcloudant.cloudant_v1 import CloudantV1, Document
import os
from dotenv import load_dotenv

# All necessary imports


load_dotenv()


SERVICE_URL = os.getenv("SERVICE_URL")
API_KEY = os.getenv("API_KEY")
AUTH_KEY = os.getenv("AUTH_KEY")

AUTH_KEY = bytes.fromhex(AUTH_KEY)
alternate = True

authenticator = IAMAuthenticator(API_KEY)

client = CloudantV1(authenticator=authenticator)

client.set_service_url(SERVICE_URL)

# All private keys loaded from .env file

hr_list = {}

i = 0

i = int(
    input(
        "Enter where do you want to resume from, if the data is completely new, enter zero: "
    )
)

data = pd.read_csv("heartrate.csv")
data.drop_duplicates(subset="At", keep="last", inplace=True)

if i > len(data["At"]):
    i = len(data["At"])


def get_new_data():
    """Function iterates through heartrate.csv created by the exe file which logs heart rate from mi band 3"""
    global i
    global hr_list
    data = pd.read_csv("heartrate.csv")  # reads csv file
    data.drop_duplicates(subset="At", keep="last", inplace=True)  # drops duplicates
    data = data.reset_index(drop=True)  # resets index
    if i < len(data["At"]):  # check to make sure i does not exceed length of data
        try:
            timedate_raw = data["At"][i]  # gets time and date from csv file
            timedate_obj = datetime.strptime(
                timedate_raw, "%d-%m-%Y %H:%M:%S"
            )  # converts to datetime object
            time_ = str(
                timedate_obj.strftime("%d/%m/%y %H:%M:%S")
            )  # converts to string
            print(timedate_obj)
            hr_list[timedate_obj] = data["Heartrate"][i]  # adds to dictionary
            if i % 6 == 0:  # every 6th row is used to create a document
                data_entry: Document = Document(id=time_)  # creates document
                data_entry.value = int(data["Heartrate"][i])  # adds value to document
                create_document_response = client.post_document(
                    db="muskan", document=data_entry
                ).get_result()
                print(f"You have created the document:\n{data_entry}")  # logs document
                print("Logged the data")
                time.sleep(1)
            else:
                print("Skipped the entry")  # logs skipped entry
            print(i)
            time.sleep(0.5)
            i = i + 1
        except ApiException as e:
            print(e)
            i = i + 1
        except KeyError as e:
            print(e)
            i = i + 1

    else:  # if i exceeds length of data, we are running out of data
        time.sleep(10)
        print("No more data available, will wait for new data")
        pass


while True:
    get_new_data()
