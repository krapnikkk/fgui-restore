package fairygui.utils
{
    import *.*;
    import flash.utils.*;

    public class OrderedJSONEncoder extends Object
    {
        private static var level:int;

        public function OrderedJSONEncoder()
        {
            return;
        }// end function

        public static function encode(param1) : String
        {
            level = 0;
            return convertToString(param1);
        }// end function

        private static function convertToString(param1) : String
        {
            if (param1 is String)
            {
                return escapeString(param1 as String);
            }
            if (param1 is Number)
            {
                return isFinite(param1 as Number) ? (param1.toString()) : ("null");
            }
            else if (param1 is Boolean)
            {
                return param1 ? ("true") : ("false");
            }
            else
            {
                if (param1 is Array)
                {
                    return arrayToString(param1 as Array);
                }
                if (param1 is Object && param1 != null)
                {
                    return objectToString(param1);
                }
            }
            return "null";
        }// end function

        private static function escapeString(param1:String) : String
        {
            var _loc_3:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_2:* = "";
            var _loc_4:* = param1.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3 = param1.charAt(_loc_5);
                switch(_loc_3)
                {
                    case "\"":
                    {
                        _loc_2 = _loc_2 + "\\\"";
                        break;
                    }
                    case "\\":
                    {
                        _loc_2 = _loc_2 + "\\\\";
                        break;
                    }
                    case "\b":
                    {
                        _loc_2 = _loc_2 + "\\b";
                        break;
                    }
                    case "\f":
                    {
                        _loc_2 = _loc_2 + "\\f";
                        break;
                    }
                    case "\n":
                    {
                        _loc_2 = _loc_2 + "\\n";
                        break;
                    }
                    case "\r":
                    {
                        _loc_2 = _loc_2 + "\\r";
                        break;
                    }
                    case "\t":
                    {
                        _loc_2 = _loc_2 + "\\t";
                        break;
                    }
                    default:
                    {
                        if (_loc_3 < " ")
                        {
                            _loc_6 = _loc_3.charCodeAt(0).toString(16);
                            _loc_7 = _loc_6.length == 2 ? ("00") : ("000");
                            _loc_2 = _loc_2 + ("\\u" + _loc_7 + _loc_6);
                        }
                        else
                        {
                            _loc_2 = _loc_2 + _loc_3;
                        }
                        break;
                    }
                }
                _loc_5++;
            }
            return "\"" + _loc_2 + "\"";
        }// end function

        private static function arrayToString(param1:Array) : String
        {
            var _loc_2:* = "";
            var _loc_3:* = 0;
            while (_loc_3 < param1.length)
            {
                
                if (_loc_2.length > 0)
                {
                    _loc_2 = _loc_2 + ",";
                }
                _loc_2 = _loc_2 + convertToString(param1[_loc_3]);
                _loc_3++;
            }
            return "[" + _loc_2 + "]";
        }// end function

        private static function objectToString(param1:Object) : String
        {
            var padding:String;
            var i:int;
            var str:String;
            var value:Object;
            var key:String;
            var v:XML;
            var o:* = param1;
            var _loc_4:* = level + 1;
            level = _loc_4;
            var keys:Array;
            var result:Array;
            var classInfo:* = describeType(o);
            if (classInfo.@name.toString() == "Object")
            {
                var _loc_3:* = 0;
                var _loc_4:* = o;
                while (_loc_4 in _loc_3)
                {
                    
                    key = _loc_4[_loc_3];
                    keys.push(key);
                }
                keys.sort();
                var _loc_3:* = 0;
                var _loc_4:* = keys;
                while (_loc_4 in _loc_3)
                {
                    
                    key = _loc_4[_loc_3];
                    value = o[key];
                    if (value is Function)
                    {
                        continue;
                    }
                    result.push(escapeString(key) + ":" + convertToString(value));
                }
            }
            else
            {
                var _loc_3:* = 0;
                var _loc_6:* = 0;
                var _loc_7:* = classInfo..*;
                var _loc_5:* = new XMLList("");
                for each (_loc_8 in _loc_7)
                {
                    
                    var _loc_9:* = _loc_7[_loc_6];
                    with (_loc_7[_loc_6])
                    {
                        if (name() == "variable" || name() == "accessor")
                        {
                            _loc_5[_loc_6] = _loc_8;
                        }
                    }
                }
                var _loc_4:* = _loc_5;
                while (_loc_4 in _loc_3)
                {
                    
                    v = _loc_4[_loc_3];
                    keys.push(v.@name.toString());
                }
                keys.sort();
                var _loc_3:* = 0;
                var _loc_4:* = keys;
                while (_loc_4 in _loc_3)
                {
                    
                    key = _loc_4[_loc_3];
                    result.push(escapeString(key) + ":" + convertToString(key));
                }
            }
            padding;
            i;
            while (i < (level - 1))
            {
                
                padding = padding + "\t";
                i = (i + 1);
            }
            if (result.length > 0)
            {
                str = padding + "\t" + result.join(",\n" + padding + "\t");
            }
            else
            {
                str;
            }
            str = "{\n" + str + "\n" + padding + "}";
            var _loc_4:* = level - 1;
            level = _loc_4;
            return str;
        }// end function

    }
}
