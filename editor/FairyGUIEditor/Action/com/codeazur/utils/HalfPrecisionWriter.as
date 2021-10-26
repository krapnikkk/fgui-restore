package com.codeazur.utils
{
    import com.codeazur.as3swf.*;

    public class HalfPrecisionWriter extends Object
    {

        public function HalfPrecisionWriter()
        {
            return;
        }// end function

        public static function write(param1:Number, param2:SWFData) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            param2.resetBitsPending();
            _loc_10 = param2.position;
            param2.writeDouble(param1);
            param2.position = param2.position - 4;
            _loc_3 = param2.readUnsignedInt();
            param2.position = _loc_10;
            if ((_loc_3 & 2147483647) == 0)
            {
                _loc_9 = _loc_3 >> 16;
            }
            else
            {
                _loc_4 = _loc_3 & 2147483648;
                _loc_5 = _loc_3 & 2146435072;
                _loc_6 = _loc_3 & 1048575;
                if (_loc_5 == 0)
                {
                    _loc_9 = _loc_4 >> 16;
                }
                else if (_loc_5 == 2146435072)
                {
                    if (_loc_6 == 0)
                    {
                        _loc_9 = _loc_4 >> 16 | 31744;
                    }
                    else
                    {
                        _loc_9 = 65024;
                    }
                }
                else
                {
                    _loc_4 = _loc_4 >> 16;
                    _loc_8 = (_loc_5 >> 20) - 1023 + 15;
                    if (_loc_8 >= 31)
                    {
                        _loc_9 = _loc_6 >> 16 | 31744;
                    }
                    else if (_loc_8 <= 0)
                    {
                        if (10 - _loc_8 > 21)
                        {
                            _loc_7 = 0;
                        }
                        else
                        {
                            _loc_6 = _loc_6 | 1048576;
                            _loc_7 = _loc_6 >> 11 - _loc_8;
                            if (_loc_6 >> 10 - _loc_8 & 1)
                            {
                                _loc_7 = _loc_7 + 1;
                            }
                        }
                        _loc_9 = _loc_4 | _loc_7;
                    }
                    else
                    {
                        _loc_5 = _loc_8 << 10;
                        _loc_7 = _loc_6 >> 10;
                        if (_loc_6 & 512)
                        {
                            _loc_9 = (_loc_4 | _loc_5 | _loc_7) + 1;
                        }
                        else
                        {
                            _loc_9 = _loc_4 | _loc_5 | _loc_7;
                        }
                    }
                }
            }
            param2.writeShort(_loc_9);
            param2.length = _loc_10 + 2;
            return;
        }// end function

    }
}
