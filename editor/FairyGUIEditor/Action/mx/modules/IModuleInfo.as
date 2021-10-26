package mx.modules
{
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;
    import mx.core.*;

    public interface IModuleInfo extends IEventDispatcher
    {

        public function IModuleInfo();

        function get data() : Object;

        function set data(param1:Object) : void;

        function get error() : Boolean;

        function get factory() : IFlexModuleFactory;

        function get loaded() : Boolean;

        function get ready() : Boolean;

        function get setup() : Boolean;

        function get url() : String;

        function load(param1:ApplicationDomain = null, param2:SecurityDomain = null, param3:ByteArray = null, param4:IFlexModuleFactory = null) : void;

        function release() : void;

        function unload() : void;

        function publish(param1:IFlexModuleFactory) : void;

    }
}
