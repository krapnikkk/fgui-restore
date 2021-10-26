package fairygui.event
{
    import *.*;
    import flash.display.*;
    import flash.events.*;

    public class GTouchEvent extends Event
    {
        private var _stopPropagation:Boolean;
        private var _realTarget:DisplayObject;
        private var _clickCount:int;
        private var _stageX:Number;
        private var _stageY:Number;
        private var _shiftKey:Boolean;
        private var _ctrlKey:Boolean;
        private var _touchPointID:int;
        public static const BEGIN:String = "beginGTouch";
        public static const DRAG:String = "dragGTouch";
        public static const END:String = "endGTouch";
        public static const CLICK:String = "clickGTouch";

        public function GTouchEvent(param1:String) : void
        {
            super(param1, false, false);
            return;
        }// end function

        public function copyFrom(event:Event, param2:int = 1) : void
        {
            if (event is MouseEvent)
            {
                _stageX = this.MouseEvent(event).stageX;
                _stageY = this.MouseEvent(event).stageY;
                _shiftKey = this.MouseEvent(event).shiftKey;
                _ctrlKey = this.MouseEvent(event).ctrlKey;
            }
            else
            {
                _stageX = this.TouchEvent(event).stageX;
                _stageY = this.TouchEvent(event).stageY;
                _shiftKey = this.TouchEvent(event).shiftKey;
                _ctrlKey = this.TouchEvent(event).ctrlKey;
                _touchPointID = this.TouchEvent(event).touchPointID;
            }
            _realTarget = event.target as DisplayObject;
            _clickCount = param2;
            _stopPropagation = false;
            return;
        }// end function

        final public function get realTarget() : DisplayObject
        {
            return _realTarget;
        }// end function

        final public function get clickCount() : int
        {
            return _clickCount;
        }// end function

        final public function get stageX() : Number
        {
            return _stageX;
        }// end function

        final public function get stageY() : Number
        {
            return _stageY;
        }// end function

        final public function get shiftKey() : Boolean
        {
            return _shiftKey;
        }// end function

        final public function get ctrlKey() : Boolean
        {
            return _ctrlKey;
        }// end function

        final public function get touchPointID() : int
        {
            return _touchPointID;
        }// end function

        override public function stopPropagation() : void
        {
            _stopPropagation = true;
            return;
        }// end function

        final public function get isPropagationStop() : Boolean
        {
            return _stopPropagation;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new GTouchEvent(type);
            _loc_1._realTarget = _realTarget;
            _loc_1._clickCount = _clickCount;
            _loc_1._stageX = _stageX;
            _loc_1._stageY = _stageY;
            _loc_1._shiftKey = _shiftKey;
            _loc_1._ctrlKey = _ctrlKey;
            _loc_1._touchPointID = _touchPointID;
            return _loc_1;
        }// end function

    }
}
