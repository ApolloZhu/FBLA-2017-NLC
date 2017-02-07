![icon](https://raw.githubusercontent.com/ApolloZhu/FBLA-2017-NLC/master/Images/Icon.png?token=AKVyPI2mLv7cUUk1X6NTe1n5Yjzek7Ifks5YowFJwA%3D%3D)
# FBLA 2017 NLC
Mobile Application Development

## Installation Guide
Due to the closed nature of Apple and iOS, you are not able to install the compiled binary directly on your iOS devices. We strongly suggest you use the following method to download the app on to your iOS devices.

## Note that the following processes have to be operated on an ios device.
1. Make sure you have your Apple ID, the e-mail account you used for iCloud, downloading apps from App Store, or in iTunes.
2. Email the Apple ID to [public-apollonian@outlook.com](mailto:public-apollonian@outlook.com)
3. You will soon receive an email from iTunes Connect
4. Provide the information needed to setup an iTunes Connect account.
6. Another email from TestFlight will be sent to your address 
7. StartTesting - install TestFlight - if asked, enter the redeem code given 
8. Download and install our application "Charity Toaster"

---

# Test Instruction

## Login
To use certain features, you need to register or login your account. We'll prompt you to do so when needed.

You are welcomed to create new accounts, but we have some sample accounts available

|     e-mail     |password|
|:--------------:|:------:|
|text@example.com| 123456 |
|test@example.com| 123456 |

## How to purchase an item?
Becuase we don't have certificates and other legal documents, we are not able to enable real transaction. But you can try out sandbox purchases. 

### Paypal
You don't need to use your paypal account, you'll be automatically using the sample account. 

### Visa
To purchase using visa card, please use the sample card provided blow

|Visa Number|Expiration Date|
|:--:|:--:|
|4111 1111 1111 1111|11/19|

## How to share an item to your social media platform?

1. select an item  
- click on the icon on the top right corner
- select the social media platform you wish to use  
- post

## How to toggle settings and other features?

The setting menu is can be toggled using the button located on the top left of the home page. You can find the followings here

- account settings
- messages/notifications
- other account related information
- language settings
- cache cleaning button
- about us
- acknowledgement page

--- 

# Developer's Note

**Please open `FBLA.xcworkspace` instead of `FBLA.xcodeproj`**, we are managing dependencies through CocoaPods

Because all the database and transaction providers uniquely identifies each app to make sure everything is safe, you can not change the team, and the account used to codesign the entire project. Therefore, you have to have our account to compile. We rather consider it an unsafe behavior to share our private key around. In conclusion, you might be able to compile it, but you will not get the same result as what we get after compilation.
