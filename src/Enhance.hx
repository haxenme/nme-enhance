package;

#if (cpp && mobile && !android)
    #if (openfl < "4.0.0")
    import cpp.Lib as CPPLoader;
    #else
    import lime.system.CFFI as CPPLoader;
    #end
#end

#if android
    #if (openfl < "4.0.0")
    import openfl.utils.JNI;
    #else
    import lime.system.JNI;
    #end
#end

class Enhance 
{
    public static inline var PLACEMENT_DEFAULT:String = "default";

    public static inline var REWARDED_PLACEMENT_DEFAULT:String = "neutral";
    public static inline var REWARDED_PLACEMENT_SUCCESS:String = "success";
    public static inline var REWARDED_PLACEMENT_NEUTRAL:String = "neutral";
    public static inline var REWARDED_PLACEMENT_HELPER:String  = "helper";

    public static inline var REWARD_ITEM:String = "item";
    public static inline var REWARD_COINS:String = "coins";

    public static inline var POSITION_TOP:Int = 0;
    public static inline var POSITION_BOTTOM:Int = 1;

    private static inline var _EXTENSION_PATH:String = "org.haxe.extension.EnhanceBridge";
    private static inline var _EXTENSION_NS:String = "enhance";

    private static var _instance:Enhance = null;
    private static var _initialized:Bool = false;

    private static var _onRewardGrantedCallback:String->Int->Void = null;
    private static var _onRewardDeclinedCallback:Void->Void = null;
    private static var _onRewardUnavailableCallback:Void->Void = null;
    private static var _onCurrencyReceivedCallback:Int->Void = null;
    private static var _onPermissionGrantedCallback:Void->Void = null;
    private static var _onPermissionRejectedCallback:Void->Void = null;
    private static var _onServiceOptInRequirementCallback:Bool->Void = null;
    private static var _onDialogsCompleteCallback:Void->Void = null;

    /** Use this object to access Enhance In-App Purchases support **/
    public static var purchases(get, null):EnhanceInAppPurchases = null;

    private static inline var IOS_EVENT_REWARD_GRANTED:String = "REWARD_GRANTED";
    private static inline var IOS_EVENT_REWARD_DECLINED:String = "REWARD_DECLINED";
    private static inline var IOS_EVENT_REWARD_UNAVAILABLE:String = "REWARD_UNAVAILABLE";
    private static inline var IOS_EVENT_CURRENCY_GRANTED:String = "CURRENCY_GRANTED";
    private static inline var IOS_EVENT_PERMISSION_GRANTED:String = "PERMISSION_GRANTED";
    private static inline var IOS_EVENT_PERMISSION_REFUSED:String = "PERMISSION_REFUSED";
    private static inline var IOS_EVENT_PURCHASE_SUCCESS:String = "PURCHASE_SUCCESS";
    private static inline var IOS_EVENT_PURCHASE_FAILED:String = "PURCHASE_FAILED";
    private static inline var IOS_EVENT_CONSUME_SUCCESS:String = "CONSUME_SUCCESS";
    private static inline var IOS_EVENT_CONSUME_FAILED:String = "CONSUME_FAILED";
    private static inline var IOS_EVENT_RESTORE_SUCCESS:String = "RESTORE_SUCCESS";
    private static inline var IOS_EVENT_RESTORE_FAILED:String = "RESTORE_FAILED";
    private static inline var IOS_EVENT_USER_OPT_IN_REQUIRED:String = "USER_OPT_IN_REQUIRED";
    private static inline var IOS_EVENT_USER_OPT_IN_NOT_REQUIRED:String = "USER_OPT_IN_NOT_REQUIRED";
    private static inline var IOS_EVENT_OPT_IN_DIALOG_COMPLETE:String = "OPT_IN_DIALOG_COMPLETE";

    public function new() {}

