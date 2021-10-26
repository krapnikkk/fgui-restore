package fairygui.tween
{
    import *.*;
    import flash.geom.*;

    public class GTweener extends Object
    {
        var _target:Object;
        var _propType:Object;
        var _killed:Boolean;
        var _paused:Boolean;
        private var _delay:Number;
        private var _duration:Number;
        private var _breakpoint:Number;
        private var _easeType:int;
        private var _easeOvershootOrAmplitude:Number;
        private var _easePeriod:Number;
        private var _repeat:int;
        private var _yoyo:Boolean;
        private var _timeScale:Number;
        private var _snapping:Boolean;
        private var _userData:Object;
        private var _path:GPath;
        private var _onUpdate:Function;
        private var _onStart:Function;
        private var _onComplete:Function;
        private var _startValue:TweenValue;
        private var _endValue:TweenValue;
        private var _value:TweenValue;
        private var _deltaValue:TweenValue;
        private var _valueSize:int;
        private var _started:Boolean;
        private var _ended:int;
        private var _elapsedTime:Number;
        private var _normalizedTime:Number;
        private static var helperPoint:Point = new Point();

        public function GTweener()
        {
            _startValue = new TweenValue();
            _endValue = new TweenValue();
            _value = new TweenValue();
            _deltaValue = new TweenValue();
            return;
        }// end function

        public function setDelay(param1:Number) : GTweener
        {
            _delay = param1;
            return this;
        }// end function

        public function get delay() : Number
        {
            return _delay;
        }// end function

        public function setDuration(param1:Number) : GTweener
        {
            _duration = param1;
            return this;
        }// end function

        public function get duration() : Number
        {
            return _duration;
        }// end function

        public function setBreakpoint(param1:Number) : GTweener
        {
            _breakpoint = param1;
            return this;
        }// end function

        public function setEase(param1:int) : GTweener
        {
            _easeType = param1;
            return this;
        }// end function

        public function setEasePeriod(param1:Number) : GTweener
        {
            _easePeriod = param1;
            return this;
        }// end function

        public function setEaseOvershootOrAmplitude(param1:Number) : GTweener
        {
            _easeOvershootOrAmplitude = param1;
            return this;
        }// end function

        public function setRepeat(param1:int, param2:Boolean = false) : GTweener
        {
            _repeat = param1;
            _yoyo = param2;
            return this;
        }// end function

        public function get repeat() : int
        {
            return _repeat;
        }// end function

        public function setTimeScale(param1:Number) : GTweener
        {
            _timeScale = param1;
            return this;
        }// end function

        public function setSnapping(param1:Boolean) : GTweener
        {
            _snapping = param1;
            return this;
        }// end function

        public function setPath(param1:GPath) : GTweener
        {
            _path = param1;
            return this;
        }// end function

        public function setTarget(param1:Object, param2:Object = null) : GTweener
        {
            _target = param1;
            _propType = param2;
            return this;
        }// end function

        public function get target() : Object
        {
            return _target;
        }// end function

        public function setUserData(param1) : GTweener
        {
            _userData = param1;
            return this;
        }// end function

        public function get userData()
        {
            return _userData;
        }// end function

        public function onUpdate(param1:Function) : GTweener
        {
            _onUpdate = param1;
            return this;
        }// end function

        public function onStart(param1:Function) : GTweener
        {
            _onStart = param1;
            return this;
        }// end function

        public function onComplete(param1:Function) : GTweener
        {
            _onComplete = param1;
            return this;
        }// end function

        public function get startValue() : TweenValue
        {
            return _startValue;
        }// end function

        public function get endValue() : TweenValue
        {
            return _endValue;
        }// end function

        public function get value() : TweenValue
        {
            return _value;
        }// end function

        public function get deltaValue() : TweenValue
        {
            return _deltaValue;
        }// end function

        public function get normalizedTime() : Number
        {
            return _normalizedTime;
        }// end function

        public function get completed() : Boolean
        {
            return _ended != 0;
        }// end function

        public function get allCompleted() : Boolean
        {
            return _ended == 1;
        }// end function

        public function setPaused(param1:Boolean) : GTweener
        {
            _paused = param1;
            return this;
        }// end function

        public function seek(param1:Number) : void
        {
            if (_killed)
            {
                return;
            }
            _elapsedTime = param1;
            if (_elapsedTime < _delay)
            {
                if (_started)
                {
                    _elapsedTime = _delay;
                }
                else
                {
                    return;
                }
            }
            update();
            return;
        }// end function

        public function kill(param1:Boolean = false) : void
        {
            if (_killed)
            {
                return;
            }
            if (param1)
            {
                if (_ended == 0)
                {
                    if (_breakpoint >= 0)
                    {
                        _elapsedTime = _delay + _breakpoint;
                    }
                    else if (_repeat >= 0)
                    {
                        _elapsedTime = _delay + _duration * (_repeat + 1);
                    }
                    else
                    {
                        _elapsedTime = _delay + _duration * 2;
                    }
                    update();
                }
                callCompleteCallback();
            }
            _killed = true;
            return;
        }// end function

        function _to(param1:Number, param2:Number, param3:Number) : GTweener
        {
            _valueSize = 1;
            _startValue.x = param1;
            _endValue.x = param2;
            _value.x = param1;
            _duration = param3;
            return this;
        }// end function

        function _to2(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : GTweener
        {
            _valueSize = 2;
            _startValue.x = param1;
            _endValue.x = param3;
            _startValue.y = param2;
            _endValue.y = param4;
            _value.x = param1;
            _value.y = param2;
            _duration = param5;
            return this;
        }// end function

        function _to3(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : GTweener
        {
            _valueSize = 3;
            _startValue.x = param1;
            _endValue.x = param4;
            _startValue.y = param2;
            _endValue.y = param5;
            _startValue.z = param3;
            _endValue.z = param6;
            _value.x = param1;
            _value.y = param2;
            _value.z = param3;
            _duration = param7;
            return this;
        }// end function

        function _to4(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : GTweener
        {
            _valueSize = 4;
            _startValue.x = param1;
            _endValue.x = param5;
            _startValue.y = param2;
            _endValue.y = param6;
            _startValue.z = param3;
            _endValue.z = param7;
            _startValue.w = param4;
            _endValue.w = param8;
            _value.x = param1;
            _value.y = param2;
            _value.z = param3;
            _value.w = param4;
            _duration = param9;
            return this;
        }// end function

        function _toColor(param1:uint, param2:uint, param3:Number) : GTweener
        {
            _valueSize = 4;
            _startValue.color = param1;
            _endValue.color = param2;
            _value.color = param1;
            _duration = param3;
            return this;
        }// end function

        function _shake(param1:Number, param2:Number, param3:Number, param4:Number) : GTweener
        {
            _valueSize = 5;
            _startValue.x = param1;
            _startValue.y = param2;
            _startValue.w = param3;
            _duration = param4;
            return this;
        }// end function

        function _init() : void
        {
            _delay = 0;
            _duration = 0;
            _breakpoint = -1;
            _easeType = 5;
            _timeScale = 1;
            _easePeriod = 0;
            _easeOvershootOrAmplitude = 1.70158;
            _snapping = false;
            _repeat = 0;
            _yoyo = false;
            _valueSize = 0;
            _started = false;
            _paused = false;
            _killed = false;
            _elapsedTime = 0;
            _normalizedTime = 0;
            _ended = 0;
            return;
        }// end function

        function _reset() : void
        {
            _target = null;
            _userData = null;
            _path = null;
            _onComplete = null;
            _onUpdate = null;
            _onStart = null;
            return;
        }// end function

        function _update(param1:Number) : void
        {
            if (_timeScale != 1)
            {
                param1 = param1 * _timeScale;
            }
            if (param1 == 0)
            {
                return;
            }
            if (_ended != 0)
            {
                callCompleteCallback();
                _killed = true;
                return;
            }
            _elapsedTime = _elapsedTime + param1;
            update();
            if (_ended != 0)
            {
                if (!_killed)
                {
                    callCompleteCallback();
                    _killed = true;
                }
            }
            return;
        }// end function

        private function update() : void
        {
            var _loc_4:* = 0;
            var _loc_2:* = NaN;
            var _loc_6:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = 0;
            var _loc_3:* = NaN;
            var _loc_5:* = NaN;
            var _loc_7:* = NaN;
            _ended = 0;
            if (_valueSize == 0)
            {
                if (_elapsedTime >= _delay + _duration)
                {
                    _ended = 1;
                }
                return;
            }
            if (!_started)
            {
                if (_elapsedTime < _delay)
                {
                    return;
                }
                _started = true;
                callStartCallback();
                if (_killed)
                {
                    return;
                }
            }
            var _loc_10:* = false;
            var _loc_1:* = _elapsedTime - _delay;
            if (_breakpoint >= 0 && _loc_1 >= _breakpoint)
            {
                _loc_1 = _breakpoint;
                _ended = 2;
            }
            if (_repeat != 0)
            {
                _loc_4 = Math.floor(_loc_1 / _duration);
                _loc_1 = _loc_1 - _duration * _loc_4;
                if (_yoyo)
                {
                    _loc_10 = _loc_4 % 2 == 1;
                }
                if (_repeat > 0 && _repeat - _loc_4 < 0)
                {
                    if (_yoyo)
                    {
                        _loc_10 = _repeat % 2 == 1;
                    }
                    _loc_1 = _duration;
                    _ended = 1;
                }
            }
            else if (_loc_1 >= _duration)
            {
                _loc_1 = _duration;
                _ended = 1;
            }
            _normalizedTime = EaseManager.evaluate(_easeType, _loc_10 ? (_duration - _loc_1) : (_loc_1), _duration, _easeOvershootOrAmplitude, _easePeriod);
            _value.setZero();
            _deltaValue.setZero();
            if (_valueSize == 5)
            {
                if (_ended == 0)
                {
                    _loc_2 = _startValue.w * (1 - _normalizedTime);
                    _loc_6 = (Math.random() * 2 - 1) * _loc_2;
                    _loc_8 = (Math.random() * 2 - 1) * _loc_2;
                    _loc_6 = _loc_6 > 0 ? (Math.ceil(_loc_6)) : (Math.floor(_loc_6));
                    _loc_8 = _loc_8 > 0 ? (Math.ceil(_loc_8)) : (Math.floor(_loc_8));
                    _deltaValue.x = _loc_6;
                    _deltaValue.y = _loc_8;
                    _value.x = _startValue.x + _loc_6;
                    _value.y = _startValue.y + _loc_8;
                }
                else
                {
                    _value.x = _startValue.x;
                    _value.y = _startValue.y;
                }
            }
            else if (_path)
            {
                _path.getPointAt(_normalizedTime, helperPoint);
                if (_snapping)
                {
                    helperPoint.x = Math.round(helperPoint.x);
                    helperPoint.y = Math.round(helperPoint.y);
                }
                _deltaValue.x = helperPoint.x - _value.x;
                _deltaValue.y = helperPoint.y - _value.y;
                _value.x = helperPoint.x;
                _value.y = helperPoint.y;
            }
            else
            {
                _loc_9 = 0;
                while (_loc_9 < _valueSize)
                {
                    
                    _loc_3 = _startValue.getField(_loc_9);
                    _loc_5 = _endValue.getField(_loc_9);
                    _loc_7 = _loc_3 + (_loc_5 - _loc_3) * _normalizedTime;
                    if (_snapping)
                    {
                        _loc_7 = Math.round(_loc_7);
                    }
                    _deltaValue.setField(_loc_9, _loc_7 - _value.getField(_loc_9));
                    _value.setField(_loc_9, _loc_7);
                    _loc_9++;
                }
            }
            if (_target != null && _propType != null)
            {
                if (_propType is Function)
                {
                    switch((_valueSize - 1)) branch count is:<5>[23, 43, 69, 101, 139, 159] default offset is:<181>;
                    _propType.call(_target, _value.x);
                    ;
                    _propType.call(_target, _value.x, _value.y);
                    ;
                    _propType.call(_target, _value.x, _value.y, _value.z);
                    ;
                    _propType.call(_target, _value.x, _value.y, _value.z, _value.w);
                    ;
                    _propType.call(_target, _value.color);
                    ;
                    _propType.call(_target, _value.x, _value.y);
                }
                else if (_valueSize == 5)
                {
                    _target[_propType] = _value.color;
                }
                else
                {
                    _target[_propType] = _value.x;
                }
            }
            callUpdateCallback();
            return;
        }// end function

        private function callStartCallback() : void
        {
            if (_onStart != null)
            {
                try
                {
                    if (_onStart.length != 0)
                    {
                        this._onStart(this);
                    }
                    else
                    {
                        this._onStart();
                    }
                }
                catch (err:Error)
                {
                    this.trace("FairyGUI: error in start callback > " + err.message);
                }
            }
            return;
        }// end function

        private function callUpdateCallback() : void
        {
            if (_onUpdate != null)
            {
                try
                {
                    if (_onUpdate.length != 0)
                    {
                        this._onUpdate(this);
                    }
                    else
                    {
                        this._onUpdate();
                    }
                }
                catch (err:Error)
                {
                    this.trace("FairyGUI: error in update callback > " + err.message);
                }
            }
            return;
        }// end function

        private function callCompleteCallback() : void
        {
            if (_onComplete != null)
            {
                try
                {
                    if (_onComplete.length != 0)
                    {
                        this._onComplete(this);
                    }
                    else
                    {
                        this._onComplete();
                    }
                }
                catch (err:Error)
                {
                    this.trace("FairyGUI: error in complete callback > " + err.message + "\n" + err.getStackTrace());
                }
            }
            return;
        }// end function

    }
}
