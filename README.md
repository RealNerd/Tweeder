# Tweeder

Tweeder is a simple iOS project demonstrating some general concepts that might be found in an app similar to the Twitter app. The primary goals were to demonstrate the following ideas:

- Account creation and login
- Displaying a list of _tweets_ or messages made by the current user
- Refreshing the list with *only* tweets that have not been fetched from the server before
- Posting a new tweet

## Architecture

Perhaps a little overkill, but to demonstrate the feature of only requesting new *tweets*, I did build a back-end service and included the code for it in this repo. This allows me to demonstrate much of the core skillset that I have used in the past four years of iOS development which have focused heavily on REST-based services and networking in iOS using AFNetworking.

## Overall Development Choices Made

### Client side

I made some very simplified technical design decisions while building this sample app. First off, most of the unit tests are very simplistic and test the *happy path* in most cases. The API layer doesn't make a great effort to notify the user of truly exceptional failures such as network timeouts and has absolutely no handling of offline mode.

The majority of my work is focused on the functional aspects of the app. I didn't spend a lot of time thinking about the cell layout in the main tableview, nor did I try to develop an overal layout theme. I did try to make it look at least presentable, though, while focusing primarily on the core functionality.

After successful login, the username is passed back to the server on most requests (instead of using some sort of session token) for simplicity. In a real app, I would expect the login service to return a token to be used in the headers (or bodies) of the subsequent API requests. The server would then be able to expire the session token for security.

Local data is stored in NSUserDefaults or flat files (JSON). My primary experience with local databases on iOS is with SQLite, but that felt like overkill for this project.

This project uses two libraries that I've used in the past:
- AFNetworking
- IQKeyboardManager

Both are included as Podfiles, so to build, you must first `pod install`. I did not include all of the Pod/* files in the repo, just the *Podfile* itself. I am using *pod* version 0.39.0.

AFNetworking provides the core networking functionality for the API calls I make. It handles JSON deserialization from the server. I used very basic AFNetworking in this project, but have developed many projects with many more advanced features.

IQKeyboardManager helps manage scrolling when the keyboard appears. I use this frequently to minimize the boilerplate code required for to ensure that input fields aren't hidden under the keyboard.

I built the app to work in all standard orientations on both iPhone and iPad.

Pull to refresh is enabled on the tableview. Try running the app on two devices with the same account, then post from one device and pull to refresh on the other. Fun!

### Testing

I have included some unit/integration tests for this project that test the basics of the API. This is the area in which I have the most experience writing tests. I did not include any UI tests as I have not used Xcode 7's UI testing, yet.

### Server side

I made no effort on the server side to secure anything. I also did very, very little in terms of exception handling. I tried to build the most basic REST service using PHP that met the minimum needs of this sample project and demonstrate some generally-accepted REST principles. All responses are either a simple HTTP status code or a JSON response object.

I have deployed the API code to a public server, so there is no need to actually set up a new API server to test this project.

### Other notes

I do not have permission to use the image for the icon.



