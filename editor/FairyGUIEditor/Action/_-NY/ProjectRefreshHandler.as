package _-NY
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.filesystem.*;

    public class ProjectRefreshHandler extends Object
    {
        private var _editor:IEditor;
        private var _project:FProject;
        private var _-Np:BulkTasks;

        public function ProjectRefreshHandler(param1:IEditor)
        {
            this._editor = param1;
            this._project = FProject(param1.project);
            this._-Np = new BulkTasks(10);
            return;
        }// end function

        public function dispose() : void
        {
            this._-Np.clear();
            this._editor = null;
            return;
        }// end function

        public function run() : void
        {
            if (this._-Np.running)
            {
                return;
            }
            this._editor.emit(EditorEvent.ProjectRefreshStart);
            var _loc_1:* = new File(this._project.assetsPath);
            _loc_1.addEventListener(FileListEvent.DIRECTORY_LISTING, this._-CU);
            _loc_1.getDirectoryListingAsync();
            return;
        }// end function

        private function _-CU(event:FileListEvent) : void
        {
            var pkg:IUIPackage;
            var pkgId:String;
            var changed:Boolean;
            var file:File;
            var pkgs:Vector.<IUIPackage>;
            var evt:* = event;
            if (!this._editor)
            {
                return;
            }
            var arr:* = evt.files;
            var _loc_3:* = 0;
            var _loc_4:* = arr;
            while (_loc_4 in _loc_3)
            {
                
                file = _loc_4[_loc_3];
                if (!file.isDirectory)
                {
                    continue;
                }
                pkg = this._project.getPackageByName(file.name);
                if (!pkg)
                {
                    pkgId = this._-1E(file);
                    if (!pkgId)
                    {
                        continue;
                    }
                    pkg = this._project.getPackage(pkgId);
                    if (pkg)
                    {
                        if (new File(pkg.basePath).exists)
                        {
                            continue;
                        }
                        try
                        {
                            pkg.renameItem(pkg.rootItem, file.name);
                        }
                        catch (err:Error)
                        {
                            _editor.consoleView.logError("refresh error ", err);
                        }
                    }
                    else
                    {
                        this._project.addPackage(file);
                    }
                    changed;
                }
            }
            pkgs = this._project.allPackages;
            var _loc_3:* = 0;
            var _loc_4:* = pkgs;
            while (_loc_4 in _loc_3)
            {
                
                pkg = _loc_4[_loc_3];
                if (!new File(pkg.basePath).exists)
                {
                    this._project.deletePackage(pkg.id);
                    changed;
                    continue;
                }
                this._-Np.addTask(this._-Nn, pkg);
            }
            if (this._project.scanBranches())
            {
                changed;
            }
            if (changed)
            {
                this._editor.emit(EditorEvent.PackageListChanged);
            }
            this._-Np.start(this._-As);
            return;
        }// end function

        private function _-As() : void
        {
            this._editor.emit(EditorEvent.ProjectRefreshEnd);
            return;
        }// end function

        private function _-Nn() : void
        {
            var _loc_2:* = null;
            var _loc_1:* = FPackage(this._-Np.taskData);
            _loc_1.touch();
            if (_loc_1.rootItem.isError)
            {
                this._-Np.finishItem();
                return;
            }
            if (_loc_1.opened)
            {
                _loc_2 = new ListingTask();
                _loc_1.setVar("listingTask", _loc_2);
                _loc_2.run(_loc_1, this._-F5);
            }
            else
            {
                this._-Np.finishItem();
            }
            return;
        }// end function

        private function _-F5(param1:ListingTask) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_9:* = null;
            var _loc_12:* = false;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = 0;
            var _loc_16:* = null;
            var _loc_17:* = null;
            if (!this._editor)
            {
                return;
            }
            var _loc_2:* = param1.pkg;
            _loc_2.setVar("listingTask", undefined);
            _loc_2.beginBatch();
            var _loc_3:* = param1.files;
            var _loc_7:* = _loc_3.length;
            var _loc_8:* = this._project.basePath.length + 1;
            var _loc_10:* = 0;
            while (_loc_10 < _loc_7)
            {
                
                _loc_13 = _loc_3[_loc_10];
                _loc_14 = UtilsStr.getFilePath(_loc_13.nativePath.substr(_loc_8)).replace(/\\/g, "/") + "/";
                _loc_15 = _loc_14.indexOf("/");
                _loc_16 = _loc_14.substring(0, _loc_15).substr(7);
                _loc_15 = _loc_14.indexOf("/", (_loc_15 + 1));
                _loc_14 = _loc_14.substr(_loc_15);
                if (_loc_16.length > 0)
                {
                    _loc_14 = "/:" + _loc_16 + _loc_14;
                }
                _loc_9 = _loc_2.getItem(_loc_14);
                if (!_loc_9)
                {
                    _loc_9 = _loc_2.createPath(_loc_14);
                }
                if (!_loc_13.isDirectory)
                {
                    _loc_9 = _loc_2.getItemByFileName(_loc_9, _loc_13.name);
                    if (!_loc_9)
                    {
                        if (!_loc_4)
                        {
                            _loc_4 = new Vector.<File>;
                            _loc_5 = new Vector.<String>;
                        }
                        _loc_4.push(_loc_13);
                        _loc_5.push(_loc_14);
                    }
                }
                _loc_10++;
            }
            var _loc_11:* = _loc_2.items;
            _loc_7 = _loc_11.length;
            _loc_10 = 0;
            while (_loc_10 < _loc_7)
            {
                
                _loc_9 = _loc_11[_loc_10++];
                _loc_12 = _loc_9.isError;
                _loc_9.touch();
                if (_loc_9.isError && _loc_9.type == FPackageItemType.FOLDER)
                {
                    if (!_loc_6)
                    {
                        _loc_6 = new Vector.<FPackageItem>;
                    }
                    _loc_6.push(_loc_9);
                }
                if (_loc_12 != _loc_9.isError)
                {
                    this._editor.emit(EditorEvent.PackageItemChanged, _loc_9);
                }
            }
            if (_loc_4)
            {
                _loc_17 = this._editor.importResource(_loc_2);
                _loc_7 = _loc_4.length;
                _loc_10 = 0;
                while (_loc_10 < _loc_7)
                {
                    
                    _loc_17.add(_loc_4[_loc_10], _loc_5[_loc_10]);
                    _loc_10++;
                }
                _loc_17.process();
            }
            if (_loc_6)
            {
                for each (_loc_9 in _loc_6)
                {
                    
                    if (_loc_9.children.length == 0)
                    {
                        _loc_2.deleteItem(_loc_9);
                    }
                }
            }
            _loc_2.endBatch();
            this._-Np.finishItem();
            return;
        }// end function

        private function _-1E(param1:File) : String
        {
            var _loc_2:* = param1.resolvePath("package.xml");
            if (!_loc_2.exists)
            {
                return null;
            }
            var _loc_3:* = UtilsFile.loadXMLRoot(_loc_2);
            if (_loc_3)
            {
                return _loc_3.getAttribute("id");
            }
            return null;
        }// end function

    }
}

