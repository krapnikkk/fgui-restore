package com.codeazur.utils
{
    import flash.utils.*;

    public class BitArray extends ByteArray
    {
        protected var bitsPending:uint = 0;

        public function BitArray()
        {
            return;
        }// end function

        public function readBits(param1:uint, param2:uint = 0) : uint
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            if (param1 == 0)
            {
                return param2;
            }
            if (this.bitsPending > 0)
            {
                _loc_5 = this[(position - 1)] & 255 >> 8 - this.bitsPending;
                _loc_4 = Math.min(this.bitsPending, param1);
                this.bitsPending = this.bitsPending - _loc_4;
                _loc_3 = _loc_5 >> this.bitsPending;
            }
            else
            {
                _loc_4 = Math.min(8, param1);
                this.bitsPending = 8 - _loc_4;
                _loc_3 = readUnsignedByte() >> this.bitsPending;
            }
            param1 = param1 - _loc_4;
            param2 = param2 << _loc_4 | _loc_3;
            return param1 > 0 ? (this.readBits(param1, param2)) : (param2);
        }// end function

        public function writeBits(param1:uint, param2:uint) : void
        {
            var _loc_3:* = 0;
            if (param1 == 0)
            {
                return;
            }
            param2 = param2 & 4294967295 >>> 32 - param1;
            if (this.bitsPending > 0)
            {
                if (this.bitsPending > param1)
                {
                    this[(position - 1)] = this[(position - 1)] | param2 << this.bitsPending - param1;
                    _loc_3 = param1;
                    this.bitsPending = this.bitsPending - param1;
                }
                else if (this.bitsPending == param1)
                {
                    this[(position - 1)] = this[(position - 1)] | param2;
                    _loc_3 = param1;
                    this.bitsPending = 0;
                }
                else
                {
                    this[(position - 1)] = this[(position - 1)] | param2 >> param1 - this.bitsPending;
                    _loc_3 = this.bitsPending;
                    this.bitsPending = 0;
                }
            }
            else
            {
                _loc_3 = Math.min(8, param1);
                this.bitsPending = 8 - _loc_3;
                writeByte(param2 >> param1 - _loc_3 << this.bitsPending);
            }
            param1 = param1 - _loc_3;
            if (param1 > 0)
            {
                this.writeBits(param1, param2);
            }
            return;
        }// end function

        public function resetBitsPending() : void
        {
            this.bitsPending = 0;
            return;
        }// end function

        public function calculateMaxBits(param1:Boolean, param2:Array) : uint
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = int.MIN_VALUE;
            if (!param1)
            {
                for each (_loc_6 in param2)
                {
                    
                    _loc_3 = _loc_3 | _loc_6;
                }
            }
            else
            {
                for each (_loc_7 in param2)
                {
                    
                    if (_loc_7 >= 0)
                    {
                        _loc_3 = _loc_3 | _loc_7;
                    }
                    else
                    {
                        _loc_3 = _loc_3 | ~_loc_7 << 1;
                    }
                    if (_loc_4 < _loc_7)
                    {
                        _loc_4 = _loc_7;
                    }
                }
            }
            _loc_5 = 0;
            if (_loc_3 > 0)
            {
                _loc_5 = _loc_3.toString(2).length;
                if (param1 && _loc_4 > 0 && _loc_4.toString(2).length >= _loc_5)
                {
                    _loc_5 = _loc_5 + 1;
                }
            }
            return _loc_5;
        }// end function

    }
}
