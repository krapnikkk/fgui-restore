package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.tween.*;
    import fairygui.utils.*;
    import flash.filters.*;

    public class Transition extends Object
    {
        public var name:String;
        private var _owner:GComponent;
        private var _ownerBaseX:Number;
        private var _ownerBaseY:Number;
        private var _items:Vector.<TransitionItem>;
        private var _totalTimes:int;
        private var _totalTasks:int;
        private var _playing:Boolean;
        private var _paused:Boolean;
        private var _onComplete:Function;
        private var _onCompleteParam:Object;
        private var _options:int;
        private var _reversed:Boolean;
        private var _totalDuration:Number;
        private var _autoPlay:Boolean;
        private var _autoPlayTimes:int;
        private var _autoPlayDelay:Number;
        private var _timeScale:Number;
        private var _startTime:Number;
        private var _endTime:Number;
        private const OPTION_IGNORE_DISPLAY_CONTROLLER:int = 1;
        private const OPTION_AUTO_STOP_DISABLED:int = 2;
        private const OPTION_AUTO_STOP_AT_END:int = 4;
        private var helperPathPoints:Vector.<GPathPoint>;

        public function Transition(param1:GComponent)
        {
            helperPathPoints = new Vector.<GPathPoint>;
            _owner = param1;
            _items = new Vector.<TransitionItem>;
            _totalDuration = 0;
            _autoPlayTimes = 1;
            _autoPlayDelay = 0;
            _timeScale = 1;
            _startTime = 0;
            _endTime = 0;
            return;
        }// end function

        public function play(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0, param5:Number = 0, param6:Number = -1) : void
        {
            _play(param1, param2, param3, param4, param5, param6, false);
            return;
        }// end function

        public function playReverse(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0, param5:Number = 0, param6:Number = -1) : void
        {
            _play(param1, param2, 1, param4, param5, param6, true);
            return;
        }// end function

        public function changePlayTimes(param1:int) : void
        {
            _totalTimes = param1;
            return;
        }// end function

        public function setAutoPlay(param1:Boolean, param2:int = 1, param3:Number = 0) : void
        {
            if (_autoPlay != param1)
            {
                _autoPlay = param1;
                _autoPlayTimes = param2;
                _autoPlayDelay = param3;
                if (_autoPlay)
                {
                    if (_owner.onStage)
                    {
                        play(null, null, _autoPlayTimes, _autoPlayDelay);
                    }
                }
                else if (!_owner.onStage)
                {
                    stop(false, true);
                }
            }
            return;
        }// end function

        private function _play(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0, param5:Number = 0, param6:Number = -1, param7:Boolean = false) : void
        {
            var _loc_11:* = 0;
            var _loc_8:* = null;
            var _loc_13:* = null;
            var _loc_12:* = 0;
            var _loc_9:* = null;
            stop(true, true);
            _totalTimes = param3;
            _reversed = param7;
            _startTime = param5;
            _endTime = param6;
            _playing = true;
            _paused = false;
            _onComplete = param1;
            _onCompleteParam = param2;
            var _loc_10:* = _items.length;
            _loc_11 = 0;
            while (_loc_11 < _loc_10)
            {
                
                _loc_8 = _items[_loc_11];
                if (_loc_8.target == null)
                {
                    if (_loc_8.targetId)
                    {
                        _loc_8.target = _owner.getChildById(_loc_8.targetId);
                    }
                    else
                    {
                        _loc_8.target = _owner;
                    }
                }
                else if (_loc_8.target != _owner && _loc_8.target.parent != _owner)
                {
                    _loc_8.target = null;
                }
                if (_loc_8.target != null && _loc_8.type == 10)
                {
                    _loc_13 = this.GComponent(_loc_8.target).getTransition(_loc_8.value.transName);
                    if (_loc_13 == this)
                    {
                        _loc_13 = null;
                    }
                    if (_loc_13 != null)
                    {
                        if (_loc_8.value.playTimes == 0)
                        {
                            _loc_12 = _loc_11 - 1;
                            while (_loc_12 >= 0)
                            {
                                
                                _loc_9 = _items[_loc_12];
                                if (_loc_9.type == 10)
                                {
                                    if (_loc_9.value.trans == _loc_13)
                                    {
                                        _loc_9.value.stopTime = _loc_8.time - _loc_9.time;
                                        break;
                                    }
                                }
                                _loc_12--;
                            }
                            if (_loc_12 < 0)
                            {
                                _loc_8.value.stopTime = 0;
                            }
                            else
                            {
                                _loc_13 = null;
                            }
                        }
                        else
                        {
                            _loc_8.value.stopTime = -1;
                        }
                    }
                    _loc_8.value.trans = _loc_13;
                }
                _loc_11++;
            }
            if (param4 == 0)
            {
                onDelayedPlay();
            }
            else
            {
                GTween.delayedCall(param4).onComplete(onDelayedPlay);
            }
            return;
        }// end function

        public function stop(param1:Boolean = true, param2:Boolean = false) : void
        {
            var _loc_7:* = 0;
            var _loc_3:* = null;
            if (!_playing)
            {
                return;
            }
            _playing = false;
            _totalTasks = 0;
            _totalTimes = 0;
            var _loc_4:* = _onComplete;
            var _loc_5:* = _onCompleteParam;
            _onComplete = null;
            _onCompleteParam = null;
            GTween.kill(this);
            var _loc_6:* = _items.length;
            if (_reversed)
            {
                _loc_7 = _loc_6 - 1;
                while (_loc_7 >= 0)
                {
                    
                    _loc_3 = _items[_loc_7];
                    if (_loc_3.target != null)
                    {
                        stopItem(_loc_3, param1);
                    }
                    _loc_7--;
                }
            }
            else
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_3 = _items[_loc_7];
                    if (_loc_3.target != null)
                    {
                        stopItem(_loc_3, param1);
                    }
                    _loc_7++;
                }
            }
            if (param2 && _loc_4 != null)
            {
                if (_loc_4.length > 0)
                {
                    this._loc_4(_loc_5);
                }
                else
                {
                    this._loc_4();
                }
            }
            return;
        }// end function

        private function stopItem(param1:TransitionItem, param2:Boolean) : void
        {
            var _loc_3:* = null;
            if (param1.displayLockToken != 0)
            {
                param1.target.releaseDisplayLock(param1.displayLockToken);
                param1.displayLockToken = 0;
            }
            if (param1.tweener != null)
            {
                param1.tweener.kill(param2);
                param1.tweener = null;
                if (param1.type == 11 && !param2)
                {
                    param1.target._gearLocked = true;
                    param1.target.setXY(param1.target.x - param1.value.lastOffsetX, param1.target.y - param1.value.lastOffsetY);
                    param1.target._gearLocked = false;
                }
            }
            if (param1.type == 10)
            {
                _loc_3 = param1.value.trans;
                if (_loc_3 != null)
                {
                    _loc_3.stop(param2, false);
                }
            }
            return;
        }// end function

        public function setPaused(param1:Boolean) : void
        {
            var _loc_4:* = 0;
            var _loc_2:* = null;
            if (!_playing || _paused == param1)
            {
                return;
            }
            _paused = param1;
            var _loc_5:* = GTween.getTween(this);
            if (GTween.getTween(this) != null)
            {
                _loc_5.setPaused(param1);
            }
            var _loc_3:* = _items.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = _items[_loc_4];
                if (_loc_2.target != null)
                {
                    if (_loc_2.type == 10)
                    {
                        if (_loc_2.value.trans != null)
                        {
                            _loc_2.value.trans.setPaused(param1);
                        }
                    }
                    else if (_loc_2.type == 7)
                    {
                        if (param1)
                        {
                            _loc_2.value.flag = _loc_2.target.getProp(4);
                            _loc_2.target.setProp(4, false);
                        }
                        else
                        {
                            _loc_2.target.setProp(4, _loc_2.value.flag);
                        }
                    }
                    if (_loc_2.tweener != null)
                    {
                        _loc_2.tweener.setPaused(param1);
                    }
                }
                _loc_4++;
            }
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_3:* = 0;
            var _loc_1:* = null;
            if (_playing)
            {
                GTween.kill(this);
            }
            var _loc_2:* = _items.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = _items[_loc_3];
                if (_loc_1.tweener != null)
                {
                    _loc_1.tweener.kill();
                    _loc_1.tweener = null;
                }
                _loc_1.target = null;
                _loc_1.hook = null;
                if (_loc_1.tweenConfig != null)
                {
                    _loc_1.tweenConfig.endHook = null;
                }
                _loc_3++;
            }
            _items.length = 0;
            _playing = false;
            _onComplete = null;
            _onCompleteParam = null;
            return;
        }// end function

        public function get playing() : Boolean
        {
            return _playing;
        }// end function

        public function setValue(param1:String, ... args) : void
        {
            var _loc_7:* = null;
            var _loc_6:* = 0;
            args = null;
            var _loc_5:* = _items.length;
            var _loc_4:* = false;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                args = _items[_loc_6];
                if (args.label == param1)
                {
                    if (args.tweenConfig != null)
                    {
                        _loc_7 = args.tweenConfig.startValue;
                    }
                    else
                    {
                        _loc_7 = args.value;
                    }
                    _loc_4 = true;
                }
                else if (args.tweenConfig != null && args.tweenConfig.endLabel == param1)
                {
                    _loc_7 = args.tweenConfig.endValue;
                    _loc_4 = true;
                }
                else
                {
                    ;
                }
                var _loc_8:* = args.type;
                while (TransitionActionType.XY === _loc_8)
                {
                    
                    
                    
                    
                    
                    _loc_7.b1 = true;
                    _loc_7.b2 = true;
                    _loc_7.f1 = this.parseFloat(args[0]);
                    _loc_7.f2 = this.parseFloat(args[1]);
                    do
                    {
                        
                        _loc_7.f1 = this.parseFloat(args[0]);
                        do
                        {
                            
                            _loc_7.f1 = this.parseFloat(args[0]);
                            do
                            {
                                
                                _loc_7.f1 = this.parseFloat(args[0]);
                                do
                                {
                                    
                                    _loc_7.frame = this.parseInt(args[0]);
                                    if (args.length > 1)
                                    {
                                        _loc_7.playing = args[1];
                                    }
                                    do
                                    {
                                        
                                        _loc_7.visible = args[0];
                                        do
                                        {
                                            
                                            _loc_7.sound = args[0];
                                            if (args.length > 1)
                                            {
                                                _loc_7.volume = this.parseFloat(args[1]);
                                            }
                                            do
                                            {
                                                
                                                _loc_7.transName = args[0];
                                                if (args.length > 1)
                                                {
                                                    _loc_7.playTimes = this.parseInt(args[1]);
                                                }
                                                do
                                                {
                                                    
                                                    _loc_7.amplitude = this.parseFloat(args[0]);
                                                    if (args.length > 1)
                                                    {
                                                        _loc_7.duration = this.parseFloat(args[1]);
                                                    }
                                                    do
                                                    {
                                                        
                                                        _loc_7.f1 = this.parseFloat(args[0]);
                                                        _loc_7.f2 = this.parseFloat(args[1]);
                                                        _loc_7.f3 = this.parseFloat(args[2]);
                                                        _loc_7.f4 = this.parseFloat(args[3]);
                                                        do
                                                        {
                                                            
                                                            
                                                            _loc_7.text = args[0];
                                                            break;
                                                        }
                                                        if (1 === _loc_8) goto 154;
                                                        if (3 === _loc_8) goto 155;
                                                        if (2 === _loc_8) goto 156;
                                                        if (13 === _loc_8) goto 157;
                                                    }while (_loc_8 === 4)
                                                }while (_loc_8 === 5)
                                            }while (_loc_8 === 6)
                                        }while (_loc_8 === 7)
                                    }while (_loc_8 === 8)
                                }while (_loc_8 === 9)
                            }while (_loc_8 === 10)
                        }while (_loc_8 === 11)
                    }while (_loc_8 === 12)
                }while (_loc_8 === 14)
                if (15 === _loc_8) goto 542;
                _loc_6++;
            }
            if (!_loc_4)
            {
                throw new Error("label not exists");
            }
            return;
        }// end function

        public function setHook(param1:String, param2:Function) : void
        {
            var _loc_6:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = false;
            var _loc_5:* = _items.length;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_3 = _items[_loc_6];
                if (_loc_3.label == param1)
                {
                    _loc_3.hook = param2;
                    _loc_4 = true;
                    break;
                }
                if (_loc_3.tweenConfig != null && _loc_3.tweenConfig.endLabel == param1)
                {
                    _loc_3.tweenConfig.endHook = param2;
                    _loc_4 = true;
                    break;
                }
                _loc_6++;
            }
            if (!_loc_4)
            {
                throw new Error("label not exists");
            }
            return;
        }// end function

        public function clearHooks() : void
        {
            var _loc_3:* = 0;
            var _loc_1:* = null;
            var _loc_2:* = _items.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = _items[_loc_3];
                _loc_1.hook = null;
                if (_loc_1.tweenConfig != null)
                {
                    _loc_1.tweenConfig.endHook = null;
                }
                _loc_3++;
            }
            return;
        }// end function

        public function setTarget(param1:String, param2:GObject) : void
        {
            var _loc_6:* = 0;
            var _loc_3:* = null;
            var _loc_5:* = _items.length;
            var _loc_4:* = false;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_3 = _items[_loc_6];
                if (_loc_3.label == param1)
                {
                    _loc_3.targetId = param2 == _owner || param2 == null ? ("") : (param2.id);
                    if (_playing)
                    {
                        if (_loc_3.targetId.length > 0)
                        {
                            _loc_3.target = _owner.getChildById(_loc_3.targetId);
                        }
                        else
                        {
                            _loc_3.target = _owner;
                        }
                    }
                    else
                    {
                        _loc_3.target = null;
                    }
                    _loc_4 = true;
                }
                _loc_6++;
            }
            if (!_loc_4)
            {
                throw new Error("label not exists");
            }
            return;
        }// end function

        public function setDuration(param1:String, param2:Number) : void
        {
            var _loc_6:* = 0;
            var _loc_3:* = null;
            var _loc_5:* = _items.length;
            var _loc_4:* = false;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_3 = _items[_loc_6];
                if (_loc_3.tweenConfig != null && _loc_3.label == param1)
                {
                    _loc_3.tweenConfig.duration = param2;
                    _loc_4 = true;
                }
                _loc_6++;
            }
            if (!_loc_4)
            {
                throw new Error("label not exists");
            }
            return;
        }// end function

        public function getLabelTime(param1:String) : Number
        {
            var _loc_4:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = _items.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = _items[_loc_4];
                if (_loc_2.label == param1)
                {
                    return _loc_2.time;
                }
                if (_loc_2.tweenConfig != null && _loc_2.tweenConfig.endLabel == param1)
                {
                    return _loc_2.time + _loc_2.tweenConfig.duration;
                }
                _loc_4++;
            }
            return NaN;
        }// end function

        public function get timeScale() : Number
        {
            return _timeScale;
        }// end function

        public function set timeScale(param1:Number) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_2:* = null;
            if (_timeScale != param1)
            {
                _timeScale = param1;
                if (_playing)
                {
                    _loc_3 = _items.length;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3)
                    {
                        
                        _loc_2 = _items[_loc_4];
                        if (_loc_2.tweener != null)
                        {
                            _loc_2.tweener.setTimeScale(param1);
                        }
                        else if (_loc_2.type == 10)
                        {
                            if (_loc_2.value.trans != null)
                            {
                                _loc_2.value.trans.timeScale = param1;
                            }
                        }
                        else if (_loc_2.type == 7)
                        {
                            if (_loc_2.target != null)
                            {
                                _loc_2.target.setProp(7, param1);
                            }
                        }
                        _loc_4++;
                    }
                }
            }
            return;
        }// end function

        function updateFromRelations(param1:String, param2:Number, param3:Number) : void
        {
            var _loc_6:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = _items.length;
            if (_items.length == 0)
            {
                return;
            }
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_4 = _items[_loc_6];
                if (_loc_4.type == TransitionActionType.XY && _loc_4.targetId == param1)
                {
                    if (_loc_4.tweenConfig != null)
                    {
                        if (!_loc_4.tweenConfig.startValue.b3)
                        {
                            _loc_4.tweenConfig.startValue.f1 = _loc_4.tweenConfig.startValue.f1 + param2;
                            _loc_4.tweenConfig.startValue.f2 = _loc_4.tweenConfig.startValue.f2 + param3;
                        }
                        if (!_loc_4.tweenConfig.endValue.b3)
                        {
                            _loc_4.tweenConfig.endValue.f1 = _loc_4.tweenConfig.endValue.f1 + param2;
                            _loc_4.tweenConfig.endValue.f2 = _loc_4.tweenConfig.endValue.f2 + param3;
                        }
                    }
                    else if (!_loc_4.value.b3)
                    {
                        _loc_4.value.f1 = _loc_4.value.f1 + param2;
                        _loc_4.value.f2 = _loc_4.value.f2 + param3;
                    }
                }
                _loc_6++;
            }
            return;
        }// end function

        function onOwnerAddedToStage() : void
        {
            if (_autoPlay && !_playing)
            {
                play(null, null, _autoPlayTimes, _autoPlayDelay);
            }
            return;
        }// end function

        function onOwnerRemovedFromStage() : void
        {
            if ((_options & 2) == 0)
            {
                stop((_options & 4) != 0 ? (true) : (false), false);
            }
            return;
        }// end function

        private function onDelayedPlay() : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            internalPlay();
            _playing = _totalTasks > 0;
            if (_playing)
            {
                if ((_options & 1) != 0)
                {
                    _loc_4 = _items.length;
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _loc_1 = _items[_loc_5];
                        if (_loc_1.target != null && _loc_1.target != _owner)
                        {
                            _loc_1.displayLockToken = _loc_1.target.addDisplayLock();
                        }
                        _loc_5++;
                    }
                }
            }
            else if (_onComplete != null)
            {
                _loc_2 = _onComplete;
                _loc_3 = _onCompleteParam;
                _onComplete = null;
                _onCompleteParam = null;
                if (_loc_2.length > 0)
                {
                    this._loc_2(_loc_3);
                }
                else
                {
                    this._loc_2();
                }
            }
            return;
        }// end function

        private function internalPlay() : void
        {
            var _loc_1:* = null;
            var _loc_4:* = 0;
            _ownerBaseX = _owner.x;
            _ownerBaseY = _owner.y;
            _totalTasks = 0;
            var _loc_3:* = _items.length;
            var _loc_2:* = false;
            if (!_reversed)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_1 = _items[_loc_4];
                    if (_loc_1.target != null)
                    {
                        if (_loc_1.type == 7 && _startTime != 0 && _loc_1.time <= _startTime)
                        {
                            _loc_2 = true;
                            _loc_1.value.flag = false;
                        }
                        else
                        {
                            playItem(_loc_1);
                        }
                    }
                    _loc_4++;
                }
            }
            else
            {
                _loc_4 = _loc_3 - 1;
                while (_loc_4 >= 0)
                {
                    
                    _loc_1 = _items[_loc_4];
                    if (_loc_1.target != null)
                    {
                        playItem(_loc_1);
                    }
                    _loc_4--;
                }
            }
            if (_loc_2)
            {
                skipAnimations();
            }
            return;
        }// end function

        private function playItem(param1:TransitionItem) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = null;
            var _loc_2:* = null;
            if (param1.tweenConfig != null)
            {
                if (_reversed)
                {
                    _loc_3 = _totalDuration - param1.time - param1.tweenConfig.duration;
                }
                else
                {
                    _loc_3 = param1.time;
                }
                if (_endTime == -1 || _loc_3 <= _endTime)
                {
                    if (_reversed)
                    {
                        _loc_4 = param1.tweenConfig.endValue;
                        _loc_2 = param1.tweenConfig.startValue;
                    }
                    else
                    {
                        _loc_4 = param1.tweenConfig.startValue;
                        _loc_2 = param1.tweenConfig.endValue;
                    }
                    param1.value.b1 = _loc_4.b1 || _loc_2.b1;
                    param1.value.b2 = _loc_4.b2 || _loc_2.b2;
                    var _loc_5:* = param1.type;
                    while (TransitionActionType.XY === _loc_5)
                    {
                        
                        
                        
                        
                        param1.tweener = GTween.to2(_loc_4.f1, _loc_4.f2, _loc_2.f1, _loc_2.f2, param1.tweenConfig.duration);
                        do
                        {
                            
                            
                            param1.tweener = GTween.to(_loc_4.f1, _loc_2.f1, param1.tweenConfig.duration);
                            do
                            {
                                
                                param1.tweener = GTween.toColor(_loc_4.f1, _loc_2.f1, param1.tweenConfig.duration);
                                do
                                {
                                    
                                    param1.tweener = GTween.to4(_loc_4.f1, _loc_4.f2, _loc_4.f3, _loc_4.f4, _loc_2.f1, _loc_2.f2, _loc_2.f3, _loc_2.f4, param1.tweenConfig.duration);
                                    break;
                                }
                                if (1 === _loc_5) goto 188;
                                if (2 === _loc_5) goto 189;
                                if (13 === _loc_5) goto 190;
                            }while (_loc_5 === 4)
                            if (5 === _loc_5) goto 232;
                        }while (_loc_5 === 6)
                    }while (_loc_5 === 12)
                    param1.tweener.setDelay(_loc_3).setEase(param1.tweenConfig.easeType).setRepeat(param1.tweenConfig.repeat, param1.tweenConfig.yoyo).setTimeScale(_timeScale).setTarget(param1).onStart(onTweenStart).onUpdate(onTweenUpdate).onComplete(onTweenComplete);
                    if (_endTime >= 0)
                    {
                        param1.tweener.setBreakpoint(_endTime - _loc_3);
                    }
                    (_totalTasks + 1);
                }
            }
            else if (param1.type == 11)
            {
                if (_reversed)
                {
                    _loc_3 = _totalDuration - param1.time - param1.value.duration;
                }
                else
                {
                    _loc_3 = param1.time;
                }
                _loc_5 = 0;
                param1.value.offsetY = _loc_5;
                param1.value.offsetX = _loc_5;
                _loc_5 = 0;
                param1.value.lastOffsetY = _loc_5;
                param1.value.lastOffsetX = _loc_5;
                param1.tweener = GTween.shake(0, 0, param1.value.amplitude, param1.value.duration).setDelay(_loc_3).setTimeScale(_timeScale).setTarget(param1).onUpdate(onTweenUpdate).onComplete(onTweenComplete);
                if (_endTime >= 0)
                {
                    param1.tweener.setBreakpoint(_endTime - param1.time);
                }
                (_totalTasks + 1);
            }
            else
            {
                if (_reversed)
                {
                    _loc_3 = _totalDuration - param1.time;
                }
                else
                {
                    _loc_3 = param1.time;
                }
                if (_loc_3 <= _startTime)
                {
                    applyValue(param1);
                    callHook(param1, false);
                }
                else if (_endTime == -1 || _loc_3 <= _endTime)
                {
                    (_totalTasks + 1);
                    param1.tweener = GTween.delayedCall(_loc_3).setTimeScale(_timeScale).setTarget(param1).onComplete(onDelayedPlayItem);
                }
            }
            if (param1.tweener != null)
            {
                param1.tweener.seek(_startTime);
            }
            return;
        }// end function

        private function skipAnimations() : void
        {
            var _loc_8:* = 0;
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_7:* = null;
            var _loc_9:* = null;
            var _loc_3:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_4:* = _items.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3 = _items[_loc_5];
                if (!(_loc_3.type != 7 || _loc_3.time > _startTime))
                {
                    _loc_7 = this.TValue_Animation(_loc_3.value);
                    if (!_loc_7.flag)
                    {
                        _loc_9 = _loc_3.target;
                        _loc_8 = _loc_9.getProp(5);
                        _loc_1 = _loc_9.getProp(4) ? (0) : (-1);
                        _loc_2 = 0;
                        _loc_6 = _loc_5;
                        while (_loc_6 < _loc_4)
                        {
                            
                            _loc_3 = _items[_loc_6];
                            if (!(_loc_3.type != 7 || _loc_3.target != _loc_9 || _loc_3.time > _startTime))
                            {
                                _loc_7 = this.TValue_Animation(_loc_3.value);
                                _loc_7.flag = true;
                                if (_loc_7.frame != -1)
                                {
                                    _loc_8 = _loc_7.frame;
                                    if (_loc_7.playing)
                                    {
                                        _loc_1 = _loc_3.time;
                                    }
                                    else
                                    {
                                        _loc_1 = -1;
                                    }
                                    _loc_2 = 0;
                                }
                                else if (_loc_7.playing)
                                {
                                    if (_loc_1 < 0)
                                    {
                                        _loc_1 = _loc_3.time;
                                    }
                                }
                                else
                                {
                                    if (_loc_1 >= 0)
                                    {
                                        _loc_2 = _loc_2 + (_loc_3.time - _loc_1);
                                    }
                                    _loc_1 = -1;
                                }
                                callHook(_loc_3, false);
                            }
                            _loc_6++;
                        }
                        if (_loc_1 >= 0)
                        {
                            _loc_2 = _loc_2 + (_startTime - _loc_1);
                        }
                        _loc_9.setProp(4, _loc_1 >= 0);
                        _loc_9.setProp(5, _loc_8);
                        if (_loc_2 > 0)
                        {
                            _loc_9.setProp(6, _loc_2 * 1000);
                        }
                    }
                }
                _loc_5++;
            }
            return;
        }// end function

        private function onDelayedPlayItem(param1:GTweener) : void
        {
            var _loc_2:* = this.TransitionItem(param1.target);
            _loc_2.tweener = null;
            (_totalTasks - 1);
            applyValue(_loc_2);
            callHook(_loc_2, false);
            checkAllComplete();
            return;
        }// end function

        private function onTweenStart(param1:GTweener) : void
        {
            var _loc_4:* = null;
            var _loc_3:* = null;
            var _loc_2:* = this.TransitionItem(param1.target);
            if (_loc_2.type == TransitionActionType.XY || _loc_2.type == 1)
            {
                if (_reversed)
                {
                    _loc_4 = _loc_2.tweenConfig.endValue;
                    _loc_3 = _loc_2.tweenConfig.startValue;
                }
                else
                {
                    _loc_4 = _loc_2.tweenConfig.startValue;
                    _loc_3 = _loc_2.tweenConfig.endValue;
                }
                if (_loc_2.type == TransitionActionType.XY)
                {
                    if (_loc_2.target != _owner)
                    {
                        if (!_loc_4.b1)
                        {
                            param1.startValue.x = _loc_2.target.x;
                        }
                        else if (_loc_4.b3)
                        {
                            param1.startValue.x = _loc_4.f1 * _owner.width;
                        }
                        if (!_loc_4.b2)
                        {
                            param1.startValue.y = _loc_2.target.y;
                        }
                        else if (_loc_4.b3)
                        {
                            param1.startValue.y = _loc_4.f2 * _owner.height;
                        }
                        if (!_loc_3.b1)
                        {
                            param1.endValue.x = param1.startValue.x;
                        }
                        else if (_loc_3.b3)
                        {
                            param1.endValue.x = _loc_3.f1 * _owner.width;
                        }
                        if (!_loc_3.b2)
                        {
                            param1.endValue.y = param1.startValue.y;
                        }
                        else if (_loc_3.b3)
                        {
                            param1.endValue.y = _loc_3.f2 * _owner.height;
                        }
                    }
                    else
                    {
                        if (!_loc_4.b1)
                        {
                            param1.startValue.x = _loc_2.target.x - _ownerBaseX;
                        }
                        if (!_loc_4.b2)
                        {
                            param1.startValue.y = _loc_2.target.y - _ownerBaseY;
                        }
                        if (!_loc_3.b1)
                        {
                            param1.endValue.x = param1.startValue.x;
                        }
                        if (!_loc_3.b2)
                        {
                            param1.endValue.y = param1.startValue.y;
                        }
                    }
                }
                else
                {
                    if (!_loc_4.b1)
                    {
                        param1.startValue.x = _loc_2.target.width;
                    }
                    if (!_loc_4.b2)
                    {
                        param1.startValue.y = _loc_2.target.height;
                    }
                    if (!_loc_3.b1)
                    {
                        param1.endValue.x = param1.startValue.x;
                    }
                    if (!_loc_3.b2)
                    {
                        param1.endValue.y = param1.startValue.y;
                    }
                }
                if (_loc_2.tweenConfig.path)
                {
                    var _loc_5:* = true;
                    _loc_2.value.b2 = true;
                    _loc_2.value.b1 = _loc_5;
                    param1.setPath(_loc_2.tweenConfig.path);
                }
            }
            callHook(_loc_2, false);
            return;
        }// end function

        private function onTweenUpdate(param1:GTweener) : void
        {
            var _loc_2:* = this.TransitionItem(param1.target);
            var _loc_3:* = _loc_2.type;
            while (TransitionActionType.XY === _loc_3)
            {
                
                
                
                
                _loc_2.value.f1 = param1.value.x;
                _loc_2.value.f2 = param1.value.y;
                if (_loc_2.tweenConfig.path)
                {
                    _loc_2.value.f1 = _loc_2.value.f1 + param1.startValue.x;
                    _loc_2.value.f2 = _loc_2.value.f2 + param1.startValue.y;
                }
                do
                {
                    
                    
                    _loc_2.value.f1 = param1.value.x;
                    do
                    {
                        
                        _loc_2.value.f1 = param1.value.color;
                        do
                        {
                            
                            _loc_2.value.f1 = param1.value.x;
                            _loc_2.value.f2 = param1.value.y;
                            _loc_2.value.f3 = param1.value.z;
                            _loc_2.value.f4 = param1.value.w;
                            do
                            {
                                
                                _loc_2.value.offsetX = param1.deltaValue.x;
                                _loc_2.value.offsetY = param1.deltaValue.y;
                                break;
                            }
                            if (1 === _loc_3) goto 26;
                            if (2 === _loc_3) goto 27;
                            if (13 === _loc_3) goto 28;
                        }while (_loc_3 === 4)
                        if (5 === _loc_3) goto 119;
                    }while (_loc_3 === 6)
                }while (_loc_3 === 12)
            }while (_loc_3 === 11)
            applyValue(_loc_2);
            return;
        }// end function

        private function onTweenComplete(param1:GTweener) : void
        {
            var _loc_2:* = this.TransitionItem(param1.target);
            _loc_2.tweener = null;
            (_totalTasks - 1);
            if (param1.allCompleted)
            {
                callHook(_loc_2, true);
            }
            checkAllComplete();
            return;
        }// end function

        private function onPlayTransCompleted(param1:TransitionItem) : void
        {
            (_totalTasks - 1);
            checkAllComplete();
            return;
        }// end function

        private function callHook(param1:TransitionItem, param2:Boolean) : void
        {
            if (param2)
            {
                if (param1.tweenConfig != null && param1.tweenConfig.endHook != null)
                {
                    param1.tweenConfig.endHook();
                }
            }
            else if (param1.time >= _startTime && param1.hook != null)
            {
                param1.hook();
            }
            return;
        }// end function

        private function checkAllComplete() : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (_playing && _totalTasks == 0)
            {
                if (_totalTimes < 0)
                {
                    internalPlay();
                }
                else
                {
                    (_totalTimes - 1);
                    if (_totalTimes > 0)
                    {
                        internalPlay();
                    }
                    else
                    {
                        _playing = false;
                        _loc_4 = _items.length;
                        _loc_5 = 0;
                        while (_loc_5 < _loc_4)
                        {
                            
                            _loc_1 = _items[_loc_5];
                            if (_loc_1.target != null && _loc_1.displayLockToken != 0)
                            {
                                _loc_1.target.releaseDisplayLock(_loc_1.displayLockToken);
                                _loc_1.displayLockToken = 0;
                            }
                            _loc_5++;
                        }
                        if (_onComplete != null)
                        {
                            _loc_2 = _onComplete;
                            _loc_3 = _onCompleteParam;
                            _onComplete = null;
                            _onCompleteParam = null;
                            if (_loc_2.length > 0)
                            {
                                this._loc_2(_loc_3);
                            }
                            else
                            {
                                this._loc_2();
                            }
                        }
                    }
                }
            }
            return;
        }// end function

        private function applyValue(param1:TransitionItem) : void
        {
            var _loc_9:* = null;
            var _loc_5:* = NaN;
            var _loc_7:* = NaN;
            var _loc_4:* = null;
            var _loc_3:* = null;
            var _loc_2:* = null;
            var _loc_6:* = null;
            param1.target._gearLocked = true;
            var _loc_8:* = param1.value;
            var _loc_10:* = param1.type;
            while (TransitionActionType.XY === _loc_10)
            {
                
                if (param1.target == _owner)
                {
                    if (_loc_8.b1 && _loc_8.b2)
                    {
                        param1.target.setXY(_loc_8.f1 + _ownerBaseX, _loc_8.f2 + _ownerBaseY);
                    }
                    else if (_loc_8.b1)
                    {
                        param1.target.x = _loc_8.f1 + _ownerBaseX;
                    }
                    else
                    {
                        param1.target.y = _loc_8.f2 + _ownerBaseY;
                    }
                }
                else if (_loc_8.b3)
                {
                    if (_loc_8.b1 && _loc_8.b2)
                    {
                        param1.target.setXY(_loc_8.f1 * _owner.width, _loc_8.f2 * _owner.height);
                    }
                    else if (_loc_8.b1)
                    {
                        param1.target.x = _loc_8.f1 * _owner.width;
                    }
                    else if (_loc_8.b2)
                    {
                        param1.target.y = _loc_8.f2 * _owner.height;
                    }
                }
                else if (_loc_8.b1 && _loc_8.b2)
                {
                    param1.target.setXY(_loc_8.f1, _loc_8.f2);
                }
                else if (_loc_8.b1)
                {
                    param1.target.x = _loc_8.f1;
                }
                else if (_loc_8.b2)
                {
                    param1.target.y = _loc_8.f2;
                }
                do
                {
                    
                    if (!_loc_8.b1)
                    {
                        _loc_8.f1 = param1.target.width;
                    }
                    if (!_loc_8.b2)
                    {
                        _loc_8.f2 = param1.target.height;
                    }
                    param1.target.setSize(_loc_8.f1, _loc_8.f2);
                    do
                    {
                        
                        param1.target.setPivot(_loc_8.f1, _loc_8.f2, param1.target.pivotAsAnchor);
                        do
                        {
                            
                            param1.target.alpha = _loc_8.f1;
                            do
                            {
                                
                                param1.target.rotation = _loc_8.f1;
                                do
                                {
                                    
                                    param1.target.setScale(_loc_8.f1, _loc_8.f2);
                                    do
                                    {
                                        
                                        do
                                        {
                                            
                                            param1.target.setProp(2, _loc_8.f1);
                                            do
                                            {
                                                
                                                if (_loc_8.frame >= 0)
                                                {
                                                    param1.target.setProp(5, _loc_8.frame);
                                                }
                                                param1.target.setProp(4, _loc_8.playing);
                                                param1.target.setProp(7, _timeScale);
                                                do
                                                {
                                                    
                                                    param1.target.visible = _loc_8.visible;
                                                    do
                                                    {
                                                        
                                                        if (_playing)
                                                        {
                                                            _loc_9 = _loc_8.trans;
                                                            if (_loc_9 != null)
                                                            {
                                                                (_totalTasks + 1);
                                                                _loc_5 = _startTime > param1.time ? (_startTime - param1.time) : (0);
                                                                _loc_7 = _endTime >= 0 ? (_endTime - param1.time) : (-1);
                                                                if (_loc_8.stopTime >= 0 && (_loc_7 < 0 || _loc_7 > _loc_8.stopTime))
                                                                {
                                                                    _loc_7 = _loc_8.stopTime;
                                                                }
                                                                _loc_9.timeScale = _timeScale;
                                                                _loc_9._play(onPlayTransCompleted, param1, _loc_8.playTimes, 0, _loc_5, _loc_7, _reversed);
                                                            }
                                                        }
                                                        do
                                                        {
                                                            
                                                            if (_playing && param1.time >= _startTime)
                                                            {
                                                                if (_loc_8.audioClip == null)
                                                                {
                                                                    _loc_4 = UIPackage.getItemByURL(_loc_8.sound);
                                                                    if (_loc_4)
                                                                    {
                                                                        _loc_8.audioClip = _loc_4.owner.getSound(_loc_4);
                                                                    }
                                                                }
                                                                if (_loc_8.audioClip)
                                                                {
                                                                    GRoot.inst.playOneShotSound(_loc_8.audioClip, _loc_8.volume);
                                                                }
                                                            }
                                                            do
                                                            {
                                                                
                                                                param1.target.setXY(param1.target.x - _loc_8.lastOffsetX + _loc_8.offsetX, param1.target.y - _loc_8.lastOffsetY + _loc_8.offsetY);
                                                                _loc_8.lastOffsetX = _loc_8.offsetX;
                                                                _loc_8.lastOffsetY = _loc_8.offsetY;
                                                                do
                                                                {
                                                                    
                                                                    _loc_2 = param1.target.filters;
                                                                    if (_loc_2 == null || !(_loc_2[0] is ColorMatrixFilter))
                                                                    {
                                                                        _loc_3 = new ColorMatrixFilter();
                                                                        _loc_2 = [_loc_3];
                                                                    }
                                                                    else
                                                                    {
                                                                        _loc_3 = this.ColorMatrixFilter(_loc_2[0]);
                                                                    }
                                                                    _loc_6 = new ColorMatrix();
                                                                    _loc_6.adjustBrightness(_loc_8.f1);
                                                                    _loc_6.adjustContrast(_loc_8.f2);
                                                                    _loc_6.adjustSaturation(_loc_8.f3);
                                                                    _loc_6.adjustHue(_loc_8.f4);
                                                                    _loc_3.matrix = _loc_6;
                                                                    param1.target.filters = _loc_2;
                                                                    do
                                                                    {
                                                                        
                                                                        param1.target.text = _loc_8.text;
                                                                        do
                                                                        {
                                                                            
                                                                            param1.target.icon = _loc_8.text;
                                                                            break;
                                                                        }
                                                                    }while (_loc_10 === 1)
                                                                }while (_loc_10 === 3)
                                                            }while (_loc_10 === 4)
                                                        }while (_loc_10 === 5)
                                                    }while (_loc_10 === 2)
                                                }while (_loc_10 === 13)
                                            }while (_loc_10 === 6)
                                        }while (_loc_10 === 7)
                                    }while (_loc_10 === 8)
                                }while (_loc_10 === 10)
                            }while (_loc_10 === 9)
                        }while (_loc_10 === 11)
                    }while (_loc_10 === 12)
                }while (_loc_10 === 14)
            }while (_loc_10 === 15)
            param1.target._gearLocked = false;
            return;
        }// end function

        public function setup(param1:XML) : void
        {
            var _loc_7:* = NaN;
            var _loc_6:* = null;
            var _loc_9:* = null;
            var _loc_3:* = null;
            var _loc_5:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_8:* = null;
            this.name = param1.@name;
            var _loc_2:* = param1.@options;
            if (_loc_2)
            {
                _options = this.parseInt(_loc_2);
            }
            _autoPlay = param1.@autoPlay == "true";
            if (_autoPlay)
            {
                _loc_2 = param1.@autoPlayRepeat;
                if (_loc_2)
                {
                    _autoPlayTimes = this.parseInt(_loc_2);
                }
                _loc_2 = param1.@autoPlayDelay;
                if (_loc_2)
                {
                    _autoPlayDelay = this.parseFloat(_loc_2);
                }
            }
            _loc_2 = param1.@fps;
            if (_loc_2)
            {
                _loc_7 = 1 / this.parseInt(_loc_2);
            }
            else
            {
                _loc_7 = 0.0416667;
            }
            var _loc_4:* = param1.item;
            for each (_loc_12 in _loc_4)
            {
                
                _loc_6 = new TransitionItem(parseItemType(_loc_12.@type));
                _items.push(_loc_6);
                _loc_6.time = this.parseInt(_loc_12.@time) * _loc_7;
                _loc_6.targetId = _loc_12.@target;
                if (_loc_12.@tween == "true")
                {
                    _loc_6.tweenConfig = new TweenConfig();
                }
                _loc_6.label = _loc_12.@label;
                if (_loc_6.label.length == 0)
                {
                    _loc_6.label = null;
                }
                if (_loc_6.tweenConfig != null)
                {
                    _loc_6.tweenConfig.duration = this.parseInt(_loc_12.@duration) * _loc_7;
                    if (_loc_6.time + _loc_6.tweenConfig.duration > _totalDuration)
                    {
                        _totalDuration = _loc_6.time + _loc_6.tweenConfig.duration;
                    }
                    _loc_2 = _loc_12.@ease;
                    if (_loc_2)
                    {
                        _loc_6.tweenConfig.easeType = EaseType.parseEaseType(_loc_2);
                    }
                    _loc_6.tweenConfig.repeat = this.parseInt(_loc_12.@repeat);
                    _loc_6.tweenConfig.yoyo = _loc_12.@yoyo == "true";
                    _loc_6.tweenConfig.endLabel = _loc_12.@label2;
                    if (_loc_6.tweenConfig.endLabel.length == 0)
                    {
                        _loc_6.tweenConfig.endLabel = null;
                    }
                    _loc_9 = _loc_12.@endValue;
                    if (_loc_9)
                    {
                        decodeValue(_loc_6, _loc_12.@startValue, _loc_6.tweenConfig.startValue);
                        decodeValue(_loc_6, _loc_9, _loc_6.tweenConfig.endValue);
                    }
                    else
                    {
                        _loc_6.tweenConfig = null;
                        decodeValue(_loc_6, _loc_12.@startValue, _loc_6.value);
                    }
                    _loc_2 = _loc_12.@path;
                    if (_loc_2)
                    {
                        _loc_3 = _loc_2.split(",");
                        _loc_5 = new GPath();
                        _loc_6.tweenConfig.path = _loc_5;
                        helperPathPoints.length = 0;
                        _loc_10 = _loc_3.length;
                        _loc_11 = 0;
                        while (_loc_11 < _loc_10)
                        {
                            
                            _loc_8 = new GPathPoint();
                            _loc_11++;
                            _loc_8.curveType = this.parseInt(_loc_3[_loc_11]);
                            switch((_loc_8.curveType - 1)) branch count is:<1>[11, 91] default offset is:<225>;
                            _loc_11++;
                            _loc_8.x = this.parseInt(_loc_3[_loc_11]);
                            _loc_11++;
                            _loc_8.y = this.parseInt(_loc_3[_loc_11]);
                            _loc_11++;
                            _loc_8.control1_x = this.parseInt(_loc_3[_loc_11]);
                            _loc_11++;
                            _loc_8.control1_y = this.parseInt(_loc_3[_loc_11]);
                            ;
                            _loc_11++;
                            _loc_8.x = this.parseInt(_loc_3[_loc_11]);
                            _loc_11++;
                            _loc_8.y = this.parseInt(_loc_3[_loc_11]);
                            _loc_11++;
                            _loc_8.control1_x = this.parseInt(_loc_3[_loc_11]);
                            _loc_11++;
                            _loc_8.control1_y = this.parseInt(_loc_3[_loc_11]);
                            _loc_11++;
                            _loc_8.control2_x = this.parseInt(_loc_3[_loc_11]);
                            _loc_11++;
                            _loc_8.control2_y = this.parseInt(_loc_3[_loc_11]);
                            _loc_11++;
                            _loc_8.smooth = _loc_3[_loc_11] == "1";
                            ;
                            _loc_11++;
                            _loc_8.x = this.parseInt(_loc_3[_loc_11]);
                            _loc_11++;
                            _loc_8.y = this.parseInt(_loc_3[_loc_11]);
                            helperPathPoints.push(_loc_8);
                        }
                        _loc_5.create(helperPathPoints);
                    }
                    continue;
                }
                if (_loc_6.time > _totalDuration)
                {
                    _totalDuration = _loc_6.time;
                }
                decodeValue(_loc_6, _loc_12.@value, _loc_6.value);
            }
            return;
        }// end function

        private function parseItemType(param1:String) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = param1;
            while (_loc_3 === "XY")
            {
                
                _loc_2 = TransitionActionType.XY;
                do
                {
                    
                    _loc_2 = 1;
                    do
                    {
                        
                        _loc_2 = 2;
                        do
                        {
                            
                            _loc_2 = 3;
                            do
                            {
                                
                                _loc_2 = 4;
                                do
                                {
                                    
                                    _loc_2 = 5;
                                    do
                                    {
                                        
                                        _loc_2 = 6;
                                        do
                                        {
                                            
                                            _loc_2 = 7;
                                            do
                                            {
                                                
                                                _loc_2 = 8;
                                                do
                                                {
                                                    
                                                    _loc_2 = 9;
                                                    do
                                                    {
                                                        
                                                        _loc_2 = 10;
                                                        do
                                                        {
                                                            
                                                            _loc_2 = 11;
                                                            do
                                                            {
                                                                
                                                                _loc_2 = 12;
                                                                do
                                                                {
                                                                    
                                                                    _loc_2 = 13;
                                                                    do
                                                                    {
                                                                        
                                                                        _loc_2 = 14;
                                                                        do
                                                                        {
                                                                            
                                                                            _loc_2 = 15;
                                                                            do
                                                                            {
                                                                                
                                                                                _loc_2 = 16;
                                                                                break;
                                                                            }
                                                                        }while (_loc_3 === "Size")
                                                                    }while (_loc_3 === "Scale")
                                                                }while (_loc_3 === "Pivot")
                                                            }while (_loc_3 === "Alpha")
                                                        }while (_loc_3 === "Rotation")
                                                    }while (_loc_3 === "Color")
                                                }while (_loc_3 === "Animation")
                                            }while (_loc_3 === "Visible")
                                        }while (_loc_3 === "Sound")
                                    }while (_loc_3 === "Transition")
                                }while (_loc_3 === "Shake")
                            }while (_loc_3 === "ColorFilter")
                        }while (_loc_3 === "Skew")
                    }while (_loc_3 === "Text")
                }while (_loc_3 === "Icon")
            }while (true)
            return _loc_2;
        }// end function

        private function decodeValue(param1:TransitionItem, param2:String, param3:Object) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = param1.type;
            while (TransitionActionType.XY === _loc_6)
            {
                
                
                
                
                _loc_4 = param2.split(",");
                if (_loc_4[0] == "-")
                {
                    param3.b1 = false;
                }
                else
                {
                    param3.f1 = this.parseFloat(_loc_4[0]);
                    param3.b1 = true;
                }
                if (_loc_4[1] == "-")
                {
                    param3.b2 = false;
                }
                else
                {
                    param3.f2 = this.parseFloat(_loc_4[1]);
                    param3.b2 = true;
                }
                if (_loc_4.length > 2 && param1.type == TransitionActionType.XY)
                {
                    param3.b3 = true;
                    param3.f1 = this.parseFloat(_loc_4[2]);
                    param3.f2 = this.parseFloat(_loc_4[3]);
                }
                do
                {
                    
                    param3.f1 = this.parseFloat(param2);
                    do
                    {
                        
                        param3.f1 = this.parseFloat(param2);
                        do
                        {
                            
                            _loc_4 = param2.split(",");
                            param3.f1 = this.parseFloat(_loc_4[0]);
                            param3.f2 = this.parseFloat(_loc_4[1]);
                            do
                            {
                                
                                param3.f1 = ToolSet.convertFromHtmlColor(param2);
                                do
                                {
                                    
                                    _loc_4 = param2.split(",");
                                    if (_loc_4[0] == "-")
                                    {
                                        param3.frame = -1;
                                    }
                                    else
                                    {
                                        param3.frame = this.parseInt(_loc_4[0]);
                                    }
                                    param3.playing = _loc_4[1] == "p";
                                    do
                                    {
                                        
                                        param3.visible = param2 == "true";
                                        do
                                        {
                                            
                                            _loc_4 = param2.split(",");
                                            param3.sound = _loc_4[0];
                                            if (_loc_4.length > 1)
                                            {
                                                _loc_5 = this.parseInt(_loc_4[1]);
                                                if (_loc_5 == 0 || _loc_5 == 100)
                                                {
                                                    param3.volume = 1;
                                                }
                                                else
                                                {
                                                    param3.volume = _loc_5 / 100;
                                                }
                                            }
                                            else
                                            {
                                                param3.volume = 1;
                                            }
                                            do
                                            {
                                                
                                                _loc_4 = param2.split(",");
                                                param3.transName = _loc_4[0];
                                                if (_loc_4.length > 1)
                                                {
                                                    param3.playTimes = this.parseInt(_loc_4[1]);
                                                }
                                                else
                                                {
                                                    param3.playTimes = 1;
                                                }
                                                do
                                                {
                                                    
                                                    _loc_4 = param2.split(",");
                                                    param3.amplitude = this.parseFloat(_loc_4[0]);
                                                    param3.duration = this.parseFloat(_loc_4[1]);
                                                    do
                                                    {
                                                        
                                                        _loc_4 = param2.split(",");
                                                        param3.f1 = this.parseFloat(_loc_4[0]);
                                                        param3.f2 = this.parseFloat(_loc_4[1]);
                                                        param3.f3 = this.parseFloat(_loc_4[2]);
                                                        param3.f4 = this.parseFloat(_loc_4[3]);
                                                        do
                                                        {
                                                            
                                                            
                                                            param3.text = param2;
                                                            break;
                                                        }
                                                        if (1 === _loc_6) goto 20;
                                                        if (3 === _loc_6) goto 21;
                                                        if (13 === _loc_6) goto 22;
                                                    }while (_loc_6 === 4)
                                                }while (_loc_6 === 5)
                                            }while (_loc_6 === 2)
                                        }while (_loc_6 === 6)
                                    }while (_loc_6 === 7)
                                }while (_loc_6 === 8)
                            }while (_loc_6 === 9)
                        }while (_loc_6 === 10)
                    }while (_loc_6 === 11)
                }while (_loc_6 === 12)
            }while (_loc_6 === 14)
            if (15 === _loc_6) goto 684;
            return;
        }// end function

    }
}

