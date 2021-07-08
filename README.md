FriendMe
===

# FriendMe

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description

FriendMe is a friend finder app that utilizes the API's of various user platforms to connect them to others with similar interests. Users will be able to connect their various accounts such as Twitter, Youtube, Spotify, and Steam, and apply weights to scale their significance in friend matching.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Social Media / Friend Finding
- **Mobile:** People would go to this app in empty pockets of their day. Lots of work to pull your computer out just for this. Easier to chat with people and better for UI. Could incorporate location.
- **Story:** App will provide users with a simple way to connect to people with similar interests. Gives them an opportunity to talk about their favorite shows, music and games. High value.
- **Market:** Large market. Attractive to kids 18 and under that want to meet others but do not have the ability to do so. Adults may not be as attracted but still caters to them.
- **Habit:** Users may not spend too much time on this app, but will go to it in empty spaces of the day. People may leave app to other messaging platforms after matching with someone.
- **Scope:** This app can be completed in 5 weeks and a stripped down version of it would not be bad. The only important thing are the integrations of the API's which may cause trouble since I want to do a couple platforms.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [] Log in/Sign Up
- [] Be able to connect to different platforms through their API's and access certain information
- [] Assign diffferent weights to connected platforms
- [] Present potential matches through a matching algorithm
- [] User can match with people
- [] Profiles for every user
* ...

**Optional Nice-to-have Stories**

- [] Chat with other users
- [] User can view things that are similar about them and their match
* ...

### 2. Screen Archetypes

* Log in
   * User is able to log in or go to sign up page
* Sign Up
    * User is able to make an account, inputting information about age and email
    * User is able to connect to other platforms and assign weights
* Matches page
   * User can view all potential matches filtered by the matching algorithm
   * User can click on math cell and view information about match, such as bio, and info about things they like through the connected platforms
   * User can view things that are similar about them and their match
   * User can view images of matches
   * User can save other users
* Platforms Page
    * User can connect more platforms to their profile
    * User can view all current connections, adjust weights, or disconnect them
* Profile
   * User can update bio, upload images, and see what is displayed to other users
* Chat
   * User can chat with matches
   * [Stretch user story]

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Platforms Page
* Matches Page
* Chat 
* Profile
* Seamless navigation, swipe to the right moves u to next tab

**Flow Navigation** (Screen to Screen)

* Matches Page
   * Click user cell to view user profile
* Platforms Page
   * Click button to add more connections

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/kE6J2Vk.png" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
