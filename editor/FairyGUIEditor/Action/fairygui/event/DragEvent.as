package fairygui.event
{
    import flash.events.*;

    public class DragEvent extends Event
    {
        public var stageX:Number;
        public var stageY:Number;
        public var touchPointID:int;
        public static const DRAG_START:String = "startDrag";
        public static const DRAG_END:String = "endDrag";
        public static const DRAG_MOVING:String = "dragMoving";

        public function DragEvent(param1:String, param2:Number = 0, param3:Number = 0, param4:int = -1)
        {
            super(param1, false, true);
            this.stageX = param2;
            this.stageY = param3;
            this.touchPointID = param4;
            return;
        }// end function

        override public function clone() : Event
        {
            return new DragEvent(type, stageX, stageY, touchPointID);
        }// end function

    }
}
