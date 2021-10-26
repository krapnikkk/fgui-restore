package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import com.adobe.crypto.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.settings.*;
    import fairygui.editor.worker.*;
    import fairygui.utils.*;
    import flash.filesystem.*;
    import flash.media.*;
    import flash.system.*;

    public class FProject extends Object implements IUIProject
    {
        public var _comExtensions:Object;
        public var _globalFontVersion:uint;
        private var _id:String;
        private var _name:String;
        private var _basePath:String;
        private var _assetsPath:String;
        private var _objsPath:String;
        private var _settingsPath:String;
        private var _packages:Vector.<IUIPackage>;
        private var _packageInsts:Object;
        private var _type:String;
        private var _opened:Boolean;
        private var _allSettings:Object;
        private var _vars:Object;
        private var _branches:Vector.<String>;
        private var _activeBranch:String;
        private var _editor:IEditor;
        private var _versionCode:int;
        private var _serialNumberSeed:String;
        private var _lastChanged:int;
        var _listDirty:Boolean;
        public static const FILE_EXT:String = "fairy";
        public static const ASSETS_PATH:String = "assets";
        public static const SETTINGS_PATH:String = "settings";
        public static const OBJS_PATH:String = ".objs";

        public function FProject(param1:IEditor)
        {
            this._editor = param1;
            this._vars = {};
            this._packages = new Vector.<IUIPackage>;
            this._packageInsts = {};
            this._branches = new Vector.<String>;
            this._activeBranch = "";
            this._serialNumberSeed = Utils.genDevCode();
            this._lastChanged = 0;
            this._allSettings = {};
            this._allSettings["common"] = new CommonSettings(this);
            this._allSettings["publish"] = new GlobalPublishSettings(this);
            this._allSettings["customProps"] = new CustomProps(this);
            this._allSettings["adaptation"] = new AdaptationSettings(this);
            this._allSettings["packageGroups"] = new PackageGroupSettings(this);
            this._allSettings["i18n"] = new I18nSettings(this);
            this._comExtensions = {};
            return;
        }// end function

        public function get editor() : IEditor
        {
            return this._editor;
        }// end function

        public function get versionCode() : int
        {
            return this._versionCode;
        }// end function

        public function get serialNumberSeed() : String
        {
            return this._serialNumberSeed;
        }// end function

        public function get lastChanged() : int
        {
            return this._lastChanged;
        }// end function

        public function setChanged() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this._lastChanged + 1;
            _loc_1._lastChanged = _loc_2;
            return;
        }// end function

        public function get opened() : Boolean
        {
            return this._opened;
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function get type() : String
        {
            return this._type;
        }// end function

        public function set type(param1:String) : void
        {
            if (this._type != param1)
            {
                this._type = param1;
                var _loc_2:* = this;
                var _loc_3:* = this._lastChanged + 1;
                _loc_2._lastChanged = _loc_3;
                this.loadAllSettings();
            }
            return;
        }// end function

        public function get supportAtlas() : Boolean
        {
            return this._type != ProjectType.FLASH && this._type != ProjectType.HAXE;
        }// end function

        public function get isH5() : Boolean
        {
            return this._type == ProjectType.EGRET || this._type == ProjectType.LAYABOX || this._type == ProjectType.PIXI || this._type == ProjectType.COCOSCREATOR;
        }// end function

        public function get supportExtractAlpha() : Boolean
        {
            return this._type == ProjectType.UNITY || this._type == ProjectType.COCOS2DX;
        }// end function

        public function get supportAlphaMask() : Boolean
        {
            return this.supportAtlas && this._type != ProjectType.EGRET && this._type != ProjectType.STARLING;
        }// end function

        public function get zipFormatOption() : Boolean
        {
            return this._type == ProjectType.FLASH || this._type == ProjectType.STARLING || this._type == ProjectType.HAXE;
        }// end function

        public function get binaryFormatOption() : Boolean
        {
            return this._type == ProjectType.UNITY || this._type == ProjectType.COCOS2DX || this._type == ProjectType.EGRET || this._type == ProjectType.LAYABOX || this._type == ProjectType.PIXI;
        }// end function

        public function get supportCustomFileExtension() : Boolean
        {
            return this.isH5 || this.zipFormatOption;
        }// end function

        public function get supportCodeType() : Boolean
        {
            return this._type == ProjectType.LAYABOX;
        }// end function

        public function get basePath() : String
        {
            return this._basePath;
        }// end function

        public function get assetsPath() : String
        {
            return this._assetsPath;
        }// end function

        public function get objsPath() : String
        {
            return this._objsPath;
        }// end function

        public function get settingsPath() : String
        {
            return this._settingsPath;
        }// end function

        public function get activeBranch() : String
        {
            return this._activeBranch;
        }// end function

        public function set activeBranch(param1:String) : void
        {
            if (this._activeBranch != param1)
            {
                this._activeBranch = param1;
                var _loc_2:* = this;
                var _loc_3:* = this._lastChanged + 1;
                _loc_2._lastChanged = _loc_3;
            }
            return;
        }// end function

        public function open(param1:File) : void
        {
            var xml:XData;
            var arr:Array;
            var projectDescFile:* = param1;
            this._opened = true;
            var projectFolder:* = projectDescFile.parent;
            projectFolder.canonicalize();
            this._basePath = projectFolder.nativePath;
            try
            {
                xml = UtilsFile.loadXData(projectDescFile);
            }
            catch (err:Error)
            {
                throw new Error(projectDescFile.name + " is corrupted, please check!");
            }
            this._id = xml.getAttribute("id");
            this._type = xml.getAttribute("type");
            if (!this._type)
            {
                this._type = ProjectType.UNITY;
            }
            this._name = UtilsStr.getFileName(projectDescFile.name);
            var str:* = xml.getAttribute("version");
            if (str)
            {
                arr = str.split(",");
                if (arr.length == 1)
                {
                    this._versionCode = parseInt(arr[0]) * 100;
                }
                else
                {
                    this._versionCode = parseInt(arr[0]) * 100 + parseInt(arr[1]);
                }
            }
            else
            {
                this._versionCode = 200;
            }
            var assetsFolder:* = projectFolder.resolvePath(ASSETS_PATH);
            if (!assetsFolder.exists)
            {
                assetsFolder.createDirectory();
            }
            this._assetsPath = assetsFolder.nativePath;
            this._objsPath = projectFolder.resolvePath(OBJS_PATH).nativePath;
            this._settingsPath = projectFolder.resolvePath(SETTINGS_PATH).nativePath;
            this.listAllPackages(assetsFolder);
            this.loadAllSettings();
            this.scanBranches();
            return;
        }// end function

        public function scanBranches() : Boolean
        {
            var _loc_1:* = false;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_2:* = this._branches.length;
            var _loc_3:* = 0;
            var _loc_4:* = [];
            while (_loc_3 < _loc_2)
            {
                
                if (!new File(this._basePath + "/assets_" + this._branches[_loc_3]).exists)
                {
                    this._branches.splice(_loc_3, 1);
                    _loc_2 = _loc_2 - 1;
                    _loc_1 = true;
                    continue;
                }
                _loc_4.push(this._branches[_loc_3]);
                _loc_3++;
            }
            var _loc_5:* = new File(this._basePath);
            var _loc_6:* = _loc_5.getDirectoryListing();
            for each (_loc_7 in _loc_6)
            {
                
                if (_loc_7.isDirectory && UtilsStr.startsWith(_loc_7.name, "assets_"))
                {
                    _loc_8 = _loc_7.name.substring(7);
                    if (_loc_4.indexOf(_loc_8) == -1)
                    {
                        this._branches.push(_loc_8);
                        _loc_1 = true;
                    }
                }
            }
            this._branches.sort(0);
            if (_loc_1)
            {
                var _loc_9:* = this;
                var _loc_10:* = this._lastChanged + 1;
                _loc_9._lastChanged = _loc_10;
            }
            return _loc_1;
        }// end function

        private function listAllPackages(param1:File) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_2:* = param1.getDirectoryListing();
            var _loc_3:* = _loc_2.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = _loc_2[_loc_4];
                if (!_loc_5.isDirectory)
                {
                }
                else
                {
                    _loc_6 = new File(_loc_5.nativePath + File.separator + "package.xml");
                    if (_loc_6.exists)
                    {
                        this.addPackage(_loc_5);
                    }
                }
                _loc_4++;
            }
            return;
        }// end function

        public function close() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this._packageInsts)
            {
                
                _loc_1.dispose();
            }
            this._opened = false;
            this._editor = null;
            WorkerClient.inst.removeRequests(this);
            return;
        }// end function

        public function getSettings(param1:String) : Object
        {
            var _loc_2:* = this._allSettings[param1];
            _loc_2.touch();
            return _loc_2;
        }// end function

        public function saveSettings(param1:String) : void
        {
            var _loc_2:* = SettingsBase(this._allSettings[param1]);
            _loc_2.save();
            return;
        }// end function

        public function getSetting(param1:String, param2:String)
        {
            return this._allSettings[param1][param2];
        }// end function

        public function setSetting(param1:String, param2:String, param3) : void
        {
            this._allSettings[param1][param2] = param3;
            return;
        }// end function

        public function loadAllSettings() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this._allSettings)
            {
                
                _loc_1.touch(true);
            }
            return;
        }// end function

        public function rename(param1:String) : void
        {
            var _loc_2:* = new File(this._basePath + File.separator + this._name + ".fairy");
            this._name = param1;
            _loc_2.moveTo(new File(this._basePath + File.separator + this._name + ".fairy"));
            return;
        }// end function

        public function getPackage(param1:String) : IUIPackage
        {
            return this._packageInsts[param1];
        }// end function

        public function getPackageByName(param1:String) : IUIPackage
        {
            var _loc_2:* = null;
            for each (_loc_2 in this._packageInsts)
            {
                
                if (Consts.isMacOS && _loc_2.name == param1 || !Consts.isMacOS && _loc_2.name.toLowerCase() == param1.toLowerCase())
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function createPackage(param1:String) : IUIPackage
        {
            var _loc_3:* = null;
            param1 = validateName(param1);
            if (this.getPackageByName(param1) != null)
            {
                throw new Error("Package already exists!");
            }
            var _loc_2:* = UtilsStr.generateUID();
            if (this._activeBranch.length == 0)
            {
                _loc_3 = new File(this.assetsPath + File.separator + param1);
            }
            else
            {
                _loc_3 = new File(this.assetsPath + "_" + this._activeBranch + File.separator + param1);
            }
            _loc_3.createDirectory();
            var _loc_4:* = XData.parse("<packageDescription><resources/></packageDescription>");
            _loc_4.setAttribute("id", _loc_2);
            UtilsFile.saveXData(new File(_loc_3.nativePath + File.separator + "package.xml"), _loc_4);
            var _loc_5:* = new FPackage(this, _loc_3);
            this._packageInsts[_loc_2] = _loc_5;
            this._packages.push(_loc_5);
            this._listDirty = true;
            _loc_5.open();
            if (this._editor)
            {
                this._editor.emit(EditorEvent.PackageListChanged);
            }
            return _loc_5;
        }// end function

        public function addPackage(param1:File) : IUIPackage
        {
            var _loc_2:* = new FPackage(this, param1);
            var _loc_3:* = this._packageInsts[_loc_2.id];
            if (_loc_3 != null)
            {
                return _loc_3;
            }
            this._packageInsts[_loc_2.id] = _loc_2;
            this._packages.push(_loc_2);
            this._listDirty = true;
            var _loc_4:* = this;
            var _loc_5:* = this._lastChanged + 1;
            _loc_4._lastChanged = _loc_5;
            return _loc_2;
        }// end function

        public function deletePackage(param1:String) : void
        {
            var _loc_2:* = this._packageInsts[param1];
            if (!_loc_2)
            {
                return;
            }
            if (this._editor)
            {
                this._editor.docView.closeDocuments(_loc_2);
            }
            _loc_2.dispose();
            var _loc_3:* = new File(this.assetsPath + File.separator + _loc_2.name);
            if (_loc_3.exists)
            {
                _loc_3.moveToTrash();
            }
            _loc_3 = new File(this.objsPath + File.separator + "cache" + File.separator + _loc_2.id);
            if (_loc_3.exists)
            {
                try
                {
                    _loc_3.deleteDirectory(true);
                }
                catch (err:Error)
                {
                }
            }
            delete this._packageInsts[param1];
            var _loc_4:* = this._packages.indexOf(_loc_2);
            this._packages.removeAt(_loc_4);
            this._listDirty = true;
            var _loc_5:* = this;
            var _loc_6:* = this._lastChanged + 1;
            _loc_5._lastChanged = _loc_6;
            if (this._editor)
            {
                this._editor.emit(EditorEvent.PackageListChanged);
            }
            return;
        }// end function

        public function get allPackages() : Vector.<IUIPackage>
        {
            if (this._listDirty)
            {
                this._packages.sort(comparePackage);
                this._listDirty = false;
            }
            return this._packages;
        }// end function

        public function get allBranches() : Vector.<String>
        {
            return this._branches;
        }// end function

        public function save() : void
        {
            var _loc_1:* = XData.create("projectDescription");
            _loc_1.setAttribute("id", this._id);
            _loc_1.setAttribute("type", this._type);
            _loc_1.setAttribute("version", int(this._versionCode / 100) + "." + int(this._versionCode % 100));
            UtilsFile.saveXData(new File(this._basePath + File.separator + this._name + ".fairy"), _loc_1);
            return;
        }// end function

        public function getItemByURL(param1:String) : FPackageItem
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = param1.indexOf("//");
            if (_loc_2 == -1)
            {
                return null;
            }
            var _loc_3:* = param1.indexOf("/", _loc_2 + 2);
            if (_loc_3 == -1)
            {
                if (param1.length > 13)
                {
                    _loc_4 = param1.substr(5, 8);
                    _loc_5 = this.getPackage(_loc_4);
                    if (_loc_5 != null)
                    {
                        _loc_6 = param1.substr(13);
                        return _loc_5.getItem(_loc_6);
                    }
                }
            }
            else
            {
                _loc_7 = param1.substr(_loc_2 + 2, _loc_3 - _loc_2 - 2);
                _loc_5 = this.getPackageByName(_loc_7);
                if (_loc_5 != null)
                {
                    _loc_8 = param1.substr((_loc_3 + 1));
                    return _loc_5.findItemByName(_loc_8);
                }
            }
            return null;
        }// end function

        public function getItem(param1:String, param2:String) : FPackageItem
        {
            var _loc_3:* = this.getPackage(param1);
            if (_loc_3)
            {
                return _loc_3.getItem(param2);
            }
            return null;
        }// end function

        public function findItemByFile(param1:File) : FPackageItem
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            param1.canonicalize();
            if (!UtilsStr.startsWith(param1.nativePath, this._assetsPath, true))
            {
                return null;
            }
            var _loc_2:* = param1.nativePath.substr(this._assetsPath.length);
            var _loc_3:* = UtilsStr.getFileFullName(_loc_2);
            _loc_2 = UtilsStr.getFilePath(_loc_2).replace(/\\/g, "/") + "/";
            var _loc_4:* = _loc_2.indexOf("/", 1);
            if (_loc_2.indexOf("/", 1) != -1)
            {
                _loc_5 = _loc_2.substring(1, _loc_4);
                _loc_6 = this.getPackageByName(_loc_5);
                if (_loc_6)
                {
                    _loc_7 = _loc_6.getItem(_loc_2.substring(_loc_4));
                    if (_loc_7)
                    {
                        return _loc_6.getItemByFileName(_loc_7, _loc_3);
                    }
                }
            }
            return null;
        }// end function

        public function getItemNameByURL(param1:String) : String
        {
            var _loc_2:* = this.getItemByURL(param1);
            if (_loc_2)
            {
                return _loc_2.name;
            }
            return "";
        }// end function

        public function createBranch(param1:String) : void
        {
            var _loc_2:* = new File(this._basePath + "/assets_" + param1);
            if (_loc_2.exists)
            {
                throw new Error(Consts.strings.text447);
            }
            _loc_2.createDirectory();
            this.scanBranches();
            if (this._editor)
            {
                this._editor.emit(EditorEvent.PackageListChanged);
            }
            return;
        }// end function

        public function renameBranch(param1:String, param2:String) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            param2 = validateName(param2);
            if (param2 == param1)
            {
                return;
            }
            var _loc_3:* = new File(this._basePath + "/assets_" + param1);
            var _loc_4:* = new File(this._basePath + "/assets_" + param2);
            UtilsFile.renameFile(_loc_3, _loc_4);
            this.scanBranches();
            param2 = ":" + param2;
            for each (_loc_5 in this._packageInsts)
            {
                
                if (_loc_5.opened)
                {
                    _loc_6 = _loc_5.getItem("/:" + param1 + "/");
                    if (_loc_6)
                    {
                        _loc_5.renameBranchRoot(_loc_6, param2);
                    }
                }
            }
            if (this._editor)
            {
                this._editor.emit(EditorEvent.PackageListChanged);
            }
            return;
        }// end function

        public function removeBranch(param1:String) : void
        {
            var _loc_2:* = new File(this._basePath + "/assets_" + param1);
            UtilsFile.deleteFile(_loc_2, true);
            this._editor.refreshProject();
            return;
        }// end function

        function getBranch(param1:FPackageItem) : FPackageItem
        {
            if (this._activeBranch.length == 0)
            {
                return param1;
            }
            var _loc_2:* = "/:" + this._activeBranch + param1.path + param1.name;
            var _loc_3:* = param1.owner.getItemByPath(_loc_2);
            if (_loc_3 && _loc_3.type == param1.type)
            {
                return _loc_3;
            }
            return param1;
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

        public function registerCustomExtension(param1:String, param2:String, param3:String) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (this._comExtensions[param2])
            {
                throw new Error("Component extension \'" + param2 + "\' already exists!");
            }
            if (param3 != null)
            {
                _loc_4 = param3.substr(1);
            }
            else
            {
                _loc_4 = null;
            }
            if (_loc_4 != null && FObjectType.NAME_PREFIX[_loc_4] == undefined)
            {
                throw new Error("Component extension \'" + param3 + "\' does not exist!");
            }
            this._comExtensions[param2] = {name:param1, className:param2, superClassName:_loc_4};
            if (this._editor)
            {
                _loc_5 = this.getVar("CustomExtensionIDs") as Array;
                if (!_loc_5)
                {
                    _loc_5 = [];
                }
                _loc_5.push(param2);
                this.setVar("CustomExtensionIDs", _loc_5);
                this.setVar("CustomExtensionChanged", true);
            }
            return;
        }// end function

        public function getCustomExtension(param1:String) : Object
        {
            return this._comExtensions[param1];
        }// end function

        public function clearCustomExtensions() : void
        {
            this._comExtensions = {};
            if (this._editor)
            {
                this.setVar("CustomExtensionIDs", undefined);
                this.setVar("CustomExtensionChanged", true);
            }
            return;
        }// end function

        public function alert(param1:String, param2:Error = null) : void
        {
            if (this._editor)
            {
                this._editor.alert(null, param2);
            }
            else if (param2)
            {
                ;
            }
            return;
        }// end function

        public function logError(param1:String, param2:Error = null) : void
        {
            if (this._editor)
            {
                this._editor.consoleView.logError(param1, param2);
            }
            else if (param2)
            {
                ;
            }
            return;
        }// end function

        public function playSound(param1:String, param2:Number) : void
        {
            var _loc_3:* = this.getItemByURL(param1);
            if (_loc_3)
            {
                _loc_3.setVar("volume", param2);
                _loc_3.getSound(this.playSound2);
            }
            return;
        }// end function

        private function playSound2(param1:FPackageItem) : void
        {
            var _loc_3:* = NaN;
            var _loc_2:* = param1.sound;
            if (_loc_2)
            {
                _loc_3 = Number(param1.getVar("volume"));
                if (_loc_3 == 0 || isNaN(_loc_3))
                {
                    _loc_2.play();
                }
                else
                {
                    _loc_2.play(0, 0, new SoundTransform(_loc_3));
                }
            }
            return;
        }// end function

        public function asyncRequest(param1:String, param2 = undefined, param3:Function = null, param4:Function = null) : void
        {
            WorkerClient.inst.send(this, param1, param2, param3, param4);
            return;
        }// end function

        public static function createNew(param1:String, param2:String, param3:String, param4:String = null) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            param2 = validateName(param2);
            _loc_5 = XData.create("projectDescription");
            _loc_5.setAttribute("id", MD5.hash(param1 + new Date().time + Math.random() * 10000 + param2 + Capabilities.serverString));
            _loc_5.setAttribute("type", param3);
            _loc_5.setAttribute("version", "5.0");
            UtilsFile.saveXData(new File(param1 + File.separator + param2 + "." + FILE_EXT), _loc_5);
            _loc_6 = new File(param1 + File.separator + ASSETS_PATH);
            _loc_6.createDirectory();
            _loc_6 = new File(param1 + File.separator + OBJS_PATH);
            _loc_6.createDirectory();
            _loc_6 = new File(param1 + File.separator + SETTINGS_PATH);
            _loc_6.createDirectory();
            if (param4)
            {
                _loc_7 = UtilsStr.generateUID();
                _loc_6 = new File(param1 + File.separator + ASSETS_PATH + File.separator + param4);
                _loc_6.createDirectory();
                _loc_8 = Utils.genDevCode() + "0";
                _loc_5 = XData.parse("<packageDescription>" + "\t<resources>" + "\t\t<component id=\"" + _loc_8 + "\" name=\"Component1.xml\" path=\"/\" exported=\"true\"/>" + "\t</resources>" + "</packageDescription>");
                _loc_5.setAttribute("id", _loc_7);
                UtilsFile.saveXData(new File(_loc_6.nativePath + File.separator + "package.xml"), _loc_5);
                _loc_5 = XData.create("component");
                _loc_5.setAttribute("size", "800,600");
                UtilsFile.saveXData(_loc_6.resolvePath("Component1.xml"), _loc_5);
            }
            return;
        }// end function

        private static function comparePackage(param1:FPackage, param2:FPackage) : int
        {
            return param1.rootItem.sortKey.localeCompare(param2.rootItem.sortKey);
        }// end function

        private static function compareItem(param1:FPackageItem, param2:FPackageItem) : int
        {
            return param1.sortKey.localeCompare(param2.sortKey);
        }// end function

        public static function validateName(param1:String) : String
        {
            param1 = UtilsStr.trim(param1);
            if (param1.length == 0)
            {
                throw new Error(Consts.strings.text197);
            }
            if (param1.search(/[\:\/\\\*\?<>\|]/) != -1)
            {
                throw new Error(Consts.strings.text196);
            }
            return param1;
        }// end function

    }
}
