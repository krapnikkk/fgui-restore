package mx.modules
{
    import *.*;
    import mx.core.*;

    public class ModuleManager extends Object
    {
        static const VERSION:String = "4.6.0.23201";

        public function ModuleManager()
        {
            return;
        }// end function

        public static function getModule(param1:String) : IModuleInfo
        {
            return getSingleton().getModule(param1);
        }// end function

        public static function getAssociatedFactory(param1:Object) : IFlexModuleFactory
        {
            return getSingleton().getAssociatedFactory(param1);
        }// end function

        private static function getSingleton() : Object
        {
            if (!ModuleManagerGlobals.managerSingleton)
            {
                ModuleManagerGlobals.managerSingleton = new ModuleManagerImpl();
            }
            return ModuleManagerGlobals.managerSingleton;
        }// end function

    }
}

import *.*;

import mx.core.*;

class ModuleManagerImpl extends EventDispatcher
{
    private var moduleDictionary:Dictionary;

    function ModuleManagerImpl()
    {
        this.moduleDictionary = new Dictionary(true);
        return;
    }// end function

    public function getAssociatedFactory(param1:Object) : IFlexModuleFactory
    {
        var _loc_3:* = null;
        var _loc_4:* = null;
        var _loc_5:* = null;
        var _loc_6:* = null;
        var _loc_2:* = getQualifiedClassName(param1);
        for (_loc_3 in this.moduleDictionary)
        {
            
            _loc_4 = _loc_3 as ModuleInfo;
            if (!_loc_4.ready)
            {
                continue;
            }
            _loc_5 = _loc_4.applicationDomain;
            if (_loc_5.hasDefinition(_loc_2))
            {
                _loc_6 = Class(_loc_5.getDefinition(_loc_2));
                if (_loc_6 && param1 is _loc_6)
                {
                    return _loc_4.factory;
                }
            }
        }
        return null;
    }// end function

    public function getModule(param1:String) : IModuleInfo
    {
        var _loc_3:* = null;
        var _loc_4:* = null;
        var _loc_2:* = null;
        for (_loc_3 in this.moduleDictionary)
        {
            
            _loc_4 = _loc_3 as ModuleInfo;
            if (_loc_6[_loc_4] == param1)
            {
                _loc_2 = _loc_4;
                break;
            }
        }
        if (!_loc_2)
        {
            _loc_2 = new ModuleInfo(param1);
            _loc_6[_loc_2] = param1;
        }
        return new ModuleInfoProxy(_loc_2);
    }// end function

}

