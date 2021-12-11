from re import I
from flask import Flask, render_template, url_for, request, redirect, make_response
import random
import json
from time import time, localtime, sleep
from random import random
from flask import Flask, render_template, make_response
import pandas as pd
import datetime

app = Flask(__name__)

i = 0


@app.route("/", methods=["GET", "POST"])
def main():
    return render_template("index.html")


@app.route("/data", methods=["GET", "POST"])
def data():
    global i
    data_from_csv = pd.read_csv("logs.csv")

    if i > len(data_from_csv):
        sleep(15)
    else:
        timedate_raw = data_from_csv["timedate"]
        date_obj = datetime.datetime.strptime(timedate_raw[i], "%d/%m/%y %H:%M:%S")
        hr_value = data_from_csv["value"]
        data1 = [str(timedate_raw[i]), hr_value[i]]
        print(data1)
        data1 = [date_obj.timestamp() * 1000, int(hr_value[i])]
        print(data1)
        response = make_response(json.dumps(data1))
        response.content_type = "application/json"
        print(response)
        i = i + 1
        return response


if __name__ == "__main__":
    app.run(debug=True)
