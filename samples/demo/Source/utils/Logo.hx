package utils;

import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class Logo extends Sprite {
    
    public function new () {
        super();

        var logoBitmapData:BitmapData = Assets.getBitmapData("assets/logo.png");
        var logoBitmap:Bitmap = new Bitmap(logoBitmapData);
        logoBitmap.x = Main.BASE_WIDTH / 2 - logoBitmap.width / 2;
        logoBitmap.y = 10;
        addChild(logoBitmap);
    }
}