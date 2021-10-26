package com.hurlant.util
{
    import flash.utils.*;

    public class Hex extends Object
    {

        public function Hex()
        {
            return;
        }// end function

        public static function fromString(param1:String, param2:Boolean = false) : String
        {
            var _loc_3:* = null;
            _loc_3 = new ByteArray();
            _loc_3.writeUTFBytes(param1);
            return fromArray(_loc_3, param2);
        }// end function

        public static function toString(param1:String) : String
        {
            var _loc_2:* = null;
            _loc_2 = toArray(param1);
            return _loc_2.readUTFBytes(_loc_2.length);
        }// end function

        public static function toArray(param1:String) : ByteArray
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            param1 = param1.replace(/\s|:/gm, "");
            _loc_2 = new ByteArray();
            if (param1.length & 1 == 1)
            {
                param1 = "0" + param1;
            }
            _loc_3 = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2[_loc_3 / 2] = parseInt(param1.substr(_loc_3, 2), 16);
                _loc_3 = _loc_3 + 2;
            }
            return _loc_2;
        }// end function

        public static function fromArray(param1:ByteArray, param2:Boolean = false) : String
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            _loc_3 = "";
            _loc_4 = 0;
            while (_loc_4 < param1.length)
            {
                
                _loc_3 = _loc_3 + ("0" + param1[_loc_4].toString(16)).substr(-2, 2);
                if (param2)
                {
                    if (_loc_4 < (param1.length - 1))
                    {
                        _loc_3 = _loc_3 + ":";
                    }
                }
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

    }
}
