# Setup instructions

* Install XCode
* Install carthage https://github.com/Carthage/Carthage#installing-carthage
* In terminal open up the project folder (the one that containts the Personio.xcodeproj file)
* run the command carthage bootstrap --use-xcframeworks --platform iOS
* Open up Personio.xcodeproj in XCode
** Highlight "Personio" in the left panel
** highlight the "Personio" target
** Notice the "Frameworks, Libraries and Embedded Content" section
![alt text](/Images/xcode_screenshot.png)
* Open up the folder "Carthage/Build" from your project folder
* Delete the items from the "Frameworks, Libraries and Embedded Content" section
* Drag each folder that's name ends in ".xcframework" into the "Frameworks, Libraries and Embedded Content" section
* Press play to run the project

# UX work
I skethced out the following for the project:
![alt text](/Images/personion_ux_sketches.jpeg)



