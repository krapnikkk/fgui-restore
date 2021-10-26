package fairygui.display
{
    import *.*;
    import fairygui.*;
    import fairygui.display.*;
    import flash.display.*;

    public class UIImage extends Bitmap implements UIDisplayObject
    {
        private var _owner:GObject;

        public function UIImage(param1:GObject)
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
