# CoBAND

## INTRODUCTION


**CoBAND** is a product idea developed by Team Ducks on Fire which aims to break down the COVID-19 crisis at the time of reopening of organizations like schools, colleges, offices etc to ensure the lasting safety from the novel coronavirus during the aftermath of the lockdown. The bands (nomenclated “CoBANDs”) would target to estimate the health and wellness of each and every individual on premises by continuously tracking four of their vitals : SPO2, heart rate, temperature and blood pressure. This will thus improvise the current system of recording solely temperatures at the entry checkpoints multi-folds and go on to ensure that any deviation from normal is recorded as a dynamic aggregate of the more diverse vitals throughout the time they are on premises. Once that is being done, alerts can be generated and requisite protocols can be ensured to escort potentially / actually COVID ridden people off-campus. We have currently deployed the software side, which includes both the website and the application using a randomly generated databse of 3 vitals for multiple students on the admin-side dashboard [https://coband19.jxt1n.repl.co/] as well as the mobile application for the student/employee side.


## Prototype

The prototype thus includes both a hardware and a software part developed through three versions to get to the final product. Our existing prototype versions have been explained with all their semantics in this [report](https://docs.google.com/document/d/1xhUftrHGRukB2wiMmyU79MKb7XuntHSvzRcDs5I9J3w/edit?usp=sharing). 

The idea behind making multiple versions was to ensure that the developing hardware adds to the functionalities of the software end in a manner that would improvise on the existing product and allow for further scaling / improvements without rendering the mobile application / website for our product entirely dysfunctional. The future could see the development of the physical hardware further with the application and the website dashboard being intact.

The software includes admin side dashboard and client side dashboard. A python web flask is used to make the admin side dashboard. Flutter technology is used in the client side dashboard. Because of lack of direct hardware data fetching, the data for the dashboard is being fetched from Cloudant after uploading it from a remote device. The web site & client side app dashboard are dynamic in nature and are updated as new data is realised by the web / mobile app. Dynamic updating and health analytics make it easier for the user to understand. 

The final version's admin-side dashboard is on this [site](https://coband19.jxt1n.repl.co/).

The final version of the application has been deployed on this repository.

## Screenshots of mobile application

### Splash Screen
![Screenshot_1637150212](https://user-images.githubusercontent.com/72869428/145687374-c51aaf65-4122-43c0-b95d-8fd2c0e9e499.png)
### Log in page 
![Screenshot_1639246616](https://user-images.githubusercontent.com/72869428/145687395-e030ee9c-5318-4abb-9f54-59764750f54a.png)
### Loading page
![Screenshot_1639246629](https://user-images.githubusercontent.com/72869428/145687516-ba3ad009-3cf9-4bc4-a8aa-08b1568ba161.png)
### App drawer
![Screenshot_1639246603](https://user-images.githubusercontent.com/72869428/145687491-17fb7808-d4b3-420b-ae75-84f858d1b568.png)
###  Tab 1
![Screenshot_1639246605](https://user-images.githubusercontent.com/72869428/145687413-564e7e6f-ef38-473f-8007-65721d99fec7.png)
###  Tab 2
![Screenshot_1637149289](https://user-images.githubusercontent.com/72869428/145687427-61663ba0-c4de-49ea-bda3-33bfe0adeabf.png)
###  Tab 3
![Screenshot_1639246609](https://user-images.githubusercontent.com/72869428/145687436-5d95a1a6-7e15-437c-b4c8-5b6d5c420d50.png)


## Screenshots for the admin-side dashboard

