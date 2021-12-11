import datetime
from itertools import count
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# plt.rcParams["figure.figsize"] = [10, 3]
plt.style.use("fivethirtyeight")


def animate(i):
    data = pd.read_csv("logs.csv")
    timedate_raw = data["timedate"]
    timedate_obj = []
    print(type(timedate_raw))
    for i in timedate_raw:
        date_obj = datetime.datetime.strptime(i, "%d/%m/%y %H:%M:%S")
        print(date_obj)
        timedate_obj.append(date_obj)

    hr_value = data["value"]

    plt.cla()

    plt.plot(timedate_obj, hr_value, color="red")
    plt.fill_between(timedate_obj, hr_value, color="#FC8F78")


ani = FuncAnimation(plt.gcf(), animate, interval=1000)

plt.show()
