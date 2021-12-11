# CoBAND

## INTRODUCTION


**CoBAND** is a product idea developed by team PontiacBandits and following is the prototype of the product dash board web version with following functionalities :

 * Visualise and raise alerts based on heartrate of the students, multiple at once.
 * Raise alerts for admin to ensure things are in check and protocols are followed properly.


## Prototype

The prototype thus includes both a hardware and a software part developed in a multitude of versions to get to the final product. Our existing prototype has five functional versions which are explained with all their semantics in this report. The idea behind making multiple versions was to ensure that the developing hardware adds to the functionalities of the software end in a manner that would improvise on the existing product and allow for further scaling/improvements without rendering the mobile application / website for our product entirely dysfunctional.


The software includes admin side dashboard and client side dashboard. A python web flask is used to make the admin side dashboard. Flutter technology is used in the client side dashboard. Because of lack of direct hardware data fetching, the data for the dashboard is being fetched from Cloudant after uploading it from a remote device. The web site & client side app dashboard are dynamic in nature and are updated as new data is realised by the web / mobile app. Dynamic updating and health analytics make it easier for the user to understand. 
