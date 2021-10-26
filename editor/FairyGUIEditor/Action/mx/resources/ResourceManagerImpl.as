package mx.resources
{
    import *.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;
    import mx.events.*;
    import mx.managers.*;
    import mx.modules.*;
    import mx.resources.*;
    import mx.utils.*;

    public class ResourceManagerImpl extends EventDispatcher implements IResourceManager
    {
        private var ignoreMissingBundles:Boolean;
        private var bundleDictionary:Dictionary;
        private var localeMap:Object;
        private var resourceModules:Object;
        private var initializedForNonFrameworkApp:Boolean = false;
        private var _localeChain:Array;
        static const VERSION:String = "4.6.0.23201";
        private static var instance:IResourceManager;

        public function ResourceManagerImpl()
        {
            this.localeMap = {};
            this.resourceModules = {};
            if (SystemManagerGlobals.topLevelSystemManagers.length)
            {
                if (SystemManagerGlobals.topLevelSystemManagers[0].currentFrame == 1)
                {
                    this.ignoreMissingBundles = true;
                    SystemManagerGlobals.topLevelSystemManagers[0].addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                }
            }
            var _loc_1:* = SystemManagerGlobals.info;
            if (_loc_1)
            {
                this.processInfo(_loc_1, false);
            }
            this.ignoreMissingBundles = false;
            if (SystemManagerGlobals.topLevelSystemManagers.length)
            {
                SystemManagerGlobals.topLevelSystemManagers[0].addEventListener(FlexEvent.NEW_CHILD_APPLICATION, this.newChildApplicationHandler);
            }
            return;
        }// end function

        public function get localeChain() : Array
        {
            return this._localeChain;
        }// end function

        public function set localeChain(param1:Array) : void
        {
            this._localeChain = param1;
            this.update();
            return;
        }// end function

        public function installCompiledResourceBundles(param1:ApplicationDomain, param2:Array, param3:Array, param4:Boolean = false) : Array
        {
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_5:* = [];
            var _loc_6:* = 0;
            var _loc_7:* = param2 ? (param2.length) : (0);
            var _loc_8:* = param3 ? (param3.length) : (0);
            var _loc_9:* = 0;
            while (_loc_9 < _loc_7)
            {
                
                _loc_10 = param2[_loc_9];
                _loc_11 = 0;
                while (_loc_11 < _loc_8)
                {
                    
                    _loc_12 = param3[_loc_11];
                    _loc_13 = this.installCompiledResourceBundle(param1, _loc_10, _loc_12, param4);
                    if (_loc_13)
                    {
                        _loc_5[++_loc_6] = _loc_13;
                    }
                    _loc_11++;
                }
                _loc_9++;
            }
            return _loc_5;
        }// end function

        private function installCompiledResourceBundle(param1:ApplicationDomain, param2:String, param3:String, param4:Boolean = false) : IResourceBundle
        {
            var _loc_5:* = null;
            var _loc_6:* = param3;
            var _loc_7:* = _loc_6.indexOf(":");
            if (_loc_6.indexOf(":") != -1)
            {
                _loc_5 = _loc_6.substring(0, _loc_7);
                _loc_6 = _loc_6.substring((_loc_7 + 1));
            }
            var _loc_8:* = this.getResourceBundleInternal(param2, param3, param4);
            if (this.getResourceBundleInternal(param2, param3, param4))
            {
                return _loc_8;
            }
            var _loc_9:* = param2 + "$" + _loc_6 + "_properties";
            if (_loc_5 != null)
            {
                _loc_9 = _loc_5 + "." + _loc_9;
            }
            var _loc_10:* = null;
            if (param1.hasDefinition(_loc_9))
            {
                _loc_10 = Class(param1.getDefinition(_loc_9));
            }
            if (!_loc_10)
            {
                _loc_9 = param3;
                if (param1.hasDefinition(_loc_9))
                {
                    _loc_10 = Class(param1.getDefinition(_loc_9));
                }
            }
            if (!_loc_10)
            {
                _loc_9 = param3 + "_properties";
                if (param1.hasDefinition(_loc_9))
                {
                    _loc_10 = Class(param1.getDefinition(_loc_9));
                }
            }
            if (!_loc_10)
            {
                if (this.ignoreMissingBundles)
                {
                    return null;
                }
                throw new Error("Could not find compiled resource bundle \'" + param3 + "\' for locale \'" + param2 + "\'.");
            }
            _loc_8 = ResourceBundle(new _loc_10);
            ResourceBundle(_loc_8)._locale = param2;
            ResourceBundle(_loc_8)._bundleName = param3;
            this.addResourceBundle(_loc_8, param4);
            return _loc_8;
        }// end function

        private function newChildApplicationHandler(event:FocusEvent) : void
        {
            var _loc_5:* = event.relatedObject;
            var _loc_2:* = _loc_5["info"]();
            var _loc_3:* = false;
            if ("_resourceBundles" in event.relatedObject)
            {
                _loc_3 = true;
            }
            var _loc_4:* = this.processInfo(_loc_2, _loc_3);
            if (_loc_3)
            {
                _loc_5["_resourceBundles"] = _loc_4;
            }
            return;
        }// end function

        private function processInfo(param1:Object, param2:Boolean) : Array
        {
            var _loc_3:* = param1["compiledLocales"];
            ResourceBundle.locale = _loc_3 != null && _loc_3.length > 0 ? (_loc_3[0]) : ("en_US");
            var _loc_4:* = SystemManagerGlobals.parameters["localeChain"];
            if (SystemManagerGlobals.parameters["localeChain"] != null && _loc_4 != "")
            {
                this.localeChain = _loc_4.split(",");
            }
            var _loc_5:* = param1["currentDomain"];
            var _loc_6:* = param1["compiledResourceBundleNames"];
            var _loc_7:* = this.installCompiledResourceBundles(_loc_5, _loc_3, _loc_6, param2);
            if (!this.localeChain)
            {
                this.initializeLocaleChain(_loc_3);
            }
            return _loc_7;
        }// end function

        public function initializeLocaleChain(param1:Array) : void
        {
            this.localeChain = LocaleSorter.sortLocalesByPreference(param1, this.getSystemPreferredLocales(), null, true);
            return;
        }// end function

        public function loadResourceModule(param1:String, param2:Boolean = true, param3:ApplicationDomain = null, param4:SecurityDomain = null) : IEventDispatcher
        {
            var moduleInfo:IModuleInfo;
            var resourceEventDispatcher:ResourceEventDispatcher;
            var timer:Timer;
            var timerHandler:Function;
            var url:* = param1;
            var updateFlag:* = param2;
            var applicationDomain:* = param3;
            var securityDomain:* = param4;
            moduleInfo = ModuleManager.getModule(url);
            resourceEventDispatcher = new ResourceEventDispatcher(moduleInfo);
            var readyHandler:* = function (event:ModuleEvent) : void
            {
                var _loc_2:* = event.module.factory.create();
                resourceModules[event.module.url].resourceModule = _loc_2;
                if (updateFlag)
                {
                    update();
                }
                return;
            }// end function
            ;
            moduleInfo.addEventListener(ModuleEvent.READY, readyHandler, false, 0, true);
            var errorHandler:* = function (event:ModuleEvent) : void
            {
                var _loc_3:* = null;
                var _loc_2:* = "Unable to load resource module from " + url;
                if (resourceEventDispatcher.willTrigger(ResourceEvent.ERROR))
                {
                    _loc_3 = new ResourceEvent(ResourceEvent.ERROR, event.bubbles, event.cancelable);
                    _loc_3.bytesLoaded = 0;
                    _loc_3.bytesTotal = 0;
                    _loc_3.errorText = _loc_2;
                    resourceEventDispatcher.dispatchEvent(_loc_3);
                }
                else
                {
                    throw new Error(_loc_2);
                }
                return;
            }// end function
            ;
            moduleInfo.addEventListener(ModuleEvent.ERROR, errorHandler, false, 0, true);
            this.resourceModules[url] = new ResourceModuleInfo(moduleInfo, readyHandler, errorHandler);
            timer = new Timer(0);
            timerHandler = function (event:TimerEvent) : void
            {
                timer.removeEventListener(TimerEvent.TIMER, timerHandler);
                timer.stop();
                moduleInfo.load(applicationDomain, securityDomain);
                return;
            }// end function
            ;
            timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
            timer.start();
            return resourceEventDispatcher;
        }// end function

        public function unloadResourceModule(param1:String, param2:Boolean = true) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_3:* = this.resourceModules[param1];
            if (!_loc_3)
            {
                return;
            }
            if (_loc_3.resourceModule)
            {
                _loc_4 = _loc_3.resourceModule.resourceBundles;
                if (_loc_4)
                {
                    _loc_5 = _loc_4.length;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_5)
                    {
                        
                        _loc_7 = _loc_4[_loc_6].locale;
                        _loc_8 = _loc_4[_loc_6].bundleName;
                        this.removeResourceBundle(_loc_7, _loc_8);
                        _loc_6++;
                    }
                }
            }
            this.resourceModules[param1] = null;
            delete this.resourceModules[param1];
            _loc_3.moduleInfo.unload();
            if (param2)
            {
                this.update();
            }
            return;
        }// end function

        public function addResourceBundle(param1:IResourceBundle, param2:Boolean = false) : void
        {
            var _loc_3:* = param1.locale;
            var _loc_4:* = param1.bundleName;
            if (!this.localeMap[_loc_3])
            {
                this.localeMap[_loc_3] = {};
            }
            if (param2)
            {
                if (!this.bundleDictionary)
                {
                    this.bundleDictionary = new Dictionary(true);
                }
                this.bundleDictionary[param1] = _loc_3 + _loc_4;
                this.localeMap[_loc_3][_loc_4] = this.bundleDictionary;
            }
            else
            {
                this.localeMap[_loc_3][_loc_4] = param1;
            }
            return;
        }// end function

        public function getResourceBundle(param1:String, param2:String) : IResourceBundle
        {
            return this.getResourceBundleInternal(param1, param2, false);
        }// end function

        private function getResourceBundleInternal(param1:String, param2:String, param3:Boolean) : IResourceBundle
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_4:* = this.localeMap[param1];
            if (!this.localeMap[param1])
            {
                return null;
            }
            var _loc_5:* = null;
            var _loc_6:* = _loc_4[param2];
            if (_loc_4[param2] is Dictionary)
            {
                if (param3)
                {
                    return null;
                }
                _loc_7 = param1 + param2;
                for (_loc_8 in _loc_6)
                {
                    
                    if (_loc_6[_loc_8] == _loc_7)
                    {
                        _loc_5 = _loc_8 as IResourceBundle;
                        break;
                    }
                }
            }
            else
            {
                _loc_5 = _loc_6 as IResourceBundle;
            }
            return _loc_5;
        }// end function

        public function removeResourceBundle(param1:String, param2:String) : void
        {
            delete this.localeMap[param1][param2];
            if (this.getBundleNamesForLocale(param1).length == 0)
            {
                delete this.localeMap[param1];
            }
            return;
        }// end function

        public function removeResourceBundlesForLocale(param1:String) : void
        {
            delete this.localeMap[param1];
            return;
        }// end function

        public function update() : void
        {
            dispatchEvent(new Event(Event.CHANGE));
            return;
        }// end function

        public function getLocales() : Array
        {
            var _loc_2:* = null;
            var _loc_1:* = [];
            for (_loc_2 in this.localeMap)
            {
                
                _loc_1.push(_loc_2);
            }
            return _loc_1;
        }// end function

        public function getPreferredLocaleChain() : Array
        {
            return LocaleSorter.sortLocalesByPreference(this.getLocales(), this.getSystemPreferredLocales(), null, true);
        }// end function

        public function getBundleNamesForLocale(param1:String) : Array
        {
            var _loc_3:* = null;
            var _loc_2:* = [];
            for (_loc_3 in this.localeMap[param1])
            {
                
                _loc_2.push(_loc_3);
            }
            return _loc_2;
        }// end function

        public function findResourceBundleWithResource(param1:String, param2:String) : IResourceBundle
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            if (!this._localeChain)
            {
                return null;
            }
            var _loc_3:* = this._localeChain.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this.localeChain[_loc_4];
                _loc_6 = this.localeMap[_loc_5];
                if (!_loc_6)
                {
                }
                else
                {
                    _loc_7 = _loc_6[param1];
                    if (!_loc_7)
                    {
                    }
                    else
                    {
                        _loc_8 = null;
                        if (_loc_7 is Dictionary)
                        {
                            _loc_9 = _loc_5 + param1;
                            for (_loc_10 in _loc_7)
                            {
                                
                                if (_loc_7[_loc_10] == _loc_9)
                                {
                                    _loc_8 = _loc_10 as IResourceBundle;
                                    break;
                                }
                            }
                        }
                        else
                        {
                            _loc_8 = _loc_7 as IResourceBundle;
                        }
                        if (_loc_8 && param2 in _loc_8.content)
                        {
                            return _loc_8;
                        }
                    }
                }
                _loc_4++;
            }
            return null;
        }// end function

        public function getObject(param1:String, param2:String, param3:String = null)
        {
            var _loc_4:* = this.findBundle(param1, param2, param3);
            if (!this.findBundle(param1, param2, param3))
            {
                return undefined;
            }
            return _loc_4.content[param2];
        }// end function

        public function getString(param1:String, param2:String, param3:Array = null, param4:String = null) : String
        {
            var _loc_5:* = this.findBundle(param1, param2, param4);
            if (!this.findBundle(param1, param2, param4))
            {
                return null;
            }
            var _loc_6:* = String(_loc_5.content[param2]);
            if (param3)
            {
                _loc_6 = StringUtil.substitute(_loc_6, param3);
            }
            return _loc_6;
        }// end function

        public function getStringArray(param1:String, param2:String, param3:String = null) : Array
        {
            var _loc_4:* = this.findBundle(param1, param2, param3);
            if (!this.findBundle(param1, param2, param3))
            {
                return null;
            }
            var _loc_5:* = _loc_4.content[param2];
            var _loc_6:* = String(_loc_5).split(",");
            var _loc_7:* = _loc_6.length;
            var _loc_8:* = 0;
            while (_loc_8 < _loc_7)
            {
                
                _loc_6[_loc_8] = StringUtil.trim(_loc_6[_loc_8]);
                _loc_8++;
            }
            return _loc_6;
        }// end function

        public function getNumber(param1:String, param2:String, param3:String = null) : Number
        {
            var _loc_4:* = this.findBundle(param1, param2, param3);
            if (!this.findBundle(param1, param2, param3))
            {
                return NaN;
            }
            var _loc_5:* = _loc_4.content[param2];
            return Number(_loc_5);
        }// end function

        public function getInt(param1:String, param2:String, param3:String = null) : int
        {
            var _loc_4:* = this.findBundle(param1, param2, param3);
            if (!this.findBundle(param1, param2, param3))
            {
                return 0;
            }
            var _loc_5:* = _loc_4.content[param2];
            return int(_loc_5);
        }// end function

        public function getUint(param1:String, param2:String, param3:String = null) : uint
        {
            var _loc_4:* = this.findBundle(param1, param2, param3);
            if (!this.findBundle(param1, param2, param3))
            {
                return 0;
            }
            var _loc_5:* = _loc_4.content[param2];
            return uint(_loc_5);
        }// end function

        public function getBoolean(param1:String, param2:String, param3:String = null) : Boolean
        {
            var _loc_4:* = this.findBundle(param1, param2, param3);
            if (!this.findBundle(param1, param2, param3))
            {
                return false;
            }
            var _loc_5:* = _loc_4.content[param2];
            return String(_loc_5).toLowerCase() == "true";
        }// end function

        public function getClass(param1:String, param2:String, param3:String = null) : Class
        {
            var _loc_4:* = this.findBundle(param1, param2, param3);
            if (!this.findBundle(param1, param2, param3))
            {
                return null;
            }
            var _loc_5:* = _loc_4.content[param2];
            return _loc_4.content[param2] as Class;
        }// end function

        private function findBundle(param1:String, param2:String, param3:String) : IResourceBundle
        {
            this.supportNonFrameworkApps();
            return param3 != null ? (this.getResourceBundle(param3, param1)) : (this.findResourceBundleWithResource(param1, param2));
        }// end function

        private function supportNonFrameworkApps() : void
        {
            if (this.initializedForNonFrameworkApp)
            {
                return;
            }
            this.initializedForNonFrameworkApp = true;
            if (this.getLocales().length > 0)
            {
                return;
            }
            var _loc_1:* = ApplicationDomain.currentDomain;
            if (!_loc_1.hasDefinition("_CompiledResourceBundleInfo"))
            {
                return;
            }
            var _loc_2:* = Class(_loc_1.getDefinition("_CompiledResourceBundleInfo"));
            var _loc_3:* = _loc_2.compiledLocales;
            var _loc_4:* = _loc_2.compiledResourceBundleNames;
            this.installCompiledResourceBundles(_loc_1, _loc_3, _loc_4);
            this.localeChain = _loc_3;
            return;
        }// end function

        private function getSystemPreferredLocales() : Array
        {
            var _loc_1:* = null;
            if (Capabilities["languages"])
            {
                _loc_1 = Capabilities["languages"];
            }
            else
            {
                _loc_1 = [Capabilities.language];
            }
            return _loc_1;
        }// end function

        private function dumpResourceModule(param1) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            for each (_loc_2 in param1.resourceBundles)
            {
                
                trace(_loc_2.locale, _loc_2.bundleName);
                for (_loc_3 in _loc_2.content)
                {
                    
                }
            }
            return;
        }// end function

        private function enterFrameHandler(event:Event) : void
        {
            if (SystemManagerGlobals.topLevelSystemManagers.length)
            {
                if (SystemManagerGlobals.topLevelSystemManagers[0].currentFrame == 2)
                {
                    SystemManagerGlobals.topLevelSystemManagers[0].removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                }
                else
                {
                    return;
                }
            }
            var _loc_2:* = SystemManagerGlobals.info;
            if (_loc_2)
            {
                this.processInfo(_loc_2, false);
            }
            return;
        }// end function

        public static function getInstance() : IResourceManager
        {
            if (!instance)
            {
                instance = new ResourceManagerImpl;
            }
            return instance;
        }// end function

    }
}

