package utils;

import openfl.display.Sprite;
import openfl.events.TouchEvent;
import openfl.events.MouseEvent;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/*
*  Helper button class
*/
    
class Button extends Sprite {
    private var textField:TextField;
    private var pressed:Sprite;
    
    private var callback:Void->Void;
        
    private var w:Int = 200; 
    private var h:Int = 50;

    public function new(x:Float, y:Float, txt:String, callback:Void->Void)  {
        super();

        this.callback = callback;
        this.x = x;
        this.y = y;
            
        var format:TextFormat = new TextFormat();
        format.size = 18;
        format.align = TextFormatAlign.CENTER;
            
        textField = new TextField(); 
        textField.defaultTextFormat = format;
        textField.text = txt;
        textField.width = w;
        textField.height = h;
        textField.selectable = false;
        textField.wordWrap = true;
        textField.multiline = true;
        textField.x = (w - textField.width) / 2;
        textField.y = textField.height / 2 - textField.textHeight / 2 - 4;
              
        graphics.clear();
        graphics.beginFill(0xE5E5E5); 
        graphics.drawRoundRect(0, 0, w, h, 10, 10); 
        graphics.endFill();
            
        pressed = new Sprite();
        pressed.graphics.clear();
        pressed.graphics.beginFill(0xFFBA00);
        pressed.graphics.drawRoundRect(0, 0, w, h, 10, 10); 
        pressed.graphics.endFill();
        pressed.visible = false;
        pressed.width = w;
        pressed.height = h;
            
        addChild(pressed);
        addChild(textField);

        addEventListener(MouseEvent.MOUSE_DOWN, tapBegin);
        addEventListener(MouseEvent.MOUSE_UP, tapEnd);
        addEventListener(MouseEvent.MOUSE_OUT, rollOut);
    }
        
    public function tapBegin(e:Event) {
        pressed.visible = true;
    }
        
    public function tapEnd(e:Event) {
        pressed.visible = false;
        
        if (callback != null) callback();
    }
        
    public function rollOut(e:Event) {
        pressed.visible = false;
    }
}