    private static function init():Void
    {
        if(_initialized) return;

        _initialized = true;
        _instance = new Enhance();

        #if android
        android_init(_instance);
        #end

        #if (cpp && mobile && !android)
        ios_init(handleEventIOS);
        #end
    }

    @:dox(hide)
    public static function get_purchases():EnhanceInAppPurchases
    {
        if(!_initialized) init();

        if(purchases == null) purchases = new EnhanceInAppPurchases();
        return purchases;
    }

    private static function handleEventIOS(eventData:Dynamic):Void
    {
        #if (cpp && mobile && !android)
        if(_instance == null) return;

        var type:String = Std.string(Reflect.field(eventData, "type"));

        if(type == IOS_EVENT_REWARD_GRANTED)
        {
            var rewardValue:Int = Std.int(Reflect.field(eventData, "rewardValue"));
            var rewardType:String = Std.string(Reflect.field(eventData, "rewardType"));

            _instance.onRewardGranted(rewardType, rewardValue);
        }

        else if(type == IOS_EVENT_REWARD_DECLINED)
        {
            _instance.onRewardDeclined();
        }

        else if(type == IOS_EVENT_REWARD_UNAVAILABLE)
        {
            _instance.onRewardUnavailable();
        }

        else if(type == IOS_EVENT_CURRENCY_GRANTED)
        {
            var currencyAmount:Int = Std.int(Reflect.field(eventData, "currencyAmount"));
            _instance.onCurrencyGranted(currencyAmount);
        }

        else if(type == IOS_EVENT_PERMISSION_GRANTED)
        {
            _instance.onPermissionGranted();
        }

        else if(type == IOS_EVENT_PERMISSION_REFUSED)
        {
            _instance.onPermissionRefused();
        }

        else if(type == IOS_EVENT_PURCHASE_SUCCESS)
        {
            _instance.onPurchaseSuccess();
        }

        else if(type == IOS_EVENT_PURCHASE_FAILED)
        {
            _instance.onPurchaseFailed();
        }

        else if(type == IOS_EVENT_CONSUME_SUCCESS)
        {
            _instance.onConsumeSuccess();
        }

        else if(type == IOS_EVENT_CONSUME_FAILED)
        {
            _instance.onConsumeFailed();
        }

        else if(type == IOS_EVENT_RESTORE_SUCCESS)
        {
            _instance.onRestoreSuccess();
        }

        else if(type == IOS_EVENT_RESTORE_FAILED)
        {
            _instance.onRestoreFailed();
        }

        else if(type == IOS_EVENT_USER_OPT_IN_REQUIRED)
        {
            _instance.onServiceOptInRequirement(true);
        }

        else if(type == IOS_EVENT_USER_OPT_IN_NOT_REQUIRED)
        {
            _instance.onServiceOptInRequirement(false);
        }

        else if(type == IOS_EVENT_OPT_IN_DIALOG_COMPLETE)
        {
            _instance.onDialogComplete();
        }
        #end
    }

    /**
        Check if an interstitial ad is ready to be shown.
    
        @param placement ad placement (optional)
        
        @example
        if(Enhance.isInterstitialReady()) doSomething();
        
        @example
        if(Enhance.isInterstitialReady("my_placement")) doSomething();
    **/

    public static function isInterstitialReady(?placement:String = PLACEMENT_DEFAULT):Bool
    {
        if(!_initialized) init();

        var result:Bool = false;

        #if android
        result = android_isInterstitialReady(placement);
        #end

        #if (cpp && mobile && !android)
        result = ios_isInterstitialReady(placement);
        #end

        return result;
    }

    @:dox(hide)
    public static function isInterstitialAdReady(?placement = PLACEMENT_DEFAULT):Bool
    {
        return isInterstitialReady(placement);
    }

    /**
        Try to show an interstitial ad.
        
        @param placement ad placement (optional)
        
        @example
        if(Enhance.isInterstitialReady()) Enhance.showInterstitialAd();
    
        @example
        Enhance.showInterstitialAd("my_placement");
    **/

