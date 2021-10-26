package fairygui.gears
{
    import *.*;
    import fairygui.*;

    public class GearDisplay2 extends GearBase
    {
        public var pages:Array;
        public var condition:int;
        private var _visible:int;

        public function GearDisplay2(param1:GObject)
        {
            super(param1);
            return;
        }// end function

        override protected function init() : void
        {
            pages = null;
            return;
        }// end function

        public function evaluate(param1:Boolean) : Boolean
        {
            var _loc_2:* = _controller == null || _visible > 0;
            if (condition == 0)
            {
                _loc_2 = _loc_2 && param1;
            }
            else
            {
                _loc_2 = _loc_2 || param1;
            }
            return _loc_2;
        }// end function

        override public function apply() : void
        {
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
