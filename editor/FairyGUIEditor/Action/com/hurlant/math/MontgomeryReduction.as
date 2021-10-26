package com.hurlant.math
{
    import *.*;
    import com.hurlant.math.*;

    class MontgomeryReduction extends Object implements IReduction
    {
        private var um:int;
        private var mp:int;
        private var mph:int;
        private var mpl:int;
        private var mt2:int;
        private var m:BigInteger;

        function MontgomeryReduction(param1:BigInteger)
        {
            this.m = param1;
            mp = param1.invDigit();
            mpl = mp & 32767;
            mph = mp >> 15;
            um = (1 << BigInteger.DB - 15) - 1;
            mt2 = 2 * param1.t;
            return;
        }// end function

        public function mulTo(param1:BigInteger, param2:BigInteger, param3:BigInteger) : void
        {
            param1.multiplyTo(param2, param3);
            reduce(param3);
            return;
        }// end function

        public function revert(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            param1.copyTo(_loc_2);
            reduce(_loc_2);
            return _loc_2;
        }// end function

        public function convert(param1:BigInteger) : BigInteger
        {
            var _loc_2:* = null;
            _loc_2 = new BigInteger();
            param1.abs().dlShiftTo(m.t, _loc_2);
            _loc_2.divRemTo(m, null, _loc_2);
            if (param1.s < 0 && _loc_2.compareTo(BigInteger.ZERO) > 0)
            {
                m.subTo(_loc_2, _loc_2);
            }
            return _loc_2;
        }// end function

        public function reduce(param1:BigInteger) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            while (_loc_6.t <= mt2)
            {
                
                var _loc_6:* = param1;
                _loc_6.t = _loc_6.t++;
                param1.a[_loc_6.t] = 0;
            }
            _loc_2 = 0;
            while (_loc_2 < m.t)
            {
                
                _loc_3 = _loc_6.a[_loc_2] & 32767;
                _loc_4 = _loc_3 * mpl + ((_loc_3 * mph + (_loc_6.a[_loc_2] >> 15) * mpl & um) << 15) & BigInteger.DM;
                _loc_3 = _loc_2 + m.t;
                _loc_6.a[_loc_3] = _loc_6.a[_loc_3] + m.am(0, _loc_4, param1, _loc_2, 0, m.t);
                while (param1.a[++_loc_3] >= BigInteger.DV)
                {
                    
                    _loc_6.a[_loc_3] = _loc_6.a[_loc_3] - BigInteger.DV;
                    var _loc_5:* = _loc_6.a;
                    var _loc_7:* = _loc_5[++_loc_3] + 1;
                    _loc_5[++_loc_3] = _loc_7;
                }
                _loc_2++;
            }
            param1.clamp();
            param1.drShiftTo(m.t, param1);
            if (param1.compareTo(m) >= 0)
            {
                param1.subTo(m, param1);
            }
            return;
        }// end function

        public function sqrTo(param1:BigInteger, param2:BigInteger) : void
        {
            param1.squareTo(param2);
            reduce(param2);
            return;
        }// end function

    }
}