    public static function showInterstitialAd(?placement:String = PLACEMENT_DEFAULT):Void
    {
        if(!_initialized) init();

        #if android
        android_showInterstitialAd(placement);
        #end

        #if (cpp && mobile && !android)
        ios_showInterstitialAd(placement);
        #end
    }

    /**
        Check if a rewarded ad is ready to be shown.

        @param placement ad placement (optional)

        @example
        if(Enhance.isRewardedAdReady()) doSomething();

        @example
        if(Enhance.isRewardedAdReady(Enhance.REWARDED_AD_PLACEMENT_SUCCESS)) doSomething();
    **/

    public static function isRewardedAdReady(?placement:String = REWARDED_PLACEMENT_DEFAULT):Bool
    {
        if(!_initialized) init();

        var result:Bool = false;

        #if android
        result = android_isRewardedAdReady(placement);
        #end

        #if (cpp && mobile && !android)
        result = ios_isRewardedAdReady(placement);
        #end

        return result;
    }

    /**
        Try to show a rewarded ad.

        @param placement ad placement (optional)
        @param onRewardGrantedCallback function to be triggered after the ad is granted
        @param onRewardDeclinedCallback function to be triggered after the ad is declined
        @param onRewardUnavailableCallback function to be triggered after the ad is unavailable

        @example 
        Enhance.showRewardedAd(onRewardGranted, onRewardDeclined, onRewardUnavailable);

        @example
        Enhance.showRewardedAd("my_placement", onRewardGranted, onRewardDeclined, onRewardUnavailable);
    **/

    public static function showRewardedAd(?placement:String = REWARDED_PLACEMENT_DEFAULT, onRewardGrantedCallback:String->Int->Void, onRewardDeclinedCallback:Void->Void, onRewardUnavailableCallback:Void->Void):Void
    {
        if(!_initialized) init();

        _onRewardGrantedCallback = onRewardGrantedCallback;
        _onRewardDeclinedCallback = onRewardDeclinedCallback;
        _onRewardUnavailableCallback = onRewardUnavailableCallback;

        #if android
        android_showRewardedAd(placement);
        #end

        #if (cpp && mobile && !android)
        ios_showRewardedAd(placement);
        #end
    }

    /**
        Check if a banner ad is ready to be shown.

        @param placement ad placement (optional)

        @example
        if(Enhance.isBannerAdReady()) doSomething();

        @example
        if(Enhance.isBannerAdReady("my_placement")) doSomething();
    **/

    public static function isBannerAdReady(?placement:String = PLACEMENT_DEFAULT):Bool
    {
        if(!_initialized) init();

        var result:Bool = false;

        #if android
        result = android_isBannerAdReady(placement);
        #end

        #if (cpp && mobile && !android)
        result = ios_isBannerAdReady(placement);
        #end

        return result;
    }

    /**
        Try to show a banner ad with position.

        @param placement ad placement (optional)
        @param position ad position

        @example
        Enhance.showBannerAdWithPosition(Enhance.POSITION_TOP);

        @example
        Enhance.showBannerAdWithPosition("my_placement", Enhance.POSITION_BOTTOM);
    **/

    public static function showBannerAdWithPosition(?placement:String = PLACEMENT_DEFAULT, ?position:Int = POSITION_BOTTOM):Void
    {
        if(!_initialized) init();

        var positionStr = "bottom";
        if(position == POSITION_TOP) positionStr = "top";

        #if android
        android_showBannerAdWithPosition(placement, positionStr);
        #end

        #if (cpp && mobile && !android)
        ios_showBannerAdWithPosition(placement, positionStr);
        #end
    }

    /**
        Hide a banner ad, if any is visible.

        @example
        Enhance.hideBannerAd();
    **/

