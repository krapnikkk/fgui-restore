package fairygui.gears
{
    import *.*;
    import fairygui.*;
    import fairygui.tween.*;

    public class GearLook extends GearBase
    {
        private var _storage:Object;
        private var _default:GearLookValue;

        public function GearLook(param1:GObject)
        {
            super(param1);
            return;
        }// end function

        override protected function init() : void
        {
            _default = new GearLookValue(_owner.alpha, _owner.rotation, _owner.grayed, _owner.touchable);
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
            var _loc_3:* = param2.split(",");
            if (param1 == null)
            {
                _loc_4 = _default;
            }
            else
            {
                _loc_4 = new GearLookValue();
                _storage[param1] = _loc_4;
            }
            _loc_4.alpha = this.parseFloat(_loc_3[0]);
            _loc_4.rotation = this.parseInt(_loc_3[1]);
            _loc_4.grayed = _loc_3[2] == "1" ? (true) : (false);
            if (_loc_3.length < 4)
            {
                _loc_4.touchable = _owner.touchable;
            }
            else
            {
                _loc_4.touchable = _loc_3[3] == "1" ? (true) : (false);
            }
            return;
        }// end function

        override public function apply() : void
        {
            var _loc_1:* = false;
            var _loc_2:* = false;
            var _loc_3:* = _storage[_controller.selectedPageId];
            if (!_loc_3)
            {
                _loc_3 = _default;
            }
            if (_tweenConfig != null && _tweenConfig.tween && !UIPackage._constructing && !disableAllTweenEffect)
            {
                _owner._gearLocked = true;
                _owner.grayed = _loc_3.grayed;
                _owner.touchable = _loc_3.touchable;
                _owner._gearLocked = false;
                if (_tweenConfig._tweener != null)
                {
                    if (_tweenConfig._tweener.endValue.x != _loc_3.alpha || _tweenConfig._tweener.endValue.y != _loc_3.rotation)
                    {
                        _tweenConfig._tweener.kill(true);
                        _tweenConfig._tweener = null;
                    }
                    else
                    {
                        return;
                    }
                }
                _loc_1 = _loc_3.alpha != _owner.alpha;
                _loc_2 = _loc_3.rotation != _owner.rotation;
                if (_loc_1 || _loc_2)
                {
                    if (_owner.checkGearController(0, _controller))
                    {
                        _tweenConfig._displayLockToken = _owner.addDisplayLock();
                    }
                    _tweenConfig._tweener = GTween.to2(_owner.alpha, _owner.rotation, _loc_3.alpha, _loc_3.rotation, _tweenConfig.duration).setDelay(_tweenConfig.delay).setEase(_tweenConfig.easeType).setUserData((_loc_1 ? (1) : (0)) + (_loc_2 ? (2) : (0))).setTarget(this).onUpdate(__tweenUpdate).onComplete(__tweenComplete);
                }
            }
            else
            {
                _owner._gearLocked = true;
                _owner.alpha = _loc_3.alpha;
                _owner.rotation = _loc_3.rotation;
                _owner.grayed = _loc_3.grayed;
                _owner.touchable = _loc_3.touchable;
                _owner._gearLocked = false;
            }
            return;
        }// end function

        private function __tweenUpdate(param1:GTweener) : void
        {
            var _loc_2:* = param1.userData;
            _owner._gearLocked = true;
            if ((_loc_2 & 1) != 0)
            {
                _owner.alpha = param1.value.x;
            }
            if ((_loc_2 & 2) != 0)
            {
                _owner.rotation = param1.value.y;
            }
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
                _loc_1 = new GearLookValue();
                _storage[_controller.selectedPageId] = _loc_1;
            }
            _loc_1.alpha = _owner.alpha;
            _loc_1.rotation = _owner.rotation;
            _loc_1.grayed = _owner.grayed;
            _loc_1.touchable = _owner.touchable;
            return;
        }// end function

    }
}

import *.*;

import fairygui.*;

import fairygui.tween.*;

class GearLookValue extends Object
{
    public var alpha:Number;
    public var rotation:Number;
    public var grayed:Boolean;
    public var touchable:Boolean;

    function GearLookValue(param1:Number = 0, param2:Number = 0, param3:Boolean = false, param4:Boolean = true)
    {
        this.alpha = param1;
        this.rotation = param2;
        this.grayed = param3;
        this.touchable = param4;
        return;
    }// end function

}

