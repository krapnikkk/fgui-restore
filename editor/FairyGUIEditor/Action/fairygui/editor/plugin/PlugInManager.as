package fairygui.editor.plugin
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.utils.*;
    import fairygui.utils.loader.*;
    import flash.filesystem.*;
    import flash.system.*;
    import flash.utils.*;

    public class PlugInManager extends Object
    {
        public var allPlugins:Vector.<PlugInInfo>;
        private var _editor:IEditor;
        private var _proxy:LegacyPlugInProxy;
        private var _loadTasks:BulkTasks;
        private var _pluginFolder:File;

        public function PlugInManager(param1:IEditor)
        {
            this._editor = param1;
            this.allPlugins = new Vector.<PlugInInfo>;
            return;
        }// end function

        public function dispose() : void
        {
            this._editor = null;
            return;
        }// end function

        public function get legacyProxy() : LegacyPlugInProxy
        {
            return this._proxy;
        }// end function

        public function get pluginFolder() : File
        {
            return this._pluginFolder;
        }// end function

        public function load(param1:Function = null) : void
        {
            var file:File;
            var callback:* = param1;
            this.reset();
            this._proxy = new LegacyPlugInProxy(this._editor);
            try
            {
                this._pluginFolder = new File(new File("app:/plugins").nativePath);
                if (!Consts.isMacOS)
                {
                    if (!this._pluginFolder.exists)
                    {
                        this._pluginFolder.createDirectory();
                    }
                }
                else if (!this._pluginFolder.exists)
                {
                    if (callback != null)
                    {
                        this.callback();
                    }
                    return;
                }
            }
            catch (err:Error)
            {
                _editor.consoleView.logError(null, err);
                if (callback != null)
                {
                    this.callback();
                }
                return;
            }
            var files:* = this.pluginFolder.getDirectoryListing();
            var task:* = function () : void
            {
                var _loc_1:* = File(_loadTasks.taskData);
                EasyLoader.load(_loc_1.url, {name:_loc_1.name}, __loadSwcCompleted);
                return;
            }// end function
            ;
            this._loadTasks = new BulkTasks(5);
            var _loc_3:* = 0;
            var _loc_4:* = files;
            while (_loc_4 in _loc_3)
            {
                
                file = _loc_4[_loc_3];
                if (file.isDirectory || file.extension.toLowerCase() != "swc")
                {
                    continue;
                }
                this._loadTasks.addTask(task, file);
            }
            this._loadTasks.start(callback);
            return;
        }// end function

        private function reset() : void
        {
            var plugin:PlugInInfo;
            var _loc_2:* = 0;
            var _loc_3:* = this.allPlugins;
            do
            {
                
                plugin = _loc_3[_loc_2];
                try
                {
                    plugin.entry.dispose();
                }
                catch (err:Error)
                {
                }
            }while (_loc_3 in _loc_2)
            _loc_3.length = 0;
            if (this._proxy)
            {
                this._proxy.dispose();
                this._proxy = null;
            }
            return;
        }// end function

        private function __loadSwcCompleted(param1:LoaderExt) : void
        {
            if (!this._editor)
            {
                return;
            }
            if (!param1.content)
            {
                this._loadTasks.finishItem();
                return;
            }
            var _loc_2:* = new ZipReader(param1.content);
            var _loc_3:* = _loc_2.getEntryData("library.swf");
            var _loc_4:* = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));
            _loc_4.allowCodeImport = true;
            _loc_4.allowLoadBytesCodeExecution = true;
            EasyLoader.load("", {rawContent:_loc_3, context:_loc_4, name:param1.props.name}, this.__decodeSwcCompleted);
            return;
        }// end function

        private function __decodeSwcCompleted(param1:LoaderExt) : void
        {
            var name:String;
            var clsName:String;
            var pos:int;
            var info:PlugInInfo;
            var l:* = param1;
            if (!this._editor)
            {
                return;
            }
            this._loadTasks.finishItem();
            if (!l.content)
            {
                return;
            }
            var mainClass:Object;
            var names:* = l.applicationDomain.getQualifiedDefinitionNames();
            var _loc_3:* = 0;
            var _loc_4:* = names;
            while (_loc_4 in _loc_3)
            {
                
                name = _loc_4[_loc_3];
                pos = name.indexOf("::");
                if (pos == -1)
                {
                    clsName = name;
                }
                else
                {
                    clsName = name.substr(pos + 2);
                }
                if (clsName == "PlugInMain")
                {
                    mainClass = l.applicationDomain.getDefinition(name);
                }
            }
            if (!mainClass)
            {
                return;
            }
            try
            {
                info = new PlugInInfo();
                info.name = l.props.name;
                info.entry = new mainClass(this._proxy);
                this.allPlugins.push(info);
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
            }
            return;
        }// end function

    }
}
