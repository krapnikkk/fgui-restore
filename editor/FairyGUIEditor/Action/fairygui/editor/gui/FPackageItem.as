package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import com.adobe.crypto.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.animation.*;
    import fairygui.editor.gui.text.*;
    import fairygui.editor.settings.*;
    import fairygui.editor.worker.*;
    import fairygui.utils.*;
    import fairygui.utils.loader.*;
    import flash.display.*;
    import flash.filesystem.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class FPackageItem extends Object
    {
        public var exported:Boolean;
        public var favorite:Boolean;
        public var reviewed:String;
        public var _-e:String;
        public var _errorStatus:Boolean;
        private var _id:String;
        private var _type:String;
        private var _owner:FPackage;
        private var _name:String;
        private var _path:String;
        private var _fileName:String;
        private var _branch:String;
        private var _file:File;
        private var _width:int;
        private var _height:int;
        private var _sortKey:String;
        private var _quickKey:String;
        private var _version:int;
        private var _lastTouch:int;
        private var _modificationTime:Number;
        private var _fileSize:Number;
        private var _needReload:Boolean;
        private var _hash:String;
        private var _vars:Object;
        private var _loadQueue:Array;
        private var _data:Object;
        private var _releasedTime:int;
        private var _ref:int;
        private var _dataVersion:int;
        private var _disposed:Boolean;
        private var _loading:Boolean;
        private var _imageSettings:ImageSettings;
        private var _folderSettings:FolderSettings;
        private var _fontSettings:FontSettings;
        private var _imageInfo:ImageInfo;
        private var _children:Vector.<FPackageItem>;
        private var _componentExtension:String;

        public function FPackageItem(param1:IUIPackage, param2:String, param3:String)
        {
            this._owner = param1 as FPackage;
            this._type = param2;
            this._id = param3;
            this._vars = {};
            this._needReload = true;
            this._quickKey = null;
            if (param2 == FPackageItemType.IMAGE || param2 == FPackageItemType.MOVIECLIP)
            {
                this._imageSettings = new ImageSettings();
                this._imageInfo = new ImageInfo();
            }
            else if (param2 == FPackageItemType.FOLDER)
            {
                this._folderSettings = new FolderSettings();
                this._children = new Vector.<FPackageItem>;
            }
            else if (param2 == FPackageItemType.FONT)
            {
                this._fontSettings = new FontSettings();
            }
            return;
        }// end function

        public function get owner() : FPackage
        {
            return this._owner;
        }// end function

        public function get pkg() : IUIPackage
        {
            return this._owner;
        }// end function

        public function get parent() : FPackageItem
        {
            if (this._owner.rootItem == this)
            {
                return null;
            }
            return this._owner.getItem(this._path);
        }// end function

        public function get type() : String
        {
            return this._type;
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

        public function set id(param1:String) : void
        {
            this._id = param1;
            return;
        }// end function

        public function get path() : String
        {
            return this._path;
        }// end function

        public function get branch() : String
        {
            return this._branch;
        }// end function

        public function get isRoot() : Boolean
        {
            return this._id == "/";
        }// end function

        public function get isBranchRoot() : Boolean
        {
            return this._path == "/" && this._branch.length > 0;
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function get file() : File
        {
            return this._file;
        }// end function

        public function get fileName() : String
        {
            return this._fileName;
        }// end function

        public function get modificationTime() : Number
        {
            return this._modificationTime;
        }// end function

        public function get isError() : Boolean
        {
            return this._errorStatus;
        }// end function

        public function matchName(param1:String) : Boolean
        {
            if (this._quickKey == null)
            {
                this._quickKey = PinYinUtil.toPinyin(this._name.substr(0, 5), true, false, false).toLowerCase();
            }
            var _loc_2:* = param1.length;
            if (this._quickKey.length < _loc_2)
            {
                return false;
            }
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (param1.charCodeAt(_loc_3) != this._quickKey.charCodeAt(_loc_3))
                {
                    return false;
                }
                _loc_3++;
            }
            return true;
        }// end function

        public function get sortKey() : String
        {
            if (this._sortKey == null)
            {
                this._sortKey = (this._branch.length > 0 ? ("A") : ("B")) + Utils.getStringSortKey(this._name);
            }
            return this._sortKey;
        }// end function

        public function getURL() : String
        {
            return "ui://" + this._owner.id + this._id;
        }// end function

        public function get version() : int
        {
            return this._version;
        }// end function

        public function get width() : Number
        {
            if (this._needReload)
            {
                this.loadInfo();
            }
            return this._width;
        }// end function

        public function get height() : Number
        {
            if (this._needReload)
            {
                this.loadInfo();
            }
            return this._height;
        }// end function

        public function get children() : Vector.<FPackageItem>
        {
            return this._children;
        }// end function

        public function get imageInfo() : ImageInfo
        {
            if (this._needReload)
            {
                this.loadInfo();
            }
            return this._imageInfo;
        }// end function

        public function get componentExtension() : String
        {
            if (this._needReload)
            {
                this.loadInfo();
            }
            return this._componentExtension;
        }// end function

        public function get imageSettings() : ImageSettings
        {
            return this._imageSettings;
        }// end function

        public function get folderSettings() : FolderSettings
        {
            return this._folderSettings;
        }// end function

        public function get fontSettings() : FontSettings
        {
            return this._fontSettings;
        }// end function

        public function copySettings(param1:FPackageItem) : void
        {
            if (this._type == FPackageItemType.IMAGE || this._type == FPackageItemType.MOVIECLIP)
            {
                this._imageSettings.copyFrom(param1.imageSettings);
            }
            else if (this._type == FPackageItemType.FONT)
            {
                this._fontSettings.copyFrom(param1.fontSettings);
            }
            return;
        }// end function

        public function setFile(param1:String, param2:String) : void
        {
            var _loc_4:* = 0;
            this._path = param1;
            if (this._path.length > 2 && this._path.charCodeAt(1) == 58)
            {
                _loc_4 = this._path.indexOf("/", 2);
                this._branch = this._path.substring(2, _loc_4);
            }
            else if (this._path.length == 1 && param2.charCodeAt(0) == 58)
            {
                this._branch = param2.substring(1);
            }
            else
            {
                this._branch = "";
            }
            this._fileName = param2;
            if (this.type == FPackageItemType.FOLDER)
            {
                this._name = this._fileName;
            }
            else
            {
                this._name = UtilsStr.getFileName(this._fileName);
            }
            this._sortKey = null;
            this._quickKey = null;
            var _loc_3:* = this._file;
            if (this._branch.length > 0)
            {
                if (this._path.length == 1)
                {
                    this._file = new File(this._owner.project.basePath + "/assets_" + this._branch + "/" + this._owner.name);
                }
                else
                {
                    this._file = new File(this._owner.project.basePath + "/assets_" + this._branch + "/" + this._owner.name + "/" + this._path.substr(this._branch.length + 3) + this._fileName);
                }
            }
            else if (this._path.length == 0)
            {
                this._file = new File(this._owner.basePath);
            }
            else
            {
                this._file = new File(this._owner.basePath + this._path + this._fileName);
            }
            if (_loc_3)
            {
                if (this._imageInfo && this._imageInfo.file == _loc_3)
                {
                    this._imageInfo.file = this._file;
                }
            }
            if (_loc_3.exists)
            {
                this._modificationTime = _loc_3.modificationDate.time;
                this._fileSize = _loc_3.size;
                if (this._errorStatus)
                {
                    this._errorStatus = false;
                    this.setChanged();
                }
            }
            else
            {
                if (!this._errorStatus)
                {
                    this._errorStatus = true;
                    this.setChanged();
                }
                this._hash = null;
            }
            return;
        }// end function

        public function setChanged() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this._version + 1;
            _loc_1._version = _loc_2;
            this._needReload = true;
            return;
        }// end function

        public function touch() : void
        {
            if (this._lastTouch == GTimers.workCount)
            {
                return;
            }
            this._lastTouch = GTimers.workCount;
            if (this._file.exists)
            {
                if (this._modificationTime != this._file.modificationDate.time || this._fileSize != this._file.size)
                {
                    var _loc_1:* = this;
                    var _loc_2:* = this._version + 1;
                    _loc_1._version = _loc_2;
                    this._modificationTime = this._file.modificationDate.time;
                    this._fileSize = this._file.size;
                    this._hash = null;
                    this._needReload = true;
                }
                if (this._errorStatus)
                {
                    var _loc_1:* = this;
                    var _loc_2:* = this._version + 1;
                    _loc_1._version = _loc_2;
                    this._errorStatus = false;
                }
            }
            else if (!this._errorStatus)
            {
                var _loc_1:* = this;
                var _loc_2:* = this._version + 1;
                _loc_1._version = _loc_2;
                this._errorStatus = true;
            }
            return;
        }// end function

        public function setUptoDate() : void
        {
            if (this._file.exists)
            {
                this._modificationTime = this._file.modificationDate.time;
                this._fileSize = this._file.size;
            }
            return;
        }// end function

        public function getComponentData() : ComponentData
        {
            if (this._type != FPackageItemType.COMPONENT)
            {
                throw new Error("invalid call to get componentData");
            }
            if (this._disposed)
            {
                return null;
            }
            if (this._needReload)
            {
                this.loadInfo();
            }
            if (!this._data || this._dataVersion != this._version)
            {
                this.updateData(new ComponentData(this), this._version);
            }
            return ComponentData(this._data);
        }// end function

        public function get image() : BitmapData
        {
            return BitmapData(this._data);
        }// end function

        public function getImage(param1:Function = null) : BitmapData
        {
            if (this._type != FPackageItemType.IMAGE)
            {
                throw new Error("invalid item status");
            }
            if (this._disposed)
            {
                return null;
            }
            if (this._needReload)
            {
                this.loadInfo();
            }
            if (param1 != null)
            {
                this.addLoadedCallback(param1);
            }
            if (this._data && this._dataVersion == this._version)
            {
                if (param1 != null)
                {
                    GTimers.inst.callLater(this.invokeLoadedCallbacks);
                }
                return BitmapData(this._data);
            }
            if (!this._file.exists)
            {
                this.disposeData();
                if (param1 != null)
                {
                    GTimers.inst.callLater(this.invokeLoadedCallbacks);
                }
                return null;
            }
            if (!this._loading)
            {
                this._loading = true;
                if (this._imageInfo.needConversion)
                {
                    this.convertImage();
                }
                else
                {
                    this._imageInfo.file = this._file;
                    EasyLoader.load(this._file.url, {type:"image", pi:this, ver:this._version}, __imageLoaded);
                }
            }
            return null;
        }// end function

        public function getAnimation() : AniDef
        {
            var ani:AniDef;
            var ba:ByteArray;
            if (this._type != FPackageItemType.MOVIECLIP)
            {
                throw new Error("invalid item status");
            }
            if (this._disposed)
            {
                return null;
            }
            if (this._needReload)
            {
                this.loadInfo();
            }
            if (!this._data || this._dataVersion != this._version)
            {
                ba = UtilsFile.loadBytes(this._file);
                if (ba != null)
                {
                    try
                    {
                        ani = new AniDef();
                        ani.load(ba);
                    }
                    catch (err:Error)
                    {
                        owner.project.logError("load movieclip", err);
                    }
                }
                this.updateData(ani, this._version);
            }
            return AniDef(this._data);
        }// end function

        public function getBitmapFont() : FBitmapFont
        {
            var _loc_1:* = null;
            if (this._type != FPackageItemType.FONT)
            {
                throw new Error("invalid item status");
            }
            if (this._disposed)
            {
                return null;
            }
            if (this._needReload)
            {
                this.loadInfo();
            }
            if (!this._data || this._dataVersion != this._version)
            {
                _loc_1 = new FBitmapFont(this);
                this.updateData(_loc_1, this._version);
                _loc_1.load();
            }
            return FBitmapFont(this._data);
        }// end function

        public function get sound() : Sound
        {
            return Sound(this._data);
        }// end function

        public function getSound(param1:Function = null) : Sound
        {
            if (this._type != FPackageItemType.SOUND)
            {
                throw new Error("invalid item status");
            }
            if (this._disposed)
            {
                return null;
            }
            if (this._needReload)
            {
                this.loadInfo();
            }
            if (param1 != null)
            {
                this.addLoadedCallback(param1);
            }
            if (this._data && this._dataVersion == this._version)
            {
                if (param1 != null)
                {
                    GTimers.inst.callLater(this.invokeLoadedCallbacks);
                }
                return Sound(this._data);
            }
            if (!this._file.exists)
            {
                this.disposeData();
                if (param1 != null)
                {
                    GTimers.inst.callLater(this.invokeLoadedCallbacks);
                }
                return null;
            }
            var _loc_2:* = UtilsStr.getFileExt(this._fileName);
            if (_loc_2 == "mp3")
            {
                this.updateData(new Sound(new URLRequest(this._file.url)), this._version);
                if (param1 != null)
                {
                    GTimers.inst.callLater(this.invokeLoadedCallbacks);
                }
                return Sound(this._data);
            }
            else
            {
                if (!this._loading)
                {
                    this._loading = true;
                    this.convertSound();
                }
            }
            return null;
        }// end function

        public function addLoadedCallback(param1:Function) : void
        {
            if (!this._loadQueue)
            {
                this._loadQueue = [];
            }
            var _loc_2:* = this._loadQueue.indexOf(param1);
            if (_loc_2 == -1)
            {
                this._loadQueue.push(param1);
            }
            return;
        }// end function

        public function removeLoadedCallback(param1:Function) : void
        {
            if (!this._loadQueue)
            {
                return;
            }
            var _loc_2:* = this._loadQueue.indexOf(param1);
            if (_loc_2 != -1)
            {
                this._loadQueue.splice(_loc_2, 1);
            }
            return;
        }// end function

        public function get loading() : Boolean
        {
            return this._loading;
        }// end function

        public function invokeLoadedCallbacks() : void
        {
            var _loc_3:* = null;
            if (!this._loadQueue || this._loadQueue.length == 0)
            {
                return;
            }
            var _loc_1:* = this._loadQueue.concat();
            this._loadQueue.length = 0;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                _loc_3 = _loc_1[_loc_2];
                this._loc_3(this);
                _loc_2++;
            }
            return;
        }// end function

        public function openWithDefaultApplication() : void
        {
            if (this.isRoot)
            {
                new File(this._owner.basePath + "/package.xml").openWithDefaultApplication();
            }
            else if (this.isBranchRoot)
            {
                new File(this._owner.getBranchPath(this._branch) + "/package_branch.xml").openWithDefaultApplication();
            }
            else
            {
                this._file.openWithDefaultApplication();
            }
            return;
        }// end function

        private function loadInfo() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            this._needReload = false;
            var _loc_8:* = 0;
            this._height = 0;
            this._width = _loc_8;
            if (this._type == FPackageItemType.COMPONENT)
            {
                _loc_1 = this._vars.doc;
                if (_loc_1 && _loc_1.content)
                {
                    this._width = _loc_1.content.width;
                    this._height = _loc_1.content.height;
                    this._componentExtension = _loc_1.content.extentionId;
                }
                else
                {
                    _loc_2 = UtilsFile.loadXMLRoot(this._file);
                    if (_loc_2)
                    {
                        _loc_3 = _loc_2.getAttribute("size");
                        if (_loc_3)
                        {
                            _loc_4 = _loc_3.split(",");
                            this._width = parseInt(_loc_4[0]);
                            this._height = parseInt(_loc_4[1]);
                        }
                        _loc_3 = _loc_2.getAttribute("extention");
                        if (_loc_3)
                        {
                            this._componentExtension = _loc_3;
                        }
                    }
                }
                if (this._componentExtension == null)
                {
                    this._componentExtension = "";
                }
            }
            else if (this._imageInfo != null)
            {
                _loc_5 = this._file.extension;
                if (_loc_5 && _loc_5.toLowerCase() == "svg")
                {
                    this._imageInfo.format = "svg";
                    this._width = this._imageSettings.width;
                    this._height = this._imageSettings.height;
                }
                else
                {
                    _loc_6 = ResourceSize.getSize(this._file);
                    if (_loc_6)
                    {
                        this._imageInfo.format = _loc_6.type;
                        this._width = _loc_6.width;
                        this._height = _loc_6.height;
                    }
                    else
                    {
                        this._imageInfo.format = "png";
                    }
                }
                switch(this._imageSettings.qualityOption)
                {
                    case ImageSettings.QUALITY_DEFAULT:
                    {
                        if (this.owner.project.supportAtlas)
                        {
                            this._imageInfo.targetQuality = 100;
                        }
                        else
                        {
                            _loc_7 = GlobalPublishSettings(this._owner.project.getSettings("publish"));
                            if (this._imageInfo.format == "jpg")
                            {
                                this._imageInfo.targetQuality = _loc_7.jpegQuality;
                            }
                            else
                            {
                                this._imageInfo.targetQuality = _loc_7.compressPNG ? (8) : (100);
                            }
                        }
                        break;
                    }
                    case ImageSettings.QUALITY_SOURCE:
                    {
                        this._imageInfo.targetQuality = 100;
                        break;
                    }
                    case ImageSettings.QUALITY_CUSTOM:
                    {
                        if (this._imageInfo.format == "jpg")
                        {
                            this._imageInfo.targetQuality = this._imageSettings.quality;
                        }
                        else
                        {
                            this._imageInfo.targetQuality = this._imageSettings.quality != 100 ? (8) : (100);
                        }
                        break;
                    }
                    default:
                    {
                        this._imageInfo.targetQuality = 100;
                        break;
                    }
                }
            }
            else
            {
                _loc_6 = ResourceSize.getSize(this._file);
                if (_loc_6)
                {
                    this._width = _loc_6.width;
                    this._height = _loc_6.height;
                }
            }
            return;
        }// end function

        private function updateHash() : void
        {
            var _loc_1:* = UtilsFile.loadBytes(this.file);
            if (_loc_1 != null)
            {
                this._hash = MD5.hashBinary(_loc_1);
                _loc_1.clear();
            }
            return;
        }// end function

        public function updateReviewStatus() : Boolean
        {
            if (this._hash == null)
            {
                this.updateHash();
            }
            if (this.reviewed != this._hash)
            {
                this.reviewed = this._hash;
                return true;
            }
            return false;
        }// end function

        public function get isReviewStatusUpdated() : Boolean
        {
            if (this._hash == null)
            {
                this.updateHash();
            }
            return this.reviewed == this._hash;
        }// end function

        public function get title() : String
        {
            if (this._branch.length > 0 && this._path.length == 1)
            {
                return this._branch;
            }
            return this._name;
        }// end function

        public function getIcon(param1:Boolean = false) : String
        {
            var _loc_2:* = null;
            if (this._type == FPackageItemType.FOLDER)
            {
                if (this._path == "/" && this._branch.length > 0)
                {
                    return Consts.icons.branch;
                }
                if (param1)
                {
                    if (this._id == "/")
                    {
                        return Consts.icons["package_open"];
                    }
                    return Consts.icons.folder_open;
                }
                else
                {
                    if (this._id == "/")
                    {
                        return Consts.icons["package"];
                    }
                    return Consts.icons.folder;
                }
            }
            else if (this._type == FPackageItemType.COMPONENT)
            {
                _loc_2 = Consts.icons[this.componentExtension];
                if (_loc_2)
                {
                    return _loc_2;
                }
                return Consts.icons.component;
            }
            else
            {
                return Consts.icons[this._type];
            }
        }// end function

        public function getBranch() : FPackageItem
        {
            return FProject(this._owner.project).getBranch(this);
        }// end function

        public function getHighResolution(param1:int) : FPackageItem
        {
            var _loc_3:* = null;
            var _loc_2:* = this._path + this._name;
            while (param1 > 0)
            {
                
                _loc_3 = this._owner.getItemByPath(_loc_2 + "@" + (param1 + 1) + "x");
                if (_loc_3 && _loc_3.type == this._type)
                {
                    return _loc_3;
                }
                param1 = param1 - 1;
            }
            return this;
        }// end function

        public function getAtlasIndex() : int
        {
            var _loc_2:* = null;
            var _loc_1:* = this._imageSettings.atlas;
            if (_loc_1 == "default")
            {
                _loc_2 = this.parent;
                while (_loc_2 != this._owner.rootItem)
                {
                    
                    if (!_loc_2.folderSettings.empty && _loc_2.folderSettings.atlas != "default")
                    {
                        _loc_1 = _loc_2.folderSettings.atlas;
                        break;
                    }
                    _loc_2 = _loc_2.parent;
                }
            }
            switch(_loc_1)
            {
                case "default":
                {
                    return 0;
                }
                case "alone":
                {
                    return -1;
                }
                case "alone_npot":
                {
                    return -2;
                }
                case "alone_mof":
                {
                    return -3;
                }
                default:
                {
                    return int(parseInt(_loc_1));
                    break;
                }
            }
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

        public function toString() : String
        {
            return this._name;
        }// end function

        public function addRef() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this._ref + 1;
            _loc_1._ref = _loc_2;
            return;
        }// end function

        public function releaseRef() : void
        {
            if (this._ref > 0)
            {
                var _loc_1:* = this;
                var _loc_2:* = this._ref - 1;
                _loc_1._ref = _loc_2;
            }
            if (this._ref == 0)
            {
                this._releasedTime = getTimer();
            }
            return;
        }// end function

        public function get isDisposed() : Boolean
        {
            return this._disposed;
        }// end function

        private function updateData(param1:Object, param2:int) : void
        {
            if (this._data && this._data != param1)
            {
                this.disposeData();
            }
            this._data = param1;
            this._dataVersion = param2;
            return;
        }// end function

        public function tryDisposeData(param1:int = 0) : Boolean
        {
            if (this._data && this._ref == 0 && (!this._loadQueue || this._loadQueue.length == 0) && (param1 == 0 || param1 - this._releasedTime > 10000))
            {
                this.disposeData();
                return true;
            }
            return false;
        }// end function

        public function disposeData() : void
        {
            if (!this._data)
            {
                return;
            }
            switch(this._type)
            {
                case FPackageItemType.MOVIECLIP:
                {
                    AniDef(this._data).reset();
                    break;
                }
                case FPackageItemType.IMAGE:
                {
                    BitmapData(this._data).dispose();
                    break;
                }
                case FPackageItemType.FONT:
                {
                    FBitmapFont(this._data).dispose();
                    break;
                }
                case FPackageItemType.COMPONENT:
                {
                    ComponentData(this._data).dispose();
                    break;
                }
                case FPackageItemType.SOUND:
                {
                    try
                    {
                        Sound(this._data).close();
                    }
                    catch (err)
                    {
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._data = null;
            return;
        }// end function

        public function dispose() : void
        {
            this.disposeData();
            var _loc_1:* = this;
            var _loc_2:* = this._version + 1;
            _loc_1._version = _loc_2;
            this._disposed = true;
            return;
        }// end function

        public function serialize(param1:Boolean = false) : XData
        {
            var _loc_2:* = XData.create(this._type);
            if (param1)
            {
                _loc_2.setAttribute("id", this._-e);
                _loc_2.setAttribute("name", this._name);
            }
            else
            {
                _loc_2.setAttribute("id", this._id);
                _loc_2.setAttribute("name", this._fileName);
            }
            if (this._branch.length > 0 && this._path.length > 1)
            {
                _loc_2.setAttribute("path", this._path.substr(this._branch.length + 2));
            }
            else
            {
                _loc_2.setAttribute("path", this._path);
            }
            if (param1)
            {
                _loc_2.setAttribute("size", this.width + "," + this.height);
            }
            if (this.exported)
            {
                _loc_2.setAttribute("exported", this.exported);
            }
            if (this.favorite && !param1)
            {
                _loc_2.setAttribute("favorite", this.favorite);
            }
            if (this._imageSettings)
            {
                this._imageSettings.write(this, _loc_2, param1);
            }
            else if (this._fontSettings)
            {
                this._fontSettings.write(this, _loc_2, param1);
            }
            else if (this._folderSettings)
            {
                this._folderSettings.write(this, _loc_2, param1);
            }
            if (!param1 && this.reviewed)
            {
                _loc_2.setAttribute("reviewed", this.reviewed);
            }
            return _loc_2;
        }// end function

        private function convertImage() : void
        {
            var cacheFolder:File;
            var file:File;
            var info:Object;
            try
            {
                cacheFolder = this.owner.cacheFolder;
                file = cacheFolder.resolvePath(this._id);
                if (file.exists)
                {
                    info = UtilsFile.loadJSON(cacheFolder.resolvePath(this._id + ".info"));
                    if (info)
                    {
                        if (info.modificationDate == this._modificationTime && info.fileSize == this._fileSize && info.format == this._imageInfo.format && info.quality == this._imageInfo.targetQuality && (info.format != "svg" || info.width == this._imageSettings.width && info.height == this._imageSettings.height))
                        {
                            this._imageInfo.file = file;
                            EasyLoader.load(file.url, {type:"image", pi:this, ver:this._version}, __imageLoaded);
                            return;
                        }
                    }
                    UtilsFile.deleteFile(file);
                }
            }
            catch (err:Error)
            {
                _owner.project.logError("convertImage", err);
            }
            this._vars.converting = true;
            vo = new ConvertMessage();
            vo.pkgId = this._owner.id;
            vo.itemId = this._id;
            vo.sourceFile = this._file.nativePath;
            vo.targetFile = file.nativePath;
            vo.format = this._imageInfo.format;
            vo.quality = this._imageInfo.targetQuality;
            vo.width = this._imageSettings.width;
            vo.height = this._imageSettings.height;
            vo.version = this._version;
            this._owner.project.asyncRequest("convert", vo, this.onConverted, this.onConvertFailed);
            return;
        }// end function

        private function convertSound() : void
        {
            var cacheFolder:File;
            var file:File;
            var info:Object;
            try
            {
                cacheFolder = this.owner.cacheFolder;
                file = cacheFolder.resolvePath(this._id);
                if (file.exists)
                {
                    info = UtilsFile.loadJSON(cacheFolder.resolvePath(this._id + ".info"));
                    if (info)
                    {
                        if (info.modificationDate == this._modificationTime && info.fileSize == this._fileSize)
                        {
                            this.updateData(new Sound(new URLRequest(file.url)), this._version);
                            this.invokeLoadedCallbacks();
                            return;
                        }
                    }
                }
            }
            catch (err:Error)
            {
                _owner.project.logError("convertSound", err);
            }
            this._vars.converting = true;
            vo = new ConvertMessage();
            vo.pkgId = this._owner.id;
            vo.itemId = this._id;
            vo.sourceFile = this._file.nativePath;
            vo.targetFile = file.nativePath;
            vo.format = "sound";
            vo.version = this._version;
            this.owner.project.asyncRequest("convert", vo, this.onConverted, this.onConvertFailed);
            return;
        }// end function

        private function onConverted(param1:ConvertMessage) : void
        {
            if (this._disposed)
            {
                return;
            }
            this._vars.converting = false;
            if (this._type == FPackageItemType.SOUND)
            {
                this._loading = false;
                this.updateData(new Sound(new URLRequest(new File(param1.targetFile).url)), param1.version);
                this.invokeLoadedCallbacks();
            }
            else
            {
                this._imageInfo.file = new File(param1.targetFile);
                EasyLoader.load(this._imageInfo.file.url, {type:"image", pi:this, ver:param1.version}, __imageLoaded);
            }
            return;
        }// end function

        private function onConvertFailed(param1:String, param2:ConvertMessage) : void
        {
            if (this._disposed)
            {
                return;
            }
            this._vars.converting = false;
            this._owner.project.logError("convert-response: " + this._name + "@" + this._owner.name + "(" + param2.itemId + "," + param2.pkgId + ") " + param1);
            this._loading = false;
            this.invokeLoadedCallbacks();
            return;
        }// end function

        private static function __imageLoaded(param1:LoaderExt) : void
        {
            var _loc_2:* = param1.content;
            var _loc_3:* = FPackageItem.FPackageItem(param1.props.pi);
            if (_loc_3._disposed)
            {
                return;
            }
            _loc_3._loading = false;
            if (_loc_2 is Bitmap)
            {
                _loc_3.updateData(_loc_2.bitmapData, param1.props.ver);
            }
            _loc_3.invokeLoadedCallbacks();
            return;
        }// end function

    }
}