    public static function hideBannerAd():Void
    {
        if(!_initialized) init();

        #if android
        android_hideBannerAd();
        #end

        #if (cpp && mobile && !android)
        ios_hideBannerAd();
        #end
    }

    /**
        Check if a special offer is ready to be shown.

        @param placement ad placement (optional)

        @example
        if(Enhance.isSpecialOfferReady()) doSomething();

        @example
        if(Enhance.isSpecialOfferReady("my_placement")) doSomething();
    **/

    public static function isSpecialOfferReady(?placement:String = PLACEMENT_DEFAULT):Bool
    {
        if(!_initialized) init();

        var result:Bool = false;

        #if android
        result = android_isSpecialOfferReady(placement);
        #end

        #if (cpp && mobile && !android)
        result = ios_isSpecialOfferReady(placement);
        #end

        return result;
    }

    /**
        Try to show a special offer.

        @param placement ad placement (optional)

        @example
        Enhance.showSpecialOffer();

        @example
        if(Enhance.isSpecialOfferReady("my_placement")) Enhance.showSpecialOffer("my_placement");
    **/

    public static function showSpecialOffer(?placement:String = PLACEMENT_DEFAULT):Void
    {
        if(!_initialized) init();

        #if android
        android_showSpecialOffer(placement);
        #end

        #if (cpp && mobile && !android)
        ios_showSpecialOffer(placement);
        #end
    }

    /**
        Check if an offerwall is ready to be shown.

        @param placement ad placement (optional)

        @example
        if(Enhance.isOfferwallReady()) doSomething();

        @example
        if(Enhance.isOfferwallReady("my_placement")) doSomething();
    **/

    public static function isOfferwallReady(?placement:String = PLACEMENT_DEFAULT):Bool
    {
        if(!_initialized) init();

        var result:Bool = false;

        #if android
        result = android_isOfferwallReady(placement);
        #end

        #if (cpp && mobile && !android)
        result = ios_isOfferwallReady(placement);
        #end

        return result;
    }

    /**
        Try to show an offerwall.

        @param placement ad placement (optional)

        @example
        Enhance.showOfferwall();

        @example
        if(Enhance.isOfferwallReady()) Enhance.showOfferwall();
    **/

    public static function showOfferwall(?placement:String = PLACEMENT_DEFAULT):Void
    {
        if(!_initialized) init();

        #if android
        android_showOfferwall(placement);
        #end

        #if (cpp && mobile && !android)
        ios_showOfferwall(placement);
        #end
    }

    /**
        Set the callback to be triggered when currency is received from an offerwall.

        @param onCurrencyReceivedCallback function to be triggered

        @example
        Enhance.setReceivedCurrencyCallback(onCurrencyReceived);
    **/

    public static function setReceivedCurrencyCallback(onCurrencyReceivedCallback:Int->Void):Void
    {
        if(!_initialized) init();

        _onCurrencyReceivedCallback = onCurrencyReceivedCallback;
    }

    /**
        Request a permission to schedule local notifications.

        @param onPermissionGrantedCallback function to be triggered when permission is granted
        @param onPermissionRejectedCallback function to be triggered when permission is rejected

        @example
        Enhance.requestLocalNotificationPermission(onPermissionGranted, onPermissionRejected);
    **/

    public static function requestLocalNotificationPermission(onPermissionGrantedCallback:Void->Void, onPermissionRejectedCallback:Void->Void):Void
    {
        if(!_initialized) init();

        _onPermissionGrantedCallback = onPermissionGrantedCallback;
        _onPermissionRejectedCallback = onPermissionRejectedCallback;

        #if android
        android_requestLocalNotificationPermission();
        #end

        #if (cpp && mobile && !android)
        ios_requestLocalNotificationPermission();
        #end
    }

    /**
        Enable a new local notification.

        @param title title of the notification
        @param message message of the notification
        @param delaySeconds delay of the notification

        @example
        Enhance.enableLocalNotification("Enhance", "Local Notification!", 5);
    **/

