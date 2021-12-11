# CoBAND


## Technologies
------------
Project is created with:
* Flask
* IBM Cloudant database Service
* MiBand4 library to retrieve heartrate information (Works only with linux)
* JavaScript
* Highcharts for plotting graph
	
## Setup
------------
To run this project, install the requirements.txt module using 

For linux or MacOs:
```
pip3 install -r requirements.txt
```

For Windows:
```
pip install -r requirements.txt
```

To run the prototype simulation to get data from cloudant, setup the webpage using :

For linux or MacOs:
```
python3 cloudant-flask-app.py
```

For Windows:
```
python cloudant-flask-app.py
```