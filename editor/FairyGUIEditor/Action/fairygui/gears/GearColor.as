package fairygui.gears
{
    import *.*;
    import fairygui.*;
    import fairygui.tween.*;
    import fairygui.utils.*;

    public class GearColor extends GearBase
    {
        private var _storage:Object;
        private var _default:GearColorValue;

        public function GearColor(param1:GObject)
        {
            super(param1);
            return;
        }// end function

        override protected function init() : void
        {
            _default = new GearColorValue(_owner.getProp(2), _owner.getProp(3));
            _storage = {};
            return;
        }// end function

        override protected function addStatus(param1:String, param2:String) : void
        {
            var _loc_5:* = 0;
            var _loc_4:* = 0;
            if (param2 == "-" || param2.length == 0)
            {
                return;
            }
            var _loc_3:* = param2.indexOf(",");
            if (_loc_3 == -1)
            {
                _loc_5 = ToolSet.convertFromHtmlColor(param2);
                _loc_4 = 4278190080;
            }
            else
            {
                _loc_5 = ToolSet.convertFromHtmlColor(param2.substr(0, _loc_3));
                _loc_4 = ToolSet.convertFromHtmlColor(param2.substr((_loc_3 + 1)));
            }
            if (param1 == null)
            {
                _default.color = _loc_5;
                _default.strokeColor = _loc_4;
            }
            else
            {
                _storage[param1] = new GearColorValue(_loc_5, _loc_4);
            }
            return;
        }// end function

        override public function apply() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = _storage[_controller.selectedPageId];
            if (!_loc_2)
            {
                _loc_2 = _default;
            }
            if (_tweenConfig != null && _tweenConfig.tween && !UIPackage._constructing && !disableAllTweenEffect)
            {
                if (_loc_2.strokeColor != 4278190080)
                {
                    _owner._gearLocked = true;
                    _owner.setProp(3, _loc_2.strokeColor);
                    _owner._gearLocked = false;
                }
                if (_tweenConfig._tweener != null)
                {
                    if (_tweenConfig._tweener.endValue.color != _loc_2.color)
                    {
                        _tweenConfig._tweener.kill(true);
                        _tweenConfig._tweener = null;
                    }
                    else
                    {
                        return;
                    }
                }
                _loc_1 = _owner.getProp(2);
                if (_loc_1 != _loc_2.color)
                {
                    if (_owner.checkGearController(0, _controller))
                    {
                        _tweenConfig._displayLockToken = _owner.addDisplayLock();
                    }
                    _tweenConfig._tweener = GTween.toColor(_loc_1, _loc_2.color, _tweenConfig.duration).setDelay(_tweenConfig.delay).setEase(_tweenConfig.easeType).setTarget(this).onUpdate(__tweenUpdate).onComplete(__tweenComplete);
                }
            }
            else
            {
                _owner._gearLocked = true;
                _owner.setProp(2, _loc_2.color);
                if (_loc_2.strokeColor != 4278190080)
                {
                    _owner.setProp(3, _loc_2.strokeColor);
                }
                _owner._gearLocked = false;
            }
            return;
        }// end function

        private function __tweenUpdate(param1:GTweener) : void
        {
            _owner._gearLocked = true;
            _owner.setProp(2, param1.value.color);
            _owner._gearLocked = false;
            return;
        }// end function

        private function __tweenComplete() : void
        {
            if (_tweenConfig._displayLockToken != 0)
            {
                _owner.releaseDisplayLock(_tweenConfig._displayLockToken);
                _tweenConfig._displayLockToken = 0;
            }
            _tweenConfig._tweener = null;
            return;
        }// end function

        override public function updateState() : void
        {
            var _loc_1:* = _storage[_controller.selectedPageId];
            if (!_loc_1)
            {
                _loc_1 = new GearColorValue();
                _storage[_controller.selectedPageId] = _loc_1;
            }
            _loc_1.color = _owner.getProp(2);
            _loc_1.strokeColor = _owner.getProp(3);
            return;
        }// end function

    }
}

import *.*;

import fairygui.*;

import fairygui.tween.*;

import fairygui.utils.*;

class GearColorValue extends Object
{
    public var color:uint;
    public var strokeColor:uint;

    function GearColorValue(param1:uint = 0, param2:uint = 0)
    {
        this.color = param1;
        this.strokeColor = param2;
        return;
    }// end function

}

