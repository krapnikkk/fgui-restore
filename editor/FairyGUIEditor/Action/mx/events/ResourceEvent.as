package mx.events
{
    import flash.events.*;

    public class ResourceEvent extends ProgressEvent
    {
        public var errorText:String;
        static const VERSION:String = "4.6.0.23201";
        public static const COMPLETE:String = "complete";
        public static const ERROR:String = "error";
        public static const PROGRESS:String = "progress";

        public function ResourceEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:uint = 0, param5:uint = 0, param6:String = null)
        {
            super(param1, param2, param3, param4, param5);
            this.errorText = param6;
            return;
        }// end function

        override public function clone() : Event
        {
            return new ResourceEvent(type, bubbles, cancelable, bytesLoaded, bytesTotal, this.errorText);
        }// end function

    }
}
