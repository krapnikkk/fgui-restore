package fairygui.editor.plugin
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.plugin.*;
    import fairygui.editor.settings.*;

    public class LegacyPlugInProxy extends Object implements IFairyGUIEditor, IMenuBar
    {
        private var _editor:IEditor;
        private var _project:PlugIn_UIProject;
        private var _publishHandlers:Vector.<IPublishHandler>;
        private var _dummyMenu:PopupMenu;
        private var _prompted:Boolean = false;

        public function LegacyPlugInProxy(param1:IEditor) : void
        {
            this._editor = param1;
            this._project = new PlugIn_UIProject(this._editor.project);
            this._publishHandlers = new Vector.<IPublishHandler>;
            this._editor.project.setVar("PublishPlugins", this._publishHandlers);
            return;
        }// end function

        public function dispose() : void
        {
            this._publishHandlers.length = 0;
            this._editor.project.clearCustomExtensions();
            if (this._dummyMenu)
            {
                this._dummyMenu.dispose();
            }
            return;
        }// end function

        public function get v5() : IEditor
        {
            if (_-D._-8J)
            {
                return this._editor;
            }
            if (!this._prompted)
            {
                this._prompted = true;
                this._editor.consoleView.logWarning("interface editorV5 is only available for pro version");
            }
            return null;
        }// end function

        public function get menuBar() : IMenuBar
        {
            return this;
        }// end function

        public function addMenu(param1:String, param2:String, param3:PopupMenu, param4:String = null) : void
        {
            if (Consts.isMacOS)
            {
                this._editor.consoleView.logWarning("addMenu not supported in mac os");
                return;
            }
            this._editor.menu.addItem(param2, param1, null, null, -1, new _-Eg(param3));
            return;
        }// end function

        public function getMenu(param1:String) : PopupMenu
        {
            if (Consts.isMacOS)
            {
                this._editor.consoleView.logWarning("PlugIn error: getMenu not supported in mac os");
                if (!this._dummyMenu)
                {
                    this._dummyMenu = new PopupMenu();
                }
                return this._dummyMenu;
            }
            return _-Eg(this._editor.menu.getSubMenu(param1)).menu;
        }// end function

        public function removeMenu(param1:String) : void
        {
            this._editor.menu.removeItem(param1);
            return;
        }// end function

        public function getPackage(param1:String) : IEditorUIPackage
        {
            var _loc_2:* = this._editor.project.getPackageByName(param1);
            if (!_loc_2)
            {
                return null;
            }
            var _loc_3:* = _loc_2.getVar("pluginInst");
            if (!_loc_3)
            {
                _loc_3 = new PlugIn_UIPackage(_loc_2);
                _loc_2.setVar("pluginInst", _loc_3);
            }
            return _loc_3;
        }// end function

        public function alert(param1:String) : void
        {
            this._editor.alert(param1);
            return;
        }// end function

        public function log(param1:String) : void
        {
            this._editor.consoleView.log(param1);
            return;
        }// end function

        public function logError(param1:String, param2:Error = null) : void
        {
            this._editor.consoleView.logError(param1, param2);
            return;
        }// end function

        public function logWarning(param1:String) : void
        {
            this._editor.consoleView.logWarning(param1);
            return;
        }// end function

        public function get project() : IEditorUIProject
        {
            return this._project;
        }// end function

        public function get groot() : GRoot
        {
            return this._editor.groot;
        }// end function

        public function get language() : String
        {
            return Consts.language;
        }// end function

        public function registerComponentExtension(param1:String, param2:String, param3:String) : void
        {
            this._editor.project.registerCustomExtension(param1, param2, param3);
            return;
        }// end function

        public function registerPublishHandler(param1:IPublishHandler) : void
        {
            if (this._publishHandlers.indexOf(param1) == -1)
            {
                this._publishHandlers.push(param1);
            }
            return;
        }// end function

    }
}

import *.*;

import _-Gs.*;

import __AS3__.vec.*;

import fairygui.*;

import fairygui.editor.*;

import fairygui.editor.api.*;

import fairygui.editor.plugin.*;

import fairygui.editor.settings.*;

class PlugIn_UIProject extends Object implements IEditorUIProject
{
    private var _project:IUIProject;

    function PlugIn_UIProject(param1:IUIProject) : void
    {
        this._project = param1;
        return;
    }// end function

    public function get basePath() : String
    {
        return this._project.basePath;
    }// end function

    public function get id() : String
    {
        return this._project.id;
    }// end function

    public function get name() : String
    {
        return this._project.name;
    }// end function

    public function get type() : String
    {
        return this._project.type;
    }// end function

    public function get customProperties() : Object
    {
        return CustomProps(this._project.getSettings("customProps")).all;
    }// end function

    public function getSettings(param1:String) : Object
    {
        return this._project.getSettings(param1);
    }// end function

    public function save() : void
    {
        return;
    }// end function

}


import *.*;

import _-Gs.*;

import __AS3__.vec.*;

import fairygui.*;

import fairygui.editor.*;

import fairygui.editor.api.*;

