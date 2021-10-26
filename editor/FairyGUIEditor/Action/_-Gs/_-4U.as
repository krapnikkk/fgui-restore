package _-Gs
{
    import *.*;
    import flash.events.*;

    public class _-4U extends Event
    {
        private var _-HY:uint;
        private var _ctrlKey:Boolean;
        private var _-OQ:Boolean;
        private var _-L7:Boolean;
        private var _shiftKey:Boolean;
        private var _-Nb:uint;
        private var _-9n:uint;
        private var _-Ai:int;
        private var _-6q:String;
        private var _-9V:String;
        public static const _-76:String = "EditorKeyPress";

        public function _-4U(param1:String, param2:KeyboardEvent = null, param3:int = 0, param4:String = null, param5:String = null)
        {
            super(param1, false, false);
            this._-Ai = param3;
            this._-6q = param4;
            this._-9V = param5;
            if (param2)
            {
                this.copyFrom(param2);
            }
            return;
        }// end function

        public function get keyLocation() : uint
        {
            return this._-HY;
        }// end function

        public function get ctrlKey() : Boolean
        {
            return this._ctrlKey;
        }// end function

        public function get commandKey() : Boolean
        {
            return this._-OQ;
        }// end function

        public function get charCode() : uint
        {
            return this._-9n;
        }// end function

        public function get keyCode() : uint
        {
            return this._-Nb;
        }// end function

        public function get shiftKey() : Boolean
        {
            return this._shiftKey;
        }// end function

        public function get altKey() : Boolean
        {
            return this._-L7;
        }// end function

        public function get _-2h() : int
        {
            return this._-Ai;
        }// end function

        public function get _-T() : String
        {
            return this._-6q;
        }// end function

        public function get _-8r() : String
        {
            return this._-9V;
        }// end function

        private function copyFrom(param1:Object) : void
        {
            this._-HY = param1.keyLocation;
            this._ctrlKey = param1.ctrlKey;
            this._-OQ = param1.commandKey;
            this._-L7 = param1.altKey;
            this._shiftKey = param1.shiftKey;
            this._-Nb = param1.keyCode;
            this._-9n = param1.charCode;
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new _-4U(type, null, this._-Ai, this._-T, this._-9V);
            _loc_1.copyFrom(this);
            return _loc_1;
        }// end function

    }
}
