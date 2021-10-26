package fairygui.event
{
    import flash.events.*;

    public class DropEvent extends Event
    {
        public var source:Object;
        public static const DROP:String = "dropEvent";

        public function DropEvent(param1:String, param2:Object)
        {
            super(param1, false, false);
            this.source = param2;
            return;
        }// end function

        override public function clone() : Event
        {
            return new DropEvent(type, source);
        }// end function

    }
}
