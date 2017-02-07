![Charity Toaster Icon](https://raw.githubusercontent.com/ApolloZhu/FBLA-2017-NLC/master/Images/Icon.png?token=AKVyPI2mLv7cUUk1X6NTe1n5Yjzek7Ifks5YowFJwA%3D%3D)

# Charity Toaster
Mobile Application Development

Oakton High School

FBLA 2017

## System Requirements

||Requirements|
|:--:|:--:|
|Minimum System Version|iOS 8|
|Network Access|Yes|

---

# Installation Guide
Due to the closed nature of Apple and iOS, you are not able to install the compiled binary directly on your iOS devices. We strongly suggest you use the following method to download the app on to your iOS devices.

> This process actually requires human process behind the scene at some point, so it might take longer than you expect.

1. Make sure you have your Apple ID, the e-mail account you used for iCloud, downloading apps from App Store, or in iTunes.
2. Email the Apple ID to [public-apollonian@outlook.com](mailto:public-apollonian@outlook.com)
3. You will soon receive an email from **iTunes Connect**
4. Provide the information needed to setup an iTunes Connect account
5. Another email from **Test Flight** will be sent to your Apple ID email. We strongly suggest you to open it on your iOS device(s)
6. Click Start Testing in the email
7. If you are on an iOS device, the webpage will redirect you to app store to install TestFlight
8. Open TestFlight. Tap redeem, and enter the redeem code given.
9. Download/Install/Update *Charity Toaster*

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

1. Make sure you are on a page for any item
2. Click on the share icon on the top right corner, or left corner if you are in an right to left language
3. Select the social media platform you wish to use  
4. Comment, and post!

## How to toggle settings and other features?

The setting menu can be toggled, using the hamburger-like button, which is located on the top left of the home page. 
The following features can be found here --

- Account settings
- Messages/notifications
- Other account related information
- Language settings
- Cache cleaning button
- About us information
- Acknowledgements page


## How to donate an item?
- Go to the Donate page
- Fill out the item name, condition, photo, price, and other details
- Once you fill out all the requirements, the **done** button should appear at the bottom
- The item you want to donate should now displayed on the home page ready for purchase

## How to use the Search/Filter feature
- Type in the name of the item you are looking for
- Apply filter by tapping the filter icon located on the left of the search box
- Click on the search button
- All items that fit your requirements should be displayed if they are available

--- 

# Developer's Note

**Please open `FBLA.xcworkspace` instead of `FBLA.xcodeproj`**, we are managing dependencies through CocoaPods

Because all the database and transaction providers uniquely identifies each app to make sure everything is safe, you can not change the team, and the account used to codesign the entire project. Therefore, you have to have our account to compile. We rather consider it an unsafe behavior to share our private key around. In conclusion, you might be able to compile it, but you will not get the same result as what we get after compilation.

## Team Members

- @ApolloZhu
- @Yanderella
- @mmk4822

Special thanks to Seonuk Kim for translating our app to Korean
