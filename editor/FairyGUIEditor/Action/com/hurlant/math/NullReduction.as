package com.hurlant.math
{
    import com.hurlant.math.*;

    public class NullReduction extends Object implements IReduction
    {

        public function NullReduction()
        {
            return;
        }// end function

        public function reduce(param1:BigInteger) : void
        {
            return;
        }// end function

        public function revert(param1:BigInteger) : BigInteger
        {
            return param1;
        }// end function

        public function mulTo(param1:BigInteger, param2:BigInteger, param3:BigInteger) : void
        {
            param1.multiplyTo(param2, param3);
            return;
        }// end function

        public function convert(param1:BigInteger) : BigInteger
        {
            return param1;
        }// end function

        public function sqrTo(param1:BigInteger, param2:BigInteger) : void
        {
            param1.squareTo(param2);
            return;
        }// end function

    }
}
