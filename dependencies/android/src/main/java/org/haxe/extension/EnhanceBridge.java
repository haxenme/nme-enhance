package org.haxe.extension;

import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;

import java.util.List;
import java.util.Arrays;

/* 
    You can use the Android Extension class in order to hook
    into the Android activity lifecycle. This is not required
    for standard Java code, this is designed for when you need
    deeper integration.
    
    You can access additional references from the Extension class,
    depending on your needs:
    
    - Extension.assetManager (android.content.res.AssetManager)
    - Extension.callbackHandler (android.os.Handler)
    - Extension.mainActivity (android.app.Activity)
    - Extension.mainContext (android.content.Context)
    - Extension.mainView (android.view.View)
    
    You can also make references to static or instance methods
    and properties on Java classes. These classes can be included 
    as single files using <java path="to/File.java" /> within your
    project, or use the full Android Library Project format (such
    as this example) in order to include your own AndroidManifest
    data, additional dependencies, etc.
    
    These are also optional, though this example shows a static
    function for performing a single task, like returning a value
    back to Haxe from Java.
*/

import org.haxe.nme.HaxeObject;

import co.enhance.Enhance;
import co.enhance.Enhance.*;
import co.enhance.EnhanceInAppPurchases;
import co.enhance.EnhanceInAppPurchases.*;

public class EnhanceBridge extends Extension
{
    private static HaxeObject _extensionObject = null;

    public static void init(HaxeObject object)
    {
        _extensionObject = object;
        setReceivedCurrencyCallback();
    }

    // Interstitial Ad //

    public static boolean isInterstitialReady(String placement)
    {
        if(placement == null) placement = Enhance.INTERSTITIAL_PLACEMENT_DEFAULT;
        return Enhance.isInterstitialReady(placement);
    }

    public static void showInterstitialAd(String placement)
    {
        if(placement == null) placement = Enhance.INTERSTITIAL_PLACEMENT_DEFAULT;
        Enhance.showInterstitialAd(placement);
    }

    // Rewarded Ad //

    public static boolean isRewardedAdReady(String placement)
    {
        if(placement == null) placement = Enhance.REWARDED_PLACEMENT_NEUTRAL;
        return Enhance.isRewardedAdReady(placement);
    }

