package fairygui.tween
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import flash.events.*;
    import flash.utils.*;

    public class TweenManager extends Object
    {
        private static var _activeTweens:Array = new Array(30);
        private static var _tweenerPool:Vector.<GTweener> = new Vector.<GTweener>;
        private static var _totalActiveTweens:int = 0;
        private static var _timer:Timer = null;
        private static var _lastTime:int;

        public function TweenManager()
        {
            return;
        }// end function

        static function createTween() : GTweener
        {
            var _loc_2:* = null;
            if (!_timer)
            {
                _timer = new Timer(10);
                _timer.addEventListener("timer", update);
                _timer.start();
                _lastTime = TweenManager.getTimer();
            }
            var _loc_1:* = _tweenerPool.length;
            if (_loc_1 > 0)
            {
                _loc_2 = _tweenerPool.pop();
            }
            else
            {
                _loc_2 = new GTweener();
            }
            _loc_2._init();
            (_totalActiveTweens + 1);
            _activeTweens[_totalActiveTweens] = _loc_2;
            return _loc_2;
        }// end function

        static function isTweening(param1:Object, param2:Object) : Boolean
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            if (param1 == null)
            {
                return false;
            }
            var _loc_3:* = param2 == null;
            _loc_4 = 0;
            while (_loc_4 < _totalActiveTweens)
            {
                
                _loc_5 = _activeTweens[_loc_4];
                if (_loc_5 != null && _loc_5.target == param1 && !_loc_5._killed && (_loc_3 || _loc_5._propType == param2))
                {
                    return true;
                }
                _loc_4++;
            }
            return false;
        }// end function

        static function killTweens(param1:Object, param2:Boolean, param3:Object) : Boolean
        {
            var _loc_7:* = 0;
            var _loc_8:* = null;
            if (param1 == null)
            {
                return false;
            }
            var _loc_4:* = false;
            var _loc_6:* = _totalActiveTweens;
            var _loc_5:* = param3 == null;
            _loc_7 = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_8 = _activeTweens[_loc_7];
                if (_loc_8 != null && _loc_8.target == param1 && !_loc_8._killed && (_loc_5 || _loc_8._propType == param3))
                {
                    _loc_8.kill(param2);
                    _loc_4 = true;
                }
                _loc_7++;
            }
            return _loc_4;
        }// end function

        static function getTween(param1:Object, param2:Object) : GTweener
        {
            var _loc_5:* = 0;
            var _loc_6:* = null;
            if (param1 == null)
            {
                return null;
            }
            var _loc_4:* = _totalActiveTweens;
            var _loc_3:* = param2 == null;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = _activeTweens[_loc_5];
                if (_loc_6 != null && _loc_6.target == param1 && !_loc_6._killed && (_loc_3 || _loc_6._propType == param2))
                {
                    return _loc_6;
                }
                _loc_5++;
            }
            return null;
        }// end function

        static function update(event:Event) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = TweenManager.getTimer();
            var _loc_2:* = TweenManager.getTimer() - _lastTime;
            _lastTime = _loc_8;
            _loc_2 = _loc_2 / 1000;
            var _loc_4:* = _totalActiveTweens;
            var _loc_3:* = -1;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = _activeTweens[_loc_5];
                if (_loc_6 == null)
                {
                    if (_loc_3 == -1)
                    {
                        _loc_3 = _loc_5;
                    }
                }
                else if (_loc_6._killed)
                {
                    _loc_6._reset();
                    _tweenerPool.push(_loc_6);
                    _activeTweens[_loc_5] = null;
                    if (_loc_3 == -1)
                    {
                        _loc_3 = _loc_5;
                    }
                }
                else
                {
                    if (_loc_6._target is GObject && TweenManager.GObject(_loc_6._target).isDisposed)
                    {
                        _loc_6._killed = true;
                    }
                    else if (!_loc_6._paused)
                    {
                        _loc_6._update(_loc_2);
                    }
                    if (_loc_3 != -1)
                    {
                        _activeTweens[_loc_3] = _loc_6;
                        _activeTweens[_loc_5] = null;
                        _loc_3++;
                    }
                }
                _loc_5++;
            }
            if (_loc_3 >= 0)
            {
                if (_totalActiveTweens != _loc_4)
                {
                    _loc_7 = _loc_4;
                    _loc_4 = _totalActiveTweens - _loc_4;
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _loc_3++;
                        _loc_7++;
                        _activeTweens[_loc_3] = _activeTweens[_loc_7];
                        _loc_5++;
                    }
                }
                _totalActiveTweens = _loc_3;
            }
            return;
        }// end function

    }
}
