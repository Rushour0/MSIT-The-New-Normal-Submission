import time
import random
from datetime import datetime
from ibmcloudant.cloudant_v1 import CloudantV1
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator
import pandas as pd
from ibm_cloud_sdk_core import ApiException
from ibmcloudant.cloudant_v1 import CloudantV1, Document
import os
from dotenv import load_dotenv


load_dotenv()


SERVICE_URL = os.getenv("SERVICE_URL")
API_KEY = os.getenv("API_KEY")
AUTH_KEY = os.getenv("AUTH_KEY")

AUTH_KEY = bytes.fromhex(AUTH_KEY)
alternate = True

authenticator = IAMAuthenticator(API_KEY)

client = CloudantV1(authenticator=authenticator)

client.set_service_url(SERVICE_URL)


# define a class for health values from datageneration.py


class HealthParameters:
    def __init__(self, name, hr_value, spo2_value, temperature_value):
        # Initial values
        self.name = name
        self.hr_value = hr_value
        self.spo2_value = spo2_value
        self.temperature_value = temperature_value
        self.health_index = self.health_critera()

    def health_critera(self):  # This function is used to check the health of the data
        # Generate value now
        print("Checking health")
        hr_value = self.hr_value
        temperature_value = self.temperature_value
        spo2_value = self.spo2_value
        hr_dev = 0
        temperature_dev = 0
        spo2_dev = 0
        if hr_value > 110:
            hr_dev = (hr_value - 110) / 110
        elif hr_value < 70:
            hr_dev = (70 - hr_value) / 70
        if spo2_value < 97:
            spo2_dev = (97 - spo2_value) / 97
        if temperature_value > 99.2:
            temperature_dev = ((temperature_value - 98.6) / 98.6) * 3
        elif temperature_value < 98:
            temperature_dev = (98 - temperature_value) / 98
        print(
            f"The deviation of the data is:\nHR: {hr_dev} \nSPO2: {spo2_dev} \nTemperature: {temperature_dev}"
        )

        net_dev = round(
            ((10 * hr_dev) + (60 * spo2_dev) + (50 * temperature_dev)) * 10, 4
        )
        output_result = (1 - (net_dev / 150)) * 100
        output_result = round(output_result, 2)
        # print(f"The deviation of the data is {net_dev}")
        print(f"The health index of the data is {output_result}")
        return output_result

    def update_data(self):
        self.hr_value += random.randint(-20, 30) / 10
        self.hr_value = int(self.hr_value)
        self.spo2_value += random.randint(-3, 3) / 10
        self.temperature_value += random.randint(-15, 15) / 100
        self.spo2_value = round(self.spo2_value, 2)
        if self.spo2_value > 100:
            self.spo2_value = 100
        self.temperature_value = round(self.temperature_value, 1)
        self.health_index = self.health_critera()
        self.print_data()

    def print_data(self):
        print("Name", self.name)
        print("Heart rate: ", self.hr_value)
        print("SpO2: ", self.spo2_value)
        print("Temperature: ", self.temperature_value)
        print("Health index: ", self.health_index)
        print("\n")

    def output_data(self):
        # Return a dictionary of all the values
        return {
            "name": self.name,
            "hr_value": self.hr_value,
            "spo2_value": self.spo2_value,
            "temperature_value": self.temperature_value,
            "health_index": self.health_index,
        }


# create an object of the class HealthParameters name, hr_value, spo2_value, temperature_value

student1 = HealthParameters("jatin", 100, 98, 98.6)

student2 = HealthParameters("testinglol", 85, 99, 98.9)


def post_document(student):
    timestamp = datetime.now().strftime("%d/%m/%y %H:%M:%S")
    print(timestamp)
    data = student.output_data()
    data["timestamp"] = timestamp
    data_entry: Document = Document(id=timestamp)
    data_entry.hr_value = data["hr_value"]
    data_entry.spo2_value = data["spo2_value"]
    data_entry.temperature_value = data["temperature_value"]
    data_entry.health_index = data["health_index"]
    # if True:

    if data_entry.health_index > 75:
        data_entry.health_status = "Healthy"
        create_document_response = client.post_document(
            db=student.name, document=data_entry
        ).get_result()
        print(f"You have created the document:\n{data_entry}")  # logs document
        print("Logged the data")
    else:
        print(f"You have created the document:\n{data}")  # logs document
        print("Didnt log the data")


if __name__ == "__main__":
    while True:
        student1.update_data()
        student2.update_data()
        post_document(student1)
        post_document(student2)
        time.sleep(3)
