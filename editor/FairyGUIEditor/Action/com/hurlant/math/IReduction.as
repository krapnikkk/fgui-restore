package com.hurlant.math
{

    interface IReduction
    {

        function IReduction();

        function convert(param1:BigInteger) : BigInteger;

        function revert(param1:BigInteger) : BigInteger;

        function reduce(param1:BigInteger) : void;

        function sqrTo(param1:BigInteger, param2:BigInteger) : void;

        function mulTo(param1:BigInteger, param2:BigInteger, param3:BigInteger) : void;

    }
}
