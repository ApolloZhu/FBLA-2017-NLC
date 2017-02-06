# FBLA 2017 NLC
Mobile Application Development

## Installation Guide
Due to the closed nature of Apple and iOS, you are not able to install the compiled binary directly on your iOS devices. We strongly suggest you use the following method to download the app on to your iOS devices.

## Note that the following processes have to be operated on an ios device.
1. Setup a working iTunes account 
2. Email the ITUNES ACCOUNT info to public-apollonian@outlook.com
3. You will soon receive an email from iTunes Connect
4. Provide the information needed to setup an iTunes Connect account.
6. Another email from TestFlight will be sent to your address 
7. StartTesting - install TestFlight - if asked, enter the redeem code given 
8. Download and install our application "Charity Toaster"

---

# Test Instruction
You may need an account to enable certain features. We will prompt you to create one when needed. 

We have two sample accounts setup for debugging, you are weclomed to use them:
text@example.com and test@example.com, both with password 123456

## Purchase
To purchase an item, please use the visa card number below:

VISA number: 4111 1111 1111 1111

Expiration: 11/19

## How to share an item to your social media platform

1. select an item  
- click on the icon on the top right corner
- select the social media platform you wish to use  
- post

## How to toggle settings and other features

The setting menu is located on the top left of the screen. Below are the features implemented: 

- language settings

- messages/notifications

- about us/acknowledgement page

- personal settings

--- 

# Developer's Note

**Please open `FBLA.xcworkspace` instead of `FBLA.xcodeproj`**

Because all the database and transaction providers uniquely identifies each app to make sure everything is safe, you can not change the team, and the account used to codesign the entire project. Therefore, you have to have our account to compile. We rather consider it an unsafe behavior to share our private key around. In conclusion, you might be able to compile it, but you will not get the same result as what we get after compilation.
