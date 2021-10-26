package fairygui.gears
{
    import *.*;
    import fairygui.*;
    import fairygui.tween.*;

    public class GearSize extends GearBase
    {
        private var _storage:Object;
        private var _default:GearSizeValue;

        public function GearSize(param1:GObject)
        {
            super(param1);
            return;
        }// end function

        override protected function init() : void
        {
            _default = new GearSizeValue(_owner.width, _owner.height, _owner.scaleX, _owner.scaleY);
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
                _loc_4 = new GearSizeValue();
                _storage[param1] = _loc_4;
            }
            _loc_4.width = this.parseInt(_loc_3[0]);
            _loc_4.height = this.parseInt(_loc_3[1]);
            if (_loc_3.length > 2)
            {
                _loc_4.scaleX = this.parseFloat(_loc_3[2]);
                _loc_4.scaleY = this.parseFloat(_loc_3[3]);
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
                if (_tweenConfig._tweener != null)
                {
                    if (_tweenConfig._tweener.endValue.x != _loc_3.width || _tweenConfig._tweener.endValue.y != _loc_3.height || _tweenConfig._tweener.endValue.z != _loc_3.scaleX || _tweenConfig._tweener.endValue.w != _loc_3.scaleY)
                    {
                        _tweenConfig._tweener.kill(true);
                        _tweenConfig._tweener = null;
                    }
                    else
                    {
                        return;
                    }
                }
                _loc_1 = _loc_3.width != _owner.width || _loc_3.height != _owner.height;
                _loc_2 = _loc_3.scaleX != _owner.scaleX || _loc_3.scaleY != _owner.scaleY;
                if (_loc_1 || _loc_2)
                {
                    if (_owner.checkGearController(0, _controller))
                    {
                        _tweenConfig._displayLockToken = _owner.addDisplayLock();
                    }
                    _tweenConfig._tweener = GTween.to4(_owner.width, _owner.height, _owner.scaleX, _owner.scaleY, _loc_3.width, _loc_3.height, _loc_3.scaleX, _loc_3.scaleY, _tweenConfig.duration).setDelay(_tweenConfig.delay).setEase(_tweenConfig.easeType).setUserData((_loc_1 ? (1) : (0)) + (_loc_2 ? (2) : (0))).setTarget(this).onUpdate(__tweenUpdate).onComplete(__tweenComplete);
                }
            }
            else
            {
                _owner._gearLocked = true;
                _owner.setSize(_loc_3.width, _loc_3.height, _owner.checkGearController(1, _controller));
                _owner.setScale(_loc_3.scaleX, _loc_3.scaleY);
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
                _owner.setSize(param1.value.x, param1.value.y, _owner.checkGearController(1, _controller));
            }
            if ((_loc_2 & 2) != 0)
            {
                _owner.setScale(param1.value.z, param1.value.w);
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
                _loc_1 = new GearSizeValue();
                _storage[_controller.selectedPageId] = _loc_1;
            }
            _loc_1.width = _owner.width;
            _loc_1.height = _owner.height;
            _loc_1.scaleX = _owner.scaleX;
            _loc_1.scaleY = _owner.scaleY;
            return;
        }// end function

        override public function updateFromRelations(param1:Number, param2:Number) : void
        {
            if (_controller == null || _storage == null)
            {
                return;
            }
            for each (_loc_3 in _storage)
            {
                
                _loc_3.width = _loc_3.width + param1;
                _loc_3.height = _loc_3.height + param2;
            }
            this.GearSizeValue(_default).width = this.GearSizeValue(_default).width + param1;
            this.GearSizeValue(_default).height = this.GearSizeValue(_default).height + param2;
            updateState();
            return;
        }// end function

    }
}

import *.*;

import fairygui.*;

import fairygui.tween.*;

class GearSizeValue extends Object
{
    public var width:Number;
    public var height:Number;
    public var scaleX:Number;
    public var scaleY:Number;

    function GearSizeValue(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
    {
        this.width = param1;
        this.height = param2;
        this.scaleX = param3;
        this.scaleY = param4;
        return;
    }// end function

}

