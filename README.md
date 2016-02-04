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

After successful login, the username is passed back to the server on most requests (instead of using some sort of session token) for simplicity. In a real app, I would expect the login service to return a token to be used in the headers (or bodies) of the subsequent API requests. The server would then be able to expire the session token for security.

Local data is stored in NSUserDefaults or flat files (JSON). My primary experience with local databases on iOS is with SQLite, but that felt like overkill for this project.

### Server side

I made no effort on the server side to secure anything. I also did very, very little in terms of exception handling. I tried to build the most basic REST service using PHP that met the minimum needs of this sample project and demonstrate some generally-accepted REST principles. All responses are either a simple HTTP status code or a JSON response object.