import *.*;

import __AS3__.vec.*;

import fairygui.editor.api.*;

import fairygui.editor.gui.*;

import fairygui.utils.*;

import flash.events.*;

import flash.filesystem.*;

class ListingTask extends Object
{
    public var pkg:FPackage;
    public var files:Vector.<File>;
    private var _tasks:BulkTasks;
    private var _callback:Function;

    function ListingTask()
    {
        this.files = new Vector.<File>;
        this._tasks = new BulkTasks(3);
        return;
    }// end function

    public function reset() : void
    {
        this.files.length = 0;
        this._callback = null;
        this._tasks.clear();
        return;
    }// end function

    public function run(param1:FPackage, param2:Function) : void
    {
        var _loc_5:* = null;
        var _loc_6:* = null;
        this.pkg = param1;
        this._callback = param2;
        this._tasks.clear();
        var _loc_3:* = new File(param1.basePath);
        this._tasks.addTask(this.runListingTask, _loc_3);
        var _loc_4:* = param1.project.allBranches;
        for each (_loc_5 in _loc_4)
        {
            
            _loc_6 = param1.getBranchRootItem(_loc_5);
            if (_loc_6 && _loc_6.file.exists)
            {
                this.files.push(_loc_6.file);
                this._tasks.addTask(this.runListingTask, _loc_6.file);
            }
        }
        this._tasks.start(this.complete);
        return;
    }// end function

    private function complete() : void
    {
        this._callback(this);
        return;
    }// end function

    private function runListingTask() : void
    {
        var _loc_1:* = File(this._tasks.taskData);
        _loc_1.addEventListener(FileListEvent.DIRECTORY_LISTING, this.onPackageListing);
        _loc_1.getDirectoryListingAsync();
        return;
    }// end function

    private function onPackageListing(event:FileListEvent) : void
    {
        var _loc_3:* = null;
        if (!this._tasks.running)
        {
            return;
        }
        this._tasks.finishItem();
        var _loc_2:* = event.files;
        for each (_loc_3 in _loc_2)
        {
            
            if (_loc_3.isDirectory)
            {
                this.files.push(_loc_3);
                this._tasks.addTask(this.runListingTask, _loc_3);
                continue;
            }
            if (FPackageItemType.getFileType(_loc_3) != null)
            {
                this.files.push(_loc_3);
            }
        }
        return;
    }// end function

}

