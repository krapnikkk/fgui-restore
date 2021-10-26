package mx.resources
{
    import flash.events.*;
    import flash.system.*;

    public interface IResourceManager extends IEventDispatcher
    {

        public function IResourceManager();

        function get localeChain() : Array;

        function set localeChain(param1:Array) : void;

        function loadResourceModule(param1:String, param2:Boolean = true, param3:ApplicationDomain = null, param4:SecurityDomain = null) : IEventDispatcher;

        function unloadResourceModule(param1:String, param2:Boolean = true) : void;

        function addResourceBundle(param1:IResourceBundle, param2:Boolean = false) : void;

        function removeResourceBundle(param1:String, param2:String) : void;

        function removeResourceBundlesForLocale(param1:String) : void;

        function update() : void;

        function getLocales() : Array;

        function getPreferredLocaleChain() : Array;

        function getBundleNamesForLocale(param1:String) : Array;

        function getResourceBundle(param1:String, param2:String) : IResourceBundle;

        function findResourceBundleWithResource(param1:String, param2:String) : IResourceBundle;

        function getObject(param1:String, param2:String, param3:String = null);

        function getString(param1:String, param2:String, param3:Array = null, param4:String = null) : String;

        function getStringArray(param1:String, param2:String, param3:String = null) : Array;

        function getNumber(param1:String, param2:String, param3:String = null) : Number;

        function getInt(param1:String, param2:String, param3:String = null) : int;

        function getUint(param1:String, param2:String, param3:String = null) : uint;

        function getBoolean(param1:String, param2:String, param3:String = null) : Boolean;

        function getClass(param1:String, param2:String, param3:String = null) : Class;

        function installCompiledResourceBundles(param1:ApplicationDomain, param2:Array, param3:Array, param4:Boolean = false) : Array;

        function initializeLocaleChain(param1:Array) : void;

    }
}