import fairygui.editor.plugin.*;

import fairygui.editor.settings.*;

class PlugIn_UIPackage extends Object implements IEditorUIPackage
{
    private var _pkg:IUIPackage;

    function PlugIn_UIPackage(param1:IUIPackage) : void
    {
        this._pkg = param1;
        return;
    }// end function

    public function setExported(param1:Array, param2:Boolean) : void
    {
        var id:String;
        var pi:FPackageItem;
        var ids:* = param1;
        var exported:* = param2;
        this._pkg.beginBatch();
        try
        {
            var _loc_4:* = 0;
            var _loc_5:* = ids;
            while (_loc_5 in _loc_4)
            {
                
                id = _loc_5[_loc_4];
                pi = this._pkg.getItem(id);
                if (pi)
                {
                    this._pkg.setItemProperty(pi, "exported", exported);
                }
            }
        }
        catch (e:Error)
        {
            throw null;
        }
        finally
        {
            this._pkg.endBatch();
        }
        this._pkg.endBatch();
        return;
    }// end function

    public function get basePath() : String
    {
        return this._pkg.basePath;
    }// end function

    public function getResourceId(param1:String) : String
    {
        var _loc_2:* = this._pkg.findItemByName(param1);
        if (_loc_2)
        {
            return _loc_2.id;
        }
        return null;
    }// end function

    public function importResources(param1:String, param2:Array, param3:Array, param4:Function) : void
    {
        var _loc_5:* = this._pkg.project.editor.importResource(this._pkg);
        var _loc_6:* = param2.length;
        var _loc_7:* = 0;
        while (_loc_7 < _loc_6)
        {
            
            _loc_5.add(param2[_loc_7], param1, param3 ? (param3[_loc_7]) : (null));
            _loc_7++;
        }
        _loc_5.process(param4);
        return;
    }// end function

    public function get name() : String
    {
        return this._pkg.name;
    }// end function

    public function createMovieClip(param1:String, param2:String, param3:Array, param4:Object, param5:Function, param6:Function) : void
    {
        var pi:FPackageItem;
        var cb:Callback;
        var name:* = param1;
        var path:* = param2;
        var files:* = param3;
        var options:* = param4;
        var onSuccess:* = param5;
        var onFail:* = param6;
        pi = this._pkg.createMovieClipItem(name, path, true);
        cb = new Callback();
        cb.success = function () : void
        {
            var _loc_2:* = 0;
            var _loc_1:* = AniDef(cb.result);
            if (options)
            {
                if (options.speed != undefined)
                {
                    _loc_1.speed = options.speed;
                }
                if (options.swing != undefined)
                {
                    _loc_1.swing = options.swing;
                }
                if (options.repeatDelay != undefined)
                {
                    _loc_1.repeatDelay = options.repeatDelay;
                }
                if (options.frameDelays != undefined)
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1.frameList.length)
                    {
                        
                        if (options.frameDelays[_loc_2] != undefined)
                        {
                            _loc_1.frameList[_loc_2].delay = options.frameDelays[_loc_2];
                        }
                        _loc_2++;
                    }
                }
            }
            UtilsFile.saveBytes(pi.file, _loc_1.save());
            pi.setChanged();
            pi.owner.setChanged();
            return;
        }// end function
        ;
        cb.failed = onFail;
        AniImporter.importImages(files, false, cb);
        return;
    }// end function

    public function get id() : String
    {
        return this._pkg.id;
    }// end function

    public function createFolder(param1:String, param2:String) : void
    {
        this._pkg.createFolder(param2, param1);
        return;
    }// end function

    public function createComponent(param1:String, param2:int, param3:int, param4:String, param5:XML) : String
    {
        var _loc_6:* = this._pkg.createComponentItem(param1, param2, param3, param4, null, false, true);
        if (param5 != null)
        {
            UtilsFile.saveXML(_loc_6.file, param5);
            _loc_6.setChanged();
        }
        return _loc_6.id;
    }// end function

    public function renameResources(param1:Array, param2:Array) : void
    {
        var cnt:int;
        var i:int;
        var pi:FPackageItem;
        var ids:* = param1;
        var names:* = param2;
        this._pkg.beginBatch();
        try
        {
            cnt = ids[i];
            i;
            while (i < cnt)
            {
                
                pi = this._pkg.getItem(ids[i]);
                if (pi)
                {
                    this._pkg.renameItem(pi, names[i]);
                }
                i = (i + 1);
            }
        }
        catch (e:Error)
        {
            throw null;
        }
        finally
        {
            this._pkg.endBatch();
        }
        return;
    }// end function

    public function updateResource(param1:String, param2:File, param3:Function, param4:Function) : void
    {
        var _loc_5:* = this._pkg.getItem(param1);
        if (!this._pkg.getItem(param1))
        {
            throw new Error("Resource not found - " + param1);
        }
        var _loc_6:* = new Callback();
        _loc_6.success = param3;
        _loc_6.failed = param4;
        this._pkg.updateResource(_loc_5, param2, _loc_6);
        return;
    }// end function

}