    public static function enableLocalNotification(title:String, message:String, delaySeconds:Int):Void
    {
        if(!_initialized) init();

        #if android
        android_enableLocalNotification(title, message, delaySeconds);
        #end

        #if (cpp && mobile && !android)
        ios_enableLocalNotification(title, message, delaySeconds);
        #end
    }

    /**
        Disable any local notification.

        @example
        Enhance.disableLocalNotification();
    **/

    public static function disableLocalNotification():Void
    {
        if(!_initialized) init();

        #if android
        android_disableLocalNotification();
        #end

        #if (cpp && mobile && !android)
        ios_disableLocalNotification();
        #end
    }

    /**
        Send an event to hooked analytics networks.

        @param eventType type of the event
        @param paramKey parameter key (optional)
        @param paramValue parameter value (optional)

        @example
        Enhance.logEvent("test_event");

        @example
        Enhance.logEvent("test_event", "test_key", "test_value");
    **/

    public static function logEvent(eventType:String, ?paramKey:String, ?paramValue:String):Void
    {
        if(!_initialized) init();

        #if android
        android_logEvent(eventType, paramKey, paramValue);
        #end

        #if (cpp && mobile && !android)
        if(paramKey != null && paramValue != null)
            ios_logEvent(eventType, paramKey, paramValue);
        else
            ios_logSimpleEvent(eventType);
        #end
    }

    public static function requiresDataConsentOptIn(onServiceOptInRequirementCallback:Bool->Void):Void
    {
        if(!_initialized) init();

        _onServiceOptInRequirementCallback = onServiceOptInRequirementCallback;

        #if android
        android_requiresDataConsentOptIn();
        #end

        #if (cpp && mobile && !android)
        ios_requiresDataConsentOptIn();
        #end
    }

    public static function serviceTermsOptIn(?requestedSdks:Array<String>):Void
    {
        if(!_initialized) init();

        var requestedSdksAsString:String = null;
        if(requestedSdks != null && requestedSdks.length > 0) requestedSdksAsString = requestedSdks.join(",");

        #if android
        android_serviceTermsOptIn(requestedSdksAsString);
        #end

        #if (cpp && mobile && !android)
        ios_serviceTermsOptIn(requestedSdksAsString);
        #end
    }

    public static function showServiceOptInDialogs(?onDialogsCompleteCallback:Void->Void, ?requestedSdks:Array<String>):Void
    {
        if(!_initialized) init();

        _onDialogsCompleteCallback = onDialogsCompleteCallback;

        var requestedSdksAsString:String = null;
        if(requestedSdks != null && requestedSdks.length > 0) requestedSdksAsString = requestedSdks.join(",");

        #if android
        android_showServiceOptInDialogs(requestedSdksAsString);
        #end

        #if (cpp && mobile && !android)
        ios_showServiceOptInDialogs(requestedSdksAsString);
        #end
    }

    public static function serviceTermsOptOut()
    {
        if(!_initialized) init();
        #if android
        android_serviceTermsOptOut();
        #end

        #if (cpp && mobile && !android)
        ios_serviceTermsOptOut();
        #end
    }

    /* ---------- Java->Haxe --------- */

    @:dox(hide)
    public function onRewardGranted(rewardType:String, rewardValue:Int):Void
    {
        if(_onRewardGrantedCallback != null) _onRewardGrantedCallback(rewardType.toLowerCase(), rewardValue);
    }

    @:dox(hide)
    public function onRewardDeclined():Void
    {
        if(_onRewardDeclinedCallback != null) _onRewardDeclinedCallback();
    }

    @:dox(hide)
    public function onRewardUnavailable():Void
    {
        if(_onRewardUnavailableCallback != null) _onRewardUnavailableCallback();
    }

    @:dox(hide)
    public function onCurrencyGranted(amount:Int):Void
    {
        if(_onCurrencyReceivedCallback != null) _onCurrencyReceivedCallback(amount);
    }

