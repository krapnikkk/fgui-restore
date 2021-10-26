package fairygui.utils
{
    import *.*;
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.utils.*;

    public class GTimers extends Object
    {
        private var _items:Object;
        private var _itemMap:Dictionary;
        private var _itemPool:Object;
        private var _timer:Timer;
        private var _lastTime:Number;
        private var _enumI:int;
        private var _enumCount:int;
        public static var deltaTime:int;
        public static var time:Number;
        public static var workCount:uint;
        public static const inst:GTimers = new GTimers;
        private static const FPS24:int = 41;
        private static const FPS60:int = 16;

        public function GTimers() : void
        {
            _items = new Vector.<TimerItem>;
            _itemMap = new Dictionary();
            _itemPool = new Vector.<TimerItem>;
            deltaTime = 1;
            _lastTime = this.getTimer();
            time = _lastTime;
            _timer = new Timer(10);
            _timer.addEventListener("timer", __timer);
            _timer.start();
            return;
        }// end function

        private function getItem() : TimerItem
        {
            if (_itemPool.length)
            {
                return _itemPool.pop();
            }
            return new TimerItem();
        }// end function

        public function add(param1:int, param2:int, param3:Function, param4:Object = null) : void
        {
            var _loc_5:* = _itemMap[param3];
            if (!_itemMap[param3])
            {
                _loc_5 = getItem();
                _loc_5.callback = param3;
                _loc_5.hasParam = param3.length == 1;
                _itemMap[param3] = _loc_5;
                _items.push(_loc_5);
            }
            _loc_5.delay = param1;
            _loc_5.counter = 0;
            _loc_5.repeat = param2;
            _loc_5.param = param4;
            _loc_5.end = false;
            return;
        }// end function

        public function callLater(param1:Function, param2:Object = null) : void
        {
            add(1, 1, param1, param2);
            return;
        }// end function

        public function callDelay(param1:int, param2:Function, param3:Object = null) : void
        {
            add(param1, 1, param2, param3);
            return;
        }// end function

        public function callBy24Fps(param1:Function, param2:Object = null) : void
        {
            add(41, 0, param1, param2);
            return;
        }// end function

        public function callBy60Fps(param1:Function, param2:Object = null) : void
        {
            add(16, 0, param1, param2);
            return;
        }// end function

        public function exists(param1:Function) : Boolean
        {
            return _itemMap[param1] != undefined;
        }// end function

        public function remove(param1:Function) : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = _itemMap[param1];
            if (_loc_2)
            {
                _loc_3 = _items.indexOf(_loc_2);
                _items.splice(_loc_3, 1);
                if (_loc_3 < _enumI)
                {
                    (_enumI - 1);
                }
                (_enumCount - 1);
                _loc_2.callback = null;
                _loc_2.param = null;
                delete _itemMap[param1];
                _itemPool.push(_loc_2);
            }
            return;
        }// end function

        public function step() : void
        {
            __timer(null);
            return;
        }// end function

        private function __timer(event:TimerEvent) : void
        {
            var _loc_2:* = null;
            time = this.getTimer();
            (workCount + 1);
            deltaTime = time - _lastTime;
            _lastTime = time;
            _enumI = 0;
            _enumCount = _items.length;
            while (_enumI < _enumCount)
            {
                
                _loc_2 = _items[_enumI];
                (_enumI + 1);
                if (_loc_2.advance(deltaTime))
                {
                    if (_loc_2.end)
                    {
                        (_enumI - 1);
                        (_enumCount - 1);
                        _items.splice(_enumI, 1);
                        delete _itemMap[_loc_2.callback];
                        _itemPool.push(_loc_2);
                    }
                    if (_loc_2.hasParam)
                    {
                        _loc_2.callback(_loc_2.param);
                        continue;
                    }
                    _loc_2.callback();
                }
            }
            return;
        }// end function

    }
}

import *.*;

import __AS3__.vec.*;

import flash.events.*;

import flash.utils.*;

class TimerItem extends Object
{
    public var delay:int;
    public var counter:int;
    public var repeat:int;
    public var callback:Function;
    public var param:Object;
    public var hasParam:Boolean;
    public var end:Boolean;

    function TimerItem()
    {
        return;
    }// end function

    public function advance(param1:int) : Boolean
    {
        counter = counter + param1;
        if (counter >= delay)
        {
            counter = counter - delay;
            if (counter > delay)
            {
                counter = delay;
            }
            if (repeat > 0)
            {
                (repeat - 1);
                if (repeat == 0)
                {
                    end = true;
                }
            }
            return true;
        }
        return false;
    }// end function

}

