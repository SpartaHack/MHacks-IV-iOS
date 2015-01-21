SpartaHack-iOS
===========

Official iOS App for SpartaHack, forked from MHacks-IV forked from HShacks

To build this, you'll need to make a file in .../MHacks-iOS/MHacks called appKeys.plist with the following fields:

* parseAppId
* parseClientKey
* twitterConsumerKey
* twitterConsumerSecret


How to build
----
* You need to have cocoapods installed, and build the project with the following pods: 

+ 'Parse', '~> 1.6.0'
+ 'Facebook-iOS-SDK', '~> 3.21.1'
+ 'ParseFacebookUtils', '~> 1.6.0'