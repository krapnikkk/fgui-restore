package fairygui.utils
{
    import *.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;

    public class CharSize extends Object
    {
        private static var testTextField:TextField;
        private static var testTextField2:TextField;
        private static var testTextFormat:TextFormat;
        private static var results:Object;
        private static var boldResults:Object;
        private static var holderResults:Object;
        private static var helperBmd:BitmapData;
        public static var TEST_STRING:String = "fj|_我案爱";

        public function CharSize()
        {
            return;
        }// end function

        public static function getSize(param1:int, param2:String, param3:Boolean) : Object
        {
            if (!testTextField)
            {
                testTextField = new TextField();
                testTextField.autoSize = "left";
                testTextField.text = TEST_STRING;
                if (!testTextFormat)
                {
                    testTextFormat = new TextFormat();
                }
                results = {};
                boldResults = {};
            }
            var _loc_5:* = param3 ? (boldResults[param2]) : (results[param2]);
            if (!(param3 ? (boldResults[param2]) : (results[param2])))
            {
                _loc_5 = {};
                if (param3)
                {
                    boldResults[param2] = _loc_5;
                }
                else
                {
                    results[param2] = _loc_5;
                }
            }
            var _loc_4:* = _loc_5[param1];
            if (_loc_5[param1])
            {
                return _loc_4;
            }
            _loc_4 = {};
            _loc_5[param1] = _loc_4;
            testTextFormat.font = param2;
            testTextFormat.size = param1;
            testTextFormat.bold = param3;
            testTextField.setTextFormat(testTextFormat);
            testTextField.embedFonts = FontUtils.isEmbeddedFont(testTextFormat);
            _loc_4.height = testTextField.textHeight;
            if (_loc_4.height == 0)
            {
                _loc_4.height = param1;
            }
            if (helperBmd == null || helperBmd.width < testTextField.width || helperBmd.height < testTextField.height)
            {
                helperBmd = new BitmapData(Math.max(128, testTextField.width), Math.max(128, testTextField.height), true, 0);
            }
            else
            {
                helperBmd.fillRect(helperBmd.rect, 0);
            }
            helperBmd.draw(testTextField);
            var _loc_6:* = helperBmd.getColorBoundsRect(4278190080, 0, false);
            _loc_4.yIndent = _loc_6.top - 2 - (_loc_4.height - Math.max(_loc_6.height, param1)) / 2;
            if (_loc_4.yIndent < 0)
            {
                _loc_4.yIndent = 0;
            }
            return _loc_4;
        }// end function

        public static function getHolderWidth(param1:String, param2:int) : int
        {
            if (!testTextField2)
            {
                testTextField2 = new TextField();
                testTextField2.autoSize = "left";
                testTextField2.text = "　";
                if (!testTextFormat)
                {
                    testTextFormat = new TextFormat();
                }
                holderResults = {};
            }
            var _loc_4:* = holderResults[param1];
            if (!holderResults[param1])
            {
                _loc_4 = {};
                holderResults[param1] = _loc_4;
            }
            var _loc_3:* = _loc_4[param2];
            if (_loc_3 == null)
            {
                testTextFormat.font = param1;
                testTextFormat.size = param2;
                testTextFormat.bold = false;
                testTextField2.setTextFormat(testTextFormat);
                testTextField2.embedFonts = FontUtils.isEmbeddedFont(testTextFormat);
                _loc_3 = testTextField2.textWidth;
                _loc_4[param2] = _loc_3;
            }
            return _loc_3;
        }// end function

        public static function getFontSizeByHeight(param1:Number, param2:String) : int
        {
            var _loc_3:* = NaN;
            var _loc_6:* = 0;
            var _loc_5:* = param1;
            var _loc_4:* = param1 / 2;
            while (_loc_5 - _loc_6 > 1)
            {
                
                _loc_3 = getSize(_loc_4, param2, false).height;
                if (Math.abs(param1 - _loc_3) < 1)
                {
                    return _loc_4;
                }
                if (_loc_3 > param1)
                {
                    _loc_5 = _loc_4;
                }
                else
                {
                    _loc_6 = _loc_4;
                }
                _loc_4 = _loc_6 + (_loc_5 - _loc_6) / 2;
            }
            return _loc_4;
        }// end function

    }
}
