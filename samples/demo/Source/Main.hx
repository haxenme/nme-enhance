/*
* Enhance NME Demo
* www.enhance.co
*/

package;

import nme.display.Sprite;
import nme.display.StageScaleMode;
import nme.events.Event;
import utils.Logo;
import utils.LogOutput;
import utils.Button;
import utils.Label;

class Main extends Sprite {
    public static var BASE_WIDTH:Int = 480;
    public static var BASE_HEIGHT:Int = 800;

    private var _logOutput:LogOutput;
    private var _label:Label;

    private var _hasLocalNotificationPermission:Bool = false;
    private var _isBannerAdShown:Bool = false;
    private var _productName:String = "Enhance_SKU_One";

    public function new () {
        super();

        addEventListener(Event.ADDED_TO_STAGE, addedToStage);
    }

    private function addedToStage(e:Event) {
        // Init

        stage.scaleMode = StageScaleMode.EXACT_FIT; 

        addChild(new Logo());
        addButtons();

        _label = new Label();
        addChild(_label);

        _logOutput = new LogOutput();
        addChild(_logOutput);

        // Request a permission to schedule local notifications

        Enhance.requestLocalNotificationPermission(onPermissionGranted, onPermissionRejected);

        // Set Offerwall callback

        Enhance.setReceivedCurrencyCallback(onCurrencyReceived);
    }

    private function addButtons() {
        // Create buttons to demonstrate Enhance features

        addChild( new Button(30, 140, "Show Interstitial Ad", onShowInterstitialAdClicked) );
        addChild( new Button(250, 140, "Show Special Offer", onShowSpecialOfferClicked) );
        addChild( new Button(30, 200, "Show Rewarded Ad", onShowRewardedAdClicked) );
        addChild( new Button(250, 200, "Log Analytics Event", onLogEventClicked) );
        addChild( new Button(30, 260, "Toggle Banner Ad", onToggleBannerAdClicked) );
        addChild( new Button(250, 260, "Enable\nLocal Notifications", onEnableLocalNotificationClicked) );
        addChild( new Button(30, 320, "Show Offerwall", onShowOfferwallClicked) );
        addChild( new Button(250, 320, "Disable\nLocal Notification", onDisableLocalNotificationClicked) );
        addChild( new Button(30, 380, "Purchase IAP", onPurchaseIAPClicked) );
        addChild( new Button(250, 380, "Consume IAP", onConsumeIAPClicked) );
        addChild( new Button(30, 440, "GDPR Opt-In", onGDPROptInClicked) );
        addChild( new Button(250, 440, "GDPR Opt-Out", onGDPROptOutClicked) );
        addChild( new Button(155, 500, "Show GDPR Dialogs", onGDPRShowDialogsClicked) );
    }

    // Interstitial Ad

    private function onShowInterstitialAdClicked() {
        // Show interstitial ad if available

        var isReady:Bool = Enhance.isInterstitialReady();

        if(!isReady) {
            _logOutput.writeLog("Interstitial ad is not ready");
            return;
        }

        Enhance.showInterstitialAd();
        _logOutput.writeLog("Showing interstitial ad");
    }

    // Rewarded Ad

    private function onShowRewardedAdClicked() {
        // Show rewarded ad if available

        var isReady:Bool = Enhance.isRewardedAdReady();

        if(!isReady) {
            _logOutput.writeLog("Rewarded ad is not ready");
            return;
        }

        var onRewardGranted = function(rewardType:String, rewardValue:Int) 
        { 
            // Reward is granted (user watched video for example)
            // You can check reward type

            if(rewardType == Enhance.REWARD_ITEM)
                _logOutput.writeLog("Reward granted (item)");
            else if(rewardType == Enhance.REWARD_COINS)
                _logOutput.writeLog("Reward granted (coins), value: " + rewardValue);
            else
                _logOutput.writeLog("Unknown reward granted");
        };

        var onRewardDeclined = function() { _logOutput.writeLog("Reward declined"); };

        var onRewardUnavailable = function() { _logOutput.writeLog("Reward unavailable"); };

        Enhance.showRewardedAd(onRewardGranted, onRewardDeclined, onRewardUnavailable);
        _logOutput.writeLog("Showing rewarded ad");
    }

    // Banner Ad

