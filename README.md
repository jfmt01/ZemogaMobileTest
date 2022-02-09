# Post It 🔖 (ZemogaMobileTest)
iOS 14+ Mobile App of posts and their respective description

# Do You Want Remember It? Post It 🔖

Post it is an application that shows a post list and allows the user to interact with it, doing actions like mark the post as read or favorite, delete all post or delete each one. For las the app allows you to reset your post list from the server through a refresh control (scroll down from the list top edge) on the main view.


# Let's Start 🏁✈️

Following you will find instructions to get a copy of the project and run it on your local machine for development and test porpouse. You will also find relevant information about the app flow and the development process.


## Requirements 📖🔍

```
 MacBook with Xcode installed on it (preferably the last version) 💻
```
## Instalation 💻🔨

1) Download or clone the project from the next link:
[Github Repository](https://github.com/jfmt01/ZemogaMobileTest)

2) Once downloaded, open a terminal in the project route where is the "Podfile"

3) Execute the next command:
```
Pod install
```

4) Open the project from the "ZemogaMobileTest.xcworkspace" file

5) You did it, now run it

# How does it work?🧐

1) When app begin it fetch all data from a cloud [Service](https://my-json-server.typicode.com/jfmt01/ZemogaJSONDB/posts)
2) The app storage the data in the device using a Realm Data Base
3) The main view is shown with a list of all posts fetched and marked as unread with a blue icon
4) There's a button in the view that allows you delete all posts in the local data of the device
5) Each post can be selected to view the decription, user information, comments, and allow you mark the post as a favorite post
6) Back in main view, the post opened will not have the blue unread icon and will be moved to the last position of the list
7) If you mark the selected post as favorite it will show you a star and will moved the post to the top position of the list
8) Now you can see only your favorite posts by tapping "Favorites" tab of the list
9) Scrolling from the right edge of each post you can delete them individually
10) Finally you can refresh the posts by scrolling down from the top edge of the list

NOTE: Dark mode and portrait view compatible.

# Builth With 🛠⚙️⌨️

## Xcode : IDE

Xcode is Apple's integrated development environment (IDE) for macOS, used to develop software for macOS, iOS, iPadOS, watchOS, and tvOS.

##  MVVM : Model - View - ViewModel

It's a software dessign pattern that allows you to separate the data data structure, bussiness logic and user interface controller, this translates in a more easy understanding code, reduce long code files, better maintainability, best workflow, easy group work, much simple testing and reliable design, widely used in the world of software development

## Observable : Data Binding

Is a way to connect the View Model and the View Controller, so the updates in UI are based on the change of the data in real time

## URLSession

The URLSession is a native class that allowS us to connect to an endpoint to download or upload data from and to the API through a series of common network tasks

## Realm : Data Base

Object Oriented database easy to usa and realiable. It was used to save local data(cache) on the device.

## NotificationBannerSwift
UI library used to implement custom banner notifications when needed


# License 📝
[Apache License](http://www.apache.org/licenses/) Version 2.0, January 2004

# Author ✍️
[Jeison Fernand Moreno Tovar](https://www.linkedin.com/feed/) iOS Dev


