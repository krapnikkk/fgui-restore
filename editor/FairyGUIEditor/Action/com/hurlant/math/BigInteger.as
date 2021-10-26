package com.hurlant.math
{
    import *.*;
    import com.hurlant.crypto.prng.*;
    import com.hurlant.util.*;
    import flash.utils.*;

    public class BigInteger extends Object
    {
        var a:Array;
        var s:int;
        public var t:int;
        public static const ONE:BigInteger = nbv(1);
        public static const ZERO:BigInteger = nbv(0);
        public static const DM:int = DV - 1;
        public static const F1:int = 22;
        public static const F2:int = 8;
        public static const lplim:int = (1 << 26) / lowprimes[(lowprimes.length - 1)];
        public static const lowprimes:Array = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509];
        public static const FV:Number = Math.pow(2, BI_FP);
        public static const BI_FP:int = 52;
        public static const DV:int = 1 << DB;
        public static const DB:int = 30;

        public function BigInteger(param1 = null, param2:int = 0)
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            a = new Array();
            if (param1 is String)
            {
                param1 = Hex.toArray(param1);
                param2 = 0;
            }
            if (param1 is ByteArray)
            {
                _loc_3 = param1 as ByteArray;
                _loc_4 = param2 || _loc_3.length - _loc_3.position;
                fromArray(_loc_3, _loc_4);
            }
            return;
        }// end function

        public function clearBit(param1:int) : BigInteger
        {
            return changeBit(param1, op_andnot);
        }// end function

        public function negate() : BigInteger
        {
            var _loc_1:* = null;
            _loc_1 = nbi();
            ZERO.subTo(this, _loc_1);
            return _loc_1;
        }// end function

        public function andNot(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            bitwiseTo(param1, op_andnot, _loc_2);
            return _loc_2;
        }// end function

        public function modPow(param1:BigInteger, param2:BigInteger) : BigInteger
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = false;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            _loc_3 = param1.bitLength();
            _loc_5 = nbv(1);
            if (_loc_3 <= 0)
            {
                return _loc_5;
            }
            if (_loc_3 < 18)
            {
                _loc_4 = 1;
            }
            else if (_loc_3 < 48)
            {
                _loc_4 = 3;
            }
            else if (_loc_3 < 144)
            {
                _loc_4 = 4;
            }
            else if (_loc_3 < 768)
            {
                _loc_4 = 5;
            }
            else
            {
                _loc_4 = 6;
            }
            if (_loc_3 < 8)
            {
                _loc_6 = new ClassicReduction(param2);
            }
            else if (param2.isEven())
            {
                _loc_6 = new BarrettReduction(param2);
            }
            else
            {
                _loc_6 = new MontgomeryReduction(param2);
            }
            _loc_7 = [];
            _loc_8 = 3;
            _loc_9 = _loc_4 - 1;
            _loc_10 = (1 << _loc_4) - 1;
            _loc_7[1] = _loc_6.convert(this);
            if (_loc_4 > 1)
            {
                _loc_16 = new BigInteger();
                _loc_6.sqrTo(_loc_7[1], _loc_16);
                while (_loc_8 <= _loc_10)
                {
                    
                    _loc_7[_loc_8] = new BigInteger();
                    _loc_6.mulTo(_loc_16, _loc_7[_loc_8 - 2], _loc_7[_loc_8]);
                    _loc_8 = _loc_8 + 2;
                }
            }
            _loc_11 = param1.t - 1;
            _loc_13 = true;
            _loc_14 = new BigInteger();
            _loc_3 = nbits(param1.a[_loc_11]) - 1;
            while (_loc_11 >= 0)
            {
                
                if (_loc_3 >= _loc_9)
                {
                    _loc_12 = param1.a[_loc_11] >> _loc_3 - _loc_9 & _loc_10;
                }
                else
                {
                    _loc_12 = (param1.a[_loc_11] & (1 << (_loc_3 + 1)) - 1) << _loc_9 - _loc_3;
                    if (_loc_11 > 0)
                    {
                        _loc_12 = _loc_12 | param1.a[(_loc_11 - 1)] >> DB + _loc_3 - _loc_9;
                    }
                }
                _loc_8 = _loc_4;
                while ((_loc_12 & 1) == 0)
                {
                    
                    _loc_12 = _loc_12 >> 1;
                    _loc_8 = _loc_8 - 1;
                }
                var _loc_17:* = _loc_3 - _loc_8;
                _loc_3 = _loc_3 - _loc_8;
                if (_loc_17 < 0)
                {
                    _loc_3 = _loc_3 + DB;
                    _loc_11 = _loc_11 - 1;
                }
                if (_loc_13)
                {
                    _loc_7[_loc_12].copyTo(_loc_5);
                    _loc_13 = false;
                }
                else
                {
                    while (_loc_8 > 1)
                    {
                        
                        _loc_6.sqrTo(_loc_5, _loc_14);
                        _loc_6.sqrTo(_loc_14, _loc_5);
                        _loc_8 = _loc_8 - 2;
                    }
                    if (_loc_8 > 0)
                    {
                        _loc_6.sqrTo(_loc_5, _loc_14);
                    }
                    else
                    {
                        _loc_15 = _loc_5;
                        _loc_5 = _loc_14;
                        _loc_14 = _loc_15;
                    }
                    _loc_6.mulTo(_loc_14, _loc_7[_loc_12], _loc_5);
                }
                while (_loc_11 >= 0 && (param1.a[_loc_11] & 1 << --_loc_3) == 0)
                {
                    
                    _loc_6.sqrTo(_loc_5, _loc_14);
                    _loc_15 = _loc_5;
                    _loc_5 = _loc_14;
                    _loc_14 = _loc_15;
                    if (--_loc_3 < 0)
                    {
                        --_loc_3 = DB - 1;
                        _loc_11 = _loc_11 - 1;
                    }
                }
            }
            return _loc_6.revert(_loc_5);
        }// end function

        public function isProbablePrime(param1:int) : Boolean
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            _loc_3 = abs();
            if (_loc_3.t == 1 && _loc_3.a[0] <= lowprimes[(lowprimes.length - 1)])
            {
                _loc_2 = 0;
                while (_loc_2 < lowprimes.length)
                {
                    
                    if (_loc_3[0] == lowprimes[_loc_2])
                    {
                        return true;
                    }
                    _loc_2++;
                }
                return false;
            }
            if (_loc_3.isEven())
            {
                return false;
            }
            _loc_2 = 1;
            while (_loc_2 < lowprimes.length)
            {
                
                _loc_4 = lowprimes[_loc_2];
                _loc_5 = _loc_2 + 1;
                while (_loc_5 < lowprimes.length && _loc_4 < lplim)
                {
                    
                    _loc_4 = _loc_4 * lowprimes[_loc_5++];
                }
                _loc_4 = _loc_3.modInt(_loc_4);
                while (_loc_2 < _loc_5)
                {
                    
                    if (_loc_4 % lowprimes[_loc_2++] == 0)
                    {
                        return false;
                    }
                }
            }
            return _loc_3.millerRabin(param1);
        }// end function

        private function op_or(param1:int, param2:int) : int
        {
            return param1 | param2;
        }// end function

        public function mod(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = nbi();
            abs().divRemTo(param1, null, _loc_2);
            if (s < 0 && _loc_2.compareTo(ZERO) > 0)
            {
                param1.subTo(_loc_2, _loc_2);
            }
            return _loc_2;
        }// end function

        protected function addTo(param1:BigInteger, param2:BigInteger) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            _loc_3 = 0;
            _loc_4 = 0;
            _loc_5 = Math.min(param1.t, t);
            while (_loc_3 < _loc_5)
            {
                
                _loc_4 = _loc_4 + (this.a[_loc_3] + param1.a[_loc_3]);
                param2.a[++_loc_3] = _loc_4 & DM;
                _loc_4 = _loc_4 >> DB;
            }
            if (param1.t < t)
            {
                _loc_4 = _loc_4 + param1.s;
                while (_loc_3 < t)
                {
                    
                    _loc_4 = _loc_4 + this.a[_loc_3];
                    param2.a[++_loc_3] = _loc_4 & DM;
                    _loc_4 = _loc_4 >> DB;
                }
                _loc_4 = _loc_4 + s;
            }
            else
            {
                _loc_4 = _loc_4 + s;
                while (_loc_3 < param1.t)
                {
                    
                    _loc_4 = _loc_4 + param1.a[_loc_3];
                    param2.a[++_loc_3] = _loc_4 & DM;
                    _loc_4 = _loc_4 >> DB;
                }
                _loc_4 = _loc_4 + param1.s;
            }
            param2.s = _loc_4 < 0 ? (-1) : (0);
            if (_loc_4 > 0)
            {
                param2.a[++_loc_3] = _loc_4;
            }
            else if (_loc_4 < -1)
            {
                param2.a[++_loc_3] = DV + _loc_4;
            }
            param2.t = _loc_3;
            param2.clamp();
            return;
        }// end function

        protected function bitwiseTo(param1:BigInteger, param2:Function, param3:BigInteger) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            _loc_6 = Math.min(param1.t, t);
            _loc_4 = 0;
            while (_loc_4 < _loc_6)
            {
                
                param3.a[_loc_4] = this.param2(this.a[_loc_4], param1.a[_loc_4]);
                _loc_4++;
            }
            if (param1.t < t)
            {
                _loc_5 = param1.s & DM;
                _loc_4 = _loc_6;
                while (_loc_4 < t)
                {
                    
                    param3.a[_loc_4] = this.param2(this.a[_loc_4], _loc_5);
                    _loc_4++;
                }
                param3.t = t;
            }
            else
            {
                _loc_5 = s & DM;
                _loc_4 = _loc_6;
                while (_loc_4 < param1.t)
                {
                    
                    param3.a[_loc_4] = this.param2(_loc_5, param1.a[_loc_4]);
                    _loc_4++;
                }
                param3.t = param1.t;
            }
            param3.s = this.param2(s, param1.s);
            param3.clamp();
            return;
        }// end function

        protected function modInt(param1:int) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            if (param1 <= 0)
            {
                return 0;
            }
            _loc_2 = DV % param1;
            _loc_3 = s < 0 ? ((param1 - 1)) : (0);
            if (t > 0)
            {
                if (_loc_2 == 0)
                {
                    _loc_3 = a[0] % param1;
                }
                else
                {
                    _loc_4 = t - 1;
                    while (_loc_4 >= 0)
                    {
                        
                        _loc_3 = (_loc_2 * _loc_3 + a[_loc_4]) % param1;
                        _loc_4 = _loc_4 - 1;
                    }
                }
            }
            return _loc_3;
        }// end function

        protected function chunkSize(param1:Number) : int
        {
            return Math.floor(Math.LN2 * DB / Math.log(param1));
        }// end function

        function dAddOffset(param1:int, param2:int) : void
        {
            while (t <= param2)
            {
                
                var _loc_3:* = t + 1;
                a[_loc_3] = 0;
            }
            a[param2] = a[param2] + param1;
            while (_loc_3[_loc_2] >= DV)
            {
                
                a[param2] = a[param2] - DV;
                param2 = (param2 + 1);
                if (param2 >= t)
                {
                    var _loc_3:* = t + 1;
                    a[_loc_3] = 0;
                }
                var _loc_3:* = a;
                param2 = param2;
                var _loc_5:* = _loc_3[param2] + 1;
                _loc_3[param2] = _loc_5;
            }
            return;
        }// end function

        function lShiftTo(param1:int, param2:BigInteger) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            _loc_3 = param1 % DB;
            _loc_4 = DB - _loc_3;
            _loc_5 = (1 << _loc_4) - 1;
            _loc_6 = param1 / DB;
            _loc_7 = s << _loc_3 & DM;
            _loc_8 = t - 1;
            while (_loc_8 >= 0)
            {
                
                param2.a[_loc_8 + _loc_6 + 1] = a[_loc_8] >> _loc_4 | _loc_7;
                _loc_7 = (a[_loc_8] & _loc_5) << _loc_3;
                _loc_8 = _loc_8 - 1;
            }
            _loc_8 = _loc_6 - 1;
            while (_loc_8 >= 0)
            {
                
                param2.a[_loc_8] = 0;
                _loc_8 = _loc_8 - 1;
            }
            param2.a[_loc_6] = _loc_7;
            param2.t = t + _loc_6 + 1;
            param2.s = s;
            param2.clamp();
            return;
        }// end function

        public function getLowestSetBit() : int
        {
            var _loc_1:* = 0;
            _loc_1 = 0;
            while (_loc_1 < t)
            {
                
                if (a[_loc_1] != 0)
                {
                    return _loc_1 * DB + lbit(a[_loc_1]);
                }
                _loc_1++;
            }
            if (s < 0)
            {
                return t * DB;
            }
            return -1;
        }// end function

        public function subtract(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            subTo(param1, _loc_2);
            return _loc_2;
        }// end function

        public function primify(param1:int, param2:int) : void
        {
            if (!testBit((param1 - 1)))
            {
                bitwiseTo(BigInteger.ONE.shiftLeft((param1 - 1)), op_or, this);
            }
            if (isEven())
            {
                dAddOffset(1, 0);
            }
            while (!isProbablePrime(param2))
            {
                
                dAddOffset(2, 0);
                while (bitLength() > param1)
                {
                    
                    subTo(BigInteger.ONE.shiftLeft((param1 - 1)), this);
                }
            }
            return;
        }// end function

        public function gcd(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            _loc_2 = s < 0 ? (negate()) : (clone());
            _loc_3 = param1.s < 0 ? (param1.negate()) : (param1.clone());
            if (_loc_2.compareTo(_loc_3) < 0)
            {
                _loc_6 = _loc_2;
                _loc_2 = _loc_3;
                _loc_3 = _loc_6;
            }
            _loc_4 = _loc_2.getLowestSetBit();
            _loc_5 = _loc_3.getLowestSetBit();
            if (_loc_5 < 0)
            {
                return _loc_2;
            }
            if (_loc_4 < _loc_5)
            {
                _loc_5 = _loc_4;
            }
            if (_loc_5 > 0)
            {
                _loc_2.rShiftTo(_loc_5, _loc_2);
                _loc_3.rShiftTo(_loc_5, _loc_3);
            }
            while (_loc_2.sigNum() > 0)
            {
                
                var _loc_7:* = _loc_2.getLowestSetBit();
                _loc_4 = _loc_2.getLowestSetBit();
                if (_loc_7 > 0)
                {
                    _loc_2.rShiftTo(_loc_4, _loc_2);
                }
                var _loc_7:* = _loc_3.getLowestSetBit();
                _loc_4 = _loc_3.getLowestSetBit();
                if (_loc_7 > 0)
                {
                    _loc_3.rShiftTo(_loc_4, _loc_3);
                }
                if (_loc_2.compareTo(_loc_3) >= 0)
                {
                    _loc_2.subTo(_loc_3, _loc_2);
                    _loc_2.rShiftTo(1, _loc_2);
                    continue;
                }
                _loc_3.subTo(_loc_2, _loc_3);
                _loc_3.rShiftTo(1, _loc_3);
            }
            if (_loc_5 > 0)
            {
                _loc_3.lShiftTo(_loc_5, _loc_3);
            }
            return _loc_3;
        }// end function

        function multiplyLowerTo(param1:BigInteger, param2:int, param3:BigInteger) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            _loc_4 = Math.min(t + param1.t, param2);
            param3.s = 0;
            param3.t = _loc_4;
            while (--_loc_4 > 0)
            {
                
                param3.a[--_loc_4] = 0;
            }
            _loc_5 = param3.t - t;
            while (_loc_4 < _loc_5)
            {
                
                param3.a[_loc_4 + t] = am(0, param1.a[_loc_4], param3, _loc_4, 0, t);
                _loc_4++;
            }
            _loc_5 = Math.min(param1.t, param2);
            while (_loc_4 < _loc_5)
            {
                
                am(0, param1.a[_loc_4], param3, _loc_4, 0, param2 - _loc_4);
                _loc_4++;
            }
            param3.clamp();
            return;
        }// end function

        public function modPowInt(param1:int, param2:BigInteger) : BigInteger
        {
            var _loc_3:* = null;
            if (param1 < 256 || param2.isEven())
            {
                _loc_3 = new ClassicReduction(param2);
            }
            else
            {
                _loc_3 = new MontgomeryReduction(param2);
            }
            return exp(param1, _loc_3);
        }// end function

        function intAt(param1:String, param2:int) : int
        {
            return parseInt(param1.charAt(param2), 36);
        }// end function

        public function testBit(param1:int) : Boolean
        {
            var _loc_2:* = 0;
            _loc_2 = Math.floor(param1 / DB);
            if (_loc_2 >= t)
            {
                return s != 0;
            }
            return (a[_loc_2] & 1 << param1 % DB) != 0;
        }// end function

        function exp(param1:int, param2:IReduction) : BigInteger
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            if (param1 > 4294967295 || param1 < 1)
            {
                return ONE;
            }
            _loc_3 = nbi();
            _loc_4 = nbi();
            _loc_5 = param2.convert(this);
            _loc_6 = nbits(param1) - 1;
            _loc_5.copyTo(_loc_3);
            while (--_loc_6 >= 0)
            {
                
                param2.sqrTo(_loc_3, _loc_4);
                if ((param1 & 1 << _loc_6) > 0)
                {
                    param2.mulTo(_loc_4, _loc_5, _loc_3);
                    continue;
                }
                _loc_7 = _loc_3;
                _loc_3 = _loc_4;
                _loc_4 = _loc_7;
            }
            return param2.revert(_loc_3);
        }// end function

        public function toArray(param1:ByteArray) : uint
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = false;
            var _loc_8:* = 0;
            _loc_2 = 8;
            _loc_3 = (1 << 8) - 1;
            _loc_4 = 0;
            _loc_5 = t;
            _loc_6 = DB - _loc_5 * DB % _loc_2;
            _loc_7 = false;
            _loc_8 = 0;
            if (_loc_5-- > 0)
            {
                var _loc_9:* = a[_loc_5] >> _loc_6;
                _loc_4 = a[_loc_5] >> _loc_6;
                if (_loc_6 < DB && _loc_9 > 0)
                {
                    _loc_7 = true;
                    param1.writeByte(_loc_4);
                    _loc_8++;
                }
                while (_loc_5 >= 0)
                {
                    
                    if (_loc_6 < _loc_2)
                    {
                        _loc_4 = (a[_loc_5] & (1 << _loc_6) - 1) << _loc_2 - _loc_6;
                        var _loc_9:* = _loc_6 + (DB - _loc_2);
                        _loc_6 = _loc_6 + (DB - _loc_2);
                        _loc_4 = _loc_4 | a[--_loc_5] >> _loc_9;
                    }
                    else
                    {
                        var _loc_9:* = _loc_6 - _loc_2;
                        _loc_6 = _loc_6 - _loc_2;
                        _loc_4 = a[--_loc_5] >> _loc_9 & _loc_3;
                        if (_loc_6 <= 0)
                        {
                            _loc_6 = _loc_6 + DB;
                            _loc_5 = _loc_5 - 1;
                        }
                    }
                    if (_loc_4 > 0)
                    {
                        _loc_7 = true;
                    }
                    if (_loc_7)
                    {
                        param1.writeByte(_loc_4);
                        _loc_8++;
                    }
                }
            }
            return _loc_8;
        }// end function

        public function dispose() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            _loc_1 = new Random();
            _loc_2 = 0;
            while (_loc_2 < a.length)
            {
                
                a[_loc_2] = _loc_1.nextByte();
                delete a[_loc_2];
                _loc_2 = _loc_2 + 1;
            }
            a = null;
            t = 0;
            s = 0;
            Memory.gc();
            return;
        }// end function

        private function lbit(param1:int) : int
        {
            var _loc_2:* = 0;
            if (param1 == 0)
            {
                return -1;
            }
            _loc_2 = 0;
            if ((param1 & 65535) == 0)
            {
                param1 = param1 >> 16;
                _loc_2 = _loc_2 + 16;
            }
            if ((param1 & 255) == 0)
            {
                param1 = param1 >> 8;
                _loc_2 = _loc_2 + 8;
            }
            if ((param1 & 15) == 0)
            {
                param1 = param1 >> 4;
                _loc_2 = _loc_2 + 4;
            }
            if ((param1 & 3) == 0)
            {
                param1 = param1 >> 2;
                _loc_2 = _loc_2 + 2;
            }
            if ((param1 & 1) == 0)
            {
                _loc_2++;
            }
            return _loc_2;
        }// end function

        function divRemTo(param1:BigInteger, param2:BigInteger = null, param3:BigInteger = null) : void
        {
            var pm:BigInteger;
            var pt:BigInteger;
            var y:BigInteger;
            var ts:int;
            var ms:int;
            var nsh:int;
            var ys:int;
            var y0:int;
            var yt:Number;
            var d1:Number;
            var d2:Number;
            var e:Number;
            var i:int;
            var j:int;
            var t:BigInteger;
            var qd:int;
            var m:* = param1;
            var q:* = param2;
            var r:* = param3;
            pm = m.abs();
            if (pm.t <= 0)
            {
                return;
            }
            pt = abs();
            if (pt.t < pm.t)
            {
                if (q != null)
                {
                    q.fromInt(0);
                }
                if (r != null)
                {
                    copyTo(r);
                }
                return;
            }
            if (r == null)
            {
                r = nbi();
            }
            y = nbi();
            ts = s;
            ms = m.s;
            nsh = DB - nbits(pm.a[(pm.t - 1)]);
            if (nsh > 0)
            {
                pm.lShiftTo(nsh, y);
                pt.lShiftTo(nsh, r);
            }
            else
            {
                pm.copyTo(y);
                pt.copyTo(r);
            }
            ys = y.t;
            y0 = y.a[(ys - 1)];
            if (y0 == 0)
            {
                return;
            }
            yt = y0 * (1 << F1) + (ys > 1 ? (y.a[ys - 2] >> F2) : (0));
            d1 = FV / yt;
            d2 = (1 << F1) / yt;
            e = 1 << F2;
            i = r.t;
            j = i - ys;
            t = q == null ? (nbi()) : (q);
            y.dlShiftTo(j, t);
            if (r.compareTo(t) >= 0)
            {
                var _loc_6:* = r;
                _loc_6.t = _loc_6.t++;
                r.a[_loc_6.t] = 1;
                _loc_6.subTo(t, r);
            }
            ONE.dlShiftTo(ys, t);
            t.subTo(y, y);
            while (_loc_7.t < ys)
            {
                
                var _loc_6:* = 0;
                var _loc_7:* = y;
                var _loc_5:* = new XMLList("");
                for each (_loc_8 in _loc_7)
                {
                    
                    var _loc_9:* = _loc_7[_loc_6];
                    with (_loc_7[_loc_6])
                    {
                        var _loc_10:* = y;
                        var _loc_11:* = _loc_7.t + 1;
                        _loc_10.t = _loc_11;
                        if (0)
                        {
                            _loc_5[_loc_6] = _loc_8;
                        }
                    }
                }
            }
            do
            {
                
                i = (i - 1);
                qd = r.a[(i - 1)] == y0 ? (DM) : (Number(r.a[i]) * d1 + (Number(r.a[(i - 1)]) + e) * d2);
                var _loc_5:* = r.a[i] + _loc_7.am(0, qd, r, j, 0, ys);
                r.a[i] = r.a[i] + _loc_7.am(0, qd, r, j, 0, ys);
                if (_loc_5 < qd)
                {
                    _loc_7.dlShiftTo(j, t);
                    r.subTo(t, r);
                    do
                    {
                        
                        r.subTo(t, r);
                        qd = (qd - 1);
                    }while (r.a[i] < (qd - 1))
                }
                j = (j - 1);
            }while ((j - 1) >= 0)
            if (q != null)
            {
                r.drShiftTo(ys, q);
                if (ts != ms)
                {
                    ZERO.subTo(q, q);
                }
            }
            r.t = ys;
            r.clamp();
            if (nsh > 0)
            {
                r.rShiftTo(nsh, r);
            }
            if (ts < 0)
            {
                ZERO.subTo(r, r);
            }
            return;
        }// end function

        public function remainder(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            divRemTo(param1, null, _loc_2);
            return _loc_2;
        }// end function

        public function divide(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            divRemTo(param1, _loc_2, null);
            return _loc_2;
        }// end function

        public function divideAndRemainder(param1:BigInteger) : Array
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            _loc_2 = new BigInteger();
            _loc_3 = new BigInteger();
            divRemTo(param1, _loc_2, _loc_3);
            return [_loc_2, _loc_3];
        }// end function

        public function valueOf() : Number
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = 0;
            _loc_1 = 1;
            _loc_2 = 0;
            _loc_3 = 0;
            while (_loc_3 < t)
            {
                
                _loc_2 = _loc_2 + a[_loc_3] * _loc_1;
                _loc_1 = _loc_1 * DV;
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        public function shiftLeft(param1:int) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            if (param1 < 0)
            {
                rShiftTo(-param1, _loc_2);
            }
            else
            {
                lShiftTo(param1, _loc_2);
            }
            return _loc_2;
        }// end function

        public function multiply(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            multiplyTo(param1, _loc_2);
            return _loc_2;
        }// end function

        function am(param1:int, param2:int, param3:BigInteger, param4:int, param5:int, param6:int) : int
        {
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            _loc_7 = param2 & 32767;
            _loc_8 = param2 >> 15;
            do
            {
                
                _loc_9 = a[param1] & 32767;
                _loc_10 = a[param1++] >> 15;
                _loc_11 = _loc_8 * _loc_9 + _loc_10 * _loc_7;
                _loc_9 = _loc_7 * _loc_9 + ((_loc_11 & 32767) << 15) + param3.a[param4] + (param5 & 1073741823);
                param5 = (_loc_9 >>> 30) + (_loc_11 >>> 15) + _loc_8 * _loc_10 + (param5 >>> 30);
                param4 = param4++;
                param3.a[param4] = _loc_9 & 1073741823;
                param6 = (param6 - 1);
            }while (param6 >= 0)
            return param5;
        }// end function

        function drShiftTo(param1:int, param2:BigInteger) : void
        {
            var _loc_3:* = 0;
            _loc_3 = param1;
            while (_loc_3 < t)
            {
                
                param2.a[_loc_3 - param1] = a[_loc_3];
                _loc_3++;
            }
            param2.t = Math.max(t - param1, 0);
            param2.s = s;
            return;
        }// end function

        public function add(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            addTo(param1, _loc_2);
            return _loc_2;
        }// end function

        function multiplyUpperTo(param1:BigInteger, param2:int, param3:BigInteger) : void
        {
            var _loc_4:* = 0;
            param2 = param2 - 1;
            var _loc_5:* = t + param1.t - param2;
            param3.t = t + param1.t - param2;
            _loc_4 = _loc_5;
            param3.s = 0;
            while (--_loc_4 >= 0)
            {
                
                param3.a[_loc_4] = 0;
            }
            --_loc_4 = Math.max(param2 - t, 0);
            while (_loc_4 < param1.t)
            {
                
                param3.a[t + --_loc_4 - param2] = am(param2 - _loc_4, param1.a[_loc_4], param3, 0, 0, t + _loc_4 - param2);
                _loc_4++;
            }
            param3.clamp();
            param3.drShiftTo(1, param3);
            return;
        }// end function

        protected function nbi()
        {
            return new BigInteger();
        }// end function

        protected function millerRabin(param1:int) : Boolean
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            _loc_2 = subtract(BigInteger.ONE);
            _loc_3 = _loc_2.getLowestSetBit();
            if (_loc_3 <= 0)
            {
                return false;
            }
            _loc_4 = _loc_2.shiftRight(_loc_3);
            param1 = (param1 + 1) >> 1;
            if (param1 > lowprimes.length)
            {
                param1 = lowprimes.length;
            }
            _loc_5 = new BigInteger();
            _loc_6 = 0;
            while (_loc_6 < param1)
            {
                
                _loc_5.fromInt(lowprimes[_loc_6]);
                _loc_7 = _loc_5.modPow(_loc_4, this);
                if (_loc_7.compareTo(BigInteger.ONE) != 0 && _loc_7.compareTo(_loc_2) != 0)
                {
                    _loc_8 = 1;
                    while (_loc_8++ < _loc_3 && _loc_7.compareTo(_loc_2) != 0)
                    {
                        
                        _loc_7 = _loc_7.modPowInt(2, this);
                        if (_loc_7.compareTo(BigInteger.ONE) == 0)
                        {
                            return false;
                        }
                    }
                    if (_loc_7.compareTo(_loc_2) != 0)
                    {
                        return false;
                    }
                }
                _loc_6++;
            }
            return true;
        }// end function

        function dMultiply(param1:int) : void
        {
            a[t] = am(0, (param1 - 1), this, 0, 0, t);
            var _loc_3:* = t + 1;
            t = _loc_3;
            clamp();
            return;
        }// end function

        private function op_andnot(param1:int, param2:int) : int
        {
            return param1 & ~param2;
        }// end function

        function clamp() : void
        {
            var _loc_1:* = 0;
            _loc_1 = s & DM;
            while (t > 0 && a[(t - 1)] == _loc_1)
            {
                
                var _loc_3:* = t - 1;
                t = _loc_3;
            }
            return;
        }// end function

        function invDigit() : int
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            if (t < 1)
            {
                return 0;
            }
            _loc_1 = a[0];
            if ((_loc_1 & 1) == 0)
            {
                return 0;
            }
            _loc_2 = _loc_1 & 3;
            _loc_2 = _loc_2 * (2 - (_loc_1 & 15) * _loc_2) & 15;
            _loc_2 = _loc_2 * (2 - (_loc_1 & 255) * _loc_2) & 255;
            _loc_2 = _loc_2 * (2 - ((_loc_1 & 65535) * _loc_2 & 65535)) & 65535;
            _loc_2 = _loc_2 * (2 - _loc_1 * _loc_2 % DV) % DV;
            return _loc_2 > 0 ? (DV - _loc_2) : (-_loc_2);
        }// end function

        protected function changeBit(param1:int, param2:Function) : BigInteger
        {
            var _loc_3:* = null;
            _loc_3 = BigInteger.ONE.shiftLeft(param1);
            bitwiseTo(_loc_3, param2, _loc_3);
            return _loc_3;
        }// end function

        public function equals(param1:BigInteger) : Boolean
        {
            return compareTo(param1) == 0;
        }// end function

        public function compareTo(param1:BigInteger) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            _loc_2 = s - param1.s;
            if (_loc_2 != 0)
            {
                return _loc_2;
            }
            _loc_3 = t;
            _loc_2 = _loc_3 - param1.t;
            if (_loc_2 != 0)
            {
                return _loc_2;
            }
            while (--_loc_3 >= 0)
            {
                
                _loc_2 = a[_loc_3] - param1.a[_loc_3];
                if (_loc_2 != 0)
                {
                    return _loc_2;
                }
            }
            return 0;
        }// end function

        public function shiftRight(param1:int) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            if (param1 < 0)
            {
                lShiftTo(-param1, _loc_2);
            }
            else
            {
                rShiftTo(param1, _loc_2);
            }
            return _loc_2;
        }// end function

        function multiplyTo(param1:BigInteger, param2:BigInteger) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            _loc_3 = abs();
            _loc_4 = param1.abs();
            _loc_5 = _loc_3.t;
            param2.t = _loc_5 + _loc_4.t;
            while (--_loc_5 >= 0)
            {
                
                param2.a[_loc_5] = 0;
            }
            --_loc_5 = 0;
            while (_loc_5 < _loc_4.t)
            {
                
                param2.a[--_loc_5 + _loc_3.t] = _loc_3.am(0, _loc_4.a[_loc_5], param2, _loc_5, 0, _loc_3.t);
                _loc_5++;
            }
            param2.s = 0;
            param2.clamp();
            if (s != param1.s)
            {
                ZERO.subTo(param2, param2);
            }
            return;
        }// end function

        public function bitCount() : int
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            _loc_1 = 0;
            _loc_2 = s & DM;
            _loc_3 = 0;
            while (_loc_3 < t)
            {
                
                _loc_1 = _loc_1 + cbit(a[_loc_3] ^ _loc_2);
                _loc_3++;
            }
            return _loc_1;
        }// end function

        public function byteValue() : int
        {
            return t == 0 ? (s) : (a[0] << 24 >> 24);
        }// end function

        private function cbit(param1:int) : int
        {
            var _loc_2:* = 0;
            _loc_2 = 0;
            while (param1 != 0)
            {
                
                param1 = param1 & (param1 - 1);
                _loc_2 = _loc_2 + 1;
            }
            return _loc_2;
        }// end function

        function rShiftTo(param1:int, param2:BigInteger) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            param2.s = s;
            _loc_3 = param1 / DB;
            if (_loc_3 >= t)
            {
                param2.t = 0;
                return;
            }
            _loc_4 = param1 % DB;
            _loc_5 = DB - _loc_4;
            _loc_6 = (1 << _loc_4) - 1;
            param2.a[0] = a[_loc_3] >> _loc_4;
            _loc_7 = _loc_3 + 1;
            while (_loc_7 < t)
            {
                
                param2.a[_loc_7 - _loc_3 - 1] = param2.a[_loc_7 - _loc_3 - 1] | (a[_loc_7] & _loc_6) << _loc_5;
                param2.a[_loc_7 - _loc_3] = a[_loc_7] >> _loc_4;
                _loc_7++;
            }
            if (_loc_4 > 0)
            {
                param2.a[t - _loc_3 - 1] = param2.a[t - _loc_3 - 1] | (s & _loc_6) << _loc_5;
            }
            param2.t = t - _loc_3;
            param2.clamp();
            return;
        }// end function

        public function modInverse(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = false;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            _loc_2 = param1.isEven();
            if (isEven() && _loc_2 || param1.sigNum() == 0)
            {
                return BigInteger.ZERO;
            }
            _loc_3 = param1.clone();
            _loc_4 = clone();
            _loc_5 = nbv(1);
            _loc_6 = nbv(0);
            _loc_7 = nbv(0);
            _loc_8 = nbv(1);
            while (_loc_3.sigNum() != 0)
            {
                
                while (_loc_3.isEven())
                {
                    
                    _loc_3.rShiftTo(1, _loc_3);
                    if (_loc_2)
                    {
                        if (!_loc_5.isEven() || !_loc_6.isEven())
                        {
                            _loc_5.addTo(this, _loc_5);
                            _loc_6.subTo(param1, _loc_6);
                        }
                        _loc_5.rShiftTo(1, _loc_5);
                    }
                    else if (!_loc_6.isEven())
                    {
                        _loc_6.subTo(param1, _loc_6);
                    }
                    _loc_6.rShiftTo(1, _loc_6);
                }
                while (_loc_4.isEven())
                {
                    
                    _loc_4.rShiftTo(1, _loc_4);
                    if (_loc_2)
                    {
                        if (!_loc_7.isEven() || !_loc_8.isEven())
                        {
                            _loc_7.addTo(this, _loc_7);
                            _loc_8.subTo(param1, _loc_8);
                        }
                        _loc_7.rShiftTo(1, _loc_7);
                    }
                    else if (!_loc_8.isEven())
                    {
                        _loc_8.subTo(param1, _loc_8);
                    }
                    _loc_8.rShiftTo(1, _loc_8);
                }
                if (_loc_3.compareTo(_loc_4) >= 0)
                {
                    _loc_3.subTo(_loc_4, _loc_3);
                    if (_loc_2)
                    {
                        _loc_5.subTo(_loc_7, _loc_5);
                    }
                    _loc_6.subTo(_loc_8, _loc_6);
                    continue;
                }
                _loc_4.subTo(_loc_3, _loc_4);
                if (_loc_2)
                {
                    _loc_7.subTo(_loc_5, _loc_7);
                }
                _loc_8.subTo(_loc_6, _loc_8);
            }
            if (_loc_4.compareTo(BigInteger.ONE) != 0)
            {
                return BigInteger.ZERO;
            }
            if (_loc_8.compareTo(param1) >= 0)
            {
                return _loc_8.subtract(param1);
            }
            if (_loc_8.sigNum() < 0)
            {
                _loc_8.addTo(param1, _loc_8);
            }
            else
            {
                return _loc_8;
            }
            if (_loc_8.sigNum() < 0)
            {
                return _loc_8.add(param1);
            }
            return _loc_8;
        }// end function

        function fromArray(param1:ByteArray, param2:int) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            _loc_3 = param1.position;
            _loc_4 = _loc_3 + param2;
            _loc_5 = 0;
            _loc_6 = 8;
            t = 0;
            s = 0;
            while (--_loc_4 >= _loc_3)
            {
                
                _loc_7 = _loc_4 < param1.length ? (param1[_loc_4]) : (0);
                if (_loc_5 == 0)
                {
                    t = t++;
                    a[t] = _loc_7;
                }
                else if (_loc_5 + _loc_6 > DB)
                {
                    a[(t - 1)] = a[(t - 1)] | (_loc_7 & (1 << DB - _loc_5) - 1) << _loc_5;
                    t = t++;
                    a[t] = _loc_7 >> DB - _loc_5;
                }
                else
                {
                    a[(t - 1)] = a[(t - 1)] | _loc_7 << _loc_5;
                }
                _loc_5 = _loc_5 + _loc_6;
                if (_loc_5 >= DB)
                {
                    _loc_5 = _loc_5 - DB;
                }
            }
            clamp();
            param1.position = Math.min(_loc_3 + param2, param1.length);
            return;
        }// end function

        function copyTo(param1:BigInteger) : void
        {
            var _loc_2:* = 0;
            _loc_2 = t - 1;
            while (_loc_2 >= 0)
            {
                
                param1.a[_loc_2] = a[_loc_2];
                _loc_2 = _loc_2 - 1;
            }
            param1.t = t;
            param1.s = s;
            return;
        }// end function

        public function intValue() : int
        {
            if (s < 0)
            {
                if (t == 1)
                {
                    return a[0] - DV;
                }
                if (t == 0)
                {
                    return -1;
                }
            }
            else
            {
                if (t == 1)
                {
                    return a[0];
                }
                if (t == 0)
                {
                    return 0;
                }
            }
            return (a[1] & (1 << 32 - DB) - 1) << DB | a[0];
        }// end function

        public function min(param1:BigInteger) : BigInteger
        {
            return compareTo(param1) < 0 ? (this) : (param1);
        }// end function

        public function bitLength() : int
        {
            if (t <= 0)
            {
                return 0;
            }
            return DB * (t - 1) + nbits(a[(t - 1)] ^ s & DM);
        }// end function

        public function shortValue() : int
        {
            return t == 0 ? (s) : (a[0] << 16 >> 16);
        }// end function

        public function and(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            bitwiseTo(param1, op_and, _loc_2);
            return _loc_2;
        }// end function

        protected function toRadix(param1:uint = 10) : String
        {
            var _loc_2:* = 0;
            var _loc_3:* = NaN;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            if (sigNum() == 0 || param1 < 2 || param1 > 32)
            {
                return "0";
            }
            _loc_2 = chunkSize(param1);
            _loc_3 = Math.pow(param1, _loc_2);
            _loc_4 = nbv(_loc_3);
            _loc_5 = nbi();
            _loc_6 = nbi();
            _loc_7 = "";
            divRemTo(_loc_4, _loc_5, _loc_6);
            while (_loc_5.sigNum() > 0)
            {
                
                _loc_7 = (_loc_3 + _loc_6.intValue()).toString(param1).substr(1) + _loc_7;
                _loc_5.divRemTo(_loc_4, _loc_5, _loc_6);
            }
            return _loc_6.intValue().toString(param1) + _loc_7;
        }// end function

        public function not() : BigInteger
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            _loc_1 = new BigInteger();
            _loc_2 = 0;
            while (_loc_2 < t)
            {
                
                _loc_1[_loc_2] = DM & ~a[_loc_2];
                _loc_2++;
            }
            _loc_1.t = t;
            _loc_1.s = ~s;
            return _loc_1;
        }// end function

        function subTo(param1:BigInteger, param2:BigInteger) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            _loc_3 = 0;
            _loc_4 = 0;
            _loc_5 = Math.min(param1.t, t);
            while (_loc_3 < _loc_5)
            {
                
                _loc_4 = _loc_4 + (a[_loc_3] - param1.a[_loc_3]);
                param2.a[++_loc_3] = _loc_4 & DM;
                _loc_4 = _loc_4 >> DB;
            }
            if (param1.t < t)
            {
                _loc_4 = _loc_4 - param1.s;
                while (_loc_3 < t)
                {
                    
                    _loc_4 = _loc_4 + a[_loc_3];
                    param2.a[++_loc_3] = _loc_4 & DM;
                    _loc_4 = _loc_4 >> DB;
                }
                _loc_4 = _loc_4 + s;
            }
            else
            {
                _loc_4 = _loc_4 + s;
                while (_loc_3 < param1.t)
                {
                    
                    _loc_4 = _loc_4 - param1.a[_loc_3];
                    param2.a[++_loc_3] = _loc_4 & DM;
                    _loc_4 = _loc_4 >> DB;
                }
                _loc_4 = _loc_4 - param1.s;
            }
            param2.s = _loc_4 < 0 ? (-1) : (0);
            if (_loc_4 < -1)
            {
                param2.a[++_loc_3] = DV + _loc_4;
            }
            else if (_loc_4 > 0)
            {
                param2.a[++_loc_3] = _loc_4;
            }
            param2.t = _loc_3;
            param2.clamp();
            return;
        }// end function

        public function clone() : BigInteger
        {
            var _loc_1:* = null;
            _loc_1 = new BigInteger();
            this.copyTo(_loc_1);
            return _loc_1;
        }// end function

        public function pow(param1:int) : BigInteger
        {
            return exp(param1, new NullReduction());
        }// end function

        public function flipBit(param1:int) : BigInteger
        {
            return changeBit(param1, op_xor);
        }// end function

        public function xor(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            bitwiseTo(param1, op_xor, _loc_2);
            return _loc_2;
        }// end function

        public function or(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            bitwiseTo(param1, op_or, _loc_2);
            return _loc_2;
        }// end function

        public function max(param1:BigInteger) : BigInteger
        {
            return compareTo(param1) > 0 ? (this) : (param1);
        }// end function

        function fromInt(param1:int) : void
        {
            t = 1;
            s = param1 < 0 ? (-1) : (0);
            if (param1 > 0)
            {
                a[0] = param1;
            }
            else if (param1 < -1)
            {
                a[0] = param1 + DV;
            }
            else
            {
                t = 0;
            }
            return;
        }// end function

        function isEven() : Boolean
        {
            return (t > 0 ? (a[0] & 1) : (s)) == 0;
        }// end function

        public function toString(param1:Number = 16) : String
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = false;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            if (s < 0)
            {
                return "-" + negate().toString(param1);
            }
            switch(param1)
            {
                case 2:
                {
                    _loc_2 = 1;
                    break;
                }
                case 4:
                {
                    _loc_2 = 2;
                    break;
                }
                case 8:
                {
                    _loc_2 = 3;
                    break;
                }
                case 16:
                {
                    _loc_2 = 4;
                    break;
                }
                case 32:
                {
                    _loc_2 = 5;
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_3 = (1 << _loc_2) - 1;
            _loc_4 = 0;
            _loc_5 = false;
            _loc_6 = "";
            _loc_7 = t;
            _loc_8 = DB - _loc_7 * DB % _loc_2;
            if (_loc_7-- > 0)
            {
                var _loc_9:* = a[_loc_7] >> _loc_8;
                _loc_4 = a[_loc_7] >> _loc_8;
                if (_loc_8 < DB && _loc_9 > 0)
                {
                    _loc_5 = true;
                    _loc_6 = _loc_4.toString(36);
                }
                while (_loc_7 >= 0)
                {
                    
                    if (_loc_8 < _loc_2)
                    {
                        _loc_4 = (a[_loc_7] & (1 << _loc_8) - 1) << _loc_2 - _loc_8;
                        var _loc_9:* = _loc_8 + (DB - _loc_2);
                        _loc_8 = _loc_8 + (DB - _loc_2);
                        _loc_4 = _loc_4 | a[--_loc_7] >> _loc_9;
                    }
                    else
                    {
                        var _loc_9:* = _loc_8 - _loc_2;
                        _loc_8 = _loc_8 - _loc_2;
                        _loc_4 = a[--_loc_7] >> _loc_9 & _loc_3;
                        if (_loc_8 <= 0)
                        {
                            _loc_8 = _loc_8 + DB;
                            _loc_7 = _loc_7 - 1;
                        }
                    }
                    if (_loc_4 > 0)
                    {
                        _loc_5 = true;
                    }
                    if (_loc_5)
                    {
                        _loc_6 = _loc_6 + _loc_4.toString(36);
                    }
                }
            }
            return _loc_5 ? (_loc_6) : ("0");
        }// end function

        public function setBit(param1:int) : BigInteger
        {
            return changeBit(param1, op_or);
        }// end function

        public function abs() : BigInteger
        {
            return s < 0 ? (negate()) : (this);
        }// end function

        function nbits(param1:int) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            _loc_2 = 1;
            var _loc_4:* = param1 >>> 16;
            _loc_3 = param1 >>> 16;
            if (_loc_4 != 0)
            {
                param1 = _loc_3;
                _loc_2 = _loc_2 + 16;
            }
            var _loc_4:* = param1 >> 8;
            _loc_3 = param1 >> 8;
            if (_loc_4 != 0)
            {
                param1 = _loc_3;
                _loc_2 = _loc_2 + 8;
            }
            var _loc_4:* = param1 >> 4;
            _loc_3 = param1 >> 4;
            if (_loc_4 != 0)
            {
                param1 = _loc_3;
                _loc_2 = _loc_2 + 4;
            }
            var _loc_4:* = param1 >> 2;
            _loc_3 = param1 >> 2;
            if (_loc_4 != 0)
            {
                param1 = _loc_3;
                _loc_2 = _loc_2 + 2;
            }
            var _loc_4:* = param1 >> 1;
            _loc_3 = param1 >> 1;
            if (_loc_4 != 0)
            {
                param1 = _loc_3;
                _loc_2 = _loc_2 + 1;
            }
            return _loc_2;
        }// end function

        public function sigNum() : int
        {
            if (s < 0)
            {
                return -1;
            }
            if (t <= 0 || t == 1 && a[0] <= 0)
            {
                return 0;
            }
            return 1;
        }// end function

        public function toByteArray() : ByteArray
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            _loc_1 = t;
            _loc_2 = new ByteArray();
            _loc_2[0] = s;
            _loc_3 = DB - _loc_1 * DB % 8;
            _loc_5 = 0;
            if (_loc_1-- > 0)
            {
                var _loc_6:* = a[_loc_1] >> _loc_3;
                _loc_4 = a[_loc_1] >> _loc_3;
                if (_loc_3 < DB && _loc_6 != (s & DM) >> _loc_3)
                {
                    _loc_2[++_loc_5] = _loc_4 | s << DB - _loc_3;
                }
                while (_loc_1 >= 0)
                {
                    
                    if (_loc_3 < 8)
                    {
                        _loc_4 = (a[_loc_1] & (1 << _loc_3) - 1) << 8 - _loc_3;
                        var _loc_6:* = _loc_3 + (DB - 8);
                        _loc_3 = _loc_3 + (DB - 8);
                        _loc_4 = _loc_4 | a[--_loc_1] >> _loc_6;
                    }
                    else
                    {
                        var _loc_6:* = _loc_3 - 8;
                        _loc_3 = _loc_3 - 8;
                        _loc_4 = a[--_loc_1] >> _loc_6 & 255;
                        if (_loc_3 <= 0)
                        {
                            _loc_3 = _loc_3 + DB;
                            _loc_1 = _loc_1 - 1;
                        }
                    }
                    if ((_loc_4 & 128) != 0)
                    {
                        _loc_4 = _loc_4 | -256;
                    }
                    if (_loc_5 == 0 && (s & 128) != (_loc_4 & 128))
                    {
                        _loc_5++;
                    }
                    if (_loc_5 > 0 || _loc_4 != s)
                    {
                        _loc_2[++_loc_5] = _loc_4;
                    }
                }
            }
            return _loc_2;
        }// end function

        function squareTo(param1:BigInteger) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            _loc_2 = abs();
            var _loc_5:* = 2 * _loc_2.t;
            param1.t = 2 * _loc_2.t;
            _loc_3 = _loc_5;
            while (--_loc_3 >= 0)
            {
                
                param1.a[_loc_3] = 0;
            }
            --_loc_3 = 0;
            while (_loc_3 < (_loc_2.t - 1))
            {
                
                _loc_4 = _loc_2.am(--_loc_3, _loc_2.a[--_loc_3], param1, 2 * _loc_3, 0, 1);
                var _loc_5:* = param1.a[_loc_3 + _loc_2.t] + _loc_2.am((_loc_3 + 1), 2 * _loc_2.a[_loc_3], param1, 2 * _loc_3 + 1, _loc_4, _loc_2.t - _loc_3 - 1);
                param1.a[_loc_3 + _loc_2.t] = param1.a[_loc_3 + _loc_2.t] + _loc_2.am((_loc_3 + 1), 2 * _loc_2.a[_loc_3], param1, 2 * _loc_3 + 1, _loc_4, _loc_2.t - _loc_3 - 1);
                if (_loc_5 >= DV)
                {
                    param1.a[_loc_3 + _loc_2.t] = param1.a[_loc_3 + _loc_2.t] - DV;
                    param1.a[_loc_3 + _loc_2.t + 1] = 1;
                }
                _loc_3++;
            }
            if (param1.t > 0)
            {
                param1.a[(param1.t - 1)] = param1.a[(param1.t - 1)] + _loc_2.am(_loc_3, _loc_2.a[_loc_3], param1, 2 * _loc_3, 0, 1);
            }
            param1.s = 0;
            param1.clamp();
            return;
        }// end function

        private function op_and(param1:int, param2:int) : int
        {
            return param1 & param2;
        }// end function

        protected function fromRadix(param1:String, param2:int = 10) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = NaN;
            var _loc_5:* = false;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            fromInt(0);
            _loc_3 = chunkSize(param2);
            _loc_4 = Math.pow(param2, _loc_3);
            _loc_5 = false;
            _loc_6 = 0;
            _loc_7 = 0;
            _loc_8 = 0;
            while (_loc_8 < param1.length)
            {
                
                _loc_9 = intAt(param1, _loc_8);
                if (_loc_9 < 0)
                {
                    if (param1.charAt(_loc_8) == "-" && sigNum() == 0)
                    {
                        _loc_5 = true;
                    }
                }
                else
                {
                    _loc_7 = param2 * _loc_7 + _loc_9;
                    if (++_loc_6 >= _loc_3)
                    {
                        dMultiply(_loc_4);
                        dAddOffset(_loc_7, 0);
                        ++_loc_6 = 0;
                        _loc_7 = 0;
                    }
                }
                _loc_8++;
            }
            if (++_loc_6 > 0)
            {
                dMultiply(Math.pow(param2, _loc_6));
                dAddOffset(_loc_7, 0);
            }
            if (_loc_5)
            {
                BigInteger.ZERO.subTo(this, this);
            }
            return;
        }// end function

        function dlShiftTo(param1:int, param2:BigInteger) : void
        {
            var _loc_3:* = 0;
            _loc_3 = t - 1;
            while (_loc_3 >= 0)
            {
                
                param2.a[_loc_3 + param1] = a[_loc_3];
                _loc_3 = _loc_3 - 1;
            }
            _loc_3 = param1 - 1;
            while (_loc_3 >= 0)
            {
                
                param2.a[_loc_3] = 0;
                _loc_3 = _loc_3 - 1;
            }
            param2.t = t + param1;
            param2.s = s;
            return;
        }// end function

        private function op_xor(param1:int, param2:int) : int
        {
            return param1 ^ param2;
        }// end function

        public static function nbv(param1:int) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger;
            _loc_2.fromInt(param1);
            return _loc_2;
        }// end function

    }
}
