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
![Screenshot_1637150212](https://user-images.githubusercontent.com/72869428/145687725-b092c83c-0820-42e1-8a48-913fd07fc13d.png)
### Log in page
![Screenshot_1639246616](https://user-images.githubusercontent.com/72869428/145687777-dd83bfce-435d-4b82-b9ee-ac058ea38dc0.png)
### Loading page
![Screenshot_1639246629](https://user-images.githubusercontent.com/72869428/145687627-caad0e55-5da7-4b26-9416-404c181adb9c.png)
### Hamburger Menu
![Screenshot_1639246603](https://user-images.githubusercontent.com/72869428/145687739-db891604-6c1c-41e6-875e-f18304d40321.png)
###  Tab 1
![Screenshot_1639246605](https://user-images.githubusercontent.com/72869428/145687752-19ee31de-3c42-46a5-b2f7-79e1fe096361.png)
###  Tab 2
![Screenshot_1637149289](https://user-images.githubusercontent.com/72869428/145687706-9182a8b3-1abb-4090-9813-9d4bc9429413.png)
###  Tab 3
![Screenshot_1639246609](https://user-images.githubusercontent.com/72869428/145687764-0746700f-5ad0-4e1b-b28b-a6f6d1bda4c1.png)

## Screenshots for the admin-side dashboard

