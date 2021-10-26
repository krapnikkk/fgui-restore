package fairygui.utils
{
    import *.*;

    public class UBBParser extends Object
    {
        private var _text:String;
        private var _readPos:int;
        protected var _handlers:Object;
        public var smallFontSize:int = 12;
        public var normalFontSize:int = 14;
        public var largeFontSize:int = 16;
        public var defaultImgWidth:int = 0;
        public var defaultImgHeight:int = 0;
        public var maxFontSize:int = 0;
        public var unrecognizedTags:Object;
        public static var inst:UBBParser = new UBBParser;

        public function UBBParser()
        {
            unrecognizedTags = {};
            _handlers = {};
            _handlers["url"] = onTag_URL;
            _handlers["img"] = onTag_IMG;
            _handlers["b"] = onTag_Simple;
            _handlers["i"] = onTag_Simple;
            _handlers["u"] = onTag_Simple;
            _handlers["sup"] = onTag_Simple;
            _handlers["sub"] = onTag_Simple;
            _handlers["color"] = onTag_COLOR;
            _handlers["font"] = onTag_FONT;
            _handlers["size"] = onTag_SIZE;
            _handlers["align"] = onTag_ALIGN;
            return;
        }// end function

        protected function onTag_URL(param1:String, param2:Boolean, param3:String) : String
        {
            var _loc_4:* = null;
            if (!param2)
            {
                if (param3 != null)
                {
                    return "<a href=\"" + param3 + "\" target=\"_blank\">";
                }
                _loc_4 = getTagText();
                return "<a href=\"" + _loc_4 + "\" target=\"_blank\">";
            }
            return "</a>";
        }// end function

        protected function onTag_IMG(param1:String, param2:Boolean, param3:String) : String
        {
            var _loc_4:* = null;
            if (!param2)
            {
                _loc_4 = getTagText(true);
                if (!_loc_4)
                {
                    return null;
                }
                if (defaultImgWidth)
                {
                    return "<img src=\"" + _loc_4 + "\" width=\"" + defaultImgWidth + "\" height=\"" + defaultImgHeight + "\"/>";
                }
                return "<img src=\"" + _loc_4 + "\"/>";
            }
            return null;
        }// end function

        protected function onTag_Simple(param1:String, param2:Boolean, param3:String) : String
        {
            return param2 ? ("</" + param1 + ">") : ("<" + param1 + ">");
        }// end function

        protected function onTag_COLOR(param1:String, param2:Boolean, param3:String) : String
        {
            if (!param2)
            {
                return "<font color=\"" + param3 + "\">";
            }
            return "</font>";
        }// end function

        protected function onTag_FONT(param1:String, param2:Boolean, param3:String) : String
        {
            if (!param2)
            {
                return "<font face=\"" + param3 + "\">";
            }
            return "</font>";
        }// end function

        protected function onTag_ALIGN(param1:String, param2:Boolean, param3:String) : String
        {
            if (!param2)
            {
                return "<p align=\"" + param3 + "\">";
            }
            return "</p>";
        }// end function

        protected function onTag_SIZE(param1:String, param2:Boolean, param3:String) : String
        {
            var _loc_4:* = 0;
            if (!param2)
            {
                if (param3 == "normal")
                {
                    _loc_4 = normalFontSize;
                }
                else if (param3 == "small")
                {
                    _loc_4 = smallFontSize;
                }
                else if (param3 == "large")
                {
                    _loc_4 = largeFontSize;
                }
                else if (param3.length && param3.charAt(0) == "+")
                {
                    _loc_4 = smallFontSize + param3.substr(1);
                }
                else if (param3.length && param3.charAt(0) == "-")
                {
                    _loc_4 = smallFontSize - param3.substr(1);
                }
                else
                {
                    _loc_4 = this.parseInt(param3);
                }
                if (_loc_4 > maxFontSize)
                {
                    maxFontSize = _loc_4;
                }
                return "<font size=\"" + _loc_4 + "\">";
            }
            return "</font>";
        }// end function

        protected function getTagText(param1:Boolean = false) : String
        {
            var _loc_4:* = 0;
            var _loc_3:* = _readPos;
            var _loc_2:* = "";
            do
            {
                
                if (_text.charCodeAt((_loc_4 - 1)) == 92)
                {
                    _loc_2 = _loc_2 + _text.substring(_loc_3, (_loc_4 - 1));
                    _loc_2 = _loc_2 + "[";
                    _loc_3 = _loc_4 + 1;
                }
                else
                {
                    _loc_2 = _loc_2 + _text.substring(_loc_3, _loc_4);
                    break;
                }
                _loc_4 = _text.indexOf("[", _loc_3);
            }while (_text.indexOf("[", _loc_3) != -1)
            if (_loc_4 == -1)
            {
                return null;
            }
            if (param1)
            {
                _readPos = _loc_4;
            }
            return _loc_2;
        }// end function

        public function parse(param1:String, param2:Boolean = false) : String
        {
            var _loc_6:* = 0;
            var _loc_9:* = 0;
            var _loc_7:* = false;
            var _loc_11:* = null;
            var _loc_10:* = null;
            var _loc_8:* = null;
            var _loc_4:* = null;
            _text = param1;
            maxFontSize = 0;
            var _loc_5:* = 0;
            var _loc_3:* = "";
            do
            {
                
                if (_loc_6 > 0 && _text.charCodeAt((_loc_6 - 1)) == 92)
                {
                    _loc_3 = _loc_3 + _text.substring(_loc_5, (_loc_6 - 1));
                    _loc_3 = _loc_3 + "[";
                    _loc_5 = _loc_6 + 1;
                }
                else
                {
                    _loc_3 = _loc_3 + _text.substring(_loc_5, _loc_6);
                    _loc_5 = _loc_6;
                    _loc_6 = _text.indexOf("]", _loc_5);
                    _loc_7 = _text.charAt((_loc_5 + 1)) == "/";
                    _loc_10 = _text.substring(_loc_7 ? (_loc_5 + 2) : ((_loc_5 + 1)), _loc_6);
                    _readPos = _loc_6 + 1;
                    _loc_11 = null;
                    _loc_8 = null;
                    _loc_9 = _loc_10.indexOf("=");
                    if (_loc_9 != -1)
                    {
                        _loc_11 = _loc_10.substring((_loc_9 + 1));
                        _loc_10 = _loc_10.substring(0, _loc_9);
                    }
                    _loc_10 = _loc_10.toLowerCase();
                    _loc_4 = _handlers[_loc_10];
                    if (_loc_4 != null)
                    {
                        _loc_8 = this._loc_4(_loc_10, _loc_7, _loc_11);
                        if (_loc_8 != null && !param2)
                        {
                            _loc_3 = _loc_3 + _loc_8;
                        }
                    }
                    else if (!unrecognizedTags[_loc_10])
                    {
                        _loc_3 = _loc_3 + _text.substring(_loc_5, _readPos);
                    }
                    _loc_5 = _readPos;
                }
                _loc_6 = _text.indexOf("[", _loc_5);
            }while (_text.indexOf("[", _loc_5) != -1)
            if (_loc_5 < _text.length)
            {
                _loc_3 = _loc_3 + _text.substr(_loc_5);
            }
            _text = null;
            return _loc_3;
        }// end function

    }
}
