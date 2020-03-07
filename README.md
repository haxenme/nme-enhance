# nme-enhance
Interface to the enhance.co mobile extensions



# Enhance Drag & Drop Library by Enhance, Inc.
# https://enhance.co/documentation
# 
# For Nme - Based on OpenFL source code

Setup
-----

Include the provided extension into your NME project. For example, you can do that by adding the following line to your project.xml file:

```xml
<haxelib nme="nme-enhance"/>
```

Interstitial Ads
----------------

Interstitial Ads are short static or video ads, usually shown between levels or when game is over. 


Example Usage:

```haxe
if (Enhance.isInterstitialReady()) {
    // The ad is ready, show it
    Enhance.showInterstitialAd();
}
```


Methods:

```haxe
Enhance.isInterstitialReady(
    ?placement:String = Enhance.PLACEMENT_DEFAULT
):Bool
```

Check if an interstitial ad from any of the included SDK providers is ready to be shown.
Placement is optional and specifies an internal placement (from the Enhance mediation editor). 
Returns true if any ad is ready, false otherwise.


```
Enhance.showInterstitialAd(
    ?placement:String = Enhance.PLACEMENT_DEFAULT
):Void
```

Display a new interstitial ad if any is currently available. The ad provider is selected based on your app's mediation settings. 
Placement is an optional internal placement (from the Enhance mediation editor).
Returns nothing.


Members:

```haxe
Enhance.PLACEMENT_DEFAULT:String
```

The default placement of ads, including interstitial ads.


Rewarded Ads
------------

Rewarded Ads are usually full-screen video ads which users can view to receive a reward inside the application, like an additional in-game currency or a health bonus.


Example Usage:


```haxe
// Callbacks:

var onRewardGranted = function(rewardType:String, rewardValue:Int) 
{ 
    if(rewardType == Enhance.REWARD_ITEM)
        _logOutput.writeLog("Reward granted (item)");

    else if(rewardType == Enhance.REWARD_COINS)
        _logOutput.writeLog("Reward granted (coins), value: " + rewardValue);
};

var onRewardDeclined = function() {
    _logOutput.writeLog("Reward declined");
};

var onRewardUnavailable = function() {
    _logOutput.writeLog("Reward unavailable");
};

if(Enhance.isRewardedAdReady()) {
    Enhance.showRewardedAd(onRewardGranted, onRewardDeclined, onRewardUnavailable);
}
```

Methods:

```haxe
Enhance.isRewardedAdReady(
    ?placement:String = Enhance.REWARDED_PLACEMENT_NEUTRAL
):Bool
```

Check if a rewarded ad from any of the included SDK providers is ready to be shown.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns true if any ad is ready, false otherwise.


```haxe
Enhance.showRewardedAd(
    ?placement:String = REWARDED_PLACEMENT_NEUTRAL,
    onRewardGrantedCallback:String->Int->Void,
    onRewardDeclinedCallback:Void->Void,
    onRewardUnavailableCallback:Void->Void
):Void
```

Display a new rewarded ad if any is currently available. The ad provider is selected based on your app's mediation settings.
Callbacks specify functions which are invoked when reward is granted, declined or unavailable.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns nothing.


Members:

```haxe
Enhance.REWARD_ITEM:String
```

The granted reward is a game-defined item.

```haxe
Enhance.REWARD_COINS:String
```

The granted reward is a specified number of coins.


Banner Ads
----------

Banner Ads are small sized ads displayed on the screen as a rectangle filled with content without interrupting the flow of the app.


Example Usage:

```haxe
// Toggle the banner ad

if (isBannerVisible) {
    Enhance.hideBannerAd();
    isBannerVisible = false;
}

else if (Enhance.isBannerAdReady()) {
    // The ad is ready, show it
    Enhance.showBannerAdWithPosition(Enhance.POSITION_TOP);
    isBannerVisible = true;
}
```

Methods:

```haxe
Enhance.isBannerAdReady(
    ?placement:String = Enhance.PLACEMENT_DEFAULT
):Bool
```

Check if a banner ad from any of the included SDK providers is ready to be shown.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns true if any ad is ready, false otherwise.


