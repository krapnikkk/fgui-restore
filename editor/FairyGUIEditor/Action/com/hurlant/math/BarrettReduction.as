package com.hurlant.math
{
    import *.*;
    import com.hurlant.math.*;

    class BarrettReduction extends Object implements IReduction
    {
        private var r2:BigInteger;
        private var q3:BigInteger;
        private var mu:BigInteger;
        private var m:BigInteger;

        function BarrettReduction(param1:BigInteger)
        {
            r2 = new BigInteger();
            q3 = new BigInteger();
            BigInteger.ONE.dlShiftTo(2 * param1.t, r2);
            mu = r2.divide(param1);
            this.m = param1;
            return;
        }// end function

        public function reduce(param1:BigInteger) : void
        {
            var _loc_2:* = null;
            _loc_2 = param1 as BigInteger;
            _loc_2.drShiftTo((m.t - 1), r2);
            if (_loc_2.t > (m.t + 1))
            {
                _loc_2.t = m.t + 1;
                _loc_2.clamp();
            }
            mu.multiplyUpperTo(r2, (m.t + 1), q3);
            m.multiplyLowerTo(q3, (m.t + 1), r2);
            while (_loc_2.compareTo(r2) < 0)
            {
                
                _loc_2.dAddOffset(1, (m.t + 1));
            }
            _loc_2.subTo(r2, _loc_2);
            while (_loc_2.compareTo(m) >= 0)
            {
                
                _loc_2.subTo(m, _loc_2);
            }
            return;
        }// end function

        public function revert(param1:BigInteger) : BigInteger
        {
            return param1;
        }// end function

        public function convert(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            if (param1.s < 0 || param1.t > 2 * m.t)
            {
                return param1.mod(m);
            }
            if (param1.compareTo(m) < 0)
            {
                return param1;
            }
            _loc_2 = new BigInteger();
            param1.copyTo(_loc_2);
            reduce(_loc_2);
            return _loc_2;
        }// end function

        public function sqrTo(param1:BigInteger, param2:BigInteger) : void
        {
            param1.squareTo(param2);
            reduce(param2);
            return;
        }// end function

        public function mulTo(param1:BigInteger, param2:BigInteger, param3:BigInteger) : void
        {
            param1.multiplyTo(param2, param3);
            reduce(param3);
            return;
        }// end function

    }
}
