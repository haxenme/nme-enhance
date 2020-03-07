package utils;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

// Write logs
// Not Enhance related

class LogOutput extends Sprite {
    private static inline var MAX_LINES = 8;

    private var textField:TextField;
    private var lines:Int = 0;

    public function new () {
        super();

        x = 30;
        y = 620;

        var format:TextFormat = new TextFormat();
        format.size = 16;
        format.align = TextFormatAlign.LEFT;

        textField = new TextField();
        textField.defaultTextFormat = format;
        textField.text = "Logs...";
        textField.selectable = true;
        textField.wordWrap = true;
        textField.multiline = true;
        textField.width = Main.BASE_WIDTH - x;
        textField.height = Main.BASE_HEIGHT - y;

        addChild(textField);
    }

    public function writeLog(text:String) {
        if(lines == MAX_LINES) {
            clear();
        }

        else if(lines == 0) {
            textField.text = "";
        }

        textField.text = textField.text + text + "\n";
        lines++;

        trace(text);
    }

    public function clear() {
        lines = 0;
        textField.text = "";
    }
}