```haxe
Enhance.showBannerAdWithPosition(
    ?placement:String = Enhance.PLACEMENT_DEFAULT,
    ?position:Int = Enhance.POSITION_BOTTOM
):Void
```

Display a new banner ad if any is currently available. The ad provider is selected based on your app's mediation settings.
Position specifies the position of the ad on the screen.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns nothing.


```haxe
Enhance.hideBannerAd():Void
```

Hide the banner ad which is currently visible, if any.
Returns nothing.


Members:

```haxe
Enhance.PLACEMENT_DEFAULT:String
```

The default placement of ads, including banner ads.

```haxe
Enhance.POSITION_TOP:Int
```
The top of the screen, use to set banner ads position. 

```haxe
Enhance.POSITION_BOTTOM:Int
```

The bottom of the screen, use to set banner ads position.


Offer Walls
-----------

Offer Walls show full screen of real world offers (e.g. surveys), usually with a reward offered in return for a completion.


Example usage:

```haxe
var onCurrencyReceived = function(amount:Int) {
    writeLog ("Currency received: " + amount);
};

Enhance.setReceivedCurrencyCallback(onCurrencyReceived);

if(Enhance.isOfferwallReady()) {
    Enhance.showOfferwall();
}
```


Methods:

```haxe
Enhance.setReceivedCurrencyCallback(
    onCurrencyReceivedCallback:Int->Void
):Void
```

Specify the function which is called every time the user receives a reward from any offerwall. We recommend that you use this function at the beginning of your app’s logic to be sure the callback is ready as soon as an offerwall sends the reward. This could happen at different times, even right after your app starts! As a parameter, this action will receive an amount of the granted currency (int).
Returns nothing.


```haxe
Enhance.isOfferwallReady(
    ?placement:String = Enhance.PLACEMENT_DEFAULT
):Bool
```

Check if an offerwall from any of the included SDK providers is ready to be shown.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns true if any offerwall is ready, false otherwise.


```haxe
Enhance.showOfferwall(
    ?placement:String = Enhance.PLACEMENT_DEFAULT
):Void
```

Display a new offerwall if any is currently available. The offerwall provider is selected based on your app's mediation settings.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns nothing.


Members:

```haxe
Enhance.PLACEMENT_DEFAULT:String
```

The default placement of ads, including offer walls.


Special Offers
--------------

Special offers are real world offers (e.g. surveys). They are available through Enhance ZeroCode, but you can also request them manually from code.


Example Usage:

```haxe
if (Enhance.isSpecialOfferReady()) {
    // The offer is ready, show it
    Enhance.showSpecialOffer();
}
```


Methods:

```haxe
Enhance.isSpecialOfferReady(
    ?placement:String = Enhance.PLACEMENT_DEFAULT
):Bool
```

Check if a special offer from any of the included SDK providers is ready to be shown.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns true if any offer is ready, false otherwise.


```haxe
Enhance.showSpecialOffer(
    ?placement:String = Enhance.PLACEMENT_DEFAULT
):Void
```

Display a new special offer if any is currently available. The offer provider is selected based on your app's mediation settings.
Placement is an optional internal placement (from the Enhance mediation editor).
Returns nothing.


Members:

```haxe
Enhance.PLACEMENT_DEFAULT:String
```

The default placement of ads, including special offers.


Analytics
---------

The connector library allows you to send custom events to the hooked analytics networks.


Example Usage:

```haxe
Enhance.logEvent("game_over", "level", "1");
Enhance.logEvent("user_exit");
```


Methods:

```haxe
Enhance.logEvent(
    eventType:String,
    ?paramKey:String,
    ?paramValue:String
):Void
```

Send an event with an additional parameter (optional).


Local Notifications
-------------------

Local Notifications are reminders which show up on your screen after the app becomes inactive for a specific amount of time.


Example Usage:

```haxe
var onPermissionGranted = function() {
    // Success
    Enhance.enableLocalNotification("Game", "Play me!", 60);
};

var onPermissionRefused = function() {
    // Failure
};

Enhance.requestLocalNotificationPermission(onPermissionGranted, onPermissionRefused);
```


Methods:

```haxe
Enhance.requestLocalNotificationPermission(
    onPermissionGrantedCallback:Void->Void,
    onPermissionRefusedCallback:Void->Void
):Void
```

