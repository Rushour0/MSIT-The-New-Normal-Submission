import json
import requests

link = "https://dbb024f3-9e7d-44fd-b99c-cbcdb456cc83-bluemix.cloudantnosqldb.appdomain.cloud"
r = requests.post("https://iam.cloud.ibm.com/identity/token", headers = {"Content-Type":"application/x-www-form-urlencoded"}, data = "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=9jtFMX0LC5cab8x5I5OYermeMeDYf0hQKCegLnT0z50L")
jsonResponse = r.json()
api_token = jsonResponse['access_token']

print(api_token)

r = requests.get(f"{link}/key_pass/_all_docs", headers = {"Authorization": f"Bearer {api_token}", "Content-Type":"application/json"}, data = {"include_docs":"true"})



print(r.json())