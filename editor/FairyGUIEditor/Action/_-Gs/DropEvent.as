package _-Gs
{
    import *.*;
    import flash.events.*;

    public class DropEvent extends Event
    {
        private var _-GE:Object;
        private var _-NU:Object;
        public static const DROP:String = "DropObject";

        public function DropEvent(param1:String, param2:Object, param3:Object)
        {
            super(param1, false, false);
            this._-GE = param2;
            this._-NU = param3;
            return;
        }// end function

        public function get source() : Object
        {
            return this._-GE;
        }// end function

        public function get _-LE() : Object
        {
            return this._-NU;
        }// end function

        override public function clone() : Event
        {
            return new DropEvent(type, this.source, this._-LE);
        }// end function

    }
}
