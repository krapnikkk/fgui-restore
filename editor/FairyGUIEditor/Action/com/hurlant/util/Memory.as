package com.hurlant.util
{
    import flash.net.*;
    import flash.system.*;

    public class Memory extends Object
    {

        public function Memory()
        {
            return;
        }// end function

        public static function gc() : void
        {
            try
            {
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            }
            catch (e)
            {
            }
            return;
        }// end function

        public static function get used() : uint
        {
            return System.totalMemory;
        }// end function

    }
}
