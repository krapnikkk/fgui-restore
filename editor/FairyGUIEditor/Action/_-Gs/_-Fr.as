package _-Gs
{
    import flash.events.*;

    public class _-Fr extends Event
    {
        public static const _-CF:String = "__submit";
        public static const _-DP:String = "__cancelled";

        public function _-Fr(param1:String, param2:Boolean = false, param3:Boolean = false)
        {
            super(param1, param2, param3);
            return;
        }// end function

        override public function clone() : Event
        {
            return new _-Fr(type, bubbles, cancelable);
        }// end function

    }
}
