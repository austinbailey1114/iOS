# iOS
## Features ##
This repository is an iOS app for a user to track their weight lifting progress, nutrition, and bodyweight over time. 
The app has 4 tabs. One for adding and tracking lifts, one for adding and tracking meals, one for showing graphs that show
weightlifting progress over time to the user, and one that is currently miscellaneous.
### Lift Tab ###
The lift tab is for logging a new lift, and contains a segue to a table view of the users lift history.
The tab also shows the users most recent one rep max calculation for squats, deadlifts, and bench press. The users lift history
will still display lifts other than those three. All lifts are saved in CoreData.
### Nutrition Tab ###
The nutrition tab temporarily contains text fields for the user to input data about a food they've eaten. The user can also 
view a table view of their nutrition history. Also, there is a "Choose From Saved Meals" button that allows the user to look
at saved meals (meals are saved when they are input into the users nutrition history for the first time) and tap on a meal to add 
it to their meal history. Users' nutrition history is also stored in CoreData.
### Progress Tab ###
The progress tab uses [iOS Charts] (https://github.com/danielgindi/Charts) to graph the user's lifting progress over time for
squat, deadlift and bench press, to let them see their progress visually. In development is a graph to show the users changes in body weight over time.
### More Tab ### 
At the moment, the more tab does not have any functions, but it will be the place for the user to update their bodyweight,
change their height, etc.
## In Development ##
I am currently working on changing the nutrition tab to allow the user to search for foods stored in a nutrition database using
REST calls. This way, the user will not have to look at their food for nutrition facts and manually input it. 
## Some Pictures ##
![alt-text](https://github.com/austinbailey1114/iOS/blob/master/Screenshots/LiftTab.png)

This tab is the main tab for entering and saving lifts. Pressing "View Lift History" leads to the following:
![alt-text](https://github.com/austinbailey1114/iOS/blob/master/Screenshots/Lift%20History.png)

The progress tab shows graphs of the user's progress with the three main lifts over time:
![alt-text](https://github.com/austinbailey1114/iOS/blob/master/Screenshots/Screen%20Shot%202017-08-12%20at%202.55.47%20PM.png)
