package fairygui.gears
{
    import *.*;
    import fairygui.*;

    public class GearAnimation extends GearBase
    {
        private var _storage:Object;
        private var _default:GearAnimationValue;

        public function GearAnimation(param1:GObject)
        {
            super(param1);
            return;
        }// end function

        override protected function init() : void
        {
            _default = new GearAnimationValue(_owner.getProp(4), _owner.getProp(5));
            _storage = {};
            return;
        }// end function

        override protected function addStatus(param1:String, param2:String) : void
        {
            var _loc_4:* = null;
            if (param2 == "-" || param2.length == 0)
            {
                return;
            }
            if (param1 == null)
            {
                _loc_4 = _default;
            }
            else
            {
                _loc_4 = new GearAnimationValue();
                _storage[param1] = _loc_4;
            }
            var _loc_3:* = param2.split(",");
            _loc_4.frame = _loc_3[0];
            _loc_4.playing = _loc_3[1] == "p";
            return;
        }// end function

        override public function apply() : void
        {
            _owner._gearLocked = true;
            var _loc_1:* = _storage[_controller.selectedPageId];
            if (!_loc_1)
            {
                _loc_1 = _default;
            }
            _owner.setProp(4, _loc_1.playing);
            _owner.setProp(5, _loc_1.frame);
            _owner._gearLocked = false;
            return;
        }// end function

        override public function updateState() : void
        {
            var _loc_1:* = _storage[_controller.selectedPageId];
            if (!_loc_1)
            {
                _loc_1 = new GearAnimationValue();
                _storage[_controller.selectedPageId] = _loc_1;
            }
            _loc_1.playing = _owner.getProp(4);
            _loc_1.frame = _owner.getProp(5);
            return;
        }// end function

    }
}

import *.*;

import fairygui.*;

class GearAnimationValue extends Object
{
    public var playing:Boolean;
    public var frame:int;

    function GearAnimationValue(param1:Boolean = true, param2:int = 0) : void
    {
        this.playing = param1;
        this.frame = param2;
        return;
    }// end function

}