import *.*;

import __AS3__.vec.*;

import fairygui.tween.*;

import fairygui.utils.*;

import flash.filters.*;

class TransitionItem extends Object
{
    public var time:Number;
    public var targetId:String;
    public var type:int;
    public var tweenConfig:TweenConfig;
    public var label:String;
    public var value:Object;
    public var hook:Function;
    public var tweener:GTweener;
    public var target:GObject;
    public var displayLockToken:uint;

    function TransitionItem(param1:int)
    {
        this.type = param1;
        switch(param1) branch count is:<15>[53, 53, 53, 53, 53, 53, 53, 71, 143, 107, 125, 89, 53, 53, 161, 161] default offset is:<175>;
        value = new TValue();
        ;
        value = new TValue_Animation();
        ;
        value = new TValue_Shake();
        ;
        value = new TValue_Sound();
        ;
        value = new TValue_Transition();
        ;
        value = new TValue_Visible();
        ;
        value = new TValue_Text();
        return;
    }// end function

}


import *.*;

import __AS3__.vec.*;

import fairygui.tween.*;

import fairygui.utils.*;

import flash.filters.*;

class TweenConfig extends Object
{
    public var duration:Number;
    public var easeType:int;
    public var repeat:int;
    public var yoyo:Boolean;
    public var startValue:TValue;
    public var endValue:TValue;
    public var path:GPath;
    public var endLabel:String;
    public var endHook:Function;

    function TweenConfig()
    {
        easeType = 5;
        startValue = new TValue();
        endValue = new TValue();
        return;
    }// end function

}


import *.*;

import __AS3__.vec.*;

import fairygui.tween.*;

import fairygui.utils.*;

import flash.filters.*;

class TValue_Animation extends Object
{
    public var frame:int;
    public var playing:Boolean;
    public var flag:Boolean;

    function TValue_Animation()
    {
        return;
    }// end function

}


import *.*;

import __AS3__.vec.*;

import fairygui.tween.*;

import fairygui.utils.*;

import flash.filters.*;

class TValue extends Object
{
    public var f1:Number;
    public var f2:Number;
    public var f3:Number;
    public var f4:Number;
    public var b1:Boolean;
    public var b2:Boolean;
    public var b3:Boolean;

    function TValue()
    {
        b2 = true;
        b1 = true;
        return;
    }// end function

}

