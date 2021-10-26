package fairygui.utils
{
    import *.*;
    import flash.events.*;

    public class CombineKeyHelper extends Object
    {
        private var _keyStatus:int;
        private var _keyCodes:Array;
        private var _keysCount:int;
        private var _keyMapping:Object;
        private var _combineKeyCode:int;
        private var _needReset:Boolean;

        public function CombineKeyHelper()
        {
            this._keyCodes = [];
            this._keyMapping = {};
            return;
        }// end function

        public function onKeyDown(event:KeyboardEvent) : void
        {
            var _loc_2:* = this._keyCodes[event.keyCode];
            if (_loc_2)
            {
                if (this._needReset)
                {
                    this._keyStatus = 0;
                }
                this._keyStatus = this._keyStatus | _loc_2;
                if (this._keyStatus)
                {
                    this._combineKeyCode = this._keyMapping[this._keyStatus];
                }
                else
                {
                    this._combineKeyCode = 0;
                }
            }
            this._needReset = event.ctrlKey || event.commandKey;
            return;
        }// end function

        public function onKeyUp(event:KeyboardEvent) : void
        {
            var _loc_2:* = this._keyCodes[event.keyCode];
            if (_loc_2)
            {
                this._keyStatus = this._keyStatus & ~_loc_2;
                if (this._keyStatus)
                {
                    this._combineKeyCode = this._keyMapping[this._keyStatus];
                }
                else
                {
                    this._combineKeyCode = 0;
                }
            }
            return;
        }// end function

        public function get keyCode() : int
        {
            return this._combineKeyCode;
        }// end function

        public function defineKey(param1:int, param2:int, param3:int) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            _loc_4 = this._keyCodes[param1];
            if (!_loc_4)
            {
                _loc_4 = 1 << this._keysCount;
                var _loc_6:* = this;
                var _loc_7:* = this._keysCount + 1;
                _loc_6._keysCount = _loc_7;
                this._keyCodes[param1] = _loc_4;
            }
            if (param2)
            {
                _loc_5 = this._keyCodes[param2];
                if (!_loc_5)
                {
                    _loc_5 = 1 << this._keysCount;
                    var _loc_6:* = this;
                    var _loc_7:* = this._keysCount + 1;
                    _loc_6._keysCount = _loc_7;
                    this._keyCodes[param2] = _loc_5;
                }
            }
            this._keyMapping[_loc_4 + _loc_5] = param3;
            return;
        }// end function

    }
}
