package fairygui.utils
{
    import *.*;
    import fairygui.*;
    import fairygui.display.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;

    public class ToolSet extends Object
    {
        public static var GRAY_FILTERS:Array = [new ColorMatrixFilter([0.299, 0.587, 0.114, 0, 0, 0.299, 0.587, 0.114, 0, 0, 0.299, 0.587, 0.114, 0, 0, 0, 0, 0, 1, 0])];
        public static const RAD_TO_DEG:Number = 57.2958;
        public static const DEG_TO_RAD:Number = 0.0174533;
        private static var tileIndice:Array = [-1, 0, -1, 2, 4, 3, -1, 1, -1];

        public function ToolSet()
        {
            return;
        }// end function

        public static function startsWith(param1:String, param2:String, param3:Boolean = false) : Boolean
        {
            if (!param1)
            {
                return false;
            }
            if (param1.length < param2.length)
            {
                return false;
            }
            param1 = param1.substring(0, param2.length);
            if (!param3)
            {
                return param1 == param2;
            }
            return param1.toLowerCase() == param2.toLowerCase();
        }// end function

        public static function endsWith(param1:String, param2:String, param3:Boolean = false) : Boolean
        {
            if (!param1)
            {
                return false;
            }
            if (param1.length < param2.length)
            {
                return false;
            }
            param1 = param1.substring(param1.length - param2.length);
            if (!param3)
            {
                return param1 == param2;
            }
            return param1.toLowerCase() == param2.toLowerCase();
        }// end function

        public static function trim(param1:String) : String
        {
            return trimLeft(trimRight(param1));
        }// end function

        public static function trimLeft(param1:String) : String
        {
            var _loc_3:* = 0;
            var _loc_2:* = "";
            _loc_3 = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2 = param1.charAt(_loc_3);
                if (!(_loc_2 != " " && _loc_2 != "\n" && _loc_2 != "\r"))
                {
                    _loc_3++;
                }
            }
            return param1.substr(_loc_3);
        }// end function

        public static function trimRight(param1:String) : String
        {
            var _loc_3:* = 0;
            var _loc_2:* = "";
            _loc_3 = param1.length - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_2 = param1.charAt(_loc_3);
                if (!(_loc_2 != " " && _loc_2 != "\n" && _loc_2 != "\r"))
                {
                    _loc_3--;
                }
            }
            return param1.substring(0, (_loc_3 + 1));
        }// end function

        public static function convertToHtmlColor(param1:uint, param2:Boolean = false) : String
        {
            var _loc_6:* = null;
            if (param2)
            {
                _loc_6 = (param1 >> 24 & 255).toString(16);
            }
            else
            {
                _loc_6 = "";
            }
            var _loc_3:* = (param1 >> 16 & 255).toString(16);
            var _loc_4:* = (param1 >> 8 & 255).toString(16);
            var _loc_5:* = (param1 & 255).toString(16);
            if (_loc_6.length == 1)
            {
                _loc_6 = "0" + _loc_6;
            }
            if (_loc_3.length == 1)
            {
                _loc_3 = "0" + _loc_3;
            }
            if (_loc_4.length == 1)
            {
                _loc_4 = "0" + _loc_4;
            }
            if (_loc_5.length == 1)
            {
                _loc_5 = "0" + _loc_5;
            }
            return "#" + _loc_6 + _loc_3 + _loc_4 + _loc_5;
        }// end function

        public static function convertFromHtmlColor(param1:String, param2:Boolean = false) : uint
        {
            if (param1.length < 1)
            {
                return 0;
            }
            if (param1.charAt(0) == "#")
            {
                param1 = param1.substr(1);
            }
            if (param1.length == 8)
            {
                return (ToolSet.parseInt(param1.substr(0, 2), 16) << 24) + ToolSet.parseInt(param1.substr(2), 16);
            }
            if (param2)
            {
                return 4278190080 + ToolSet.parseInt(param1, 16);
            }
            return ToolSet.parseInt(param1, 16);
        }// end function

        public static function encodeHTML(param1:String) : String
        {
            if (!param1)
            {
                return "";
            }
            return param1.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/'/g, "&apos;");
        }// end function

        public static function decodeXML(param1:String) : String
        {
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_4:* = 0;
            var _loc_3:* = param1.length;
            var _loc_2:* = "";
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            while (true)
            {
                
                _loc_6 = param1.indexOf("&", _loc_5);
                if (_loc_6 == -1)
                {
                    _loc_2 = _loc_2 + param1.substr(_loc_5);
                    break;
                }
                _loc_2 = _loc_2 + param1.substr(_loc_5, _loc_6 - _loc_5);
                _loc_6 = _loc_6 + 1;
                _loc_7 = Math.min(_loc_3, _loc_6 + 10);
                while (_loc_6 < _loc_7)
                {
                    
                    if (param1.charCodeAt(_loc_6) != 59)
                    {
                        _loc_6++;
                    }
                }
                if (_loc_6 < _loc_7 && _loc_6 > ++_loc_6)
                {
                    _loc_8 = param1.substr(_loc_5, _loc_6 - _loc_5);
                    _loc_4 = 0;
                    if (_loc_8.charCodeAt(0) == 35)
                    {
                        if (_loc_8.length > 1)
                        {
                            if (_loc_8[1] == "x")
                            {
                                _loc_4 = ToolSet.parseInt(_loc_8.substr(2), 16);
                            }
                            else
                            {
                                _loc_4 = ToolSet.parseInt(_loc_8.substr(1));
                            }
                            _loc_2 = _loc_2 + String.fromCharCode(_loc_4);
                            _loc_5 = _loc_6 + 1;
                        }
                        else
                        {
                            _loc_2 = _loc_2 + "&";
                        }
                    }
                    else
                    {
                        var _loc_9:* = _loc_8;
                        while (_loc_9 === "amp")
                        {
                            
                            _loc_4 = 38;
                            do
                            {
                                
                                _loc_4 = 39;
                                do
                                {
                                    
                                    _loc_4 = 62;
                                    do
                                    {
                                        
                                        _loc_4 = 60;
                                        do
                                        {
                                            
                                            _loc_4 = 32;
                                            do
                                            {
                                                
                                                _loc_4 = 34;
                                                break;
                                            }
                                        }while (_loc_9 === "apos")
                                    }while (_loc_9 === "gt")
                                }while (_loc_9 === "lt")
                            }while (_loc_9 === "nbsp")
                        }while (_loc_9 === "quot")
                        if (_loc_4 > 0)
                        {
                            _loc_2 = _loc_2 + String.fromCharCode(_loc_4);
                            _loc_5 = _loc_6 + 1;
                        }
                        else
                        {
                            _loc_2 = _loc_2 + "&";
                        }
                    }
                    continue;
                }
                _loc_2 = _loc_2 + "&";
            }
            return _loc_2;
        }// end function

        public static function scaleBitmapWith9Grid(param1:BitmapData, param2:Rectangle, param3:int, param4:int, param5:Boolean = false, param6:int = 0) : BitmapData
        {
            var _loc_14:* = null;
            var _loc_16:* = null;
            var _loc_17:* = NaN;
            var _loc_9:* = null;
            var _loc_11:* = null;
            var _loc_15:* = 0;
            var _loc_18:* = 0;
            var _loc_10:* = 0;
            var _loc_13:* = null;
            if (param3 == 0 || param4 == 0)
            {
                return new BitmapData(1, 1, param1.transparent, 0);
            }
            var _loc_8:* = new BitmapData(param3, param4, param1.transparent, 0);
            var _loc_12:* = [0, param2.top, param2.bottom, param1.height];
            var _loc_19:* = [0, param2.left, param2.right, param1.width];
            if (param4 >= param1.height - param2.height)
            {
                _loc_14 = [0, param2.top, param4 - (param1.height - param2.bottom), param4];
            }
            else
            {
                _loc_17 = param2.top / (param1.height - param2.bottom);
                _loc_17 = param4 * _loc_17 / (1 + _loc_17);
                _loc_14 = [0, _loc_17, _loc_17, param4];
            }
            if (param3 >= param1.width - param2.width)
            {
                _loc_16 = [0, param2.left, param3 - (param1.width - param2.right), param3];
            }
            else
            {
                _loc_17 = param2.left / (param1.width - param2.right);
                _loc_17 = param3 * _loc_17 / (1 + _loc_17);
                _loc_16 = [0, _loc_17, _loc_17, param3];
            }
            var _loc_7:* = new Matrix();
            _loc_15 = 0;
            while (_loc_15 < 3)
            {
                
                _loc_18 = 0;
                while (_loc_18 < 3)
                {
                    
                    _loc_9 = new Rectangle(_loc_19[_loc_15], _loc_12[_loc_18], _loc_19[(_loc_15 + 1)] - _loc_19[_loc_15], _loc_12[(_loc_18 + 1)] - _loc_12[_loc_18]);
                    _loc_11 = new Rectangle(_loc_16[_loc_15], _loc_14[_loc_18], _loc_16[(_loc_15 + 1)] - _loc_16[_loc_15], _loc_14[(_loc_18 + 1)] - _loc_14[_loc_18]);
                    _loc_10 = tileIndice[_loc_18 * 3 + _loc_15];
                    if (_loc_10 != -1 && (param6 & 1 << _loc_10) != 0)
                    {
                        _loc_13 = tileBitmap(param1, _loc_9, _loc_11.width, _loc_11.height);
                        _loc_8.copyPixels(_loc_13, _loc_13.rect, _loc_11.topLeft);
                        _loc_13.dispose();
                    }
                    else
                    {
                        _loc_7.identity();
                        _loc_7.a = _loc_11.width / _loc_9.width;
                        _loc_7.d = _loc_11.height / _loc_9.height;
                        _loc_7.tx = _loc_11.x - _loc_9.x * _loc_7.a;
                        _loc_7.ty = _loc_11.y - _loc_9.y * _loc_7.d;
                        _loc_8.draw(param1, _loc_7, null, null, _loc_11, param5);
                    }
                    _loc_18++;
                }
                _loc_15++;
            }
            return _loc_8;
        }// end function

        public static function tileBitmap(param1:BitmapData, param2:Rectangle, param3:int, param4:int) : BitmapData
        {
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            if (param3 == 0 || param4 == 0)
            {
                return new BitmapData(1, 1, param1.transparent, 0);
            }
            var _loc_5:* = new BitmapData(param3, param4, param1.transparent, 0);
            var _loc_9:* = Math.ceil(param3 / param2.width);
            var _loc_10:* = Math.ceil(param4 / param2.height);
            var _loc_6:* = new Point();
            _loc_7 = 0;
            while (_loc_7 < _loc_9)
            {
                
                _loc_8 = 0;
                while (_loc_8 < _loc_10)
                {
                    
                    _loc_6.x = _loc_7 * param2.width;
                    _loc_6.y = _loc_8 * param2.height;
                    _loc_5.copyPixels(param1, param2, _loc_6);
                    _loc_8++;
                }
                _loc_7++;
            }
            return _loc_5;
        }// end function

        public static function displayObjectToGObject(param1:DisplayObject) : GObject
        {
            while (param1 != null && !(param1 is Stage))
            {
                
                if (param1 is UIDisplayObject)
                {
                    return ToolSet.UIDisplayObject(param1).owner;
                }
                param1 = param1.parent;
            }
            return null;
        }// end function

        public static function clamp(param1:Number, param2:Number, param3:Number) : Number
        {
            if (ToolSet.isNaN(param1) || param1 < param2)
            {
                param1 = param2;
            }
            else if (param1 > param3)
            {
                param1 = param3;
            }
            return param1;
        }// end function

        public static function clamp01(param1:Number) : Number
        {
            if (ToolSet.isNaN(param1))
            {
                param1 = 0;
            }
            else if (param1 > 1)
            {
                param1 = 1;
            }
            else if (param1 < 0)
            {
                param1 = 0;
            }
            return param1;
        }// end function

        public static function lerp(param1:Number, param2:Number, param3:Number) : Number
        {
            return param1 + param3 * (param2 - param1);
        }// end function

        public static function distance(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return Math.sqrt(Math.pow(param1 - param3, 2) + Math.pow(param2 - param4, 2));
        }// end function

        public static function repeat(param1:Number, param2:Number) : Number
        {
            return param1 - Math.floor(param1 / param2) * param2;
        }// end function

        public static function pointLineDistance(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Boolean) : Number
        {
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = param5 - param3;
            var _loc_13:* = param6 - param4;
            var _loc_8:* = _loc_11 * _loc_11 + _loc_13 * _loc_13;
            var _loc_12:* = ((param1 - param3) * _loc_11 + (param2 - param4) * _loc_13) / _loc_8;
            if (!param7)
            {
                _loc_9 = param3 + _loc_12 * _loc_11;
                _loc_10 = param4 + _loc_12 * _loc_13;
            }
            else if (_loc_8 != 0)
            {
                if (_loc_12 < 0)
                {
                    _loc_9 = param3;
                    _loc_10 = param4;
                }
                else if (_loc_12 > 1)
                {
                    _loc_9 = param5;
                    _loc_10 = param6;
                }
                else
                {
                    _loc_9 = param3 + _loc_12 * _loc_11;
                    _loc_10 = param4 + _loc_12 * _loc_13;
                }
            }
            else
            {
                _loc_9 = param3;
                _loc_10 = param4;
            }
            _loc_11 = param1 - _loc_9;
            _loc_13 = param2 - _loc_10;
            return Math.sqrt(_loc_11 * _loc_11 + _loc_13 * _loc_13);
        }// end function

    }
}
