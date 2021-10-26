package com.codeazur.utils
{
    import *.*;

    public class StringUtils extends Object
    {
        private static var i:int = 0;
        private static const SIGN_UNDEF:int = 0;
        private static const SIGN_POS:int = -1;
        private static const SIGN_NEG:int = 1;

        public function StringUtils()
        {
            return;
        }// end function

        public static function trim(param1:String) : String
        {
            return StringUtils.ltrim(StringUtils.rtrim(param1));
        }// end function

        public static function ltrim(param1:String) : String
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            if (param1 != null)
            {
                _loc_2 = param1.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    if (param1.charCodeAt(_loc_3) > 32)
                    {
                        return param1.substring(_loc_3);
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return "";
        }// end function

        public static function rtrim(param1:String) : String
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            if (param1 != null)
            {
                _loc_2 = param1.length;
                _loc_3 = _loc_2;
                while (_loc_3 > 0)
                {
                    
                    if (param1.charCodeAt((_loc_3 - 1)) > 32)
                    {
                        return param1.substring(0, _loc_3);
                    }
                    _loc_3 = _loc_3 - 1;
                }
            }
            return "";
        }// end function

        public static function simpleEscape(param1:String) : String
        {
            param1 = param1.split("\n").join("\\n");
            param1 = param1.split("\r").join("\\r");
            param1 = param1.split("\t").join("\\t");
            param1 = param1.split("\f").join("\\f");
            param1 = param1.split("\b").join("\\b");
            return param1;
        }// end function

        public static function strictEscape(param1:String, param2:Boolean = true) : String
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            if (param1 != null && param1.length > 0)
            {
                if (param2)
                {
                    param1 = StringUtils.trim(param1);
                }
                param1 = encodeURIComponent(param1);
                _loc_3 = param1.split("");
                _loc_4 = 0;
                while (_loc_4 < _loc_3.length)
                {
                    
                    switch(_loc_3[_loc_4])
                    {
                        case "!":
                        {
                            _loc_3[_loc_4] = "%21";
                            break;
                        }
                        case "\'":
                        {
                            _loc_3[_loc_4] = "%27";
                            break;
                        }
                        case "(":
                        {
                            _loc_3[_loc_4] = "%28";
                            break;
                        }
                        case ")":
                        {
                            _loc_3[_loc_4] = "%29";
                            break;
                        }
                        case "*":
                        {
                            _loc_3[_loc_4] = "%2A";
                            break;
                        }
                        case "-":
                        {
                            _loc_3[_loc_4] = "%2D";
                            break;
                        }
                        case ".":
                        {
                            _loc_3[_loc_4] = "%2E";
                            break;
                        }
                        case "_":
                        {
                            _loc_3[_loc_4] = "%5F";
                            break;
                        }
                        case "~":
                        {
                            _loc_3[_loc_4] = "%7E";
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _loc_4 = _loc_4 + 1;
                }
                return _loc_3.join("");
            }
            return "";
        }// end function

        public static function repeat(param1:uint, param2:String = " ") : String
        {
            return new Array((param1 + 1)).join(param2);
        }// end function

        public static function printf(param1:String, ... args) : String
        {
            var _loc_7:* = null;
            var _loc_8:* = false;
            var _loc_9:* = false;
            var _loc_10:* = false;
            var _loc_11:* = false;
            var _loc_12:* = false;
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_15:* = null;
            var _loc_16:* = undefined;
            var _loc_17:* = 0;
            var _loc_18:* = 0;
            var _loc_19:* = null;
            var _loc_20:* = NaN;
            var _loc_21:* = 0;
            var _loc_22:* = 0;
            var _loc_23:* = false;
            var _loc_24:* = 0;
            var _loc_25:* = false;
            var _loc_26:* = 0;
            var _loc_27:* = null;
            var _loc_28:* = NaN;
            var _loc_29:* = 0;
            var _loc_30:* = 0;
            var _loc_31:* = 0;
            var _loc_32:* = null;
            args = "";
            var _loc_4:* = 0;
            var _loc_5:* = -1;
            var _loc_6:* = "diufFeEgGxXoscpn";
            i = 0;
            while (i < param1.length)
            {
                
                _loc_7 = param1.charAt(i);
                if (_loc_7 == "%")
                {
                    i = (i + 1);
                    if (i < param1.length)
                    {
                        _loc_7 = param1.charAt(i);
                        if (_loc_7 == "%")
                        {
                            args = args + _loc_7;
                        }
                        else
                        {
                            _loc_8 = false;
                            _loc_9 = false;
                            _loc_10 = false;
                            _loc_11 = false;
                            _loc_12 = false;
                            _loc_13 = -1;
                            _loc_14 = -1;
                            _loc_15 = "";
                            _loc_18 = getIndex(param1);
                            if (_loc_18 < -1 || _loc_18 == 0)
                            {
                                trace("ERR parsing index");
                                break;
                            }
                            else if (_loc_18 == -1)
                            {
                                if (_loc_5 == 1)
                                {
                                    trace("ERR: indexed placeholder expected");
                                    break;
                                }
                                if (_loc_5 == -1)
                                {
                                    _loc_5 = 0;
                                }
                                _loc_4++;
                            }
                            else
                            {
                                if (_loc_5 == 0)
                                {
                                    trace("ERR: non-indexed placeholder expected");
                                    break;
                                }
                                if (_loc_5 == -1)
                                {
                                    _loc_5 = 1;
                                }
                                _loc_4 = _loc_18;
                            }
                            do
                            {
                                
                                switch(_loc_7)
                                {
                                    case "+":
                                    {
                                        _loc_8 = true;
                                        break;
                                    }
                                    case "-":
                                    {
                                        _loc_9 = true;
                                        break;
                                    }
                                    case "#":
                                    {
                                        _loc_10 = true;
                                        break;
                                    }
                                    case " ":
                                    {
                                        _loc_11 = true;
                                        break;
                                    }
                                    case "0":
                                    {
                                        _loc_12 = true;
                                        break;
                                    }
                                    default:
                                    {
                                        break;
                                    }
                                }
                                i = (i + 1);
                                if (i == param1.length)
                                {
                                    break;
                                }
                                _loc_7 = param1.charAt(i);
                                var _loc_33:* = param1.charAt(i);
                                _loc_7 = param1.charAt(i);
                            }while (_loc_33 == "+" || _loc_7 == "-" || _loc_7 == "#" || _loc_7 == " " || _loc_7 == "0")
                            if (i == param1.length)
                            {
                                break;
                            }
                            if (_loc_7 == "*")
                            {
                                _loc_24 = 0;
                                i = (i + 1);
                                if (i == param1.length)
                                {
                                    break;
                                }
                                _loc_18 = getIndex(param1);
                                if (_loc_18 < -1 || _loc_18 == 0)
                                {
                                    trace("ERR parsing index for width");
                                    break;
                                }
                                else if (_loc_18 == -1)
                                {
                                    if (_loc_5 == 1)
                                    {
                                        trace("ERR: indexed placeholder expected for width");
                                        break;
                                    }
                                    if (_loc_5 == -1)
                                    {
                                        _loc_5 = 0;
                                    }
                                    _loc_24 = _loc_4 + 1;
                                }
                                else
                                {
                                    if (_loc_5 == 0)
                                    {
                                        trace("ERR: non-indexed placeholder expected for width");
                                        break;
                                    }
                                    if (_loc_5 == -1)
                                    {
                                        _loc_5 = 1;
                                    }
                                    _loc_24 = _loc_18;
                                }
                                _loc_24 = _loc_24 - 1;
                                if (args.length > _loc_24 && _loc_24 >= 0)
                                {
                                    _loc_13 = parseInt(args[_loc_24]);
                                    if (isNaN(_loc_13))
                                    {
                                        _loc_13 = -1;
                                        trace("ERR NaN while parsing width");
                                        break;
                                    }
                                }
                                else
                                {
                                    trace("ERR index out of bounds while parsing width");
                                    break;
                                }
                                _loc_7 = param1.charAt(i);
                            }
                            else
                            {
                                _loc_25 = false;
                                while (_loc_7 >= "0" && _loc_7 <= "9")
                                {
                                    
                                    if (_loc_13 == -1)
                                    {
                                        _loc_13 = 0;
                                    }
                                    _loc_13 = _loc_13 * 10 + uint(_loc_7);
                                    i = (i + 1);
                                    if (i == param1.length)
                                    {
                                        break;
                                    }
                                    _loc_7 = param1.charAt(i);
                                }
                                if (_loc_13 != -1 && i == param1.length)
                                {
                                    trace("ERR eof while parsing width");
                                    break;
                                }
                            }
                            if (_loc_7 == ".")
                            {
                                i = (i + 1);
                                if (i == param1.length)
                                {
                                    break;
                                }
                                _loc_7 = param1.charAt(i);
                                if (_loc_7 == "*")
                                {
                                    _loc_26 = 0;
                                    i = (i + 1);
                                    if (i == param1.length)
                                    {
                                        break;
                                    }
                                    _loc_18 = getIndex(param1);
                                    if (_loc_18 < -1 || _loc_18 == 0)
                                    {
                                        trace("ERR parsing index for precision");
                                        break;
                                    }
                                    else if (_loc_18 == -1)
                                    {
                                        if (_loc_5 == 1)
                                        {
                                            trace("ERR: indexed placeholder expected for precision");
                                            break;
                                        }
                                        if (_loc_5 == -1)
                                        {
                                            _loc_5 = 0;
                                        }
                                        _loc_26 = _loc_4 + 1;
                                    }
                                    else
                                    {
                                        if (_loc_5 == 0)
                                        {
                                            trace("ERR: non-indexed placeholder expected for precision");
                                            break;
                                        }
                                        if (_loc_5 == -1)
                                        {
                                            _loc_5 = 1;
                                        }
                                        _loc_26 = _loc_18;
                                    }
                                    _loc_26 = _loc_26 - 1;
                                    if (args.length > _loc_26 && _loc_26 >= 0)
                                    {
                                        _loc_14 = parseInt(args[_loc_26]);
                                        if (isNaN(_loc_14))
                                        {
                                            _loc_14 = -1;
                                            trace("ERR NaN while parsing precision");
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        trace("ERR index out of bounds while parsing precision");
                                        break;
                                    }
                                    _loc_7 = param1.charAt(i);
                                }
                                else
                                {
                                    while (_loc_7 >= "0" && _loc_7 <= "9")
                                    {
                                        
                                        if (_loc_14 == -1)
                                        {
                                            _loc_14 = 0;
                                        }
                                        _loc_14 = _loc_14 * 10 + uint(_loc_7);
                                        i = (i + 1);
                                        if (i == param1.length)
                                        {
                                            break;
                                        }
                                        _loc_7 = param1.charAt(i);
                                    }
                                    if (_loc_14 != -1 && i == param1.length)
                                    {
                                        trace("ERR eof while parsing precision");
                                        break;
                                    }
                                }
                            }
                            switch(_loc_7)
                            {
                                case "h":
                                case "l":
                                {
                                    i = (i + 1);
                                    if (i == param1.length)
                                    {
                                        trace("ERR eof after length");
                                        break;
                                    }
                                    _loc_27 = param1.charAt(i);
                                    if (_loc_7 == "h" && _loc_27 == "h" || _loc_7 == "l" && _loc_27 == "l")
                                    {
                                        i = (i + 1);
                                        if (i == param1.length)
                                        {
                                            trace("ERR eof after length");
                                            break;
                                        }
                                        _loc_7 = param1.charAt(i);
                                    }
                                    else
                                    {
                                        _loc_7 = _loc_27;
                                    }
                                    break;
                                }
                                case "L":
                                case "z":
                                case "j":
                                case "t":
                                {
                                    i = (i + 1);
                                    if (i == param1.length)
                                    {
                                        trace("ERR eof after length");
                                        break;
                                    }
                                    _loc_7 = param1.charAt(i);
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                            if (_loc_6.indexOf(_loc_7) >= 0)
                            {
                                _loc_15 = _loc_7;
                            }
                            else
                            {
                                trace("ERR unknown type: " + _loc_7);
                                break;
                            }
                            if (args.length >= _loc_4 && _loc_4 > 0)
                            {
                                _loc_16 = args[(_loc_4 - 1)];
                            }
                            else
                            {
                                trace("ERR value index out of bounds (" + _loc_4 + ")");
                                break;
                            }
                            _loc_22 = SIGN_UNDEF;
                            switch(_loc_15)
                            {
                                case "s":
                                {
                                    _loc_19 = _loc_16.toString();
                                    if (_loc_14 != -1)
                                    {
                                        _loc_19 = _loc_19.substr(0, _loc_14);
                                    }
                                    break;
                                }
                                case "c":
                                {
                                    _loc_19 = _loc_16.toString().getAt(0);
                                    break;
                                }
                                case "d":
                                case "i":
                                {
                                    _loc_21 = typeof(_loc_16) == "number" ? (int(_loc_16)) : (parseInt(_loc_16));
                                    _loc_19 = Math.abs(_loc_21).toString();
                                    _loc_22 = _loc_21 < 0 ? (SIGN_NEG) : (SIGN_POS);
                                    break;
                                }
                                case "u":
                                {
                                    _loc_19 = (typeof(_loc_16) == "number" ? (uint(_loc_16)) : (uint(parseInt(_loc_16)))).toString();
                                    break;
                                }
                                case "f":
                                case "F":
                                case "e":
                                case "E":
                                case "g":
                                case "G":
                                {
                                    if (_loc_14 == -1)
                                    {
                                        _loc_14 = 6;
                                    }
                                    _loc_28 = Math.pow(10, _loc_14);
                                    _loc_20 = typeof(_loc_16) == "number" ? (Number(_loc_16)) : (parseFloat(_loc_16));
                                    _loc_19 = (Math.round(Math.abs(_loc_20) * _loc_28) / _loc_28).toString();
                                    if (_loc_14 > 0)
                                    {
                                        _loc_30 = _loc_19.indexOf(".");
                                        if (_loc_30 == -1)
                                        {
                                            _loc_19 = _loc_19 + ".";
                                            _loc_29 = _loc_14;
                                        }
                                        else
                                        {
                                            _loc_29 = _loc_14 - (_loc_19.length - _loc_30 - 1);
                                        }
                                        _loc_17 = 0;
                                        while (_loc_17 < _loc_29)
                                        {
                                            
                                            _loc_19 = _loc_19 + "0";
                                            _loc_17++;
                                        }
                                    }
                                    _loc_22 = _loc_20 < 0 ? (SIGN_NEG) : (SIGN_POS);
                                    break;
                                }
                                case "x":
                                case "X":
                                case "p":
                                {
                                    _loc_19 = (typeof(_loc_16) == "number" ? (uint(_loc_16)) : (parseInt(_loc_16))).toString(16);
                                    if (_loc_15 == "X")
                                    {
                                        _loc_19 = _loc_19.toUpperCase();
                                    }
                                    break;
                                }
                                case "o":
                                {
                                    _loc_19 = (typeof(_loc_16) == "number" ? (uint(_loc_16)) : (parseInt(_loc_16))).toString(8);
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                            _loc_23 = _loc_22 == SIGN_NEG || _loc_8 || _loc_11;
                            if (_loc_13 > -1)
                            {
                                _loc_31 = _loc_13 - _loc_19.length;
                                if (_loc_23)
                                {
                                    _loc_31 = _loc_31 - 1;
                                }
                                if (_loc_31 > 0)
                                {
                                    _loc_32 = _loc_12 && !_loc_9 ? ("0") : (" ");
                                    if (_loc_9)
                                    {
                                        _loc_17 = 0;
                                        while (_loc_17 < _loc_31)
                                        {
                                            
                                            _loc_19 = _loc_19 + _loc_32;
                                            _loc_17++;
                                        }
                                    }
                                    else
                                    {
                                        _loc_17 = 0;
                                        while (_loc_17 < _loc_31)
                                        {
                                            
                                            _loc_19 = _loc_32 + _loc_19;
                                            _loc_17++;
                                        }
                                    }
                                }
                            }
                            if (_loc_23)
                            {
                                if (_loc_22 == SIGN_POS)
                                {
                                    _loc_19 = (_loc_11 ? (" ") : ("0")) + _loc_19;
                                }
                                else
                                {
                                    _loc_19 = "-" + _loc_19;
                                }
                            }
                            args = args + _loc_19;
                        }
                    }
                    else
                    {
                        args = args + _loc_7;
                    }
                }
                else
                {
                    args = args + _loc_7;
                }
                var _loc_34:* = i + 1;
                i = _loc_34;
            }
            return args;
        }// end function

        private static function getIndex(param1:String) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = false;
            var _loc_4:* = "";
            var _loc_5:* = i;
            do
            {
                
                _loc_3 = true;
                _loc_2 = _loc_2 * 10 + uint(_loc_4);
                i = (i + 1);
                if (i == param1.length)
                {
                    return -2;
                }
                var _loc_6:* = param1.charAt(i);
                _loc_4 = param1.charAt(i);
            }while (_loc_6 >= "0" && _loc_4 <= "9")
            if (_loc_3)
            {
                if (_loc_4 != "$")
                {
                    i = _loc_5;
                    return -1;
                }
                i = (i + 1);
                if (i == param1.length)
                {
                    return -2;
                }
                return _loc_2;
            }
            else
            {
                return -1;
            }
        }// end function

    }
}
