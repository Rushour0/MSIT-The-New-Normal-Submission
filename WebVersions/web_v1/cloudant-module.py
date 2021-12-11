import time
from datetime import datetime
from bluepy.btle import BTLEDisconnectError
from miband import miband
from ibmcloudant.cloudant_v1 import CloudantV1
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator
from ibmcloudant.cloudant_v1 import CloudantV1, Document
import os
from dotenv import load_dotenv

# All necessary imports

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

# All private keys loaded from .env file


def general_info():  # Prints general info about the band
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
count = 0


def get_realtime():
    try:
        band.start_heart_rate_realtime(heart_measure_callback=heart_logger)
    except KeyboardInterrupt:
        print("\nExit.")


def heart_logger(data):  # data is the heart rate value
    data = abs(data)
    global count  # global variable to count the number of heart rate values
    print("Realtime heart BPM:", data)  # print the heart rate value
    hr_list[
        datetime.now().strftime("%d/%m/%y %H:%M:%S")
    ] = data  # add the heart rate value to the dictionary
    print(len(hr_list) // 2)
    if count % 3 == 0:  # Using every 10th heart rate value to create a new document
        time_ = str(datetime.now().strftime("%d/%m/%y %H:%M:%S"))
        data_entry: Document = Document(id=time_)

        # Add "add heart rate reading as value" field to the document
        data_entry.value = data

        # Save the document in the database
        create_document_response = client.post_document(
            db="jxtin", document=data_entry
        ).get_result()

        print(
            f"You have created the document:\n{data_entry}"
        )  # print the document that was created
        print("Logged the data")
    else:
        print("Didnt log the data")
    count += 1


get_realtime()
