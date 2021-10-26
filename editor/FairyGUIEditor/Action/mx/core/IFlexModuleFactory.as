package mx.core
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.utils.*;

    public interface IFlexModuleFactory
    {

        public function IFlexModuleFactory();

        function get allowDomainsInNewRSLs() : Boolean;

        function set allowDomainsInNewRSLs(param1:Boolean) : void;

        function get allowInsecureDomainsInNewRSLs() : Boolean;

        function set allowInsecureDomainsInNewRSLs(param1:Boolean) : void;

        function get preloadedRSLs() : Dictionary;

        function addPreloadedRSL(param1:LoaderInfo, param2:Vector.<RSLData>) : void;

        function allowDomain(... args) : void;

        function allowInsecureDomain(... args) : void;

        function callInContext(param1:Function, param2:Object, param3:Array, param4:Boolean = true);

        function create(... args) : Object;

        function getImplementation(param1:String) : Object;

        function info() : Object;

        function registerImplementation(param1:String, param2:Object) : void;

    }
}
