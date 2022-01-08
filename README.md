# Meteors

A simple iOS app that displays a list of fallen meteors on Earth driven by data from NASA API

Built using XCode 13.1 (13A1030d) (Swift 5) 

Deployment target: iOS 14

## In this app you can:
1. See a list of all the fallen meteors on Earth from 1900
2. Sort them by date and size
3. Select a meteor to see its details. Specifically, a map view with a pin that indicates the location of the fallen meteor and by tapping on the pin more information is shown (coordinates, date, mass, fall, type and class)
5. Choose your favorite meteors 
6. See a list of your favorite meteors
7. Pull down on the list of meteors/favorites to refresh the data

## How to run the app?
1. Clone this repo
2. Open Meteors.xcodeproj and run the project on selected device or simulator

## App structure and architecture
The base architecture is MVVM in which the view controllers use the view models bindings to react to data changes