Request a permission from the user to show local notifications. This won't have any effect on Android devices as you don't need a permission to schedule local notifications there (onPermissionGrantedCallback will be still fired).
Returns nothing.


```haxe
Enhance.enableLocalNotification(
    title:String,
    message:String,
    delaySeconds:Int
):Void
```

Schedule a new local notification, if possible. The notification will persist until you disable it manually. For example, if you set a notification for 60 seconds, it will invoke this notification 60 seconds after the app is closed every time.
Returns nothing.


```haxe
Enhance.disableLocalNotification():Void
```

Disable any local notification that was previously enabled.


In-App Purchases
-------------------

The connector library provides a set of functions which help you to make use of different In-App Purchases SDKs in your application.


Example Usage:

```haxe
var onPurchaseSuccess = function() {
    var price:String = Enhance.purchases.getDisplayPrice("my_product", "$5");

    var title:String = Enhance.purchases.getDisplayTitle("my_product", "My Product");

    var desc:String  = Enhance.purchases.getDisplayDescription("my_product", "Some useful item.");
};

var onPurchaseFailed = function() {
    // Failure
};

if (Enhance.purchases.isSupported()) {
    Enhance.purchases.attemptPurchase("my_product", onPurchaseSuccess, onPurchaseFailed);
}
```


Methods:

```haxe
Enhance.purchases.isSupported():Bool
```

Check if the In-App Purchasing is currently available in your application.
Returns true if purchasing is available, false otherwise.


```haxe
Enhance.purchases.attemptPurchase(
    productName:String,
    onPurchaseSuccessCallback:Void->Void,
    onPurchaseFailedCallback:Void->Void
):Void
```

Start the purchase flow for the given product.
Product name is the reference name which you entered during the Enhance flow. 
Callbacks specify functions which are invoked when purchase is successful or not.
Returns nothing.


```haxe
Enhance.purchases.consume(
    productName:String,
    onConsumeSuccessCallback:Void->Void,
    onConsumeFailedCallback:Void->Void
):Void
```

Consume the given product, if applicable (depends on the SDK provider).
Product name is the reference name which you entered during the Enhance flow.
Callbacks specify functions which are invoked when consume is successful or not.
Returns nothing.


```haxe
Enhance.purchases.isItemOwned(
    productName:String
):Bool
```


Check if the given product is already owned. The result may be inaccurate, depending on whether the SDK provider stores the information about your products or not.
Product name is the reference name which you entered during the Enhance flow.
Returns true if the item is owned, false otherwise.


```haxe
Enhance.purchases.getOwnedItemCount(
    productName:String
):Int
```

Get a number of the given product that user owns, or 0 if none. The result may be inaccurate, depending on whether the SDK provider stores the information about your products or not.
Product name is the reference name which you entered during the Enhance flow.
Returns a number of the given product copies.


```haxe
Enhance.purchases.manuallyRestorePurchases(
    onRestoreSuccessCallback:Void->Void,
    onRestoreFailedCallback:Void->Void
):Void
```

Manually restore purchases and update the user's inventory, if applicable (availability of this feature depends on the SDK provider).
Callbacks specify functions which are invoked when restore is successful or not.
Returns nothing.


```haxe
Enhance.purchases.getDisplayPrice(
    productName:String,
    defaultPrice:String
):String
```

Get a localized display price of the given product, for example: "100zł", "100¥".
Product name is the reference name which you entered during the Enhance flow.
Default price will be used if a real one can't be fetched. 
Returns a string containing the localized display price.


```haxe
Enhance.purchases.getDisplayTitle(
    productName:String,
    defaultTitle:String
):String
```

Get a localized display title of the given product.
Product name is the reference name which you entered during the Enhance flow.
Default title will be used if a real one can't be fetched.
Returns a string containing the localized display title.


```haxe
Enhance.purchases.getDisplayDescription(
    productName:String,
    defaultDescription:String
):String 
```

Get a localized display description of the given product.
Product name is the reference name which you entered during the Enhance flow.
Default description will be used if a real one can't be fetched.
Returns a string containing the localized display description.


Demo Project
--------------

For a full implementation example, please see the demo project which can be found in the 'samples/demo' directory within the distribution package.


