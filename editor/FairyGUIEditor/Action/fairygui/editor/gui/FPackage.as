package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.animation.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;
    import fairygui.utils.pack.*;
    import flash.display.*;
    import flash.filesystem.*;
    import flash.system.*;
    import flash.utils.*;
    import org.bytearray.gif.*;

    public class FPackage extends Object implements IUIPackage
    {
        private var _project:FProject;
        private var _id:String;
        private var _basePath:String;
        private var _cacheFolder:File;
        private var _metaFolder:File;
        private var _nextId:uint;
        private var _opened:Boolean;
        private var _opening:Boolean;
        private var _fatalError:Boolean;
        private var _inTransaction:int;
        private var _needSave:Boolean;
        private var _vars:Object;
        private var _rootItem:FPackageItem;
        private var _itemList:Vector.<FPackageItem>;
        private var _itemById:Object;
        private var _itemByPath:Object;
        private var _itemsCache:Object;
        private var _strings:Object;
        private var _publishSettings:PublishSettings;
        private var _lastModified:Number;
        private static const GC_INTERVAL_IN_SECONDS:int = 300;
        private static var helperList:Array = [];

        public function FPackage(param1:FProject, param2:File)
        {
            this._project = param1;
            this._basePath = param2.nativePath;
            this._vars = {};
            this._itemById = {};
            this._itemByPath = {};
            this._itemList = new Vector.<FPackageItem>;
            this._itemsCache = {};
            this._rootItem = new FPackageItem(this, FPackageItemType.FOLDER, "/");
            this._rootItem.setFile("", param2.name);
            this._itemById[this._rootItem.id] = this._rootItem;
            this._itemByPath[this._rootItem.id] = this._rootItem;
            this.init();
            return;
        }// end function

        public function get opened() : Boolean
        {
            return this._opened;
        }// end function

        public function get project() : IUIProject
        {
            return this._project;
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

        public function get name() : String
        {
            return this._rootItem.name;
        }// end function

        public function get basePath() : String
        {
            return this._basePath;
        }// end function

        public function get cacheFolder() : File
        {
            if (!this._cacheFolder.exists)
            {
                this._cacheFolder.createDirectory();
            }
            return this._cacheFolder;
        }// end function

        public function get metaFolder() : File
        {
            if (!this._metaFolder.exists)
            {
                this._metaFolder.createDirectory();
            }
            return this._metaFolder;
        }// end function

        public function get items() : Vector.<FPackageItem>
        {
            this.ensureOpen();
            return this._itemList;
        }// end function

        public function get publishSettings() : Object
        {
            this.ensureOpen();
            return this._publishSettings;
        }// end function

        public function get rootItem() : FPackageItem
        {
            return this._rootItem;
        }// end function

        public function getBranchRootItem(param1:String) : FPackageItem
        {
            this.ensureOpen();
            return this._itemById["/:" + param1 + "/"];
        }// end function

        public function toString() : String
        {
            return this._rootItem.name;
        }// end function

        public function setVar(param1:String, param2) : void
        {
            if (param2 == undefined)
            {
                delete this._vars[param1];
            }
            else
            {
                this._vars[param1] = param2;
            }
            return;
        }// end function

        public function getVar(param1:String)
        {
            return this._vars[param1];
        }// end function

        public function beginBatch() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this._inTransaction + 1;
            _loc_1._inTransaction = _loc_2;
            return;
        }// end function

        public function endBatch() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this._inTransaction - 1;
            _loc_1._inTransaction = _loc_2;
            if (this._inTransaction < 0)
            {
                this._inTransaction = 0;
            }
            if (this._inTransaction == 0 && this._needSave)
            {
                this.save();
            }
            return;
        }// end function

        private function init() : void
        {
            var descFile:File;
            var xml:XData;
            try
            {
                descFile = new File(this._basePath + File.separator + "package.xml");
                this._lastModified = descFile.modificationDate.time;
                xml = UtilsFile.loadXMLRoot(descFile);
                if (xml)
                {
                    this._id = xml.getAttribute("id");
                    this._rootItem.favorite = xml.getAttributeBool("hasFavorites");
                }
                if (!this._id)
                {
                    this._rootItem._errorStatus = true;
                    this._id = UtilsStr.generateUID();
                    this._project.logError("Invalid package id in \'" + descFile.nativePath + "\'");
                }
            }
            catch (err:Error)
            {
                _rootItem._errorStatus = true;
                _id = UtilsStr.generateUID();
                _project.logError("UIPackage()", err);
            }
            this._cacheFolder = new File(this._project.objsPath + "/cache/" + this._id);
            this._metaFolder = new File(this._project.objsPath + "/metas/" + this._id);
            return;
        }// end function

        public function open() : void
        {
            var xd:XData;
            var step:String;
            var k:String;
            var descFile:File;
            var publishNode:XData;
            var resources:XData;
            var branches:Vector.<String>;
            var branch:String;
            var branchRoot:FPackageItem;
            var branchDescFile:File;
            var reopen:* = this._opened;
            if (reopen)
            {
                this.setChanged();
            }
            try
            {
                descFile = new File(this._basePath + "/package.xml");
                xd = UtilsFile.loadXData(descFile);
            }
            catch (err:Error)
            {
                _fatalError = true;
                _rootItem._errorStatus = true;
                _opened = true;
                _project.logError("UIPackage.open", err);
                return;
            }
            this._opened = true;
            this._opening = true;
            this._fatalError = false;
            this._itemList.length = 0;
            this._itemsCache = this._itemById;
            this._itemById = {};
            this._itemByPath = {};
            this._itemById[this._rootItem.id] = this._rootItem;
            this._itemByPath[this._rootItem.id] = this._rootItem;
            this._rootItem.children.length = 0;
            this._rootItem._errorStatus = false;
            this._rootItem.favorite = false;
            try
            {
                this._lastModified = descFile.modificationDate.time;
                this._nextId = 0;
                publishNode = xd.getChild("publish");
                if (publishNode == null)
                {
                    publishNode = XData.create("publish");
                }
                step;
                this.loadPublishSettings(publishNode);
                step;
                this.listAllFolders(this._rootItem, new File(this._basePath));
                resources = xd.getChild("resources");
                if (resources)
                {
                    step;
                    this.parseItems(resources.getChildren(), "");
                }
                xd.dispose();
                branches = this._project.allBranches;
                var _loc_2:* = 0;
                var _loc_3:* = branches;
                while (_loc_3 in _loc_2)
                {
                    
                    branch = _loc_3[_loc_2];
                    branchDescFile = new File(this.getBranchPath(branch) + "/package_branch.xml");
                    if (branchDescFile.exists)
                    {
                        step;
                        branchRoot = this.ensurePathExists("/:" + branch + "/", false);
                        xd = UtilsFile.loadXData(branchDescFile);
                        if (xd)
                        {
                            step;
                            this.listAllFolders(branchRoot, branchDescFile.parent);
                            resources = xd.getChild("resources");
                            if (resources)
                            {
                                step;
                                this.parseItems(resources.getChildren(), branch);
                            }
                            branchRoot.setVar("lastModified", branchDescFile.modificationDate.time);
                            continue;
                        }
                        branchRoot._errorStatus = true;
                    }
                }
            }
            catch (err:Error)
            {
                _fatalError = true;
                _rootItem._errorStatus = true;
                _project.logError("UIPackage.open(" + step + ")", err);
            }
            this._opening = false;
            var _loc_2:* = 0;
            var _loc_3:* = this._itemsCache;
            while (_loc_3 in _loc_2)
            {
                
                k = _loc_3[_loc_2];
                _loc_3[k].dispose();
            }
            this._itemsCache = null;
            GTimers.inst.add((GC_INTERVAL_IN_SECONDS + Math.random() * 10) * 1000, 0, this.freeUnusedResources);
            return;
        }// end function

        public function save() : void
        {
            var branchNode:XData;
            var pi:FPackageItem;
            var pd:XData;
            if (this._fatalError || !this._opened)
            {
                this._project.logError("Save failed! The package is not opened!");
                return;
            }
            if (this._inTransaction > 0)
            {
                this._needSave = true;
                return;
            }
            this._needSave = false;
            this.setChanged();
            var xd:* = XData.create("packageDescription");
            xd.setAttribute("id", this._id);
            var resData:* = XData.create("resources");
            xd.appendChild(resData);
            var branchRoot:Object;
            this._rootItem.favorite = false;
            var cnt:* = this._itemList.length;
            var i:int;
            while (i < cnt)
            {
                
                pi = this._itemList[i];
                if (pi.favorite)
                {
                    this._rootItem.favorite = true;
                }
                pd;
                if (pi.type == FPackageItemType.FOLDER)
                {
                    if (!pi.folderSettings.empty || pi.favorite)
                    {
                        pd = pi.serialize();
                    }
                    else
                    {
                    }
                }
                else
                {
                    pd = pi.serialize();
                }
                if (pi.branch)
                {
                    branchNode = branchRoot[pi.branch];
                    if (!branchNode)
                    {
                        branchNode = XData.create("resources");
                        branchRoot[pi.branch] = branchNode;
                    }
                    branchNode.appendChild(pd);
                }
                else
                {
                    resData.appendChild(pd);
                }
                i = (i + 1);
            }
            if (this._rootItem.favorite)
            {
                xd.setAttribute("hasFavorites", this._rootItem.favorite);
            }
            var publishNode:* = XData.create("publish");
            xd.appendChild(publishNode);
            this.savePublishSettings(publishNode);
            var descFile:* = new File(this._basePath + "/package.xml");
            try
            {
                UtilsFile.saveXData(descFile, xd);
                this._lastModified = descFile.modificationDate.time;
            }
            catch (err:Error)
            {
                _project.alert("Save package", err);
            }
            xd.dispose();
            var _loc_2:* = 0;
            var _loc_3:* = this._rootItem.children;
            do
            {
                
                pi = _loc_3[_loc_2];
                if (pi.branch.length > 0)
                {
                    xd = XData.create("branchDescription");
                    branchNode = branchRoot[pi.branch];
                    if (branchNode)
                    {
                        xd.appendChild(branchRoot[pi.branch]);
                    }
                    descFile = new File(this.getBranchPath(pi.branch) + "/package_branch.xml");
                    try
                    {
                        UtilsFile.saveXData(descFile, xd);
                        pi.setVar("lastModified", descFile.modificationDate.time);
                    }
                    catch (err:Error)
                    {
                        _project.alert("Save branch", err);
                    }
                }
            }while (_loc_3 in _loc_2)
            return;
        }// end function

        private function loadPublishSettings(param1:XData) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = false;
            var _loc_5:* = null;
            var _loc_7:* = false;
            var _loc_8:* = false;
            var _loc_9:* = false;
            var _loc_12:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = null;
            var _loc_2:* = GlobalPublishSettings(this._project.getSettings("publish"));
            this._publishSettings = new PublishSettings();
            this._publishSettings.fileName = param1.getAttribute("name", "");
            this._publishSettings.path = param1.getAttribute("path", "");
            this._publishSettings.branchPath = param1.getAttribute("branchPath", "");
            this._publishSettings.packageCount = param1.getAttributeInt("packageCount", _loc_2.packageCount);
            this._publishSettings.genCode = param1.getAttributeBool("genCode");
            this._publishSettings.codePath = param1.getAttribute("codePath", "");
            this._publishSettings.useGlobalAtlasSettings = !param1.hasAttribute("maxAtlasSize");
            var _loc_6:* = true;
            if (this._publishSettings.useGlobalAtlasSettings)
            {
                _loc_3 = _loc_2.atlasMaxSize;
                _loc_5 = _loc_2.atlasSizeOption;
                _loc_8 = _loc_2.atlasForceSquare;
                _loc_9 = _loc_2.atlasAllowRotation;
                _loc_4 = _loc_2.atlasPaging;
            }
            else
            {
                _loc_3 = param1.getAttributeInt("maxAtlasSize", _loc_2.atlasMaxSize);
                _loc_5 = param1.getAttribute("sizeOption", _loc_2.atlasSizeOption);
                if (param1.getAttributeBool("npot"))
                {
                    _loc_5 = "npot";
                }
                _loc_8 = param1.getAttributeBool("square", _loc_2.atlasForceSquare);
                _loc_9 = param1.getAttributeBool("rotation", _loc_2.atlasAllowRotation);
                _loc_4 = param1.getAttributeBool("multiPage", _loc_2.atlasPaging);
            }
            if (_loc_5 == "npot")
            {
                _loc_6 = false;
            }
            else if (_loc_5 == "mof")
            {
                _loc_6 = false;
                _loc_7 = true;
            }
            var _loc_10:* = param1.getAttributeBool("extractAlpha");
            var _loc_11:* = param1.getAttributeInt("maxAtlasIndex", 10);
            this._publishSettings.atlasList.length = _loc_11 + 1;
            var _loc_13:* = 0;
            while (_loc_13 <= _loc_11)
            {
                
                _loc_12 = this._publishSettings.atlasList[_loc_13];
                if (!_loc_12)
                {
                    _loc_12 = new AtlasSettings();
                    this._publishSettings.atlasList[_loc_13] = _loc_12;
                }
                _loc_12.name = "";
                _loc_12.extractAlpha = _loc_10;
                _loc_12.compression = false;
                _loc_17 = _loc_12.packSettings;
                _loc_17.pot = _loc_6;
                _loc_17.mof = _loc_7;
                _loc_17.square = _loc_8;
                _loc_17.rotation = _loc_9;
                var _loc_18:* = _loc_3;
                _loc_17.maxWidth = _loc_3;
                _loc_17.maxHeight = _loc_18;
                _loc_17.multiPage = _loc_4;
                _loc_13++;
            }
            var _loc_14:* = param1.getEnumerator("atlas");
            while (_loc_14.moveNext())
            {
                
                _loc_13 = _loc_14.current.getAttributeInt("index");
                if (_loc_13 <= _loc_11)
                {
                    _loc_12 = this._publishSettings.atlasList[_loc_13];
                    _loc_12.name = _loc_14.current.getAttribute("name", "");
                    _loc_12.compression = _loc_14.current.getAttributeBool("compression");
                }
            }
            this._publishSettings.excludedList.length = 0;
            _loc_15 = param1.getAttribute("excluded");
            if (_loc_15)
            {
                _loc_16 = _loc_15.split(",");
                for each (_loc_15 in _loc_16)
                {
                    
                    this._publishSettings.excludedList.push(_loc_15);
                }
            }
            return;
        }// end function

        private function savePublishSettings(param1:XData) : void
        {
            var _loc_5:* = false;
            var _loc_6:* = null;
            var _loc_8:* = null;
            param1.setAttribute("name", this._publishSettings.fileName);
            if (this._publishSettings.path)
            {
                param1.setAttribute("path", this._publishSettings.path);
                param1.setAttribute("packageCount", this._publishSettings.packageCount);
            }
            if (this._publishSettings.branchPath)
            {
                param1.setAttribute("branchPath", this._publishSettings.branchPath);
            }
            if (this._publishSettings.genCode)
            {
                param1.setAttribute("genCode", this._publishSettings.genCode);
            }
            if (this._publishSettings.codePath)
            {
                param1.setAttribute("codePath", this._publishSettings.codePath);
            }
            var _loc_2:* = this._publishSettings.atlasList[0];
            var _loc_3:* = _loc_2.packSettings;
            if (!this._publishSettings.useGlobalAtlasSettings)
            {
                param1.setAttribute("maxAtlasSize", _loc_3.maxWidth);
                if (!_loc_3.pot)
                {
                    param1.setAttribute("sizeOption", _loc_3.mof ? ("mof") : ("npot"));
                }
                if (_loc_3.square)
                {
                    param1.setAttribute("square", _loc_3.square);
                }
                if (_loc_3.rotation)
                {
                    param1.setAttribute("rotation", _loc_3.rotation);
                }
                if (!_loc_3.multiPage)
                {
                    param1.setAttribute("multiPage", _loc_3.multiPage);
                }
            }
            if (_loc_2.extractAlpha)
            {
                param1.setAttribute("extractAlpha", _loc_2.extractAlpha);
            }
            var _loc_4:* = this._publishSettings.atlasList.length;
            if (this._publishSettings.atlasList.length != 11)
            {
                param1.setAttribute("maxAtlasIndex", (_loc_4 - 1));
            }
            var _loc_7:* = 0;
            while (_loc_7 < _loc_4)
            {
                
                _loc_6 = this._publishSettings.atlasList[_loc_7];
                _loc_8 = XData.create("atlas");
                _loc_5 = false;
                if (_loc_6.name)
                {
                    _loc_8.setAttribute("name", _loc_6.name);
                    _loc_5 = true;
                }
                if (_loc_6.compression)
                {
                    _loc_8.setAttribute("compression", _loc_6.compression);
                    _loc_5 = true;
                }
                if (_loc_5)
                {
                    _loc_8.setAttribute("index", _loc_7);
                    param1.appendChild(_loc_8);
                }
                else
                {
                    _loc_8.dispose();
                }
                _loc_7++;
            }
            if (this._publishSettings.excludedList.length > 0)
            {
                param1.setAttribute("excluded", this._publishSettings.excludedList.join(","));
            }
            return;
        }// end function

        public function setChanged() : void
        {
            this._vars.modifiedYetNotPublished = true;
            this._project.setChanged();
            return;
        }// end function

        public function touch() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_1:* = false;
            var _loc_2:* = new File(this._basePath + File.separator + "package.xml");
            if (!_loc_2.exists || this._lastModified != _loc_2.modificationDate.time)
            {
                _loc_1 = true;
            }
            if (this._opened)
            {
                _loc_3 = this._project.allBranches;
                if (_loc_3.length > 0)
                {
                    for each (_loc_4 in _loc_3)
                    {
                        
                        _loc_2 = new File(this.getBranchPath(_loc_4) + "/package_branch.xml");
                        if (_loc_2.exists)
                        {
                            _loc_5 = this.getBranchRootItem(_loc_4);
                            if (!_loc_5)
                            {
                                _loc_1 = true;
                                continue;
                            }
                            if (_loc_5.getVar("lastModified") != _loc_2.modificationDate.time)
                            {
                                _loc_1 = true;
                            }
                        }
                    }
                }
                for each (_loc_5 in this._rootItem.children)
                {
                    
                    if (_loc_5.branch.length > 0)
                    {
                        _loc_5.touch();
                        if (!_loc_5.file.exists)
                        {
                            _loc_1 = true;
                        }
                    }
                }
            }
            if (_loc_1)
            {
                if (this._opened)
                {
                    this.open();
                }
                else
                {
                    this.init();
                }
                if (this._project.editor)
                {
                    this._project.editor.emit(EditorEvent.PackageReloaded, this);
                }
            }
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_3:* = null;
            GTimers.inst.remove(this.freeUnusedResources);
            var _loc_1:* = this._itemList.length;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._itemList[_loc_2];
                _loc_3.dispose();
                _loc_2++;
            }
            this._itemList.length = 0;
            this._opened = false;
            return;
        }// end function

        public function ensureOpen() : void
        {
            if (!this._opened)
            {
                this.open();
            }
            return;
        }// end function

        public function freeUnusedResources(param1:Boolean = false) : void
        {
            var _loc_2:* = false;
            var _loc_4:* = null;
            if (Capabilities.isDebugger)
            {
                _loc_2 = true;
            }
            var _loc_3:* = param1 ? (0) : (getTimer());
            for each (_loc_4 in this._itemList)
            {
                
                if (_loc_4.type == FPackageItemType.IMAGE || _loc_4.type == FPackageItemType.MOVIECLIP)
                {
                    if (_loc_4.tryDisposeData(_loc_3))
                    {
                    }
                }
            }
            return;
        }// end function

        public function get strings() : Object
        {
            return this._strings;
        }// end function

        public function set strings(param1:Object) : void
        {
            this._strings = param1;
            return;
        }// end function

        private function listAllFolders(param1:FPackageItem, param2:File) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_3:* = param2.getDirectoryListing();
            var _loc_4:* = _loc_3.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = _loc_3[_loc_5];
                if (!_loc_6.isDirectory)
                {
                }
                else
                {
                    _loc_7 = param1.id + _loc_6.name + "/";
                    _loc_8 = this._itemsCache[_loc_7];
                    if (!_loc_8)
                    {
                        _loc_8 = new FPackageItem(this, FPackageItemType.FOLDER, _loc_7);
                    }
                    else
                    {
                        delete this._itemsCache[_loc_7];
                        _loc_8.children.length = 0;
                    }
                    _loc_8.setFile(param1.id, _loc_6.name);
                    this._itemById[_loc_8.id] = _loc_8;
                    this._itemByPath[_loc_8.path + _loc_8.name] = _loc_8;
                    this._itemList.push(_loc_8);
                    param1.children.push(_loc_8);
                    this.listAllFolders(_loc_8, _loc_6);
                }
                _loc_5++;
            }
            return;
        }// end function

        private function parseItems(param1:Vector.<XData>, param2:String) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            for each (_loc_7 in param1)
            {
                
                _loc_4 = _loc_7.getAttribute("id");
                if (!_loc_4)
                {
                    continue;
                }
                _loc_5 = _loc_7.getName();
                if (_loc_5 == "folder")
                {
                    _loc_3 = this._itemById[_loc_4];
                    if (_loc_3)
                    {
                        _loc_3.favorite = _loc_7.getAttributeBool("favorite");
                        if (_loc_3.favorite)
                        {
                            this._rootItem.favorite = true;
                        }
                        _loc_3.folderSettings.read(_loc_3, _loc_7);
                    }
                    continue;
                }
                _loc_3 = this._itemById[_loc_4];
                if (_loc_3)
                {
                    continue;
                }
                _loc_3 = this._itemsCache[_loc_4];
                if (!_loc_3)
                {
                    _loc_3 = new FPackageItem(this, _loc_5, _loc_4);
                }
                else
                {
                    delete this._itemsCache[_loc_4];
                    _loc_3.setChanged();
                }
                _loc_6 = _loc_7.getAttribute("path", "");
                if (_loc_6.length == 0)
                {
                    _loc_6 = "/";
                }
                else
                {
                    if (_loc_6.charAt(0) != "/")
                    {
                        _loc_6 = "/" + _loc_6;
                    }
                    if (_loc_6.charAt((_loc_6.length - 1)) != "/")
                    {
                        _loc_6 = _loc_6 + "/";
                    }
                }
                if (param2)
                {
                    _loc_6 = "/:" + param2 + _loc_6;
                }
                _loc_3.setFile(_loc_6, _loc_7.getAttribute("name", ""));
                _loc_3.exported = _loc_7.getAttributeBool("exported");
                _loc_3.favorite = _loc_7.getAttributeBool("favorite");
                _loc_3.reviewed = _loc_7.getAttribute("reviewed");
                if (_loc_3.imageSettings)
                {
                    _loc_3.imageSettings.read(_loc_3, _loc_7);
                }
                else if (_loc_3.fontSettings)
                {
                    _loc_3.fontSettings.read(_loc_3, _loc_7);
                }
                if (_loc_3.favorite)
                {
                    this._rootItem.favorite = true;
                }
                _loc_8 = this._itemById[_loc_3.path];
                if (!_loc_8)
                {
                    _loc_8 = this.ensurePathExists(_loc_3.path, false);
                }
                _loc_8.children.push(_loc_3);
                this._itemById[_loc_3.id] = _loc_3;
                this._itemList.push(_loc_3);
                this._itemByPath[_loc_3.path + _loc_3.name] = _loc_3;
                _loc_6 = _loc_3.id.substr(4);
                _loc_9 = parseInt(_loc_6, 36);
                if (_loc_9 >= this._nextId)
                {
                    this._nextId = _loc_9 + 1;
                }
            }
            return;
        }// end function

        public function getNextId() : String
        {
            var _loc_2:* = this;
            _loc_2._nextId = this._nextId + 1;
            var _loc_1:* = this._project.serialNumberSeed + (this._nextId++).toString(36);
            while (this._itemById[_loc_1])
            {
                
                var _loc_2:* = this;
                _loc_2._nextId = this._nextId + 1;
                _loc_1 = this._project.serialNumberSeed + (this._nextId++).toString(36);
            }
            return _loc_1;
        }// end function

        public function getSequenceName(param1:String) : String
        {
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_2:* = param1.length;
            var _loc_3:* = this._itemList.length;
            var _loc_4:* = -1;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_6 = this._itemList[_loc_5];
                if (UtilsStr.startsWith(_loc_6.name, param1))
                {
                    _loc_7 = parseInt(_loc_6.name.substr(_loc_2));
                    if (_loc_7 > _loc_4)
                    {
                        _loc_4 = _loc_7;
                    }
                }
                _loc_5++;
            }
            if (_loc_4 <= 0)
            {
                return param1 + "1";
            }
            return param1 + ++_loc_4;
        }// end function

        public function getUniqueName(param1:FPackageItem, param2:String) : String
        {
            var _loc_5:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = false;
            var _loc_3:* = UtilsStr.getFileName(param2);
            var _loc_4:* = UtilsStr.getFileExt(param2, true);
            if (UtilsStr.getFileExt(param2, true))
            {
                _loc_5 = "." + _loc_4;
                _loc_5 = _loc_5.toLowerCase();
            }
            else
            {
                _loc_5 = "";
            }
            var _loc_6:* = 1;
            var _loc_12:* = _loc_3.length;
            if (param1 == null)
            {
                _loc_7 = this._itemList.length;
                _loc_8 = 0;
                while (_loc_8 < _loc_7)
                {
                    
                    _loc_10 = this._itemList[_loc_8];
                    if (UtilsStr.startsWith(_loc_10.name, _loc_3, true) && UtilsStr.getFileExt(_loc_10.fileName) == _loc_4)
                    {
                        if (_loc_10.name.length == _loc_12)
                        {
                            _loc_11 = true;
                        }
                        else if (_loc_10.name.charAt(_loc_12) == "(")
                        {
                            _loc_9 = _loc_10.name.indexOf(")", _loc_12);
                            if (_loc_9 != -1)
                            {
                                _loc_9 = parseInt(_loc_10.fileName.substring((_loc_12 + 1), _loc_9));
                                if (_loc_9 >= _loc_6)
                                {
                                    _loc_6 = _loc_9 + 1;
                                }
                            }
                        }
                    }
                    _loc_8++;
                }
            }
            else
            {
                _loc_7 = param1.children.length;
                _loc_8 = 0;
                while (_loc_8 < _loc_7)
                {
                    
                    _loc_10 = param1.children[_loc_8];
                    if (UtilsStr.startsWith(_loc_10.name, _loc_3, true) && UtilsStr.getFileExt(_loc_10.fileName) == _loc_4)
                    {
                        if (_loc_10.name.length == _loc_12)
                        {
                            _loc_11 = true;
                        }
                        else if (_loc_10.name.charAt(_loc_12) == "(")
                        {
                            _loc_9 = _loc_10.name.indexOf(")", _loc_12);
                            if (_loc_9 != -1)
                            {
                                _loc_9 = parseInt(_loc_10.fileName.substring((_loc_12 + 1), _loc_9));
                                if (_loc_9 >= _loc_6)
                                {
                                    _loc_6 = _loc_9 + 1;
                                }
                            }
                        }
                    }
                    _loc_8++;
                }
            }
            if (_loc_11)
            {
                return _loc_3 + "(" + _loc_6 + ")" + _loc_5;
            }
            return param2;
        }// end function

        public function getItemListing(param1:FPackageItem, param2:Array = null, param3:Boolean = true, param4:Boolean = false, param5:Vector.<FPackageItem> = null) : Vector.<FPackageItem>
        {
            var _loc_8:* = null;
            this.ensureOpen();
            if (param5 == null)
            {
                param5 = new Vector.<FPackageItem>;
            }
            var _loc_6:* = param1.children.length;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_8 = param1.children[_loc_7];
                if (param2 != null && param2.indexOf(_loc_8.type) == -1)
                {
                }
                else
                {
                    param5.push(_loc_8);
                    if (param4 && _loc_8.type == FPackageItemType.FOLDER)
                    {
                        this.getItemListing(_loc_8, param2, param3, param4, param5);
                    }
                }
                _loc_7++;
            }
            if (param3 && !param4 && param5.length)
            {
                param5.sort(this.compareItem);
            }
            return param5;
        }// end function

        public function getFavoriteItems(param1:Vector.<FPackageItem> = null) : Vector.<FPackageItem>
        {
            this.ensureOpen();
            if (param1 == null)
            {
                param1 = new Vector.<FPackageItem>;
            }
            this.collectFavorites(this._rootItem.children, param1);
            param1.sort(this.compareItem);
            return param1;
        }// end function

        private function collectFavorites(param1:Vector.<FPackageItem>, param2:Vector.<FPackageItem>) : void
        {
            var _loc_5:* = null;
            var _loc_3:* = param1.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = param1[_loc_4];
                if (_loc_5.favorite)
                {
                    param2.push(_loc_5);
                }
                else if (_loc_5.type == FPackageItemType.FOLDER)
                {
                    this.collectFavorites(_loc_5.children, param2);
                }
                _loc_4++;
            }
            return;
        }// end function

        private function compareItem(param1:FPackageItem, param2:FPackageItem) : int
        {
            if (param1.type == "folder" && param2.type != "folder")
            {
                return -1;
            }
            if (param1.type != "folder" && param2.type == "folder")
            {
                return 1;
            }
            return param1.sortKey.localeCompare(param2.sortKey);
        }// end function

        public function getItem(param1:String) : FPackageItem
        {
            this.ensureOpen();
            return this._itemById[param1];
        }// end function

        public function findItemByName(param1:String) : FPackageItem
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            this.ensureOpen();
            for each (_loc_2 in this._itemList)
            {
                
                if (_loc_2.name == param1)
                {
                    if (_loc_2.exported)
                    {
                        helperList.unshift(_loc_2);
                        continue;
                    }
                    helperList.push(_loc_2);
                }
            }
            if (helperList.length > 0)
            {
                _loc_3 = helperList[0];
                helperList.length = 0;
                return _loc_3;
            }
            return null;
        }// end function

        public function getItemByPath(param1:String) : FPackageItem
        {
            this.ensureOpen();
            return this._itemByPath[param1];
        }// end function

        public function getItemByName(param1:FPackageItem, param2:String) : FPackageItem
        {
            var _loc_4:* = null;
            this.ensureOpen();
            if (param1 == null)
            {
                param1 = this._rootItem;
            }
            var _loc_3:* = param1.children;
            for each (_loc_4 in _loc_3)
            {
                
                if (_loc_4.name == param2)
                {
                    return _loc_4;
                }
            }
            return null;
        }// end function

        public function getItemByFileName(param1:FPackageItem, param2:String) : FPackageItem
        {
            var _loc_5:* = null;
            var _loc_3:* = param1.children.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = param1.children[_loc_4];
                if (Consts.isMacOS && _loc_5.fileName == param2 || !Consts.isMacOS && _loc_5.fileName.toLowerCase() == param2.toLowerCase())
                {
                    return _loc_5;
                }
                _loc_4++;
            }
            return null;
        }// end function

        public function getItemPath(param1:FPackageItem, param2:Vector.<FPackageItem> = null) : Vector.<FPackageItem>
        {
            if (!param2)
            {
                param2 = new Vector.<FPackageItem>;
            }
            param2.push(param1);
            while (param1 != this._rootItem)
            {
                
                param1 = param1.parent;
                if (param1)
                {
                    if (param1 != this._rootItem)
                    {
                        param2.push(param1);
                    }
                    continue;
                }
                break;
            }
            param2.reverse();
            return param2;
        }// end function

        public function addItem(param1:FPackageItem) : void
        {
            param1.touch();
            this._itemList.push(param1);
            this._itemById[param1.id] = param1;
            this._itemByPath[param1.path + param1.name] = param1;
            var _loc_2:* = this._itemById[param1.path];
            _loc_2.children.push(param1);
            if (!this._opening)
            {
                if (this._project.editor)
                {
                    this._project.editor.emit(EditorEvent.PackageTreeChanged, _loc_2);
                }
                this.save();
            }
            return;
        }// end function

        public function renameItem(param1:FPackageItem, param2:String) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            if (param1.isBranchRoot)
            {
                return;
            }
            param2 = FProject.validateName(param2);
            var _loc_3:* = param1.file;
            if (param1.type != FPackageItemType.FOLDER)
            {
                _loc_5 = _loc_3.extension;
                param2 = param2 + (_loc_5 ? ("." + _loc_5) : (""));
            }
            var _loc_4:* = new File(UtilsStr.getFilePath(_loc_3.nativePath) + "/" + param2);
            UtilsFile.renameFile(_loc_3, _loc_4);
            if (param1 == this._rootItem)
            {
                this._basePath = _loc_4.nativePath;
                this._project._listDirty = true;
                param1.setFile(param1.path, param2);
                _loc_6 = this._project.allBranches;
                for each (_loc_7 in _loc_6)
                {
                    
                    _loc_8 = this.getBranchRootItem(_loc_7);
                    if (_loc_8)
                    {
                        _loc_4 = new File(this.getBranchPath(_loc_7));
                        UtilsFile.renameFile(_loc_8.file, _loc_4);
                    }
                }
                this.changeChildrenPath(param1);
                if (this._project.editor)
                {
                    this._project.editor.emit(EditorEvent.PackageItemChanged, param1);
                    this._project.editor.emit(EditorEvent.PackageTreeChanged, null);
                }
            }
            else
            {
                delete this._itemByPath[param1.path + param1.name];
                param1.setFile(param1.path, param2);
                this._itemByPath[param1.path + param1.name] = param1;
                if (param1.type == FPackageItemType.FOLDER)
                {
                    delete this._itemById[param1.id];
                    param1.id = param1.path + param1.name + "/";
                    this._itemById[param1.id] = param1;
                    this.changeChildrenPath(param1);
                }
                if (this._project.editor)
                {
                    this._project.editor.emit(EditorEvent.PackageItemChanged, param1);
                    _loc_9 = this._itemById[param1.path];
                    if (_loc_9)
                    {
                        this._project.editor.emit(EditorEvent.PackageTreeChanged, _loc_9);
                    }
                }
            }
            this.save();
            return;
        }// end function

        function renameBranchRoot(param1:FPackageItem, param2:String) : void
        {
            var _loc_3:* = null;
            if (!param1.isBranchRoot)
            {
                return;
            }
            delete this._itemByPath[param1.path + param1.name];
            param1.setFile(param1.path, param2);
            this._itemByPath[param1.path + param1.name] = param1;
            delete this._itemById[param1.id];
            param1.id = param1.path + param1.name + "/";
            this._itemById[param1.id] = param1;
            this.changeChildrenPath(param1);
            if (this._project.editor)
            {
                this._project.editor.emit(EditorEvent.PackageItemChanged, param1);
                _loc_3 = this._itemById[param1.path];
                if (_loc_3)
                {
                    this._project.editor.emit(EditorEvent.PackageTreeChanged, _loc_3);
                }
            }
            return;
        }// end function

        public function moveItem(param1:FPackageItem, param2:String) : void
        {
            if (param1.path == param2)
            {
                return;
            }
            var _loc_3:* = this._itemById[param1.path];
            var _loc_4:* = this._itemById[param2];
            if (_loc_3 == null || _loc_4 == null)
            {
                throw new Error("Path not exists");
            }
            var _loc_5:* = this.getUniqueName(_loc_4, param1.fileName);
            var _loc_6:* = param1.file;
            var _loc_7:* = new File(_loc_4.file.nativePath + "/" + _loc_5);
            try
            {
                _loc_6.canonicalize();
                _loc_7.canonicalize();
            }
            catch (err)
            {
            }
            if (_loc_6.nativePath != _loc_7.nativePath)
            {
                if (param1.type == FPackageItemType.FOLDER)
                {
                    if (UtilsStr.startsWith(_loc_7.nativePath, _loc_6.nativePath, true))
                    {
                        throw new Error("Cannot move into child folder");
                    }
                }
                if (_loc_6.exists)
                {
                    _loc_6.moveTo(_loc_7);
                }
            }
            var _loc_8:* = _loc_3.children.indexOf(param1);
            _loc_3.children.splice(_loc_8, 1);
            _loc_4.children.push(param1);
            delete this._itemByPath[param1.path + param1.name];
            param1.setFile(param2, _loc_5);
            this._itemByPath[param1.path + param1.name] = param1;
            if (param1.type == FPackageItemType.FOLDER)
            {
                delete this._itemById[param1.id];
                param1.id = param1.path + param1.name + "/";
                this._itemById[param1.id] = param1;
                this.changeChildrenPath(param1);
            }
            if (this._project.editor)
            {
                this._project.editor.emit(EditorEvent.PackageTreeChanged, _loc_3);
                this._project.editor.emit(EditorEvent.PackageTreeChanged, _loc_4);
            }
            this.save();
            return;
        }// end function

        private function changeChildrenPath(param1:FPackageItem) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = param1.children.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = param1.children[_loc_3];
                delete this._itemByPath[_loc_4.path + _loc_4.name];
                _loc_4.setFile(param1.id, _loc_4.fileName);
                this._itemByPath[_loc_4.path + _loc_4.name] = _loc_4;
                if (_loc_4.type == FPackageItemType.FOLDER)
                {
                    delete this._itemById[_loc_4.id];
                    _loc_4.id = _loc_4.path + _loc_4.name + "/";
                    this._itemById[_loc_4.id] = _loc_4;
                    this.changeChildrenPath(_loc_4);
                }
                _loc_3++;
            }
            return;
        }// end function

        public function deleteItem(param1:FPackageItem) : int
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_2:* = this._deleteItem(param1);
            if (_loc_2 > 0)
            {
                _loc_3 = param1.file;
                if (_loc_3.exists)
                {
                    UtilsFile.deleteFile(_loc_3, true);
                }
                _loc_4 = this._itemById[param1.path];
                if (_loc_4 != null)
                {
                    _loc_5 = _loc_4.children.indexOf(param1);
                    _loc_4.children.splice(_loc_5, 1);
                    if (this._project.editor)
                    {
                        this._project.editor.emit(EditorEvent.PackageTreeChanged, _loc_4);
                    }
                }
                this.save();
            }
            return _loc_2;
        }// end function

        private function _deleteItem(param1:FPackageItem) : int
        {
            var _loc_4:* = 0;
            var _loc_2:* = this._itemList.indexOf(param1);
            if (_loc_2 == -1)
            {
                return 0;
            }
            this._itemList.splice(_loc_2, 1);
            delete this._itemById[param1.id];
            delete this._itemByPath[param1.path + param1.name];
            var _loc_3:* = 1;
            if (param1.type == FPackageItemType.FOLDER)
            {
                _loc_4 = param1.children.length;
                _loc_2 = 0;
                while (_loc_2 < _loc_4)
                {
                    
                    _loc_3 = _loc_3 + this._deleteItem(param1.children[_loc_2]);
                    _loc_2++;
                }
            }
            param1.dispose();
            if (this._project.editor)
            {
                this._project.editor.emit(EditorEvent.PackageItemDeleted, param1);
            }
            return _loc_3;
        }// end function

        public function duplicateItem(param1:FPackageItem, param2:String) : FPackageItem
        {
            param2 = FProject.validateName(param2);
            var _loc_3:* = UtilsStr.getFileExt(param1.fileName);
            param2 = param2 + (_loc_3 ? ("." + _loc_3) : (""));
            var _loc_4:* = new FPackageItem(this, param1.type, this.getNextId());
            _loc_4.setFile(param1.path, param2);
            _loc_4.copySettings(param1);
            var _loc_5:* = param1.file;
            var _loc_6:* = _loc_4.file;
            if (_loc_6.exists)
            {
                throw new Error("File already exists");
            }
            if (_loc_5.isDirectory)
            {
                _loc_6.createDirectory();
            }
            else
            {
                UtilsFile.copyFile(_loc_5, _loc_6);
            }
            this.addItem(_loc_4);
            return _loc_4;
        }// end function

        public function setItemProperty(param1:FPackageItem, param2:String, param3) : void
        {
            if (param1[param2] == param3)
            {
                return;
            }
            param1[param2] = param3;
            this.save();
            if (this._project.editor)
            {
                this._project.editor.emit(EditorEvent.PackageItemChanged, param1);
            }
            return;
        }// end function

        public function ensurePathExists(param1:String, param2:Boolean) : FPackageItem
        {
            var _loc_6:* = null;
            var _loc_9:* = null;
            var _loc_3:* = this._itemById[param1];
            if (_loc_3)
            {
                return _loc_3;
            }
            var _loc_4:* = param1.length;
            var _loc_5:* = 1;
            var _loc_7:* = this._rootItem;
            var _loc_8:* = 1;
            while (_loc_8 < _loc_4)
            {
                
                if (param1.charCodeAt(_loc_8) == 47)
                {
                    _loc_6 = param1.substring(0, (_loc_8 + 1));
                    _loc_3 = this._itemById[_loc_6];
                    if (!_loc_3)
                    {
                        _loc_3 = new FPackageItem(this, FPackageItemType.FOLDER, _loc_6);
                        _loc_3.setFile(_loc_6.substring(0, _loc_5), _loc_6.substring(_loc_5, _loc_8));
                        if (param2)
                        {
                            _loc_9 = _loc_3.file;
                            if (!_loc_9.exists)
                            {
                                _loc_9.createDirectory();
                            }
                        }
                        this.addItem(_loc_3);
                    }
                    _loc_7 = _loc_3;
                    _loc_5 = _loc_8 + 1;
                }
                _loc_8++;
            }
            if (!_loc_3)
            {
                _loc_3 = this._rootItem;
            }
            return _loc_3;
        }// end function

        public function getBranchPath(param1:String) : String
        {
            return this._project.basePath + "/assets_" + param1 + "/" + this._rootItem.name;
        }// end function

        public function createBranch(param1:String) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = new File(this.getBranchPath(param1));
            if (!_loc_2.exists)
            {
                _loc_2.createDirectory();
            }
            var _loc_3:* = _loc_2.resolvePath("package_branch.xml");
            if (!_loc_3.exists)
            {
                _loc_4 = XData.parse("<branchDescription><resources/></branchDescription>");
                UtilsFile.saveXData(_loc_3, _loc_4);
            }
            this.ensurePathExists("/:" + param1 + "/", false);
            return;
        }// end function

        public function createFolder(param1:String, param2:String = null, param3:Boolean = false) : FPackageItem
        {
            this.ensureOpen();
            if (param2 == null)
            {
                param2 = "/";
            }
            var _loc_4:* = this._itemById[param2];
            if (!this._itemById[param2])
            {
                throw new Error("Path not exists");
            }
            param1 = FProject.validateName(param1);
            if (param3)
            {
                param1 = this.getUniqueName(null, param1);
            }
            var _loc_5:* = new FPackageItem(this, FPackageItemType.FOLDER, param2 + param1 + "/");
            _loc_5.setFile(param2, param1);
            if (_loc_5.file.exists)
            {
                throw new Error(Consts.strings.text113);
            }
            _loc_5.file.createDirectory();
            this.addItem(_loc_5);
            return _loc_5;
        }// end function

        public function createPath(param1:String) : FPackageItem
        {
            this.ensureOpen();
            return this.ensurePathExists(param1, true);
        }// end function

        public function createComponentItem(param1:String, param2:int, param3:int, param4:String = null, param5:String = null, param6:Boolean = false, param7:Boolean = false) : FPackageItem
        {
            var _loc_12:* = null;
            this.ensureOpen();
            if (param4 == null)
            {
                param4 = "/";
            }
            var _loc_8:* = this._itemById[param4];
            if (!this._itemById[param4])
            {
                throw new Error("Path not exists");
            }
            param1 = FProject.validateName(param1);
            var _loc_9:* = param1 + ".xml";
            if (param7)
            {
                _loc_9 = this.getUniqueName(null, _loc_9);
            }
            var _loc_10:* = new FPackageItem(this, FPackageItemType.COMPONENT, this.getNextId());
            _loc_10.setFile(param4, _loc_9);
            _loc_10.exported = param6;
            if (_loc_10.file.exists)
            {
                throw new Error(Consts.strings.text113);
            }
            var _loc_11:* = XData.create("component");
            _loc_11.setAttribute("size", param2 + "," + param3);
            if (param5)
            {
                _loc_11.setAttribute("extention", param5);
                _loc_12 = XData.create(param5);
                _loc_11.appendChild(_loc_12);
            }
            UtilsFile.saveXData(_loc_10.file, _loc_11);
            this.addItem(_loc_10);
            return _loc_10;
        }// end function

        public function createFontItem(param1:String, param2:String = null, param3:Boolean = false) : FPackageItem
        {
            this.ensureOpen();
            if (param2 == null)
            {
                param2 = "/";
            }
            var _loc_4:* = this._itemById[param2];
            if (!this._itemById[param2])
            {
                throw new Error("Path not exists");
            }
            param1 = FProject.validateName(param1);
            var _loc_5:* = param1 + ".fnt";
            if (param3)
            {
                _loc_5 = this.getUniqueName(null, _loc_5);
            }
            var _loc_6:* = new FPackageItem(this, FPackageItemType.FONT, this.getNextId());
            _loc_6.setFile(param2, _loc_5);
            _loc_6.exported = true;
            if (_loc_6.file.exists)
            {
                throw new Error(Consts.strings.text113);
            }
            UtilsFile.saveString(_loc_6.file, "info creator=UIBuilder\n");
            this.addItem(_loc_6);
            return _loc_6;
        }// end function

        public function createMovieClipItem(param1:String, param2:String = null, param3:Boolean = false) : FPackageItem
        {
            this.ensureOpen();
            if (param2 == null)
            {
                param2 = "/";
            }
            var _loc_4:* = this._itemById[param2];
            if (!this._itemById[param2])
            {
                throw new Error("Path not exists");
            }
            param1 = FProject.validateName(param1);
            var _loc_5:* = param1 + ".jta";
            if (param3)
            {
                _loc_5 = this.getUniqueName(null, _loc_5);
            }
            var _loc_6:* = new FPackageItem(this, FPackageItemType.MOVIECLIP, this.getNextId());
            _loc_6.setFile(param2, _loc_5);
            if (_loc_6.file.exists)
            {
                throw new Error(Consts.strings.text113);
            }
            var _loc_7:* = new AniDef();
            UtilsFile.saveBytes(_loc_6.file, _loc_7.save());
            this.addItem(_loc_6);
            return _loc_6;
        }// end function

        public function importResource(param1:File, param2:String, param3:String, param4:Callback) : void
        {
            var pi:FPackageItem;
            var callback2:Callback;
            var info:Object;
            var ani:AniDef;
            var ext:String;
            var sourceFile:* = param1;
            var toPath:* = param2;
            var resName:* = param3;
            var callback:* = param4;
            var type:* = FPackageItemType.getFileType(sourceFile);
            if (type == null)
            {
                callback.callOnFail();
                return;
            }
            var folderItem:* = this.createPath(toPath);
            var fileName:* = resName ? (resName) : (sourceFile.name);
            if (type == FPackageItemType.MOVIECLIP)
            {
                fileName = UtilsStr.replaceFileExt(fileName, "jta");
            }
            fileName = this.getUniqueName(folderItem, fileName);
            pi = new FPackageItem(this, type, this.getNextId());
            pi.setFile(toPath, fileName);
            callback2 = new Callback();
            callback2.success = function () : void
            {
                addItem(pi);
                callback.result = pi;
                callback.callOnSuccess();
                return;
            }// end function
            ;
            callback2.failed = function () : void
            {
                callback.addMsgs(callback2.msgs);
                callback.callOnFail();
                return;
            }// end function
            ;
            if (type == FPackageItemType.IMAGE)
            {
                info = ResourceSize.getSize(sourceFile);
                if (info && info.type == "svg")
                {
                    pi.imageSettings.width = info.width;
                    pi.imageSettings.height = info.height;
                }
                UtilsFile.copyFile(sourceFile, pi.file);
                callback2.callOnSuccessImmediately();
            }
            else if (type == FPackageItemType.MOVIECLIP)
            {
                ext = sourceFile.extension.toLowerCase();
                if (ext == "gif")
                {
                    this.importGif(pi, sourceFile, callback2);
                }
                else if (ext == "plist" || ext == "eas")
                {
                    importMovieClip(pi, sourceFile, callback2);
                }
                else
                {
                    ani = new AniDef();
                    ani.load(UtilsFile.loadBytes(sourceFile));
                    if (ani.frameCount == 0)
                    {
                        callback.addMsg(Consts.strings.text116);
                        callback.callOnFailImmediately();
                    }
                    else
                    {
                        UtilsFile.saveBytes(pi.file, ani.save());
                        callback2.callOnSuccessImmediately();
                    }
                }
            }
            else if (type == FPackageItemType.FONT)
            {
                this.importFont(pi, sourceFile, callback2);
            }
            else
            {
                UtilsFile.copyFile(sourceFile, pi.file);
                callback2.callOnSuccessImmediately();
            }
            return;
        }// end function

        public function updateResource(param1:FPackageItem, param2:File, param3:Callback) : void
        {
            var callback2:Callback;
            var info:Object;
            var ani:AniDef;
            var pi:* = param1;
            var sourceFile:* = param2;
            var callback:* = param3;
            var newType:* = FPackageItemType.getFileType(sourceFile);
            if (newType == null)
            {
                callback.callOnFail();
                return;
            }
            var oldExt:* = UtilsStr.getFileExt(pi.fileName);
            var newExt:* = sourceFile.extension.toLowerCase();
            if (newType != pi.type && !(newType == FPackageItemType.COMPONENT && pi.type == FPackageItemType.MISC))
            {
                callback.addMsg("Source file type mismatched!");
                callback.callOnFail();
                return;
            }
            var folderItem:* = this.createPath(pi.path);
            var fileName:* = pi.fileName;
            if ((pi.type == FPackageItemType.IMAGE || pi.type == FPackageItemType.SOUND || pi.type == FPackageItemType.MISC) && oldExt != newExt)
            {
                fileName = UtilsStr.replaceFileExt(fileName, newExt);
                if (new File(pi.file.parent.nativePath + "/" + fileName).exists)
                {
                    callback.addMsg("File already exists!");
                    callback.callOnFail();
                    return;
                }
                UtilsFile.deleteFile(pi.file);
                pi.setFile(pi.path, fileName);
                this.save();
            }
            callback2 = new Callback();
            callback2.success = function () : void
            {
                pi.setChanged();
                setChanged();
                callback.result = pi;
                callback.callOnSuccess();
                return;
            }// end function
            ;
            callback2.failed = function () : void
            {
                callback.addMsgs(callback2.msgs);
                callback.callOnFail();
                return;
            }// end function
            ;
            if (pi.type == FPackageItemType.IMAGE)
            {
                info = ResourceSize.getSize(sourceFile);
                if (info && info.type == "svg" && pi.imageSettings.width == 0)
                {
                    pi.imageSettings.width = info.width;
                    pi.imageSettings.height = info.height;
                    this.save();
                }
                UtilsFile.copyFile(sourceFile, pi.file);
                callback2.callOnSuccessImmediately();
            }
            else if (pi.type == FPackageItemType.MOVIECLIP)
            {
                if (newExt == "gif")
                {
                    this.importGif(pi, sourceFile, callback2);
                }
                else if (newExt == "plist" || newExt == "eas")
                {
                    importMovieClip(pi, sourceFile, callback2);
                }
                else
                {
                    ani = new AniDef();
                    ani.load(UtilsFile.loadBytes(sourceFile));
                    if (ani.frameCount == 0)
                    {
                        callback.addMsg(Consts.strings.text116);
                        callback.callOnFailImmediately();
                    }
                    else
                    {
                        UtilsFile.saveBytes(pi.file, ani.save());
                        callback2.callOnSuccessImmediately();
                    }
                }
            }
            else if (pi.type == FPackageItemType.FONT)
            {
                this.importFont(pi, sourceFile, callback2);
            }
            else
            {
                UtilsFile.copyFile(sourceFile, pi.file);
                callback2.callOnSuccessImmediately();
            }
            return;
        }// end function

        private function importFont(param1:FPackageItem, param2:File, param3:Callback) : void
        {
            var pkg:IUIPackage;
            var i:int;
            var pngFile:String;
            var ttf:Boolean;
            var str:String;
            var arr:Array;
            var j:int;
            var arr2:Array;
            var atlasItem:FPackageItem;
            var newAtlas:Boolean;
            var sourcePngFile:File;
            var callback2:Callback;
            var pi:* = param1;
            var sourceFile:* = param2;
            var callback:* = param3;
            pkg = pi.owner;
            var content:* = UtilsFile.loadString(sourceFile);
            var lines:* = content.split("\n");
            var lineCount:* = lines.length;
            var kv:Object;
            i;
            while (i < lineCount)
            {
                
                str = lines[i];
                if (!str)
                {
                }
                else
                {
                    str = UtilsStr.trim(str);
                    arr = str.split(" ");
                    j;
                    while (j < arr.length)
                    {
                        
                        arr2 = arr[j].split("=");
                        kv[arr2[0]] = arr2[1];
                        j = (j + 1);
                    }
                    str = arr[0];
                    if (str == "page")
                    {
                        pngFile = kv.file.substr(1, kv.file.length - 2);
                        break;
                    }
                    else if (str == "info")
                    {
                        ttf = kv.face != null;
                    }
                    else if (str == "common")
                    {
                        if (int(kv.pages) > 1)
                        {
                            callback.addMsg(Consts.strings.text114);
                            callback.callOnFail();
                            return;
                        }
                    }
                }
                i = (i + 1);
            }
            if (ttf)
            {
                if (pi.fontSettings.texture)
                {
                    atlasItem = pi.owner.getItem(pi.fontSettings.texture);
                }
                if (!atlasItem)
                {
                    atlasItem = new FPackageItem(pkg, FPackageItemType.IMAGE, pkg.getNextId());
                    atlasItem.setFile(pi.path, pkg.getUniqueName(pkg.getItem(pi.path), pi.name + "_atlas.png"));
                    newAtlas;
                }
                else
                {
                    atlasItem.setChanged();
                }
                pi.fontSettings.texture = atlasItem.id;
                sourcePngFile = new File(sourceFile.parent.nativePath + "/" + pngFile);
                if (!sourcePngFile.exists)
                {
                    sourcePngFile = new File(sourceFile.parent.nativePath + "/" + UtilsStr.replaceFileExt(sourceFile.name, "png"));
                }
                if (!sourcePngFile.exists)
                {
                    callback.addMsg("File not found: " + sourcePngFile.nativePath);
                    callback.callOnFail();
                    return;
                }
                callback2 = new Callback();
                callback2.success = function () : void
            {
                UtilsFile.copyFile(sourcePngFile, atlasItem.file);
                UtilsFile.copyFile(sourceFile, pi.file);
                if (newAtlas)
                {
                    pkg.addItem(atlasItem);
                }
                callback.callOnSuccessImmediately();
                return;
            }// end function
            ;
                callback2.failed = function () : void
            {
                callback.addMsgs(callback2.msgs);
                callback.callOnFailImmediately();
                return;
            }// end function
            ;
                ImageTool.cropImage(sourcePngFile, atlasItem.file, callback2);
            }
            else
            {
                pi.fontSettings.texture = null;
                UtilsFile.copyFile(sourceFile, pi.file);
                callback.callOnSuccess();
            }
            return;
        }// end function

        private function importGif(param1:FPackageItem, param2:File, param3:Callback) : void
        {
            var tmpFiles:Array;
            var tmpFolder:File;
            var frameDelays:Array;
            var frameCount:int;
            var i:int;
            var gf:GIFFrame;
            var delay:int;
            var args:Vector.<String>;
            var callback3:Callback;
            var bmd:BitmapData;
            var tmpFile:File;
            var ba:ByteArray;
            var pi:* = param1;
            var sourceFile:* = param2;
            var callback:* = param3;
            var gd:* = new GIFDecoder(UtilsFile.loadBytes(sourceFile));
            tmpFiles;
            tmpFolder = File.createTempDirectory();
            frameDelays;
            frameCount = gd.getFrameCount();
            if (gd.hasError() || frameCount == 0)
            {
                callback.addMsg("GIF format error!");
                callback.callOnFail();
                return;
            }
            i;
            while (i < frameCount)
            {
                
                gf = gd.getFrame(i);
                delay = gf.delay > 0 ? (gf.delay) : (100);
                frameDelays[i] = int(delay / 1000 * 24);
                i = (i + 1);
            }
            if (ImageTool.magickExe.exists)
            {
                args = new Vector.<String>;
                args.push("convert");
                args.push("-coalesce");
                args.push(sourceFile.nativePath);
                args.push(tmpFolder.nativePath + File.separator + "g.png");
                callback3 = new Callback();
                callback3.success = function () : void
            {
                if (frameCount == 1)
                {
                    tmpFile = new File(tmpFolder.nativePath + File.separator + "g.png");
                    if (tmpFile.exists)
                    {
                        tmpFiles.push(tmpFile);
                    }
                }
                else
                {
                    i = 0;
                    while (i < frameCount)
                    {
                        
                        tmpFile = new File(tmpFolder.nativePath + File.separator + "g-" + i + ".png");
                        if (tmpFile.exists)
                        {
                            tmpFiles.push(tmpFile);
                        }
                        var _loc_2:* = i + 1;
                        i = _loc_2;
                    }
                }
                if (tmpFiles.length == 0)
                {
                    callback.addMsg("GIF format error!");
                    callback.callOnFail();
                }
                else
                {
                    importGif2(pi, sourceFile, tmpFiles, frameDelays, callback);
                }
                return;
            }// end function
            ;
                callback3.failed = function () : void
            {
                callback.addMsg("GIF decode failed!\n" + callback3.msgs.join("\n"));
                callback.callOnFail();
                return;
            }// end function
            ;
                ImageTool.magick(args, callback3);
            }
            else
            {
                i;
                while (i < frameCount)
                {
                    
                    gf = gd.getFrame(i);
                    bmd = gf.bitmapData;
                    tmpFile = new File(tmpFolder.nativePath + File.separator + i + ".png");
                    ba = bmd.encode(bmd.rect, new PNGEncoderOptions());
                    UtilsFile.saveBytes(tmpFile, ba);
                    tmpFiles[i] = tmpFile;
                    i = (i + 1);
                }
                this.importGif2(pi, sourceFile, tmpFiles, frameDelays, callback);
            }
            return;
        }// end function

        private function importGif2(param1:FPackageItem, param2:File, param3:Array, param4:Array, param5:Callback) : void
        {
            var callback2:Callback;
            var item:* = param1;
            var sourceFile:* = param2;
            var framesFiles:* = param3;
            var frameDelays:* = param4;
            var callback:* = param5;
            callback2 = new Callback();
            callback2.success = function () : void
            {
                var ani:* = AniDef(callback2.result);
                var fcnt:* = ani.frameCount;
                var i:int;
                while (i < fcnt)
                {
                    
                    ani.frameList[i].delay = int(frameDelays[i]);
                    i = (i + 1);
                }
                UtilsFile.saveBytes(item.file, ani.save());
                if (UtilsStr.startsWith(sourceFile.parent.nativePath, _basePath))
                {
                    UtilsFile.deleteFile(sourceFile);
                }
                try
                {
                    framesFiles[0].parent.deleteDirectory(true);
                }
                catch (err:Error)
                {
                }
                callback.callOnSuccessImmediately();
                return;
            }// end function
            ;
            callback2.failed = function () : void
            {
                try
                {
                    framesFiles[0].parent.deleteDirectory(true);
                }
                catch (err:Error)
                {
                }
                callback.addMsgs(callback2.msgs);
                callback.callOnFailImmediately();
                return;
            }// end function
            ;
            AniImporter.importImages(framesFiles, !item.owner.project.supportAtlas, callback2);
            return;
        }// end function

        private static function importMovieClip(param1:FPackageItem, param2:File, param3:Callback) : void
        {
            var callback2:Callback;
            var pi:* = param1;
            var sourceFile:* = param2;
            var callback:* = param3;
            callback2 = new Callback();
            callback2.success = function () : void
            {
                var _loc_1:* = AniDef(callback2.result);
                UtilsFile.saveBytes(pi.file, _loc_1.save());
                callback.callOnSuccessImmediately();
                return;
            }// end function
            ;
            callback2.failed = function () : void
            {
                callback.addMsgs(callback2.msgs);
                callback.callOnFailImmediately();
                return;
            }// end function
            ;
            AniImporter.importSpriteSheet(sourceFile, !pi.owner.project.supportAtlas, callback2);
            return;
        }// end function

    }
}
