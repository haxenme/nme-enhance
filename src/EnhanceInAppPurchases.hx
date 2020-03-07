package;

#if (cpp && mobile && !android)
    import cpp.Lib as CPPLoader;
#end

#if android
    import nme.utils.JNI;
#end

class EnhanceInAppPurchases 
{
    private static inline var _EXTENSION_PATH:String = "org.haxe.extension.EnhanceBridge";
    private static inline var _EXTENSION_NS:String   = "enhance";

    // Enhance class needs access
    public var onPurchaseSuccessCallback(get, null):Void->Void = null;
    public var onPurchaseFailedCallback(get, null):Void->Void = null;
    public var onConsumeSuccessCallback(get, null):Void->Void = null;
    public var onConsumeFailedCallback(get, null):Void->Void = null;
    public var onRestoreSuccessCallback(get, null):Void->Void = null;
    public var onRestoreFailedCallback(get, null):Void->Void = null;

    public function new() {}

    public function isSupported():Bool
    {
        var result:Bool = false;

        #if android
        result = android_isPurchasingSupported();
        #end

        #if (cpp && mobile && !android)
        result = ios_isPurchasingSupported();
        #end

        return result;
    }

    public function attemptPurchase(sku:String, onPurchaseSuccess:Void->Void, onPurchaseFailed:Void->Void):Void
    {
        onPurchaseSuccessCallback = onPurchaseSuccess;
        onPurchaseFailedCallback = onPurchaseFailed;

        #if android
        android_attemptPurchase(sku);
        #end

        #if (cpp && mobile && !android)
        ios_attemptPurchase(sku);
        #end
    }

    public function getDisplayPrice(sku:String, defaultPrice:String):String
    {
        var result:String = defaultPrice;

        #if android
        result = android_getDisplayPrice(sku, defaultPrice);
        #end

        #if (cpp && mobile && !android)
        result = ios_getDisplayPrice(sku, defaultPrice);
        #end

        return result;
    }

    public function isItemOwned(sku:String):Bool
    {
        var result:Bool = false;

        #if android
        result = android_isItemOwned(sku);
        #end

        #if (cpp && mobile && !android)
        result = ios_isItemOwned(sku);
        #end

        return result;
    }

    public function getOwnedItemCount(sku:String):Int
    {
        var result:Int = 0;

        #if android
        result = android_getOwnedItemCount(sku);
        #end

        #if (cpp && mobile && !android)
        result = ios_getOwnedItemCount(sku);
        #end

        return result;
    }

    public function consume(sku:String, onConsumeSuccess:Void->Void, onConsumeFailed:Void->Void):Void
    {
        onConsumeSuccessCallback = onConsumeSuccess;
        onConsumeFailedCallback = onConsumeFailed;

        #if android
        android_consume(sku);
        #end

        #if (cpp && mobile && !android)
        ios_consume(sku);
        #end
    }

    public function manuallyRestorePurchases(onRestoreSuccess:Void->Void, onRestoreFailed:Void->Void):Void
    {
        onRestoreSuccessCallback = onRestoreSuccess;
        onRestoreFailedCallback = onRestoreFailed;

        #if android
        android_manuallyRestorePurchases();
        #end

        #if (cpp && mobile && !android)
        ios_manuallyRestorePurchases();
        #end
    }

    public function getDisplayTitle(sku:String, defaultTitle:String):String
    {
        var result:String = defaultTitle;

        #if android
        result = android_getDisplayTitle(sku, defaultTitle);
        #end

        #if (cpp && mobile && !android)
        result = ios_getDisplayTitle(sku, defaultTitle);
        #end

        return result;
    }

    public function getDisplayDescription(sku:String, defaultDescription:String):String
    {
        var result:String = defaultDescription;

        #if android
        result = android_getDisplayDescription(sku, defaultDescription);
        #end

        #if (cpp && mobile && !android)
        result = ios_getDisplayDescription(sku, defaultDescription);
        #end

        return result;
    }

    public function get_onPurchaseSuccessCallback() { return onPurchaseSuccessCallback; }
    public function get_onPurchaseFailedCallback() { return onPurchaseFailedCallback; }
    public function get_onConsumeSuccessCallback() { return onConsumeSuccessCallback; }
    public function get_onConsumeFailedCallback() { return onConsumeFailedCallback; }
    public function get_onRestoreSuccessCallback() { return onRestoreSuccessCallback; }
    public function get_onRestoreFailedCallback() { return onRestoreFailedCallback; }

    #if android
    private static var android_isPurchasingSupported:Dynamic = JNI.createStaticMethod(_EXTENSION_PATH, "isPurchasingSupported", "()Z");
    private static var android_attemptPurchase:Dynamic = JNI.createStaticMethod(_EXTENSION_PATH, "attemptPurchase", "(Ljava/lang/String;)V");
    private static var android_getDisplayPrice:Dynamic = JNI.createStaticMethod(_EXTENSION_PATH, "getDisplayPrice", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;");
    private static var android_isItemOwned:Dynamic = JNI.createStaticMethod(_EXTENSION_PATH, "isItemOwned", "(Ljava/lang/String;)Z");
    private static var android_getOwnedItemCount:Dynamic = JNI.createStaticMethod(_EXTENSION_PATH, "getOwnedItemCount", "(Ljava/lang/String;)I");
    private static var android_consume:Dynamic = JNI.createStaticMethod(_EXTENSION_PATH, "consume", "(Ljava/lang/String;)V");
    private static var android_manuallyRestorePurchases:Dynamic = JNI.createStaticMethod(_EXTENSION_PATH, "manuallyRestorePurchases", "()V");
    private static var android_getDisplayTitle:Dynamic = JNI.createStaticMethod(_EXTENSION_PATH, "getDisplayTitle", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;");
    private static var android_getDisplayDescription:Dynamic = JNI.createStaticMethod(_EXTENSION_PATH, "getDisplayDescription", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;");
    #end

    #if (cpp && mobile && !android)
    private static var ios_isPurchasingSupported:Dynamic = CPPLoader.load(_EXTENSION_NS, "ios_isPurchasingSupported", 0);
    private static var ios_attemptPurchase:Dynamic = CPPLoader.load(_EXTENSION_NS, "ios_attemptPurchase", 1);
    private static var ios_getDisplayPrice:Dynamic = CPPLoader.load(_EXTENSION_NS, "ios_getDisplayPrice", 2);
    private static var ios_isItemOwned:Dynamic = CPPLoader.load(_EXTENSION_NS, "ios_isItemOwned", 1);
    private static var ios_getOwnedItemCount:Dynamic = CPPLoader.load(_EXTENSION_NS, "ios_getOwnedItemCount", 1);
    private static var ios_consume:Dynamic = CPPLoader.load(_EXTENSION_NS, "ios_consume", 1);
    private static var ios_manuallyRestorePurchases:Dynamic = CPPLoader.load(_EXTENSION_NS, "ios_manuallyRestorePurchases", 0);
    private static var ios_getDisplayTitle:Dynamic = CPPLoader.load(_EXTENSION_NS, "ios_getDisplayTitle", 2);
    private static var ios_getDisplayDescription:Dynamic = CPPLoader.load(_EXTENSION_NS, "ios_getDisplayDescription", 2);
    #end
}