    public static void showRewardedAd(String placement) 
    {
        final RewardCallback rewardCallbacks = new RewardCallback() 
        {
            @Override
            public void onRewardGranted(int rewardValue, RewardType rewardType) 
            {
                final int rewardValueInt = rewardValue; 
                final String rewardTypeStr;
                if(rewardType == RewardType.COINS) rewardTypeStr = "coins";
                else rewardTypeStr = "item";

                Extension.callbackHandler.post(new Runnable() 
                {
                    @Override 
                    public void run() 
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onRewardGranted", new Object[] { rewardTypeStr, rewardValueInt });
                    }
                });
            }

            @Override
            public void onRewardDeclined()
            {
                Extension.callbackHandler.post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onRewardDeclined", new Object[] {});
                    }
                });
            }

            @Override
            public void onRewardUnavailable()
            {
                Extension.callbackHandler.post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onRewardUnavailable", new Object[] {});
                    }
                });
            }
        };

        if(placement == null) placement = Enhance.REWARDED_PLACEMENT_NEUTRAL;
        Enhance.showRewardedAd(rewardCallbacks, placement);
    } 

    // Banner Ad //

    public static boolean isBannerAdReady(String placement)
    {
        if(placement == null) placement = Enhance.PLACEMENT_DEFAULT;
        return Enhance.isBannerAdReady(placement);
    }

    public static void showBannerAdWithPosition(String placement, String positionStr)
    {
        if(positionStr == null) positionStr = "BOTTOM";

        Position position = Position.BOTTOM;
        if(positionStr.toUpperCase().equals("TOP")) position = Position.TOP;

        if(placement == null) placement = Enhance.PLACEMENT_DEFAULT;
        if(position == null) position = Position.BOTTOM;

        Enhance.showBannerAdWithPosition(placement, position);
    }

    public static void hideBannerAd()
    {
        Enhance.hideBannerAd();
    } 

    // Special Offer //

    public static boolean isSpecialOfferReady(String placement)
    {
        if(placement == null) placement = Enhance.PLACEMENT_DEFAULT;
        return Enhance.isSpecialOfferReady(placement);
    }

    public static void showSpecialOffer(String placement)
    {
        if(placement == null) placement = Enhance.PLACEMENT_DEFAULT;
        Enhance.showSpecialOffer(placement);
    }

    // Offerwall //

    public static boolean isOfferwallReady(String placement)
    {
        if(placement == null) placement = Enhance.PLACEMENT_DEFAULT;
        return Enhance.isOfferwallReady(placement);
    }

    public static void showOfferwall(String placement)
    {
        if(placement == null) placement = Enhance.PLACEMENT_DEFAULT;
        Enhance.showOfferwall(placement);
    }

    private static void setReceivedCurrencyCallback()
    {
        CurrencyCallback currencyCallback = new CurrencyCallback()
        {
            @Override
            public void onCurrencyGranted(int currencyAmount)
            {
                final int currencyAmountInt = currencyAmount;

                Extension.callbackHandler.post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onCurrencyGranted", new Object[] { currencyAmountInt });
                    }
                });
            }
        };
        Enhance.setReceivedCurrencyCallback(currencyCallback);
    }

    // Local Notification //

    public static void requestLocalNotificationPermission()
    {
        PermissionCallback permissionCallbacks = new PermissionCallback()
        {
            @Override
            public void onPermissionGranted()
            {
                Extension.callbackHandler.post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onPermissionGranted", new Object[] {});
                    }
                });
            }

            @Override
            public void onPermissionRefused()
            {
                Extension.callbackHandler.post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onPermissionRefused", new Object[] {});
                    }
                });
            }
        };

        Enhance.requestLocalNotificationPermission(permissionCallbacks);
    }

    public static void enableLocalNotification(String title, String message, int delay)
    {
        if(title == null || message == null) return; 
        Enhance.enableLocalNotification(title, message, delay);
    }

    public static void disableLocalNotification() 
    {
        Enhance.disableLocalNotification();
    }

    // Analytics //

    public static void logEvent(String eventType, String paramKey, String paramValue)
    {
        if(eventType == null) return;

        if(paramKey.equals("")) paramKey = null;
        if(paramValue.equals("")) paramValue = null;

        if(paramKey == null || paramValue == null)
            Enhance.logEvent(eventType);
        else if(paramKey != null && paramValue != null)
            Enhance.logEvent(eventType, paramKey, paramValue);
    }

    // Is Purchasing Supported //

    public static boolean isPurchasingSupported()
    {
        return Enhance.purchases.isSupported();
    }

    // Attempt Purchase //

    public static void attemptPurchase(String sku)
    {
        if(sku == null) return;

        PurchaseCallback purchaseCalbacks = new PurchaseCallback()
        {
            @Override 
            public void onPurchaseSuccess()
            {
                Extension.callbackHandler.post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onPurchaseSuccess", new Object[] {});
                    }
                });
            }

            @Override
            public void onPurchaseFailed()
            {
                Extension.callbackHandler.post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onPurchaseFailed", new Object[] {});
                    }
                });
            }
        };
        Enhance.purchases.attemptPurchase(sku, purchaseCalbacks);
    }

    // Get Display Price //

    public static String getDisplayPrice(String sku, String defaultPrice)
    {
        if(sku == null || defaultPrice == null) return "";

        return Enhance.purchases.getDisplayPrice(sku, defaultPrice);
    }

    // Is Item Owned //

    public static boolean isItemOwned(String sku)
    {
        if(sku == null) return false;

        return Enhance.purchases.isItemOwned(sku);
    }

    // Get Owned Item Count //

    public static int getOwnedItemCount(String sku)
    {
        if(sku == null) return 0;

        return Enhance.purchases.getOwnedItemCount(sku);
    }

    // Consume //

    public static void consume(String sku)
    {
        if(sku == null) return;

        ConsumeCallback consumeCallbacks = new ConsumeCallback()
        {
            @Override
            public void onConsumeSuccess()
            {
                Extension.callbackHandler.post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onConsumeSuccess", new Object[] {});
                    }
                });
            }

            @Override
            public void onConsumeFailed()
            {
                Extension.callbackHandler.post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onConsumeFailed", new Object[] {});
                    }
                });
            }
        };
        Enhance.purchases.consume(sku, consumeCallbacks);
    }

    // Manually restore purchases //

    public static void manuallyRestorePurchases()
    {
        RestoreCallback callbacks = new RestoreCallback()
        {
            @Override
            public void onRestoreSuccess() 
            {
                Extension.callbackHandler.post(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onRestoreSuccess", new Object[] {});
                    }
                });
            }

            @Override
            public void onRestoreFailed()
            {
                Extension.callbackHandler.post(new Runnable() 
                {
                    @Override
                    public void run()
                    {
                        if(EnhanceBridge._extensionObject != null)
                            EnhanceBridge._extensionObject.call("onRestoreFailed", new Object[] {});
                    }
                });
            }
        };
        Enhance.purchases.manuallyRestorePurchases(callbacks);
    }

    // Get Display Title //

    public static String getDisplayTitle(String sku, String defaultTitle)
    {
        if(sku == null || defaultTitle == null) return "";

        return Enhance.purchases.getDisplayTitle(sku, defaultTitle);
    }

    // Get Display Description //

    public static String getDisplayDescription(String sku, String defaultDescription)
    {
        if(sku == null || defaultDescription == null) return "";

        return Enhance.purchases.getDisplayDescription(sku, defaultDescription);
    }

    // GDPR

    public static void requiresDataConsentOptIn() {
        OptInRequiredCallback callback = new OptInRequiredCallback() {
            @Override
            public void onServiceOptInRequirement(boolean isUserOptInRequired) {
                EnhanceBridge._extensionObject.call("onServiceOptInRequirement", new Object[] { isUserOptInRequired });
            }
        };
        Enhance.requiresDataConsentOptIn(callback);
    }

    public static void serviceTermsOptIn(String requestedSdksString) {
        if(requestedSdksString != null && !requestedSdksString.isEmpty()) {
            String[] array = requestedSdksString.split(",");
            List<String> requestedSdks = Arrays.asList(array);
            Enhance.serviceTermsOptIn(requestedSdks);
            return;
        }

        Enhance.serviceTermsOptIn();
    }

    public static void showServiceOptInDialogs(String requestedSdksString)
    {
        OnDataConsentOptInComplete callback = new OnDataConsentOptInComplete() {
            @Override
            public void onDialogComplete() {
                EnhanceBridge._extensionObject.call("onDialogComplete", new Object[] {});
            }
        };

        if(requestedSdksString != null && !requestedSdksString.isEmpty()) {
            String[] array = requestedSdksString.split(",");
            List<String> requestedSdks = Arrays.asList(array);
            Enhance.showServiceOptInDialogs(requestedSdks, callback);
            return;
        }

        Enhance.showServiceOptInDialogs(callback);
    }

    public static void serviceTermsOptOut() {
        Enhance.serviceTermsOptOut();
    }

    /**
     * Called when an activity you launched exits, giving you the requestCode 
     * you started it with, the resultCode it returned, and any additional data 
     * from it.
     */
    public boolean onActivityResult (int requestCode, int resultCode, Intent data)
    {
        return true;
    }

    /**
     * Called when the activity is starting.
     */
    public void onCreate (Bundle savedInstanceState)
    {
    }
    
    /**
     * Perform any final cleanup before an activity is destroyed.
     */
    public void onDestroy ()
    {
    }
    
    /**
     * Called as part of the activity lifecycle when an activity is going into
     * the background, but has not (yet) been killed.
     */
    public void onPause () 
    {
    }
    
    /**
     * Called after {@link #onStop} when the current activity is being 
     * re-displayed to the user (the user has navigated back to it).
     */
    public void onRestart () 
    {
    }
    
    /**
     * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
     * to start interacting with the user.
     */
    public void onResume ()
    {
    }
    
    /**
     * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
     * the activity had been stopped, but is now again being displayed to the 
     * user.
     */
    public void onStart ()
    {
    }

    /**
     * Called when the activity is no longer visible to the user, because 
     * another activity has been resumed and is covering this one. 
     */
    public void onStop ()
    {
    }
}
