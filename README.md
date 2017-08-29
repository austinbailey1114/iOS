# iOS
## Features ##
This repository is an iOS app for a user to track their weight lifting progress, nutrition, and bodyweight over time. 
The app has 3 tabs. One for adding and tracking lifts, one for adding and tracking meals, and one for tracking changes in their bodyweight over time. 
### Lift Tab ###
The lift tab allows users to input and track their lifts quickly. The user simply inputs the weight, repetitions, and type of lift to track it. The user can input a new type of lift, and once they do it will be added to the picker wheel for quickly choosing it without typing it into the keyboard again. On this tab, the user can track their progress by either viewing their lift history as a table view, or by viewing it as a graph using [iOS Charts] (https://github.com/danielgindi/Charts). On the graph page, the user selects the lift they want to display from a picker wheel as well.
### Nutrition Tab ###
The nutrition tab connects the user to https://www.nutritionix.com/ using a pre-formatted GET request to search for a food and return a JSON with name, brand, and nutrient information. Upon searching, the user is presented with a Table View which shows this information to the user who will tap on a food to add it to their nutrition history. The user is presented with an alert to let them know that it was added. The nutrition tab also allows for the user to view their nutrient consumption for today, and input meals manually.
### Weight Tracking Tab ###
The weight tab uses [iOS Charts] (https://github.com/danielgindi/Charts) to graph the user's weight over time so that they can see if they are reaching their bodyweight goals or not.
## In Development ##
The app is now on TestFlight, before I put it on the App Store. 
## Some Pictures ##
![alt-text](https://github.com/austinbailey1114/iOS/blob/master/Screenshots/image1.png)

![alt-text](https://github.com/austinbailey1114/iOS/blob/master/Screenshots/image2.png)

![alt-text](https://github.com/austinbailey1114/iOS/blob/master/Screenshots/image3.png)
