package _-NY
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.filesystem.*;
    import flash.system.*;

    public class _-y extends Object
    {
        private var _editor:IEditor;
        private var _-Lh:Vector.<_-1F>;
        private var _-Op:Vector.<_-1l>;
        private var _-LU:Object;
        private var _-JX:int;
        public static const _-Hs:int = 0;
        public static const _-62:int = 1;
        public static const _-EB:int = 2;
        public static const _-D0:int = 3;

        public function _-y()
        {
            this._-Lh = new Vector.<_-1F>;
            this._-Op = new Vector.<_-1l>;
            return;
        }// end function

        public function get _-CN() : Vector.<_-1F>
        {
            return this._-Lh;
        }// end function

        public function get _-O2() : Vector.<_-1l>
        {
            return this._-Op;
        }// end function

        public function _-Mz(param1:Vector.<FPackageItem>, param2:int) : void
        {
            var _loc_3:* = null;
            this._-Lh.length = 0;
            this._-Op.length = 0;
            this._-LU = {};
            this._-JX = param2;
            var _loc_4:* = param1.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3 = param1[_loc_5];
                this.addItem(_loc_3, true);
                _loc_5++;
            }
            return;
        }// end function

        public function _-96(param1:IUIProject, param2:String, param3:int) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            this._-Lh.length = 0;
            this._-Op.length = 0;
            this._-LU = {};
            this._-JX = param3;
            var _loc_4:* = param1.getItemByURL(param2);
            if (param1.getItemByURL(param2))
            {
                this.addItem(_loc_4, true);
                _loc_5 = this._-Lh.length;
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    if (this._-Lh[_loc_6].item == _loc_4)
                    {
                        this._-Lh.splice(_loc_6, 1);
                        break;
                    }
                    _loc_6++;
                }
            }
            return;
        }// end function

        public function _-6d(param1:IUIPackage, param2:XData, param3:int) : void
        {
            this._-Lh.length = 0;
            this._-Op.length = 0;
            this._-LU = {};
            this._-JX = param3;
            this.parse(param1, param2);
            return;
        }// end function

        public function _-Ea(param1:IUIProject, param2:String) : void
        {
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = false;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            this._-Lh.length = 0;
            this._-Op.length = 0;
            this._-LU = {};
            if (!param2 || param2.length < 14 || !UtilsStr.startsWith(param2, "ui://"))
            {
                return;
            }
            var _loc_3:* = param2.substr(5, 8);
            var _loc_4:* = param2.substr(13);
            var _loc_5:* = new Vector.<_-1l>;
            this._-JX = _-Hs;
            var _loc_6:* = param1.allPackages;
            var _loc_7:* = param1.allBranches;
            for each (_loc_9 in _loc_6)
            {
                
                if (!_loc_9.opened)
                {
                    _loc_10 = this._-1j(_loc_9, "", new File(_loc_9.basePath + "/package.xml"), _loc_4);
                    if (!_loc_10)
                    {
                        for each (_loc_11 in _loc_7)
                        {
                            
                            _loc_12 = new File(_loc_9.getBranchPath(_loc_11) + "/package_branch.xml");
                            if (_loc_12.exists)
                            {
                                if (this._-1j(_loc_9, _loc_11, _loc_12, _loc_4))
                                {
                                    _loc_10 = true;
                                    break;
                                }
                            }
                        }
                    }
                    if (!_loc_10)
                    {
                        continue;
                    }
                }
                for each (_loc_8 in _loc_9.items)
                {
                    
                    if (_loc_8.type == FPackageItemType.COMPONENT || _loc_8.type == FPackageItemType.FONT)
                    {
                        _loc_10 = false;
                        if (_loc_8.file.exists)
                        {
                            _loc_15 = UtilsFile.loadString(_loc_8.file);
                            if (_loc_15.indexOf(_loc_4) != -1)
                            {
                                _loc_10 = true;
                            }
                        }
                        if (_loc_8.fontSettings && _loc_8.fontSettings.texture == _loc_4 && _loc_9.id == _loc_3)
                        {
                            _loc_10 = true;
                        }
                        if (!_loc_10)
                        {
                            continue;
                        }
                        _loc_13 = new _-1F();
                        _loc_13._-Lj = true;
                        _loc_13.item = _loc_8;
                        this._-Op.length = 0;
                        if (_loc_8.type == FPackageItemType.COMPONENT)
                        {
                            this._-3V(_loc_13);
                        }
                        else if (_loc_8.type == FPackageItemType.FONT)
                        {
                            this._-3Y(_loc_13);
                        }
                        for each (_loc_14 in this._-Op)
                        {
                            
                            if (_loc_14.pkgId == _loc_3 && _loc_14.itemId == _loc_4)
                            {
                                _loc_5.push(_loc_14);
                                var _loc_22:* = _loc_13;
                                var _loc_23:* = _loc_13._-C4 + 1;
                                _loc_22._-C4 = _loc_23;
                            }
                        }
                        if (_loc_13._-C4 > 0)
                        {
                            this._-Lh.push(_loc_13);
                        }
                    }
                }
            }
            this._-Op = _loc_5;
            return;
        }// end function

        private function _-1j(param1:IUIPackage, param2:String, param3:File, param4:String) : Boolean
        {
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_5:* = false;
            var _loc_6:* = UtilsFile.loadXML(param3);
            var _loc_7:* = _loc_6.resources;
            if (_loc_6.resources)
            {
                _loc_8 = _loc_7.elements();
                for each (_loc_9 in _loc_8)
                {
                    
                    _loc_10 = _loc_9.name().localName;
                    if (_loc_10 == "component" || _loc_10 == "font")
                    {
                        _loc_11 = _loc_9.@path;
                        if (!_loc_11)
                        {
                            _loc_11 = "/";
                        }
                        else
                        {
                            if (_loc_11.charAt(0) != "/")
                            {
                                _loc_11 = "/" + _loc_11;
                            }
                            if (_loc_11.charAt((_loc_11.length - 1)) != "/")
                            {
                                _loc_11 = _loc_11 + "/";
                            }
                        }
                        _loc_12 = _loc_9.@name;
                        if (param2)
                        {
                            _loc_13 = new File(param1.project.basePath + "/assets_" + param2 + "/" + param1.name + "/" + _loc_11 + _loc_12);
                        }
                        else
                        {
                            _loc_13 = new File(param1.basePath + _loc_11 + _loc_12);
                        }
                        if (_loc_13.exists)
                        {
                            _loc_14 = UtilsFile.loadString(_loc_13);
                            if (_loc_14.indexOf(param4) != -1)
                            {
                                _loc_5 = true;
                                break;
                            }
                        }
                        _loc_14 = _loc_9.@texture;
                        if (_loc_14 == param4)
                        {
                            _loc_5 = true;
                            break;
                        }
                    }
                }
            }
            System.disposeXML(_loc_6);
            return _loc_5;
        }// end function

        public function replaceReferences(param1:FPackageItem) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_2:* = {};
            for each (_loc_3 in this._-Op)
            {
                
                if (_loc_3.update(param1))
                {
                    _loc_2[_loc_3._-f.id] = _loc_3._-f;
                }
            }
            _loc_4 = {};
            for each (_loc_5 in this._-Lh)
            {
                
                if (_loc_5.item.type == FPackageItemType.COMPONENT)
                {
                    if (_loc_5.content)
                    {
                        UtilsFile.saveXData(_loc_5.item.file, _loc_5.content);
                        _loc_5.item.setChanged();
                        _loc_4[_loc_5.item.owner.id] = _loc_5.item.owner;
                    }
                    continue;
                }
                if (_loc_5.item.type == FPackageItemType.FONT)
                {
                    if (_loc_5.content)
                    {
                        UtilsFile.saveString(_loc_5.item.file, _loc_5.content.join("\n"));
                        _loc_5.item.setChanged();
                        _loc_4[_loc_5.item.owner.id] = _loc_5.item.owner;
                    }
                }
            }
            for (_loc_6 in _loc_2)
            {
                
                IUIPackage(_loc_2[_loc_6]).save();
            }
            for (_loc_6 in _loc_4)
            {
                
                IUIPackage(_loc_4[_loc_6]).setChanged();
            }
            return;
        }// end function

        private function addItem(param1:FPackageItem, param2:Boolean = false) : Boolean
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_3:* = this._-LU[param1.getURL()];
            if (_loc_3)
            {
                if (!_loc_3._-Lj && param2)
                {
                    _loc_3._-Lj = param2;
                    if (!_loc_3._-7 && this._-JX != _-Hs && param1.file.exists)
                    {
                        if (param1.type == FPackageItemType.COMPONENT)
                        {
                            this._-3V(_loc_3);
                        }
                        else if (param1.type == FPackageItemType.FONT)
                        {
                            this._-3Y(_loc_3);
                        }
                    }
                }
                return true;
            }
            if (!param2)
            {
                if (this._-JX == _-Hs || this._-JX == _-62 && param1.exported)
                {
                    return false;
                }
            }
            _loc_3 = new _-1F();
            _loc_3.item = param1;
            _loc_3._-Lj = param2;
            this._-LU[param1.getURL()] = _loc_3;
            this._-Lh.push(_loc_3);
            if (param2 || this._-JX != _-Hs)
            {
                _loc_3._-7 = true;
                if (param1.file.exists)
                {
                    if (param1.type == FPackageItemType.COMPONENT)
                    {
                        this._-3V(_loc_3);
                    }
                    else if (param1.type == FPackageItemType.FONT)
                    {
                        this._-3Y(_loc_3);
                    }
                    else if (param1.imageInfo)
                    {
                        _loc_4 = param1.name.length;
                        if (_loc_4 > 3 && param1.name.charCodeAt((_loc_4 - 1)) != 120 && param1.name.charCodeAt(_loc_4 - 3) != 64)
                        {
                            _loc_5 = param1.path + param1.name;
                            _loc_6 = 3;
                            while (_loc_6 > 0)
                            {
                                
                                _loc_7 = param1.owner.getItemByPath(_loc_5 + "@" + (_loc_6 + 1) + "x");
                                if (_loc_7 && _loc_7.type == param1.type)
                                {
                                    this.addItem(_loc_7);
                                }
                                _loc_6 = _loc_6 - 1;
                            }
                        }
                    }
                }
            }
            return true;
        }// end function

        private function _-x(param1:IUIPackage, param2:XData, param3:String, param4:Boolean = false) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = false;
            var _loc_10:* = 0;
            var _loc_5:* = param2.getAttribute(param3);
            if (!param2.getAttribute(param3))
            {
                return;
            }
            if (param4)
            {
                _loc_6 = _loc_5.indexOf(",") != -1 ? (",") : ("|");
                _loc_7 = _loc_5.split(_loc_6);
                _loc_8 = _loc_7.length;
                _loc_9 = false;
                _loc_10 = 0;
                while (_loc_10 < _loc_8)
                {
                    
                    this._-JW(param1, param2, param3, _loc_7[_loc_10], true);
                    _loc_10++;
                }
            }
            else
            {
                this._-JW(param1, param2, param3, _loc_5, false);
            }
            return;
        }// end function

        private function _-JW(param1:IUIPackage, param2:XData, param3:String, param4:String, param5:Boolean) : void
        {
            var _loc_10:* = null;
            if (!param4 || param4.length < 14 || !UtilsStr.startsWith(param4, "ui://"))
            {
                return;
            }
            var _loc_6:* = param4.substr(5, 8);
            var _loc_7:* = param1.project.getPackage(_loc_6);
            var _loc_8:* = param4.substr(13);
            var _loc_9:* = _loc_8.indexOf(",");
            if (_loc_8.indexOf(",") != -1)
            {
                param5 = true;
                _loc_8 = _loc_8.substr(0, _loc_9);
            }
            this.addReference(param1, _loc_6, _loc_8, param2, param3, param5 ? (_-1l._-Gd) : (_-1l._-6e));
            if (this._-JX == _-D0 || _loc_7 == param1)
            {
                if (_loc_7 != null)
                {
                    _loc_10 = _loc_7.getItem(_loc_8);
                    if (_loc_10)
                    {
                        this.addItem(_loc_10);
                    }
                }
            }
            return;
        }// end function

        private function addReference(param1:IUIPackage, param2:String, param3:String, param4, param5, param6:int) : _-1l
        {
            var _loc_7:* = new _-1l();
            _loc_7._-f = param1;
            _loc_7.pkgId = param2;
            _loc_7.itemId = param3;
            _loc_7.content = param4;
            _loc_7._-Fe = param5;
            _loc_7._-Ch = param6;
            this._-Op.push(_loc_7);
            return _loc_7;
        }// end function

        private function _-3V(param1:_-1F) : void
        {
            var pi:FPackageItem;
            var xml:XData;
            var di:* = param1;
            pi = di.item;
            try
            {
                xml = UtilsFile.loadXData(pi.file);
            }
            catch (err:Error)
            {
                throw new Error("Read \'" + pi.file.nativePath + "\' failed，check the file format！");
            }
            var pkg:* = pi.owner;
            di.content = xml;
            this.parse(pkg, xml);
            return;
        }// end function

        private function parse(param1:IUIPackage, param2:XData) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = null;
            var _loc_11:* = param2.getChild("displayList");
            if (param2.getChild("displayList"))
            {
                _loc_3 = _loc_11.getChildren();
                for each (_loc_5 in _loc_3)
                {
                    
                    _loc_8 = _loc_5.getName();
                    _loc_12 = _loc_5.getAttribute("src");
                    if (_loc_12)
                    {
                        _loc_13 = _loc_5.getAttribute("pkg");
                        if (_loc_13)
                        {
                            _loc_14 = param1.project.getPackage(_loc_13);
                            if (_loc_14 && (this._-JX == _-D0 || _loc_14 == param1))
                            {
                                _loc_15 = _loc_14.getItem(_loc_12);
                                if (_loc_15)
                                {
                                    this.addItem(_loc_15);
                                }
                            }
                        }
                        else
                        {
                            _loc_13 = param1.id;
                            _loc_15 = param1.getItem(_loc_12);
                            if (_loc_15)
                            {
                                this.addItem(_loc_15);
                            }
                        }
                        this.addReference(param1, _loc_13, _loc_12, _loc_5, "src", _-1l._-9j);
                    }
                    if (_loc_8 == "loader")
                    {
                        this._-x(param1, _loc_5, "url");
                    }
                    else if (_loc_8 == "list")
                    {
                        this._-x(param1, _loc_5, "defaultItem");
                        _loc_4 = _loc_5.getEnumerator("item");
                        while (_loc_4.moveNext())
                        {
                            
                            _loc_7 = _loc_4.current;
                            _loc_10 = _loc_7.getAttribute("url");
                            if (_loc_10)
                            {
                                this._-x(param1, _loc_7, "url");
                            }
                            _loc_10 = _loc_7.getAttribute("icon");
                            if (_loc_10)
                            {
                                this._-x(param1, _loc_7, "icon");
                            }
                            _loc_10 = _loc_7.getAttribute("selectedIcon");
                            if (_loc_10)
                            {
                                this._-x(param1, _loc_7, "selectedIcon");
                            }
                            _loc_16 = _loc_7.getEnumerator("property");
                            while (_loc_16.moveNext())
                            {
                                
                                if (_loc_16.current.getAttributeInt("propertyId") == 1)
                                {
                                    this._-x(param1, _loc_16.current, "value");
                                }
                            }
                        }
                        _loc_10 = _loc_5.getAttribute("scrollBarRes");
                        if (_loc_10)
                        {
                            this._-x(param1, _loc_5, "scrollBarRes", true);
                        }
                        _loc_10 = _loc_5.getAttribute("ptrRes");
                        if (_loc_10)
                        {
                            this._-x(param1, _loc_5, "ptrRes", true);
                        }
                    }
                    else if (_loc_8 == "text" || _loc_8 == "richtext")
                    {
                        this._-x(param1, _loc_5, "font");
                    }
                    else if (_loc_8 == "component")
                    {
                        _loc_6 = _loc_5.getChild("Button");
                        if (_loc_6)
                        {
                            this._-x(param1, _loc_6, "icon");
                            this._-x(param1, _loc_6, "selectedIcon");
                            this._-x(param1, _loc_6, "sound");
                        }
                        _loc_6 = _loc_5.getChild("Label");
                        if (_loc_6)
                        {
                            this._-x(param1, _loc_6, "icon");
                        }
                        _loc_6 = _loc_5.getChild("ComboBox");
                        if (_loc_6)
                        {
                            _loc_4 = _loc_6.getEnumerator("item");
                            while (_loc_4.moveNext())
                            {
                                
                                _loc_7 = _loc_4.current;
                                _loc_10 = _loc_7.getAttribute("icon");
                                if (_loc_10)
                                {
                                    this._-x(param1, _loc_7, "icon");
                                }
                            }
                        }
                        _loc_16 = _loc_5.getEnumerator("property");
                        while (_loc_16.moveNext())
                        {
                            
                            if (_loc_16.current.getAttributeInt("propertyId") == 1)
                            {
                                this._-x(param1, _loc_16.current, "value");
                            }
                        }
                    }
                    _loc_6 = _loc_5.getChild("gearIcon");
                    if (_loc_6)
                    {
                        this._-x(param1, _loc_6, "values", true);
                        this._-x(param1, _loc_6, "default");
                    }
                }
            }
            _loc_6 = param2.getChild("Button");
            if (_loc_6)
            {
                this._-x(param1, _loc_6, "sound");
            }
            _loc_6 = param2.getChild("ComboBox");
            if (_loc_6)
            {
                this._-x(param1, _loc_6, "dropdown");
            }
            _loc_4 = param2.getEnumerator("transition");
            while (_loc_4.moveNext())
            {
                
                for each (_loc_6 in _loc_7.getChildren())
                {
                    
                    _loc_17 = _loc_6.getAttribute("type");
                    if (_loc_17 == "Sound" || _loc_17 == "Icon")
                    {
                        this._-x(param1, _loc_6, "value");
                    }
                }
            }
            this._-x(param1, param2, "designImage");
            this._-x(param1, param2, "hitTestData");
            _loc_10 = param2.getAttribute("scrollBarRes");
            if (_loc_10)
            {
                this._-x(param1, param2, "scrollBarRes", true);
            }
            _loc_10 = param2.getAttribute("ptrRes");
            if (_loc_10)
            {
                this._-x(param1, param2, "ptrRes", true);
            }
            return;
        }// end function

        private function _-3Y(param1:_-1F) : void
        {
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_2:* = param1.item.owner;
            var _loc_3:* = UtilsFile.loadString(param1.item.file);
            var _loc_4:* = _loc_3.split("\n");
            param1.content = _loc_4;
            var _loc_5:* = _loc_4.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = _loc_4[_loc_6];
                if (!_loc_7)
                {
                }
                else
                {
                    if (UtilsStr.startsWith(_loc_7, "info") && _loc_7.indexOf("face") != -1)
                    {
                        break;
                    }
                    if (UtilsStr.startsWith(_loc_7, "char"))
                    {
                        _loc_8 = _loc_7.indexOf("img=");
                        if (_loc_8 != -1)
                        {
                            _loc_8 = _loc_8 + 4;
                            _loc_9 = _loc_7.indexOf(" ", _loc_8);
                            if (_loc_9 == -1)
                            {
                                _loc_9 = _loc_7.length;
                            }
                            _loc_10 = _loc_7.substring(_loc_8, _loc_9);
                            _loc_11 = _loc_2.getItem(_loc_10);
                            if (_loc_11)
                            {
                                this.addItem(_loc_11, this._-JX != _-Hs);
                            }
                            this.addReference(_loc_2, _loc_2.id, _loc_10, _loc_4, _loc_6, _-1l._-9y);
                        }
                    }
                }
                _loc_6++;
            }
            if (param1.item.fontSettings.texture)
            {
                _loc_11 = _loc_2.getItem(param1.item.fontSettings.texture);
                if (_loc_11)
                {
                    this.addItem(_loc_11, this._-JX != _-Hs);
                }
                this.addReference(_loc_2, _loc_2.id, param1.item.fontSettings.texture, param1, null, _-1l._-N);
            }
            return;
        }// end function

    }
}
