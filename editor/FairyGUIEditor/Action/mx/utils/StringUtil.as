package mx.utils
{
    import *.*;

    public class StringUtil extends Object
    {
        static const VERSION:String = "4.6.0.23201";

        public function StringUtil()
        {
            return;
        }// end function

        public static function trim(param1:String) : String
        {
            if (param1 == null)
            {
                return "";
            }
            var _loc_2:* = 0;
            while (isWhitespace(param1.charAt(_loc_2)))
            {
                
                _loc_2++;
            }
            var _loc_3:* = param1.length - 1;
            while (isWhitespace(param1.charAt(_loc_3)))
            {
                
                _loc_3 = _loc_3 - 1;
            }
            if (_loc_3 >= _loc_2)
            {
                return param1.slice(_loc_2, (_loc_3 + 1));
            }
            return "";
        }// end function

        public static function trimArrayElements(param1:String, param2:String) : String
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            if (param1 != "" && param1 != null)
            {
                _loc_3 = param1.split(param2);
                _loc_4 = _loc_3.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_3[_loc_5] = StringUtil.trim(_loc_3[_loc_5]);
                    _loc_5++;
                }
                if (_loc_4 > 0)
                {
                    param1 = _loc_3.join(param2);
                }
            }
            return param1;
        }// end function

        public static function isWhitespace(param1:String) : Boolean
        {
            switch(param1)
            {
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                {
                    return true;
                }
                default:
                {
                    return false;
                    break;
                }
            }
        }// end function

        public static function substitute(param1:String, ... args) : String
        {
            var _loc_4:* = null;
            if (param1 == null)
            {
                return "";
            }
            args = args.length;
            if (args == 1 && args[0] is Array)
            {
                _loc_4 = args[0] as Array;
                args = _loc_4.length;
            }
            else
            {
                _loc_4 = args;
            }
            var _loc_5:* = 0;
            while (_loc_5 < args)
            {
                
                param1 = param1.replace(new RegExp("\\{" + _loc_5 + "\\}", "g"), _loc_4[_loc_5]);
                _loc_5++;
            }
            return param1;
        }// end function

        public static function repeat(param1:String, param2:int) : String
        {
            if (param2 == 0)
            {
                return "";
            }
            var _loc_3:* = param1;
            var _loc_4:* = 1;
            while (_loc_4 < param2)
            {
                
                _loc_3 = _loc_3 + param1;
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public static function restrict(param1:String, param2:String) : String
        {
            var _loc_6:* = 0;
            if (param2 == null)
            {
                return param1;
            }
            if (param2 == "")
            {
                return "";
            }
            var _loc_3:* = [];
            var _loc_4:* = param1.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = param1.charCodeAt(_loc_5);
                if (testCharacter(_loc_6, param2))
                {
                    _loc_3.push(_loc_6);
                }
                _loc_5++;
            }
            return String.fromCharCode.apply(null, _loc_3);
        }// end function

        private static function testCharacter(param1:uint, param2:String) : Boolean
        {
            var _loc_9:* = 0;
            var _loc_11:* = false;
            var _loc_3:* = false;
            var _loc_4:* = false;
            var _loc_5:* = false;
            var _loc_6:* = true;
            var _loc_7:* = 0;
            var _loc_8:* = param2.length;
            if (param2.length > 0)
            {
                _loc_9 = param2.charCodeAt(0);
                if (_loc_9 == 94)
                {
                    _loc_3 = true;
                }
            }
            var _loc_10:* = 0;
            while (_loc_10 < _loc_8)
            {
                
                _loc_9 = param2.charCodeAt(_loc_10);
                _loc_11 = false;
                if (!_loc_4)
                {
                    if (_loc_9 == 45)
                    {
                        _loc_5 = true;
                    }
                    else if (_loc_9 == 94)
                    {
                        _loc_6 = !_loc_6;
                    }
                    else if (_loc_9 == 92)
                    {
                        _loc_4 = true;
                    }
                    else
                    {
                        _loc_11 = true;
                    }
                }
                else
                {
                    _loc_11 = true;
                    _loc_4 = false;
                }
                if (_loc_11)
                {
                    if (_loc_5)
                    {
                        if (_loc_7 <= param1 && param1 <= _loc_9)
                        {
                            _loc_3 = _loc_6;
                        }
                        _loc_5 = false;
                        _loc_7 = 0;
                    }
                    else
                    {
                        if (param1 == _loc_9)
                        {
                            _loc_3 = _loc_6;
                        }
                        _loc_7 = _loc_9;
                    }
                }
                _loc_10++;
            }
            return _loc_3;
        }// end function

    }
}
