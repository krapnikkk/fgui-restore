package com.hurlant.util
{
    import *.*;
    import flash.utils.*;

    public class Base64 extends Object
    {
        public static const version:String = "1.0.0";
        private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

        public function Base64()
        {
            throw new Error("Base64 class is static container only");
        }// end function

        public static function encode(param1:String) : String
        {
            var _loc_2:* = null;
            _loc_2 = new ByteArray();
            _loc_2.writeUTFBytes(param1);
            return encodeByteArray(_loc_2);
        }// end function

        public static function encodeByteArray(param1:ByteArray) : String
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            _loc_2 = "";
            _loc_4 = new Array(4);
            param1.position = 0;
            while (param1.bytesAvailable > 0)
            {
                
                _loc_3 = new Array();
                _loc_5 = 0;
                while (_loc_5 < 3 && param1.bytesAvailable > 0)
                {
                    
                    _loc_3[_loc_5] = param1.readUnsignedByte();
                    _loc_5 = _loc_5 + 1;
                }
                _loc_4[0] = (_loc_3[0] & 252) >> 2;
                _loc_4[1] = (_loc_3[0] & 3) << 4 | _loc_3[1] >> 4;
                _loc_4[2] = (_loc_3[1] & 15) << 2 | _loc_3[2] >> 6;
                _loc_4[3] = _loc_3[2] & 63;
                _loc_6 = _loc_3.length;
                while (_loc_6 < 3)
                {
                    
                    _loc_4[(_loc_6 + 1)] = 64;
                    _loc_6 = _loc_6 + 1;
                }
                _loc_7 = 0;
                while (_loc_7 < _loc_4.length)
                {
                    
                    _loc_2 = _loc_2 + BASE64_CHARS.charAt(_loc_4[_loc_7]);
                    _loc_7 = _loc_7 + 1;
                }
            }
            return _loc_2;
        }// end function

        public static function decode(param1:String) : String
        {
            var _loc_2:* = null;
            _loc_2 = decodeToByteArray(param1);
            return _loc_2.readUTFBytes(_loc_2.length);
        }// end function

        public static function decodeToByteArray(param1:String) : ByteArray
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            _loc_2 = new ByteArray();
            _loc_3 = new Array(4);
            _loc_4 = new Array(3);
            _loc_5 = 0;
            while (_loc_5 < param1.length)
            {
                
                _loc_6 = 0;
                while (_loc_6 < 4 && _loc_5 + _loc_6 < param1.length)
                {
                    
                    _loc_3[_loc_6] = BASE64_CHARS.indexOf(param1.charAt(_loc_5 + _loc_6));
                    _loc_6 = _loc_6 + 1;
                }
                _loc_4[0] = (_loc_3[0] << 2) + ((_loc_3[1] & 48) >> 4);
                _loc_4[1] = ((_loc_3[1] & 15) << 4) + ((_loc_3[2] & 60) >> 2);
                _loc_4[2] = ((_loc_3[2] & 3) << 6) + _loc_3[3];
                _loc_7 = 0;
                while (_loc_7 < _loc_4.length)
                {
                    
                    if (_loc_3[(_loc_7 + 1)] == 64)
                    {
                        break;
                    }
                    _loc_2.writeByte(_loc_4[_loc_7]);
                    _loc_7 = _loc_7 + 1;
                }
                _loc_5 = _loc_5 + 4;
            }
            _loc_2.position = 0;
            return _loc_2;
        }// end function

    }
}
