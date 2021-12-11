import time
from datetime import datetime
from bluepy.btle import BTLEDisconnectError
from miband import miband
import csv
from ibmcloudant.cloudant_v1 import CloudantV1
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator
import json
import logging

from ibm_cloud_sdk_core import ApiException
from ibmcloudant.cloudant_v1 import CloudantV1, Document
import os
from dotenv import load_dotenv

load_dotenv()


SERVICE_URL = os.getenv("SERVICE_URL")
API_KEY = os.getenv("API_KEY")
AUTH_KEY = os.getenv("AUTH_KEY")
MAC_ADDR = os.getenv("MAC_ADDR")

AUTH_KEY = bytes.fromhex(AUTH_KEY)
alternate = True

authenticator = IAMAuthenticator(API_KEY)

client = CloudantV1(authenticator=authenticator)

client.set_service_url(SERVICE_URL)


def general_info():
    global band
    print("MiBand-4")
    print("Soft revision:", band.get_revision())
    print("Hardware revision:", band.get_hrdw_revision())
    print("Serial:", band.get_serial())
    print("Battery:", band.get_battery_info()["level"])
    print("Time:", band.get_current_time()["date"].isoformat())


# function to create connection and band object ;-;
def create_connection():
    success = False
    while not success:
        try:
            band = miband(MAC_ADDR, AUTH_KEY, debug=True)
            success = band.initialize()
            return band
        except BTLEDisconnectError:
            print("Connection to the MIBand failed. Trying out again in 3 seconds")
            time.sleep(3)
            continue
        except KeyboardInterrupt:
            print("\nExit.")
            exit()


band = create_connection()
general_info()

hr_list = {}


def get_realtime():
    try:
        band.start_heart_rate_realtime(heart_measure_callback=heart_logger)
    except KeyboardInterrupt:
        print("\nExit.")


def heart_logger(data):
    data = abs(data)
    print("Realtime heart BPM:", data)
    hr_list[datetime.now().strftime("%d/%m/%y %H:%M:%S")] = data
    print(len(hr_list) // 2)
    global alternate
    if alternate:
        time_ = str(datetime.now().strftime("%d/%m/%y %H:%M:%S"))
        data_entry: Document = Document(id=time_)

        # Add "add heart rate reading as value" field to the document
        data_entry.value = data

        # Save the document in the database
        create_document_response = client.post_document(
            db="coband", document=data_entry
        ).get_result()

        print(f"You have created the document:\n{data_entry}")
        print("Logged the data")
    else:
        print("Didnt log the data")
    alternate = not alternate


get_realtime()
