package fairygui.gears
{
    import *.*;
    import fairygui.*;

    public class GearIcon extends GearBase
    {
        private var _storage:Object;
        private var _default:String;

        public function GearIcon(param1:GObject)
        {
            super(param1);
            return;
        }// end function

        override protected function init() : void
        {
            _default = _owner.icon;
            _storage = {};
            return;
        }// end function

        override protected function addStatus(param1:String, param2:String) : void
        {
            if (param1 == null)
            {
                _default = param2;
            }
            else
            {
                _storage[param1] = param2;
            }
            return;
        }// end function

        override public function apply() : void
        {
            _owner._gearLocked = true;
            var _loc_1:* = _storage[_controller.selectedPageId];
            if (_loc_1 != undefined)
            {
                _owner.icon = _loc_1;
            }
            else
            {
                _owner.icon = _default;
            }
            _owner._gearLocked = false;
            return;
        }// end function

        override public function updateState() : void
        {
            _storage[_controller.selectedPageId] = _owner.icon;
            return;
        }// end function

    }
}