    @:dox(hide)
    public function onPermissionGranted():Void
    {
        if(_onPermissionGrantedCallback != null) _onPermissionGrantedCallback();
    }

    @:dox(hide)
    public function onPermissionRefused():Void
    {
        if(_onPermissionRejectedCallback != null) _onPermissionRejectedCallback();
    }

    @:dox(hide)
    public function onPurchaseSuccess():Void
    {
        if(purchases == null) return;
        if(purchases.onPurchaseSuccessCallback != null) purchases.onPurchaseSuccessCallback();
    }

    @:dox(hide)
    public function onPurchaseFailed():Void
    {
        if(purchases == null) return;
        if(purchases.onPurchaseFailedCallback != null) purchases.onPurchaseFailedCallback();
    }

    @:dox(hide)
    public function onConsumeSuccess():Void
    {
        if(purchases == null) return;
        if(purchases.onConsumeSuccessCallback != null) purchases.onConsumeSuccessCallback();
    }

    @:dox(hide)
    public function onConsumeFailed():Void
    {
        if(purchases == null) return;
        if(purchases.onConsumeFailedCallback != null) purchases.onConsumeFailedCallback();
    }

    @:dox(hide)
    public function onRestoreSuccess():Void
    {
        if(purchases == null) return;
        if(purchases.onRestoreSuccessCallback != null) purchases.onRestoreSuccessCallback();
    }

    @:dox(hide)
    public function onRestoreFailed():Void
    {
        if(purchases == null) return;
        if(purchases.onRestoreFailedCallback != null) purchases.onRestoreFailedCallback();
    }

    @:dox(hide)
    public function onServiceOptInRequirement(isUserOptInRequired:Bool):Void
    {
        if(_onServiceOptInRequirementCallback != null) _onServiceOptInRequirementCallback(isUserOptInRequired);
    }

    @:dox(hide)
    public function onDialogComplete():Void
    {
        if(_onDialogsCompleteCallback != null) _onDialogsCompleteCallback();
    }


    /* ------------- JNI ------------- */

    #if android

    // Init

