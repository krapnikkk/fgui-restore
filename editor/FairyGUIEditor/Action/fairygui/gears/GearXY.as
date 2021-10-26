package fairygui.gears
{
    import *.*;
    import fairygui.*;
    import fairygui.tween.*;

    public class GearXY extends GearBase
    {
        public var positionsInPercent:Boolean;
        private var _storage:Object;
        private var _default:Object;

        public function GearXY(param1:GObject)
        {
            super(param1);
            return;
        }// end function

        override protected function init() : void
        {
            _default = {x:_owner.x, y:_owner.y, px:_owner.x / _owner.parent.width, py:_owner.y / _owner.parent.height};
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
                _loc_4 = {};
                _storage[param1] = _loc_4;
            }
            _loc_4.x = this.parseInt(_loc_3[0]);
            _loc_4.y = this.parseInt(_loc_3[1]);
            _loc_4.px = this.parseFloat(_loc_3[2]);
            _loc_4.py = this.parseFloat(_loc_3[3]);
            if (this.isNaN(_loc_4.px))
            {
                _loc_4.px = _loc_4.x / _owner.parent.width;
                _loc_4.py = _loc_4.y / _owner.parent.height;
            }
            return;
        }// end function

        override public function apply() : void
        {
            var _loc_1:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_2:* = _storage[_controller.selectedPageId];
            if (!_loc_2)
            {
                _loc_2 = _default;
            }
            if (positionsInPercent && _owner.parent)
            {
                _loc_1 = _loc_2.px * _owner.parent.width;
                _loc_3 = _loc_2.py * _owner.parent.height;
            }
            else
            {
                _loc_1 = _loc_2.x;
                _loc_3 = _loc_2.y;
            }
            if (_tweenConfig != null && _tweenConfig.tween && !UIPackage._constructing && !disableAllTweenEffect)
            {
                if (_tweenConfig._tweener != null)
                {
                    if (_tweenConfig._tweener.endValue.x != _loc_1 || _tweenConfig._tweener.endValue.y != _loc_3)
                    {
                        _tweenConfig._tweener.kill(true);
                        _tweenConfig._tweener = null;
                    }
                    else
                    {
                        return;
                    }
                }
                _loc_4 = _owner.x;
                _loc_5 = _owner.y;
                if (_loc_4 != _loc_1 || _loc_5 != _loc_3)
                {
                    if (_owner.checkGearController(0, _controller))
                    {
                        _tweenConfig._displayLockToken = _owner.addDisplayLock();
                    }
                    _tweenConfig._tweener = GTween.to2(_loc_4, _loc_5, _loc_1, _loc_3, _tweenConfig.duration).setDelay(_tweenConfig.delay).setEase(_tweenConfig.easeType).setTarget(this).onUpdate(__tweenUpdate).onComplete(__tweenComplete);
                }
            }
            else
            {
                _owner._gearLocked = true;
                _owner.setXY(_loc_1, _loc_3);
                _owner._gearLocked = false;
            }
            return;
        }// end function

        private function __tweenUpdate(param1:GTweener) : void
        {
            _owner._gearLocked = true;
            _owner.setXY(param1.value.x, param1.value.y);
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
                _loc_1 = {};
                _storage[_controller.selectedPageId] = _loc_1;
            }
            _loc_1.x = _owner.x;
            _loc_1.y = _owner.y;
            if (_owner.parent)
            {
                _loc_1.px = _owner.x / _owner.parent.width;
                _loc_1.py = _owner.y / _owner.parent.height;
            }
            return;
        }// end function

        override public function updateFromRelations(param1:Number, param2:Number) : void
        {
            if (_controller == null || _storage == null || positionsInPercent)
            {
                return;
            }
            for each (_loc_3 in _storage)
            {
                
                _loc_3.x = _loc_3.x + param1;
                _loc_3.y = _loc_3.y + param2;
            }
            _default.x = _default.x + param1;
            _default.y = _default.y + param2;
            updateState();
            return;
        }// end function

    }
}
