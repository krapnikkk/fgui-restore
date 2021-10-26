package fairygui.gears
{
    import *.*;
    import fairygui.*;

    public class GearDisplay extends GearBase
    {
        public var pages:Array;
        private var _visible:int;
        private var _displayLockToken:uint;

        public function GearDisplay(param1:GObject)
        {
            super(param1);
            _displayLockToken = 1;
            return;
        }// end function

        override protected function init() : void
        {
            pages = null;
            return;
        }// end function

        public function addLock() : uint
        {
            (_visible + 1);
            return _displayLockToken;
        }// end function

        public function releaseLock(param1:uint) : void
        {
            if (param1 == _displayLockToken)
            {
                (_visible - 1);
            }
            return;
        }// end function

        public function get connected() : Boolean
        {
            return _controller == null || _visible > 0;
        }// end function

        override public function apply() : void
        {
            (_displayLockToken + 1);
            if (_displayLockToken == 0)
            {
                _displayLockToken = 1;
            }
            if (pages == null || pages.length == 0 || pages.indexOf(_controller.selectedPageId) != -1)
            {
                _visible = 1;
            }
            else
            {
                _visible = 0;
            }
            return;
        }// end function

    }
}
