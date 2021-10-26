package fairygui.event
{
    import *.*;
    import fairygui.*;
    import flash.events.*;

    public class FocusChangeEvent extends Event
    {
        private var _oldFocusedObject:GObject;
        private var _newFocusedObject:GObject;
        public static const CHANGED:String = "focusChanged";

        public function FocusChangeEvent(param1:String, param2:GObject, param3:GObject)
        {
            super(param1, false, false);
            _oldFocusedObject = param2;
            _newFocusedObject = param3;
            return;
        }// end function

        final public function get oldFocusedObject() : GObject
        {
            return _oldFocusedObject;
        }// end function

        final public function get newFocusedObject() : GObject
        {
            return _newFocusedObject;
        }// end function

        override public function clone() : Event
        {
            return new FocusChangeEvent(type, _oldFocusedObject, _newFocusedObject);
        }// end function

    }
}
