package utils;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

// Write logs
// Not Enhance related

class Label extends Sprite {
    private var textField:TextField;
    private var lines:Int = 0;

    public function new () {
        super();

        x = 0;
        y = 585;

        var format:TextFormat = new TextFormat();
        format.size = 16;
        format.align = TextFormatAlign.CENTER;

        textField = new TextField();
        textField.defaultTextFormat = format;
        textField.text = "";
        textField.selectable = true;
        textField.wordWrap = true;
        textField.multiline = true;
        textField.width = Main.BASE_WIDTH - x;
        textField.height = Main.BASE_HEIGHT - y;

        addChild(textField);
    }

    public function update(text:String) {
        textField.text = text;
    }
}