    private static var android_init = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "init", "(Lorg/haxe/nme/HaxeObject;)V"
    );

    // Interstitial Ad
    
    private static var android_isInterstitialReady = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "isInterstitialReady", "(Ljava/lang/String;)Z"
    );

    private static var android_showInterstitialAd = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "showInterstitialAd", "(Ljava/lang/String;)V"
    );

    // Rewarded Ad

    private static var android_isRewardedAdReady = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "isRewardedAdReady", "(Ljava/lang/String;)Z"
    );

    private static var android_showRewardedAd = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "showRewardedAd", "(Ljava/lang/String;)V"
    );

    // Banner Ad

    private static var android_isBannerAdReady = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "isBannerAdReady", "(Ljava/lang/String;)Z"
    );

    private static var android_showBannerAdWithPosition = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "showBannerAdWithPosition", "(Ljava/lang/String;Ljava/lang/String;)V"
    );

    private static var android_hideBannerAd = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "hideBannerAd", "()V"
    );

    // Special Offer

    private static var android_isSpecialOfferReady = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "isSpecialOfferReady", "(Ljava/lang/String;)Z"
    );

    private static var android_showSpecialOffer = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "showSpecialOffer", "(Ljava/lang/String;)V"
    );

    // Offerwall

    private static var android_isOfferwallReady = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "isOfferwallReady", "(Ljava/lang/String;)Z"
    );

    private static var android_showOfferwall = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "showOfferwall", "(Ljava/lang/String;)V"
    );

    // Local Notifications

    private static var android_requestLocalNotificationPermission = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "requestLocalNotificationPermission", "()V"
    );

    private static var android_enableLocalNotification = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "enableLocalNotification", "(Ljava/lang/String;Ljava/lang/String;I)V"
    );

    private static var android_disableLocalNotification = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "disableLocalNotification", "()V"
    );

    // Analytics

    private static var android_logEvent = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "logEvent", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
    );

    // GDPR

    private static var android_requiresDataConsentOptIn = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "requiresDataConsentOptIn", "()V"
    );

    private static var android_serviceTermsOptIn = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "serviceTermsOptIn", "(Ljava/lang/String;)V"
    );

    private static var android_showServiceOptInDialogs = JNI.createStaticMethod
    (
        _EXTENSION_PATH, "showServiceOptInDialogs", "(Ljava/lang/String;)V"
    );

    private static var android_serviceTermsOptOut = JNI.createStaticMethod
    (
         _EXTENSION_PATH, "serviceTermsOptOut", "()V"
    );
    #end

    /* ------------- CPPLoader ------------- */

    #if (cpp && mobile && !android)

    // Init

    private static var ios_init = CPPLoader.load(_EXTENSION_NS, "ios_init", 1);

    // Interstitial Ad

    private static var ios_isInterstitialReady = CPPLoader.load(_EXTENSION_NS, "ios_isInterstitialReady", 1);
    private static var ios_showInterstitialAd = CPPLoader.load(_EXTENSION_NS, "ios_showInterstitialAd", 1);

    // Rewarded Ad

    private static var ios_isRewardedAdReady = CPPLoader.load(_EXTENSION_NS, "ios_isRewardedAdReady", 1);
    private static var ios_showRewardedAd = CPPLoader.load(_EXTENSION_NS, "ios_showRewardedAd", 1);

    // Banner Ad

    private static var ios_isBannerAdReady = CPPLoader.load(_EXTENSION_NS, "ios_isBannerAdReady", 1);
    private static var ios_showBannerAdWithPosition = CPPLoader.load(_EXTENSION_NS, "ios_showBannerAdWithPosition", 2);
    private static var ios_hideBannerAd = CPPLoader.load(_EXTENSION_NS, "ios_hideBannerAd", 0);

    // Special Offer

    private static var ios_isSpecialOfferReady = CPPLoader.load(_EXTENSION_NS, "ios_isSpecialOfferReady", 1);
    private static var ios_showSpecialOffer = CPPLoader.load(_EXTENSION_NS, "ios_showSpecialOffer", 1);

    /// Offerwall

    private static var ios_isOfferwallReady = CPPLoader.load(_EXTENSION_NS, "ios_isOfferwallReady", 1);
    private static var ios_showOfferwall = CPPLoader.load(_EXTENSION_NS, "ios_showOfferwall", 1);

    // Local Notifications

    private static var ios_requestLocalNotificationPermission = CPPLoader.load(_EXTENSION_NS, "ios_requestLocalNotificationPermission", 0);
    private static var ios_enableLocalNotification = CPPLoader.load(_EXTENSION_NS, "ios_enableLocalNotification", 3);
    private static var ios_disableLocalNotification = CPPLoader.load(_EXTENSION_NS, "ios_disableLocalNotification", 0);

    // Analytics

    private static var ios_logSimpleEvent = CPPLoader.load(_EXTENSION_NS, "ios_logSimpleEvent", 1);
    private static var ios_logEvent = CPPLoader.load(_EXTENSION_NS, "ios_logEvent", 3);

    // GDPR

    private static var ios_requiresDataConsentOptIn = CPPLoader.load(_EXTENSION_NS, "ios_requiresDataConsentOptIn", 0);
    private static var ios_serviceTermsOptIn = CPPLoader.load(_EXTENSION_NS, "ios_serviceTermsOptIn", 1);
    private static var ios_showServiceOptInDialogs = CPPLoader.load(_EXTENSION_NS, "ios_showServiceOptInDialogs", 1);
    private static var ios_serviceTermsOptOut = CPPLoader.load(_EXTENSION_NS, "ios_serviceTermsOptOut", 0);
    #end
}
