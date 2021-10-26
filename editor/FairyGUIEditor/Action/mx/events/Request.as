package mx.events
{
    import flash.events.*;

    public class Request extends Event
    {
        public var value:Object;
        static const VERSION:String = "4.6.0.23201";
        public static const GET_PARENT_FLEX_MODULE_FACTORY_REQUEST:String = "getParentFlexModuleFactoryRequest";

        public function Request(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
        {
            super(param1, param2, param3);
            this.value = param4;
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new Request(type, bubbles, cancelable, this.value);
            return _loc_1;
        }// end function

    }
}
