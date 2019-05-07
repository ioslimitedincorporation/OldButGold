# OldButGold

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
An iOS app which allows UCSD students to sell their used items or buy used items from others.


### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Shopping, Utilities, Lifestyle
- **Mobile:** Mobility is important because students may want to access the trading market on their iphone.
- **Story:** Allow users post about things they want to sell and scroll through and search for items they want. 
- **Market:** UCSD students who need to sell or buy used items. 
- **Habit:** User can get the habit of checking the app on their phone whenever they want to buy something.
- **Scope:** This app will target at UCSD students for now. In the future, it may be expanded to more campuses.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Make a post
* Provide a title for the post
* Provide a description for the post
* Provide a image for the post
* Provide a price for the post
* Prove contact infomartion 
* Show the posts in the home feed using tableView and scroll bar 
* allow pull to refresh 
* Search for the posts

**Optional Nice-to-have Stories**

* Login
* Logout
* Comment on the post
* Provide multiple images
* Sort by pricing
* Sort by name
* Sort by time
* Use API from facebook to add posts
* Add filters
* Options for grid and list

### 2. Screen Archetypes

* Home Screen
   * User can scroll and see all the item title on this screen.
   * User can search an item using keyword.
   * User can navigate to Post screen to post their item to sell.
   * User can navigate to Item screen to check the detail of an item.
   * User can pull to refresh the feeds.
* Post Screen
   * User can provide a title for the item.
   * User can provide an image for the item.
   * User can provide a description for the item.
   * User can provide a price for the item.
   * User can post the item to the feeds.
   * User can navigate back to Home screen.
* Item Screen
   * User can see the description of the item selected.
   * User can see the image of the item selected.
   * User can navigate back to Home screen.


### 3. Navigation

**Flow Navigation** (Screen to Screen)

* Home screen
   * Post screen
   * Item screen
* Post screen
   * Home screen
* Item screen
   * Home screen

## Wireframes
<img src="https://i.imgur.com/55hUhny.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype
https://marvelapp.com/4711cbd/screen/55948944

## Schema 
### Models
Object: Post

| Property | Type | Description |
| -------- | ---- | ------- |
| title | String | The title of the item |
| objectId | String | unique ID for the user's post |
| author | Pointer to user | The user that posted the item |
| image | File | The image that describes the post|
| description | String | The description for the item |

Object: User

| Property | Type | Description |
| -------- | ---- | ------- |
| userId | String | unique ID for the user |
| userName | String | name of the user |
| profilePic | File | Avatar |

### Networking

 1. Home Feed Screen
  - (Read/GET) Query all the item's titles from the database.
  ```
 let userID = Auth.auth().currentUser?.uid
ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
  // Get user value
  let value = snapshot.value as? NSDictionary
  let username = value?["username"] as? String ?? ""
  let user = User(username: username)

  // ...
  }) { (error) in
    print(error.localizedDescription)
}
```
 2. Item Screen
  - (Read/GET) Query the detail about the item selected.
```
 let userID = Auth.auth().currentUser?.uid
ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
  // Get user value
  let value = snapshot.value as? NSDictionary
  let username = value?["username"] as? String ?? ""
  let user = User(username: username)

  // ...
  }) { (error) in
    print(error.localizedDescription)
}
```

 3. Post Screen
  - (Create/POST) Post the new item as an author.

```
ref.child("users").child(user.uid).setValue(["username": username]) {
  (error:Error?, ref:DatabaseReference) in
  if let error = error {
    print("Data could not be saved: \(error).")
  } else {
    print("Data saved successfully!")
  }
}
```

- GIF Sprint 1

![Alt Text](https://media.giphy.com/media/jSDPuwAdIOT8FvVBRf/giphy.gif)


- [OPTIONAL: List endpoints if using existing API such as Yelp]
