package fairygui.utils
{
    import *.*;

    public class UtilsStr extends Object
    {
        private static const FIX:String = int(Math.random() * 36).toString(36).substr(0, 1);

        public function UtilsStr()
        {
            return;
        }// end function

        public static function getFileName(param1:String) : String
        {
            var _loc_2:* = param1.lastIndexOf("/");
            if (_loc_2 != -1)
            {
                param1 = param1.substr((_loc_2 + 1));
            }
            _loc_2 = param1.lastIndexOf("\\");
            if (_loc_2 != -1)
            {
                param1 = param1.substr((_loc_2 + 1));
            }
            _loc_2 = param1.lastIndexOf(".");
            if (_loc_2 != -1)
            {
                return param1.substring(0, _loc_2);
            }
            return param1;
        }// end function

        public static function replaceFileName(param1:String, param2:String) : String
        {
            var _loc_3:* = getFileExt(param1, true);
            return param2 + (_loc_3 ? ("." + _loc_3) : (""));
        }// end function

        public static function getFileExt(param1:String, param2:Boolean = false) : String
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_3:* = param1.lastIndexOf("?");
            if (_loc_3 != -1)
            {
                _loc_4 = param1.lastIndexOf(".", _loc_3);
                if (_loc_4 != -1)
                {
                    _loc_5 = param1.substring((_loc_4 + 1), _loc_3);
                }
                else
                {
                    _loc_5 = "";
                }
            }
            else
            {
                _loc_4 = param1.lastIndexOf(".");
                if (_loc_4 != -1)
                {
                    _loc_5 = param1.substr((_loc_4 + 1));
                }
                else
                {
                    _loc_5 = "";
                }
            }
            if (!param2)
            {
                _loc_5 = _loc_5.toLowerCase();
            }
            return _loc_5;
        }// end function

        public static function removeFileExt(param1:String) : String
        {
            var _loc_2:* = param1.lastIndexOf(".");
            if (_loc_2 != -1)
            {
                return param1.substring(0, _loc_2);
            }
            return param1;
        }// end function

        public static function replaceFileExt(param1:String, param2:String) : String
        {
            if (param2)
            {
                param2 = "." + param2;
            }
            var _loc_3:* = param1.lastIndexOf(".");
            if (_loc_3 != -1)
            {
                return param1.substring(0, _loc_3) + param2;
            }
            return param1 + param2;
        }// end function

        public static function removeURLParam(param1:String) : String
        {
            var _loc_2:* = param1.lastIndexOf("?");
            if (_loc_2 != -1)
            {
                return param1.substr(0, _loc_2);
            }
            return param1;
        }// end function

        public static function getFileFullName(param1:String) : String
        {
            var _loc_2:* = param1.lastIndexOf("/");
            if (_loc_2 != -1)
            {
                param1 = param1.substr((_loc_2 + 1));
            }
            _loc_2 = param1.lastIndexOf("\\");
            if (_loc_2 != -1)
            {
                param1 = param1.substr((_loc_2 + 1));
            }
            return param1;
        }// end function

        public static function getFilePath(param1:String) : String
        {
            var _loc_2:* = param1.lastIndexOf("/");
            if (_loc_2 != -1)
            {
                param1 = param1.substring(0, _loc_2);
            }
            _loc_2 = param1.lastIndexOf("\\");
            if (_loc_2 != -1)
            {
                param1 = param1.substring(0, _loc_2);
            }
            return param1;
        }// end function

        public static function padString(param1:String, param2:int, param3:String) : String
        {
            var _loc_4:* = param1.length;
            var _loc_5:* = param1.length;
            while (_loc_5 < param2)
            {
                
                param1 = param3 + param1;
                _loc_5++;
            }
            return param1;
        }// end function

        public static function trim(param1:String) : String
        {
            return trimLeft(trimRight(param1));
        }// end function

        public static function trimLeft(param1:String) : String
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2 = param1.charCodeAt(_loc_3);
                if (_loc_2 != 32 && _loc_2 != 9 && _loc_2 != 13 && _loc_2 != 10)
                {
                    break;
                }
                _loc_3++;
            }
            return param1.substr(_loc_3);
        }// end function

        public static function trimRight(param1:String) : String
        {
            var _loc_2:* = 0;
            var _loc_3:* = param1.length - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_2 = param1.charCodeAt(_loc_3);
                if (_loc_2 != 32 && _loc_2 != 9 && _loc_2 != 13 && _loc_2 != 10)
                {
                    break;
                }
                _loc_3 = _loc_3 - 1;
            }
            return param1.substring(0, (_loc_3 + 1));
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

        public static function generateUID() : String
        {
            var _loc_1:* = "0000" + int(Math.random() * 1679616).toString(36);
            var _loc_2:* = "000" + int(Math.random() * 46656).toString(36);
            return FIX + _loc_1.substr(_loc_1.length - 4) + _loc_2.substr(_loc_2.length - 3);
        }// end function

        public static function convertToHtmlColor(param1:uint, param2:Boolean = false) : String
        {
            var _loc_3:* = null;
            if (param2)
            {
                _loc_3 = (param1 >> 24 & 255).toString(16);
            }
            else
            {
                _loc_3 = "";
            }
            var _loc_4:* = (param1 >> 16 & 255).toString(16);
            var _loc_5:* = (param1 >> 8 & 255).toString(16);
            var _loc_6:* = (param1 & 255).toString(16);
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
            if (_loc_6.length == 1)
            {
                _loc_6 = "0" + _loc_6;
            }
            return "#" + _loc_3 + _loc_4 + _loc_5 + _loc_6;
        }// end function

        public static function convertFromHtmlColor(param1:String, param2:Boolean = false) : uint
        {
            if (param1 == null || param1.length < 1 || param1.charAt(0) != "#")
            {
                return 0;
            }
            if (param1.length == 9)
            {
                return (parseInt(param1.substr(1, 2), 16) << 24) + parseInt(param1.substr(3), 16);
            }
            if (param2)
            {
                return 4278190080 + parseInt(param1.substr(1), 16);
            }
            return parseInt(param1.substr(1), 16);
        }// end function

        public static function formatPrice(param1:String) : String
        {
            if (!param1)
            {
                return "";
            }
            if (param1.length < 4)
            {
                return param1;
            }
            var _loc_2:* = param1.length;
            var _loc_3:* = param1.length % 3;
            var _loc_4:* = "";
            _loc_4 = "" + param1.substring(0, _loc_3);
            while (_loc_3 < _loc_2)
            {
                
                if (_loc_4.length > 0)
                {
                    _loc_4 = _loc_4 + ",";
                }
                _loc_4 = _loc_4 + param1.substr(_loc_3, 3);
                _loc_3 = _loc_3 + 3;
            }
            return _loc_4;
        }// end function

        public static function formatString(param1:String, ... args) : String
        {
            args = new activation;
            var format:* = param1;
            var params:* = args;
            if (UtilsStr.length == 0)
            {
                return ;
            }
            var re:* = /\{(\d+)\}/g;
            return UtilsStr.replace(, function () : String
            {
                if (params[arguments[1]] == null)
                {
                    throw new ArgumentError("argument missing " + arguments[1]);
                }
                return params[arguments[1]];
            }// end function
            );
        }// end function

        public static function formatStringByName(param1:String, param2:Object) : String
        {
            var _loc_3:* = null;
            for (_loc_3 in param2)
            {
                
                param1 = param1.replace(new RegExp("\\{" + _loc_3 + "\\}", "gm"), _loc_5[_loc_3]);
            }
            return param1;
        }// end function

        public static function getSizeName(param1:int, param2:int = 2) : String
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            if (param1 < 1024)
            {
                return param1 + "B";
            }
            if (param2)
            {
                param2++;
            }
            if (param1 < 1024 * 1024)
            {
                _loc_3 = "" + param1 / 1024;
                _loc_4 = _loc_3.lastIndexOf(".");
                if (_loc_4 < _loc_3.length - param2)
                {
                    _loc_3 = _loc_3.substr(0, _loc_4 + param2);
                }
                _loc_3 = _loc_3 + "K";
            }
            else
            {
                _loc_3 = "" + param1 / (1024 * 1024);
                _loc_4 = _loc_3.lastIndexOf(".");
                if (_loc_4 < _loc_3.length - param2)
                {
                    _loc_3 = _loc_3.substr(0, _loc_4 + param2);
                }
                _loc_3 = _loc_3 + "M";
            }
            return _loc_3;
        }// end function

        public static function encodeXML(param1:String) : String
        {
            if (!param1)
            {
                return "";
            }
            return param1.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/'/g, "&apos;");
        }// end function

        public static function decodeXML(param1:String) : String
        {
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_2:* = param1.length;
            var _loc_3:* = "";
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            while (true)
            {
                
                _loc_5 = param1.indexOf("&", _loc_4);
                if (_loc_5 == -1)
                {
                    _loc_3 = _loc_3 + param1.substr(_loc_4);
                    break;
                }
                _loc_3 = _loc_3 + param1.substr(_loc_4, _loc_5 - _loc_4);
                _loc_5 = _loc_5 + 1;
                _loc_6 = Math.min(_loc_2, _loc_5 + 10);
                while (_loc_5 < _loc_6)
                {
                    
                    if (param1.charCodeAt(_loc_5) == 59)
                    {
                        break;
                    }
                    _loc_5++;
                }
                if (_loc_5 < _loc_6 && _loc_5 > ++_loc_5)
                {
                    _loc_7 = param1.substr(_loc_4, _loc_5 - _loc_4);
                    _loc_8 = 0;
                    if (_loc_7.charCodeAt(0) == 35)
                    {
                        if (_loc_7.length > 1)
                        {
                            if (_loc_7[1] == "x")
                            {
                                _loc_8 = parseInt(_loc_7.substr(2), 16);
                            }
                            else
                            {
                                _loc_8 = parseInt(_loc_7.substr(1));
                            }
                            _loc_3 = _loc_3 + String.fromCharCode(_loc_8);
                            _loc_4 = _loc_5 + 1;
                        }
                        else
                        {
                            _loc_3 = _loc_3 + "&";
                        }
                    }
                    else
                    {
                        switch(_loc_7)
                        {
                            case "amp":
                            {
                                _loc_8 = 38;
                                break;
                            }
                            case "apos":
                            {
                                _loc_8 = 39;
                                break;
                            }
                            case "gt":
                            {
                                _loc_8 = 62;
                                break;
                            }
                            case "lt":
                            {
                                _loc_8 = 60;
                                break;
                            }
                            case "nbsp":
                            {
                                _loc_8 = 32;
                                break;
                            }
                            case "quot":
                            {
                                _loc_8 = 34;
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                        if (_loc_8 > 0)
                        {
                            _loc_3 = _loc_3 + String.fromCharCode(_loc_8);
                            _loc_4 = _loc_5 + 1;
                        }
                        else
                        {
                            _loc_3 = _loc_3 + "&";
                        }
                    }
                    continue;
                }
                _loc_3 = _loc_3 + "&";
            }
            return _loc_3;
        }// end function

        public static function toFixed(param1:Number, param2:int = 2) : String
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            if (param2 == 0)
            {
                return param1.toFixed(0);
            }
            _loc_3 = param1.toFixed(param2);
            _loc_4 = _loc_3.length;
            _loc_5 = 1;
            while (_loc_5 <= param2)
            {
                
                if (_loc_3.charCodeAt(_loc_4 - _loc_5) != 48)
                {
                    break;
                }
                _loc_5++;
            }
            if (_loc_5 != 1)
            {
                if (_loc_5 > param2)
                {
                    _loc_3 = _loc_3.substr(0, _loc_4 - _loc_5);
                }
                else
                {
                    _loc_3 = _loc_3.substr(0, _loc_4 - _loc_5 + 1);
                }
            }
            return _loc_3;
        }// end function

        public static function getNameFromId(param1:String) : String
        {
            var _loc_2:* = param1.indexOf("_");
            if (_loc_2 != -1)
            {
                return param1.substring(0, _loc_2);
            }
            return param1;
        }// end function

    }
}
