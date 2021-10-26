package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.display.*;
    import fairygui.text.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.system.*;
    import flash.utils.*;

    public class UIPackage extends Object
    {
        private var _id:String;
        private var _name:String;
        private var _basePath:String;
        private var _items:Vector.<PackageItem>;
        private var _itemsById:Object;
        private var _itemsByName:Object;
        private var _hitTestDatas:Object;
        private var _customId:String;
        private var _branches:Array;
        var _branchIndex:int;
        private var _reader:IUIPackageReader;
        public static var _constructing:int;
        private static var _packageInstById:Object = {};
        private static var _packageInstByName:Object = {};
        private static var _bitmapFonts:Object = {};
        private static var _loadingQueue:Array = [];
        private static var _stringsSource:Object = null;
        private static var _branch:String = null;
        private static var _vars:Object = {};

        public function UIPackage()
        {
            _items = new Vector.<PackageItem>;
            _hitTestDatas = {};
            _branches = [];
            _branchIndex = -1;
            return;
        }// end function

        private function create(param1:IUIPackageReader) : void
        {
            var _loc_8:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_2:* = null;
            var _loc_6:* = null;
            var _loc_5:* = 0;
            _reader = param1;
            var _loc_7:* = XML.ignoreWhitespace;
            XML.ignoreWhitespace = true;
            _loc_8 = _reader.readDescFile("package.xml");
            var _loc_9:* = new XML(_loc_8);
            XML.ignoreWhitespace = _loc_7;
            _id = _loc_9.@id;
            _name = _loc_9.@name;
            _loc_8 = _loc_9.@branches;
            if (_loc_8)
            {
                _branches = _loc_8.split(",");
                if (_branch)
                {
                    _branchIndex = _branches.indexOf(_branch);
                }
            }
            var _loc_12:* = _branches.length > 0;
            _itemsById = {};
            _itemsByName = {};
            var _loc_4:* = _loc_9.resources.elements();
            for each (_loc_11 in _loc_4)
            {
                
                _loc_10 = new PackageItem();
                _loc_10.owner = this;
                _loc_10.type = PackageItemType.parseType(_loc_11.name().localName);
                _loc_10.id = _loc_11.@id;
                _loc_10.name = _loc_11.@name;
                _loc_10.file = _loc_11.@file;
                _loc_8 = _loc_11.@size;
                _loc_2 = _loc_8.split(",");
                _loc_10.width = _loc_2[0];
                _loc_10.height = _loc_2[1];
                _loc_8 = _loc_11.@branch;
                if (_loc_8)
                {
                    _loc_10.name = _loc_8 + "/" + _loc_10.name;
                }
                _loc_8 = _loc_11.@branches;
                if (_loc_8)
                {
                    if (_loc_12)
                    {
                        _loc_10.branches = _loc_8.split(",");
                    }
                    else
                    {
                        _itemsById[_loc_8] = _loc_10;
                    }
                }
                switch(_loc_10.type) branch count is:<4>[20, 277, 218, 277, 268] default offset is:<277>;
                _loc_8 = _loc_11.@scale;
                if (_loc_8 == "9grid")
                {
                    _loc_10.scale9Grid = new Rectangle();
                    _loc_8 = _loc_11.@scale9grid;
                    _loc_2 = _loc_8.split(",");
                    _loc_10.scale9Grid.x = _loc_2[0];
                    _loc_10.scale9Grid.y = _loc_2[1];
                    _loc_10.scale9Grid.width = _loc_2[2];
                    _loc_10.scale9Grid.height = _loc_2[3];
                    _loc_8 = _loc_11.@gridTile;
                    if (_loc_8)
                    {
                        _loc_10.tileGridIndice = this.parseInt(_loc_8);
                    }
                }
                else if (_loc_8 == "tile")
                {
                    _loc_10.scaleByTile = true;
                }
                _loc_8 = _loc_11.@smoothing;
                _loc_10.smoothing = _loc_8 != "false";
                _loc_8 = _loc_11.@highRes;
                if (_loc_8)
                {
                    _loc_10.highResolution = _loc_8.split(",");
                }
                ;
                _loc_8 = _loc_11.@smoothing;
                _loc_10.smoothing = _loc_8 != "false";
                _loc_8 = _loc_11.@highRes;
                if (_loc_8)
                {
                    _loc_10.highResolution = _loc_8.split(",");
                }
                ;
                UIObjectFactory.resolvePackageItemExtension(_loc_10);
                _items.push(_loc_10);
                _itemsById[_loc_10.id] = _loc_10;
                if (_loc_10.name != null)
                {
                    _itemsByName[_loc_10.name] = _loc_10;
                }
            }
            var _loc_13:* = _reader.readResFile("hittest.bytes");
            if (_reader.readResFile("hittest.bytes") != null)
            {
                while (_loc_13.bytesAvailable)
                {
                    
                    _loc_6 = new PixelHitTestData();
                    _hitTestDatas[_loc_13.readUTF()] = _loc_6;
                    _loc_6.load(_loc_13);
                }
            }
            var _loc_3:* = _items.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_10 = _items[_loc_5];
                if (_loc_10.type == 6)
                {
                    loadFont(_loc_10);
                    _bitmapFonts[_loc_10.bitmapFont.id] = _loc_10.bitmapFont;
                }
                _loc_5++;
            }
            return;
        }// end function

        public function loadAllImages() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_1:* = _items.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = _items[_loc_2];
                if (!(_loc_3.type != 0 || _loc_3.image != null || _loc_3.loading))
                {
                    loadImage(_loc_3);
                }
                _loc_2++;
            }
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_6:* = 0;
            var _loc_3:* = _items.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = _items[_loc_4];
                _loc_1 = _loc_5.image;
                if (_loc_1 != null)
                {
                    _loc_1.dispose();
                }
                else if (_loc_5.frames != null)
                {
                    _loc_2 = _loc_5.frames.length;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_2)
                    {
                        
                        _loc_1 = _loc_5.frames[_loc_6].image;
                        if (_loc_1 != null)
                        {
                            _loc_1.dispose();
                        }
                        _loc_6++;
                    }
                }
                else if (_loc_5.bitmapFont != null)
                {
                    delete _bitmapFonts[_loc_5.bitmapFont.id];
                    _loc_5.bitmapFont.dispose();
                }
                _loc_4++;
            }
            return;
        }// end function

        public function get id() : String
        {
            return _id;
        }// end function

        public function get name() : String
        {
            return _name;
        }// end function

        public function get customId() : String
        {
            return _customId;
        }// end function

        public function set customId(param1:String) : void
        {
            if (_customId != null)
            {
                delete _packageInstById[_customId];
            }
            _customId = param1;
            if (_customId != null)
            {
                _packageInstById[_customId] = this;
            }
            return;
        }// end function

        public function createObject(param1:String, param2:Object = null) : GObject
        {
            var _loc_3:* = _itemsByName[param1];
            if (_loc_3)
            {
                return internalCreateObject(_loc_3, param2);
            }
            return null;
        }// end function

        function internalCreateObject(param1:PackageItem, param2:Object) : GObject
        {
            var _loc_3:* = null;
            if (param1.type == 4)
            {
                if (param2 != null)
                {
                    if (param2 is Class)
                    {
                        _loc_3 = new param2;
                    }
                    else
                    {
                        _loc_3 = this.GObject(param2);
                    }
                }
                else
                {
                    _loc_3 = UIObjectFactory.newObject(param1);
                }
            }
            else
            {
                _loc_3 = UIObjectFactory.newObject(param1);
            }
            if (_loc_3 == null)
            {
                return null;
            }
            (_constructing + 1);
            _loc_3.packageItem = param1;
            _loc_3.constructFromResource();
            (_constructing - 1);
            return _loc_3;
        }// end function

        public function getItemById(param1:String) : PackageItem
        {
            return _itemsById[param1];
        }// end function

        public function getItemByName(param1:String) : PackageItem
        {
            return _itemsByName[param1];
        }// end function

        private function getXMLDesc(param1:String) : XML
        {
            var _loc_3:* = XML.ignoreWhitespace;
            XML.ignoreWhitespace = true;
            var _loc_2:* = new XML(_reader.readDescFile(param1));
            XML.ignoreWhitespace = _loc_3;
            return _loc_2;
        }// end function

        public function getItemRaw(param1:PackageItem) : ByteArray
        {
            return _reader.readResFile(param1.file);
        }// end function

        public function getImage(param1:String) : BitmapData
        {
            var _loc_2:* = _itemsByName[param1];
            if (_loc_2)
            {
                return _loc_2.image;
            }
            return null;
        }// end function

        public function getPixelHitTestData(param1:String) : PixelHitTestData
        {
            return _hitTestDatas[param1];
        }// end function

        public function getComponentData(param1:PackageItem) : XML
        {
            var _loc_2:* = null;
            if (!param1.componentData)
            {
                _loc_2 = getXMLDesc(param1.id + ".xml");
                param1.componentData = _loc_2;
                loadComponentChildren(param1);
                translateComponent(param1);
            }
            return param1.componentData;
        }// end function

        private function loadComponentChildren(param1:PackageItem) : void
        {
            var _loc_2:* = null;
            var _loc_9:* = 0;
            var _loc_4:* = null;
            var _loc_6:* = 0;
            var _loc_8:* = null;
            var _loc_11:* = null;
            var _loc_5:* = null;
            var _loc_10:* = null;
            var _loc_12:* = null;
            var _loc_7:* = null;
            var _loc_3:* = param1.componentData.displayList[0];
            if (_loc_3 != null)
            {
                _loc_2 = _loc_3.elements();
                _loc_9 = _loc_2.length();
                param1.displayList = new Vector.<DisplayListItem>(_loc_9);
                _loc_6 = 0;
                while (_loc_6 < _loc_9)
                {
                    
                    _loc_8 = _loc_2[_loc_6];
                    _loc_11 = _loc_8.name().localName;
                    _loc_5 = _loc_8.@src;
                    if (_loc_5)
                    {
                        _loc_10 = _loc_8.@pkg;
                        if (_loc_10 && _loc_10 != param1.owner.id)
                        {
                            _loc_12 = UIPackage.getById(_loc_10);
                        }
                        else
                        {
                            _loc_12 = param1.owner;
                        }
                        _loc_7 = _loc_12 != null ? (_loc_12.getItemById(_loc_5)) : (null);
                        if (_loc_7 != null)
                        {
                            _loc_4 = new DisplayListItem(_loc_7, null);
                        }
                        else
                        {
                            _loc_4 = new DisplayListItem(null, _loc_11);
                        }
                    }
                    else if (_loc_11 == "text" && _loc_8.@input == "true")
                    {
                        _loc_4 = new DisplayListItem(null, "inputtext");
                    }
                    else if (_loc_11 == "list" && _loc_8.@treeView == "true")
                    {
                        _loc_4 = new DisplayListItem(null, "tree");
                    }
                    else
                    {
                        _loc_4 = new DisplayListItem(null, _loc_11);
                    }
                    _loc_4.desc = _loc_8;
                    param1.displayList[_loc_6] = _loc_4;
                    _loc_6++;
                }
            }
            else
            {
                param1.displayList = new Vector.<DisplayListItem>(0);
            }
            return;
        }// end function

        private function translateComponent(param1:PackageItem) : void
        {
            var _loc_12:* = undefined;
            var _loc_11:* = null;
            var _loc_10:* = null;
            var _loc_6:* = 0;
            var _loc_5:* = 0;
            var _loc_8:* = null;
            var _loc_2:* = null;
            var _loc_7:* = null;
            var _loc_3:* = null;
            var _loc_13:* = null;
            if (_stringsSource == null)
            {
                return;
            }
            var _loc_9:* = _stringsSource[this.id + param1.id];
            if (_stringsSource[this.id + param1.id] == null)
            {
                return;
            }
            var _loc_4:* = param1.displayList.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_10 = param1.displayList[_loc_5].desc;
                _loc_8 = _loc_10.name().localName;
                _loc_2 = _loc_10.@id;
                if (_loc_10.@tooltips.length() > 0)
                {
                    _loc_12 = _loc_9[_loc_2 + "-tips"];
                    if (_loc_12 != undefined)
                    {
                        _loc_10.@tooltips = _loc_12;
                    }
                }
                _loc_11 = _loc_10.gearText[0];
                if (_loc_11)
                {
                    _loc_7 = _loc_11.@values;
                    if (_loc_7)
                    {
                        _loc_3 = _loc_7.split("|");
                        _loc_6 = 0;
                        while (_loc_6 < _loc_3.length)
                        {
                            
                            _loc_12 = _loc_9[_loc_2 + "-texts_" + _loc_6];
                            if (_loc_12 != null)
                            {
                                _loc_3[_loc_6] = _loc_12;
                            }
                            _loc_6++;
                        }
                        _loc_11.@values = _loc_3.join("|");
                    }
                    _loc_12 = _loc_9[_loc_2 + "-texts_def"];
                    if (_loc_12 != undefined)
                    {
                        _loc_11["default"] = _loc_12;
                    }
                }
                if (_loc_8 == "text" || _loc_8 == "richtext")
                {
                    _loc_12 = _loc_9[_loc_2];
                    if (_loc_12 != undefined)
                    {
                        _loc_10.@text = _loc_12;
                    }
                    _loc_12 = _loc_9[_loc_2 + "-prompt"];
                    if (_loc_12 != undefined)
                    {
                        _loc_10.@prompt = _loc_12;
                    }
                }
                else if (_loc_8 == "list")
                {
                    _loc_13 = _loc_10.item;
                    _loc_6 = 0;
                    for each (_loc_14 in _loc_13)
                    {
                        
                        _loc_12 = _loc_9[_loc_2 + "-" + _loc_6];
                        if (_loc_12 != undefined)
                        {
                            _loc_14.@title = _loc_12;
                        }
                        _loc_6++;
                    }
                }
                else if (_loc_8 == "component")
                {
                    _loc_11 = _loc_10.Button[0];
                    if (_loc_11)
                    {
                        _loc_12 = _loc_9[_loc_2];
                        if (_loc_12 != undefined)
                        {
                            _loc_11.@title = _loc_12;
                        }
                        _loc_12 = _loc_9[_loc_2 + "-0"];
                        if (_loc_12 != undefined)
                        {
                            _loc_11.@selectedTitle = _loc_12;
                        }
                    }
                    else
                    {
                        _loc_11 = _loc_10.Label[0];
                        if (_loc_11)
                        {
                            _loc_12 = _loc_9[_loc_2];
                            if (_loc_12 != undefined)
                            {
                                _loc_11.@title = _loc_12;
                            }
                            _loc_12 = _loc_9[_loc_2 + "-prompt"];
                            if (_loc_12 != undefined)
                            {
                                _loc_11.@prompt = _loc_12;
                            }
                        }
                        else
                        {
                            _loc_11 = _loc_10.ComboBox[0];
                            if (_loc_11)
                            {
                                _loc_12 = _loc_9[_loc_2];
                                if (_loc_12 != undefined)
                                {
                                    _loc_11.@title = _loc_12;
                                }
                                _loc_13 = _loc_11.item;
                                _loc_6 = 0;
                                for each (_loc_14 in _loc_13)
                                {
                                    
                                    _loc_12 = _loc_9[_loc_2 + "-" + _loc_6];
                                    if (_loc_12 != undefined)
                                    {
                                        _loc_14.@title = _loc_12;
                                    }
                                    _loc_6++;
                                }
                            }
                        }
                    }
                }
                _loc_5++;
            }
            return;
        }// end function

        public function getSound(param1:PackageItem) : Sound
        {
            if (!param1.loaded)
            {
                loadSound(param1);
            }
            return param1.sound;
        }// end function

        public function addCallback(param1:String, param2:Function) : void
        {
            var _loc_3:* = _itemsByName[param1];
            if (_loc_3)
            {
                addItemCallback(_loc_3, param2);
            }
            return;
        }// end function

        public function removeCallback(param1:String, param2:Function) : void
        {
            var _loc_3:* = _itemsByName[param1];
            if (_loc_3)
            {
                removeItemCallback(_loc_3, param2);
            }
            return;
        }// end function

        public function addItemCallback(param1:PackageItem, param2:Function) : void
        {
            param1.lastVisitTime = this.getTimer();
            if (param1.type == 0)
            {
                if (param1.loaded)
                {
                    GTimers.inst.add(0, 1, param2);
                    return;
                }
                param1.addCallback(param2);
                if (param1.loading)
                {
                    return;
                }
                loadImage(param1);
            }
            else if (param1.type == 2)
            {
                if (param1.loaded)
                {
                    GTimers.inst.add(0, 1, param2);
                    return;
                }
                param1.addCallback(param2);
                if (param1.loading)
                {
                    return;
                }
                loadMovieClip(param1);
            }
            else if (param1.type == 1)
            {
                param1.addCallback(param2);
                loadSwf(param1);
            }
            else if (param1.type == 3)
            {
                if (!param1.loaded)
                {
                    loadSound(param1);
                }
                GTimers.inst.add(0, 1, param2);
            }
            return;
        }// end function

        public function removeItemCallback(param1:PackageItem, param2:Function) : void
        {
            param1.removeCallback(param2);
            return;
        }// end function

        private function loadImage(param1:PackageItem) : void
        {
            var _loc_3:* = _reader.readResFile(param1.file);
            if (_loc_3 == null)
            {
                this.trace("cannot load " + param1.file);
                param1.completeLoading();
                return;
            }
            var _loc_2:* = new PackageItemLoader();
            _loc_2.contentLoaderInfo.addEventListener("complete", __imageLoaded);
            _loc_2.contentLoaderInfo.addEventListener("ioError", __imageLoaded);
            _loc_2.item = param1;
            param1.loading = 1;
            _loadingQueue.push(_loc_2);
            _loc_2.loadBytes(_loc_3);
            return;
        }// end function

        private function __imageLoaded(event:Event) : void
        {
            var _loc_2:* = this.PackageItemLoader(this.LoaderInfo(event.currentTarget).loader);
            var _loc_3:* = _loadingQueue.indexOf(_loc_2);
            if (_loc_3 == -1)
            {
                return;
            }
            _loadingQueue.splice(_loc_3, 1);
            var _loc_4:* = _loc_2.item;
            if (_loc_2.content)
            {
                _loc_4.image = this.Bitmap(_loc_2.content).bitmapData;
            }
            else
            {
                this.trace("load \'" + _loc_4.name + "," + _loc_4.file + "\' failed: " + event.toString());
            }
            _loc_4.completeLoading();
            return;
        }// end function

        private function loadSwf(param1:PackageItem) : void
        {
            var _loc_4:* = _reader.readResFile(param1.file);
            var _loc_2:* = new PackageItemLoader();
            _loc_2.contentLoaderInfo.addEventListener("complete", __swfLoaded);
            var _loc_3:* = new LoaderContext();
            _loc_3.allowCodeImport = true;
            _loc_2.loadBytes(_loc_4, _loc_3);
            _loc_2.item = param1;
            _loadingQueue.push(_loc_2);
            return;
        }// end function

        private function __swfLoaded(event:Event) : void
        {
            var _loc_2:* = this.PackageItemLoader(this.LoaderInfo(event.currentTarget).loader);
            var _loc_3:* = _loadingQueue.indexOf(_loc_2);
            if (_loc_3 == -1)
            {
                return;
            }
            _loadingQueue.splice(_loc_3, 1);
            var _loc_4:* = _loc_2.item;
            var _loc_5:* = _loc_4.callbacks.pop();
            if (_loc_4.callbacks.pop() != null)
            {
                this._loc_5(_loc_2.content);
            }
            return;
        }// end function

        private function loadMovieClip(param1:PackageItem) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_8:* = 0;
            var _loc_10:* = null;
            var _loc_5:* = null;
            var _loc_11:* = null;
            var _loc_7:* = null;
            var _loc_6:* = getXMLDesc(param1.id + ".xml");
            _loc_2 = _loc_6.@interval;
            if (_loc_2 != null)
            {
                param1.interval = this.parseInt(_loc_2);
            }
            _loc_2 = _loc_6.@swing;
            if (_loc_2 != null)
            {
                param1.swing = _loc_2 == "true";
            }
            _loc_2 = _loc_6.@repeatDelay;
            if (_loc_2 != null)
            {
                param1.repeatDelay = this.parseInt(_loc_2);
            }
            var _loc_4:* = this.parseInt(_loc_6.@frameCount);
            param1.frames = new Vector.<Frame>(_loc_4);
            var _loc_9:* = _loc_6.frames.elements();
            _loc_8 = 0;
            while (_loc_8 < _loc_4)
            {
                
                _loc_10 = new Frame();
                _loc_5 = _loc_9[_loc_8];
                _loc_2 = _loc_5.@rect;
                _loc_3 = _loc_2.split(",");
                _loc_10.rect = new Rectangle(this.parseInt(_loc_3[0]), this.parseInt(_loc_3[1]), this.parseInt(_loc_3[2]), this.parseInt(_loc_3[3]));
                _loc_2 = _loc_5.@addDelay;
                _loc_10.addDelay = this.parseInt(_loc_2);
                param1.frames[_loc_8] = _loc_10;
                if (_loc_10.rect.width != 0)
                {
                    _loc_2 = _loc_5.@sprite;
                    if (_loc_2)
                    {
                        _loc_2 = param1.id + "_" + _loc_2 + ".png";
                    }
                    else
                    {
                        _loc_2 = param1.id + "_" + _loc_8 + ".png";
                    }
                    _loc_11 = _reader.readResFile(_loc_2);
                    if (_loc_11)
                    {
                        _loc_7 = new FrameLoader();
                        _loc_7.contentLoaderInfo.addEventListener("complete", __frameLoaded);
                        _loc_7.loadBytes(_loc_11);
                        _loc_7.item = param1;
                        _loc_7.frame = _loc_10;
                        _loadingQueue.push(_loc_7);
                        (param1.loading + 1);
                    }
                    else
                    {
                        _loc_10.rect.setEmpty();
                    }
                }
                _loc_8++;
            }
            return;
        }// end function

        private function __frameLoaded(event:Event) : void
        {
            var _loc_2:* = this.FrameLoader(event.currentTarget.loader);
            var _loc_3:* = _loadingQueue.indexOf(_loc_2);
            if (_loc_3 == -1)
            {
                return;
            }
            _loadingQueue.splice(_loc_3, 1);
            var _loc_4:* = _loc_2.item;
            var _loc_5:* = _loc_2.frame;
            _loc_5.image = this.Bitmap(_loc_2.content).bitmapData;
            (_loc_4.loading - 1);
            if (_loc_4.loading == 0)
            {
                _loc_4.completeLoading();
            }
            return;
        }// end function

        private function loadSound(param1:PackageItem) : void
        {
            var _loc_2:* = new Sound();
            var _loc_3:* = _reader.readResFile(param1.file);
            _loc_2.loadCompressedDataFromByteArray(_loc_3, _loc_3.length);
            param1.sound = _loc_2;
            param1.loaded = true;
            return;
        }// end function

        private function loadFont(param1:PackageItem) : void
        {
            var _loc_8:* = 0;
            var _loc_2:* = null;
            var _loc_9:* = 0;
            var _loc_17:* = null;
            var _loc_5:* = null;
            var _loc_3:* = null;
            var _loc_20:* = null;
            var _loc_6:* = null;
            var _loc_19:* = new BitmapFont();
            _loc_19.id = "ui://" + this.id + param1.id;
            var _loc_11:* = _reader.readDescFile(param1.id + ".fnt");
            var _loc_16:* = _loc_11.split("\n");
            var _loc_18:* = _loc_16.length;
            var _loc_10:* = {};
            var _loc_7:* = false;
            var _loc_13:* = 0;
            var _loc_12:* = 0;
            var _loc_4:* = false;
            var _loc_14:* = false;
            var _loc_15:* = 0;
            _loc_8 = 0;
            while (_loc_8 < _loc_18)
            {
                
                _loc_11 = _loc_16[_loc_8];
                if (_loc_11.length != 0)
                {
                    _loc_11 = ToolSet.trim(_loc_11);
                    _loc_2 = _loc_11.split(" ");
                    _loc_9 = 1;
                    while (_loc_9 < _loc_2.length)
                    {
                        
                        _loc_17 = _loc_2[_loc_9].split("=");
                        _loc_10[_loc_17[0]] = _loc_17[1];
                        _loc_9++;
                    }
                    _loc_11 = _loc_2[0];
                    if (_loc_11 == "char")
                    {
                        _loc_5 = new BMGlyph();
                        _loc_5.x = _loc_10.x;
                        _loc_5.y = _loc_10.y;
                        _loc_5.offsetX = _loc_10.xoffset;
                        _loc_5.offsetY = _loc_10.yoffset;
                        _loc_5.width = _loc_10.width;
                        _loc_5.height = _loc_10.height;
                        _loc_5.advance = _loc_10.xadvance;
                        _loc_5.channel = _loc_19.translateChannel(_loc_10.chnl);
                        if (!_loc_7)
                        {
                            if (_loc_10.img)
                            {
                                _loc_3 = _itemsById[_loc_10.img];
                                if (_loc_3 != null)
                                {
                                    _loc_3 = _loc_3.getBranch();
                                    _loc_5.width = _loc_3.width;
                                    _loc_5.height = _loc_3.height;
                                    _loc_3 = _loc_3.getHighResolution();
                                    _loc_5.imageItem = _loc_3;
                                    loadImage(_loc_3);
                                }
                            }
                        }
                        if (_loc_7)
                        {
                            _loc_5.lineHeight = _loc_15;
                        }
                        else
                        {
                            if (_loc_5.advance == 0)
                            {
                                if (_loc_12 == 0)
                                {
                                    _loc_5.advance = _loc_5.offsetX + _loc_5.width;
                                }
                                else
                                {
                                    _loc_5.advance = _loc_12;
                                }
                            }
                            _loc_5.lineHeight = _loc_5.offsetY < 0 ? (_loc_5.height) : (_loc_5.offsetY + _loc_5.height);
                            if (_loc_13 > 0 && _loc_5.lineHeight < _loc_13)
                            {
                                _loc_5.lineHeight = _loc_13;
                            }
                        }
                        _loc_19.glyphs[String.fromCharCode(_loc_10.id)] = _loc_5;
                    }
                    else if (_loc_11 == "info")
                    {
                        _loc_7 = _loc_10.face != null;
                        _loc_14 = _loc_7;
                        _loc_13 = _loc_10.size;
                        _loc_4 = _loc_10.resizable == "true";
                        if (_loc_10.colored != undefined)
                        {
                            _loc_14 = _loc_10.colored == "true";
                        }
                        if (_loc_7)
                        {
                            _loc_20 = _reader.readResFile(param1.id + ".png");
                            _loc_6 = new PackageItemLoader();
                            _loc_6.contentLoaderInfo.addEventListener("complete", __fontAtlasLoaded);
                            _loc_6.loadBytes(_loc_20);
                            _loc_6.item = param1;
                            _loadingQueue.push(_loc_6);
                        }
                    }
                    else if (_loc_11 == "common")
                    {
                        _loc_15 = _loc_10.lineHeight;
                        if (_loc_13 == 0)
                        {
                            _loc_13 = _loc_15;
                        }
                        else if (_loc_15 == 0)
                        {
                            _loc_15 = _loc_13;
                        }
                        _loc_12 = _loc_10.xadvance;
                    }
                }
                _loc_8++;
            }
            if (_loc_13 == 0 && _loc_5)
            {
                _loc_13 = _loc_5.height;
            }
            _loc_19.ttf = _loc_7;
            _loc_19.size = _loc_13;
            _loc_19.resizable = _loc_4;
            _loc_19.colored = _loc_14;
            param1.bitmapFont = _loc_19;
            return;
        }// end function

        private function __fontAtlasLoaded(event:Event) : void
        {
            var _loc_2:* = this.PackageItemLoader(this.LoaderInfo(event.currentTarget).loader);
            var _loc_3:* = _loadingQueue.indexOf(_loc_2);
            if (_loc_3 == -1)
            {
                return;
            }
            _loadingQueue.splice(_loc_3, 1);
            var _loc_4:* = _loc_2.item;
            _loc_4.bitmapFont.atlas = this.Bitmap(_loc_2.content).bitmapData;
            return;
        }// end function

        public static function getById(param1:String) : UIPackage
        {
            return _packageInstById[param1];
        }// end function

        public static function getByName(param1:String) : UIPackage
        {
            return _packageInstByName[param1];
        }// end function

        public static function addPackage(param1:ByteArray, param2:ByteArray) : UIPackage
        {
            var _loc_4:* = new UIPackage;
            var _loc_3:* = new ZipUIPackageReader(param1, param2);
            _loc_4.create(_loc_3);
            _packageInstById[_loc_4.id] = _loc_4;
            _packageInstByName[_loc_4.name] = _loc_4;
            return _loc_4;
        }// end function

        public static function addPackage2(param1:IUIPackageReader) : UIPackage
        {
            var _loc_2:* = new UIPackage;
            _loc_2.create(param1);
            _packageInstById[_loc_2.id] = _loc_2;
            _packageInstByName[_loc_2.name] = _loc_2;
            return _loc_2;
        }// end function

        public static function removePackage(param1:String) : void
        {
            var _loc_2:* = _packageInstById[param1];
            _loc_2.dispose();
            delete _packageInstById[_loc_2.id];
            if (_loc_2._customId != null)
            {
                delete _packageInstById[_loc_2._customId];
            }
            return;
        }// end function

        public static function createObject(param1:String, param2:String, param3:Object = null) : GObject
        {
            var _loc_4:* = getByName(param1);
            if (getByName(param1))
            {
                return _loc_4.createObject(param2, param3);
            }
            return null;
        }// end function

        public static function createObjectFromURL(param1:String, param2:Object = null) : GObject
        {
            var _loc_3:* = getItemByURL(param1);
            if (_loc_3)
            {
                return _loc_3.owner.internalCreateObject(_loc_3, param2);
            }
            return null;
        }// end function

        public static function getItemURL(param1:String, param2:String) : String
        {
            var _loc_4:* = getByName(param1);
            if (!getByName(param1))
            {
                return null;
            }
            var _loc_3:* = _loc_4._itemsByName[param2];
            if (!_loc_3)
            {
                return null;
            }
            return "ui://" + _loc_4.id + _loc_3.id;
        }// end function

        public static function getItemByURL(param1:String) : PackageItem
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_2:* = null;
            if (param1 == null)
            {
                return null;
            }
            var _loc_5:* = param1.indexOf("//");
            if (param1.indexOf("//") == -1)
            {
                return null;
            }
            var _loc_6:* = param1.indexOf("/", _loc_5 + 2);
            if (param1.indexOf("/", _loc_5 + 2) == -1)
            {
                if (param1.length > 13)
                {
                    _loc_7 = param1.substr(5, 8);
                    _loc_8 = getById(_loc_7);
                    if (_loc_8 != null)
                    {
                        _loc_3 = param1.substr(13);
                        return _loc_8.getItemById(_loc_3);
                    }
                }
            }
            else
            {
                _loc_4 = param1.substr(_loc_5 + 2, _loc_6 - _loc_5 - 2);
                _loc_8 = getByName(_loc_4);
                if (_loc_8 != null)
                {
                    _loc_2 = param1.substr((_loc_6 + 1));
                    return _loc_8.getItemByName(_loc_2);
                }
            }
            return null;
        }// end function

        public static function normalizeURL(param1:String) : String
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_4:* = param1.indexOf("//");
            if (param1.indexOf("//") == -1)
            {
                return null;
            }
            var _loc_5:* = param1.indexOf("/", _loc_4 + 2);
            if (param1.indexOf("/", _loc_4 + 2) == -1)
            {
                return param1;
            }
            var _loc_3:* = param1.substr(_loc_4 + 2, _loc_5 - _loc_4 - 2);
            var _loc_2:* = param1.substr((_loc_5 + 1));
            return getItemURL(_loc_3, _loc_2);
        }// end function

        public static function getBitmapFontByURL(param1:String) : BitmapFont
        {
            return _bitmapFonts[param1];
        }// end function

        public static function setStringsSource(param1:XML) : void
        {
            var _loc_9:* = null;
            var _loc_7:* = null;
            var _loc_6:* = 0;
            var _loc_2:* = null;
            var _loc_5:* = null;
            var _loc_3:* = null;
            _stringsSource = {};
            var _loc_8:* = param1.string;
            for each (_loc_4 in _loc_8)
            {
                
                _loc_9 = (_loc_4).@name;
                _loc_7 = _loc_4.toString();
                _loc_6 = _loc_9.indexOf("-");
                if (_loc_6 != -1)
                {
                    _loc_2 = _loc_9.substr(0, _loc_6);
                    _loc_5 = _loc_9.substr((_loc_6 + 1));
                    _loc_3 = _stringsSource[_loc_2];
                    if (!_loc_3)
                    {
                        _loc_3 = {};
                        _stringsSource[_loc_2] = _loc_3;
                    }
                    _loc_3[_loc_5] = _loc_7;
                }
            }
            return;
        }// end function

        public static function get branch() : String
        {
            return _branch;
        }// end function

        public static function set branch(param1:String) : void
        {
            var _loc_3:* = null;
            _branch = param1;
            for (_loc_2 in _packageInstById)
            {
                
                _loc_3 = _loc_4[_loc_2];
                if (_loc_3._branches)
                {
                    _loc_3._branchIndex = _loc_3._branches.indexOf(_branch);
                }
            }
            return;
        }// end function

        public static function getVar(param1:String)
        {
            return _vars[param1];
        }// end function

        public static function setVar(param1:String, param2) : void
        {
            if (param2 == undefined)
            {
                delete _vars[param1];
            }
            else
            {
                _vars[param1] = param2;
            }
            return;
        }// end function

        public static function loadingCount() : int
        {
            return _loadingQueue.length;
        }// end function

        public static function waitToLoadCompleted(param1:Function) : void
        {
            GTimers.inst.add(10, 0, checkComplete, param1);
            return;
        }// end function

        private static function checkComplete(param1:Function) : void
        {
            if (_loadingQueue.length == 0)
            {
                GTimers.inst.remove(checkComplete);
                UIPackage.param1();
            }
            return;
        }// end function

    }
}

import *.*;

import __AS3__.vec.*;

import fairygui.display.*;

import fairygui.text.*;

import fairygui.utils.*;

import flash.display.*;

import flash.events.*;

import flash.geom.*;

import flash.media.*;

import flash.system.*;

import flash.utils.*;

class PackageItemLoader extends Loader
{
    public var item:PackageItem;

    function PackageItemLoader() : void
    {
        return;
    }// end function

}


import *.*;

import __AS3__.vec.*;

import fairygui.display.*;

import fairygui.text.*;

import fairygui.utils.*;

import flash.display.*;

import flash.events.*;

import flash.geom.*;

import flash.media.*;

import flash.system.*;

import flash.utils.*;

class FrameLoader extends Loader
{
    public var item:PackageItem;
    public var frame:Frame;

    function FrameLoader() : void
    {
        return;
    }// end function

}

