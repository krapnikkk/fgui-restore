package fairygui.display
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class MovieClip extends Sprite
    {
        public var interval:int;
        public var swing:Boolean;
        public var repeatDelay:int;
        public var timeScale:Number;
        private var _bitmap:Bitmap;
        private var _frameCount:int;
        private var _frames:Vector.<Frame>;
        private var _boundsRect:Rectangle;
        private var _smoothing:Boolean;
        private var _frame:int;
        private var _playing:Boolean;
        private var _ready:Boolean;
        private var _start:int;
        private var _end:int;
        private var _times:int;
        private var _endAt:int;
        private var _status:int;
        private var _frameElapsed:Number;
        private var _reversed:Boolean;
        private var _repeatedCount:int;
        private var _callback:Function;

        public function MovieClip()
        {
            _bitmap = new Bitmap();
            addChild(_bitmap);
            _playing = true;
            _frameCount = 0;
            _frame = 0;
            _smoothing = true;
            _reversed = false;
            _frameElapsed = 0;
            _repeatedCount = 0;
            timeScale = 1;
            setPlaySettings();
            this.addEventListener("addedToStage", __addedToStage);
            this.addEventListener("removedFromStage", __removedFromStage);
            return;
        }// end function

        public function get frames() : Vector.<Frame>
        {
            return _frames;
        }// end function

        public function set frames(param1:Vector.<Frame>) : void
        {
            _frames = param1;
            if (_frames != null)
            {
                _frameCount = _frames.length;
            }
            else
            {
                _frameCount = 0;
            }
            if (_end == -1 || _end > (_frameCount - 1))
            {
                _end = _frameCount - 1;
            }
            if (_endAt == -1 || _endAt > (_frameCount - 1))
            {
                _endAt = _frameCount - 1;
            }
            if (_frame < 0 || _frame > (_frameCount - 1))
            {
                _frame = _frameCount - 1;
            }
            _ready = checkReady();
            drawFrame();
            _frameElapsed = 0;
            _repeatedCount = 0;
            _reversed = false;
            checkTimer();
            return;
        }// end function

        public function get frameCount() : int
        {
            return _frameCount;
        }// end function

        public function get boundsRect() : Rectangle
        {
            return _boundsRect;
        }// end function

        public function set boundsRect(param1:Rectangle) : void
        {
            _boundsRect = param1;
            return;
        }// end function

        public function get frame() : int
        {
            return _frame;
        }// end function

        public function set frame(param1:int) : void
        {
            if (_frame != param1)
            {
                if (_frames != null && param1 >= _frameCount)
                {
                    param1 = _frameCount - 1;
                }
                _frame = param1;
                _frameElapsed = 0;
                drawFrame();
            }
            return;
        }// end function

        public function get playing() : Boolean
        {
            return _playing;
        }// end function

        public function set playing(param1:Boolean) : void
        {
            if (_playing != param1)
            {
                _playing = param1;
                checkTimer();
            }
            return;
        }// end function

        public function get smoothing() : Boolean
        {
            return _smoothing;
        }// end function

        public function set smoothing(param1:Boolean) : void
        {
            _smoothing = param1;
            _bitmap.smoothing = _smoothing;
            return;
        }// end function

        public function rewind() : void
        {
            _frame = 0;
            _frameElapsed = 0;
            _reversed = false;
            _repeatedCount = 0;
            drawFrame();
            return;
        }// end function

        public function syncStatus(param1:MovieClip) : void
        {
            _frame = param1._frame;
            _frameElapsed = param1._frameElapsed;
            _reversed = param1._reversed;
            _repeatedCount = param1._repeatedCount;
            drawFrame();
            return;
        }// end function

        public function advance(param1:Number) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_6:* = _frame;
            var _loc_4:* = _reversed;
            var _loc_5:* = param1;
            while (true)
            {
                
                _loc_2 = interval + _frames[_frame].addDelay;
                if (_frame == 0 && _repeatedCount > 0)
                {
                    _loc_2 = _loc_2 + repeatDelay;
                }
                if (param1 < _loc_2)
                {
                    _frameElapsed = 0;
                    break;
                }
                param1 = param1 - _loc_2;
                if (swing)
                {
                    if (_reversed)
                    {
                        (_frame - 1);
                        if (_frame <= 0)
                        {
                            _frame = 0;
                            (_repeatedCount + 1);
                            _reversed = !_reversed;
                        }
                    }
                    else
                    {
                        (_frame + 1);
                        if (_frame > (_frameCount - 1))
                        {
                            _frame = Math.max(0, _frameCount - 2);
                            (_repeatedCount + 1);
                            _reversed = !_reversed;
                        }
                    }
                }
                else
                {
                    (_frame + 1);
                    if (_frame > (_frameCount - 1))
                    {
                        _frame = 0;
                        (_repeatedCount + 1);
                    }
                }
                if (_frame == _loc_6 && _reversed == _loc_4)
                {
                    _loc_3 = _loc_5 - param1;
                    param1 = param1 - Math.floor(param1 / _loc_3) * _loc_3;
                }
            }
            drawFrame();
            return;
        }// end function

        public function setPlaySettings(param1:int = 0, param2:int = -1, param3:int = 0, param4:int = -1, param5:Function = null) : void
        {
            _start = param1;
            _end = param2;
            if (_end == -1 || _end > (_frameCount - 1))
            {
                _end = _frameCount - 1;
            }
            _times = param3;
            _endAt = param4;
            if (_endAt == -1)
            {
                _endAt = _end;
            }
            _status = 0;
            _callback = param5;
            this.frame = param1;
            return;
        }// end function

        private function checkReady() : Boolean
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            _loc_1 = 0;
            while (_loc_1 < _frameCount)
            {
                
                _loc_2 = _frames[_loc_1];
                if (_loc_2.rect.width != 0 && _loc_2.image == null)
                {
                    return false;
                }
                _loc_1++;
            }
            return true;
        }// end function

        private function update() : void
        {
            var _loc_3:* = null;
            if (!_ready)
            {
                if (checkReady())
                {
                    _ready = true;
                    if (!_playing)
                    {
                        GTimers.inst.remove(update);
                        drawFrame();
                    }
                }
            }
            if (!_playing || _frameCount == 0 || _status == 3)
            {
                return;
            }
            var _loc_1:* = GTimers.deltaTime;
            if (timeScale != 1)
            {
                _loc_1 = _loc_1 * timeScale;
            }
            _frameElapsed = _frameElapsed + _loc_1;
            var _loc_2:* = interval + _frames[_frame].addDelay;
            if (_frame == 0 && _repeatedCount > 0)
            {
                _loc_2 = _loc_2 + repeatDelay;
            }
            if (_frameElapsed < _loc_2)
            {
                return;
            }
            _frameElapsed = _frameElapsed - _loc_2;
            if (_frameElapsed > interval)
            {
                _frameElapsed = interval;
            }
            if (swing)
            {
                if (_reversed)
                {
                    (_frame - 1);
                    if (_frame <= 0)
                    {
                        _frame = 0;
                        (_repeatedCount + 1);
                        _reversed = !_reversed;
                    }
                }
                else
                {
                    (_frame + 1);
                    if (_frame > (_frameCount - 1))
                    {
                        _frame = Math.max(0, _frameCount - 2);
                        (_repeatedCount + 1);
                        _reversed = !_reversed;
                    }
                }
            }
            else
            {
                (_frame + 1);
                if (_frame > (_frameCount - 1))
                {
                    _frame = 0;
                    (_repeatedCount + 1);
                }
            }
            if (_status == 1)
            {
                _frame = _start;
                _frameElapsed = 0;
                _status = 0;
            }
            else if (_status == 2)
            {
                _frame = _endAt;
                _frameElapsed = 0;
                _status = 3;
                if (_callback != null)
                {
                    _loc_3 = _callback;
                    _callback = null;
                    if (_loc_3.length == 1)
                    {
                        this._loc_3(this);
                    }
                    else
                    {
                        this._loc_3();
                    }
                }
            }
            else if (_frame == _end)
            {
                if (_times > 0)
                {
                    (_times - 1);
                    if (_times == 0)
                    {
                        _status = 2;
                    }
                    else
                    {
                        _status = 1;
                    }
                }
                else if (_start != 0)
                {
                    _status = 1;
                }
            }
            drawFrame();
            return;
        }// end function

        private function drawFrame() : void
        {
            var _loc_1:* = null;
            if (_frameCount > 0 && _frame < _frames.length)
            {
                _loc_1 = _frames[_frame];
                _bitmap.bitmapData = _loc_1.image;
                if (_bitmap.smoothing != _smoothing)
                {
                    _bitmap.smoothing = _smoothing;
                }
                _bitmap.x = _loc_1.rect.x;
                _bitmap.y = _loc_1.rect.y;
            }
            else
            {
                _bitmap.bitmapData = null;
            }
            return;
        }// end function

        private function checkTimer() : void
        {
            if ((_playing || !_ready) && _frameCount > 0 && this.stage != null)
            {
                GTimers.inst.add(1, 0, update);
            }
            else
            {
                GTimers.inst.remove(update);
            }
            return;
        }// end function

        private function __addedToStage(event:Event) : void
        {
            if ((_playing || !_ready) && _frameCount > 0)
            {
                GTimers.inst.add(1, 0, update);
            }
            return;
        }// end function

        private function __removedFromStage(event:Event) : void
        {
            GTimers.inst.remove(update);
            return;
        }// end function

    }
}
