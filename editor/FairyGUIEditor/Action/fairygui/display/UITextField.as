package fairygui.display
{
    import *.*;
    import fairygui.*;
    import fairygui.display.*;
    import flash.text.*;

    public class UITextField extends TextField implements UIDisplayObject
    {
        private var _owner:GObject;

        public function UITextField(param1:GObject)
        {
            _owner = param1;
            return;
        }// end function

        public function get owner() : GObject
        {
            return _owner;
        }// end function

    }
}