import *.*;

import flash.events.*;

import flash.system.*;

import flash.utils.*;

import mx.events.*;

import mx.managers.*;

import mx.modules.*;

import mx.resources.*;

import mx.utils.*;

class ResourceModuleInfo extends Object
{
    public var errorHandler:Function;
    public var moduleInfo:IModuleInfo;
    public var readyHandler:Function;
    public var resourceModule:IResourceModule;

    function ResourceModuleInfo(param1:IModuleInfo, param2:Function, param3:Function)
    {
        this.moduleInfo = param1;
        this.readyHandler = param2;
        this.errorHandler = param3;
        return;
    }// end function

}


import *.*;

import flash.events.*;

import flash.system.*;

import flash.utils.*;

import mx.events.*;

import mx.managers.*;

import mx.modules.*;

import mx.resources.*;

import mx.utils.*;

class ResourceEventDispatcher extends EventDispatcher
{

    function ResourceEventDispatcher(param1:IModuleInfo)
    {
        param1.addEventListener(ModuleEvent.ERROR, this.moduleInfo_errorHandler, false, 0, true);
        param1.addEventListener(ModuleEvent.PROGRESS, this.moduleInfo_progressHandler, false, 0, true);
        param1.addEventListener(ModuleEvent.READY, this.moduleInfo_readyHandler, false, 0, true);
        return;
    }// end function

    private function moduleInfo_errorHandler(event:ModuleEvent) : void
    {
        var _loc_2:* = new ResourceEvent(ResourceEvent.ERROR, event.bubbles, event.cancelable);
        _loc_2.bytesLoaded = event.bytesLoaded;
        _loc_2.bytesTotal = event.bytesTotal;
        _loc_2.errorText = event.errorText;
        dispatchEvent(_loc_2);
        return;
    }// end function

    private function moduleInfo_progressHandler(event:ModuleEvent) : void
    {
        var _loc_2:* = new ResourceEvent(ResourceEvent.PROGRESS, event.bubbles, event.cancelable);
        _loc_2.bytesLoaded = event.bytesLoaded;
        _loc_2.bytesTotal = event.bytesTotal;
        dispatchEvent(_loc_2);
        return;
    }// end function

    private function moduleInfo_readyHandler(event:ModuleEvent) : void
    {
        var _loc_2:* = new ResourceEvent(ResourceEvent.COMPLETE);
        dispatchEvent(_loc_2);
        return;
    }// end function

}

