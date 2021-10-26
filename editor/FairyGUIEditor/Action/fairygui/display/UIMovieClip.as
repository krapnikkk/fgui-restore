package fairygui.display
{
    import *.*;
    import fairygui.*;
    import fairygui.display.*;

    public class UIMovieClip extends MovieClip implements UIDisplayObject
    {
        private var _owner:GObject;

        public function UIMovieClip(param1:GObject)
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
