package fairygui.event
{
    import flash.events.*;

    public class StateChangeEvent extends Event
    {
        public static const CHANGED:String = "stateChanged";

        public function StateChangeEvent(param1:String)
        {
            super(param1, false, false);
            return;
        }// end function

        override public function clone() : Event
        {
            return new StateChangeEvent(type);
        }// end function

    }
}