    private function onToggleBannerAdClicked() {
        // Check if the banner ad is already visible, then hide it

        if(_isBannerAdShown) {
            Enhance.hideBannerAd();
            _isBannerAdShown = false;
            _logOutput.writeLog("Hiding banner ad");
            return;
        }

        // Check whether any banner ad is available

        var isReady:Bool = Enhance.isBannerAdReady();

        if(!isReady) {
            _logOutput.writeLog("Banner ad is not ready");
            return;
        }

        // Display the banner

        Enhance.showBannerAdWithPosition(Enhance.POSITION_TOP);
        _isBannerAdShown = true;
        _logOutput.writeLog("Showing banner ad");
    }

    // Offerwall

    private function onShowOfferwallClicked() {
        // Show offer wall if available

        var isReady:Bool = Enhance.isOfferwallReady();

        if(!isReady) {
            _logOutput.writeLog("Offerwall is not ready");
            return;
        }

        Enhance.showOfferwall();
        _logOutput.writeLog("Showing offerwall");
    }

    private function onCurrencyReceived(amount:Int) {
        _logOutput.writeLog("Currency received: " + amount);
    }

    // Special Offer

    private function onShowSpecialOfferClicked() {
        // Show special offer is available

        var isReady:Bool = Enhance.isSpecialOfferReady();

        if(!isReady) {
            _logOutput.writeLog("Special offer is not ready");
            return;
        }

        Enhance.showSpecialOffer();
        _logOutput.writeLog("Showing special offer");
    }

    // Analytics

    private function onLogEventClicked() {
        // Send an event to analytics network (e.g. Google Analytics)

        // Simple event:
        Enhance.logEvent("event_type");

        // Event with an additional parameter:
        Enhance.logEvent("event_type", "event_param_key", "event_param_value");

        _logOutput.writeLog("Sent analytics event");
    }

    // Local Notification

    private function onPermissionGranted() {
        _hasLocalNotificationPermission = true;
    }

    private function onPermissionRejected() {
        _hasLocalNotificationPermission = false;
    }

    private function onEnableLocalNotificationClicked() {
        // Schedule a new local notification if permission is granted

        if(!_hasLocalNotificationPermission) {
            _logOutput.writeLog("Permission is not granted");
            return;
        }

        Enhance.enableLocalNotification("Enhance", "Local Notification!", 5);
        _logOutput.writeLog("Enabled local notification");
    }

    private function onDisableLocalNotificationClicked() {
        // Cancel any local notification

        if(!_hasLocalNotificationPermission) {
            _logOutput.writeLog("Permission is not granted");
            return;
        }

        Enhance.disableLocalNotification();
        _logOutput.writeLog("Disabled local notification");
    }

    // In-App Purchases

    private function onPurchaseIAPClicked() {
        // Attempt purchase

        Enhance.purchases.attemptPurchase(_productName, onPurchaseSuccess, onPurchaseFailed);
        _logOutput.writeLog("Attempting purchase");
    }

    private function onPurchaseSuccess() {
        updateIAPLabel();
        _logOutput.writeLog("Purchase success");
    }

    private function onPurchaseFailed() {
        _logOutput.writeLog("Purchase failed");
    }

    private function onConsumeIAPClicked() {
        // Try to consume

        Enhance.purchases.consume(_productName, onConsumeSuccess, onConsumeFailed);
        _logOutput.writeLog("Attempting consume");
    }

    private function onConsumeSuccess() {
        updateIAPLabel();
        _logOutput.writeLog("Consume success");
    }

    private function onConsumeFailed() {
        _logOutput.writeLog("Consume failed");
    }

    private function updateIAPLabel() {
        var title:String = Enhance.purchases.getDisplayTitle(_productName, "Default Title");
        var price:String = Enhance.purchases.getDisplayPrice(_productName, "Default Price");
        var quantity:Int = Enhance.purchases.getOwnedItemCount(_productName);

        _label.update(title + " - " + price + " - Qty: " + quantity);
    }

    // GDPR

    private function onGDPROptInClicked() {
        Enhance.serviceTermsOptIn();
        _logOutput.writeLog("Called explicit opt-in");
    }

    private function onGDPROptOutClicked() {
        Enhance.serviceTermsOptOut();
        _logOutput.writeLog("Called explicit opt-out");
    }

    private function onGDPRShowDialogsClicked() {
        Enhance.requiresDataConsentOptIn(onServiceOptInRequirement);
    }

    private function onServiceOptInRequirement(isOptInRequired:Bool) {
        if(isOptInRequired) {
            Enhance.showServiceOptInDialogs(onDialogsComplete);
        }
    }

    private function onDialogsComplete() {
        _logOutput.writeLog("Finished displaying opt-in dialogs");
    }
}
