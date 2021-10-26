package _-NY
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;
    import flash.geom.*;

    public class _-Cs extends Object
    {
        private var _pkg:IUIPackage;
        private var _fontSize:int;
        private var _textHeight:int;
        private var _serialNumberSeed:String;

        public function _-Cs(param1:IUIPackage)
        {
            this._pkg = param1;
            this._serialNumberSeed = this._pkg.project.serialNumberSeed;
            return;
        }// end function

        private function getComponentData(param1:FPackageItem) : XData
        {
            var xml:XData;
            var pi:* = param1;
            try
            {
                xml = UtilsFile.loadXData(pi.file);
            }
            catch (err:Error)
            {
            }
            return xml;
        }// end function

        private function getFontSize() : int
        {
            if (this._fontSize == 0)
            {
                this._fontSize = this._pkg.project.getSetting("common", "fontSize");
            }
            return this._fontSize;
        }// end function

        private function _-Bp() : int
        {
            if (this._textHeight == 0)
            {
                this._textHeight = CharSize.getSize(this._pkg.project.getSetting("common", "fontSize"), this._pkg.project.getSetting("common", "font"), false).height + 4;
            }
            return this._textHeight;
        }// end function

        private function _-MR(param1:String, param2:String, param3:Object) : String
        {
            if (!Preferences.meaningfullChildName)
            {
                return UtilsStr.getNameFromId(param1);
            }
            var _loc_4:* = FObjectType.NAME_PREFIX[param2];
            var _loc_5:* = param3[_loc_4];
            if (param3[_loc_4] == undefined)
            {
                param3[_loc_4] = 1;
                return _loc_4 + "0";
            }
            var _loc_6:* = param3;
            var _loc_7:* = _loc_4;
            var _loc_8:* = _loc_6[_loc_4] + 1;
            _loc_6[_loc_7] = _loc_8;
            return _loc_4 + _loc_5;
        }// end function

        public function _-Fq(param1:String, param2:int, param3:int, param4:String) : FPackageItem
        {
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_5:* = this._pkg.createComponentItem(param1, param2, param3, param4, "Label");
            var _loc_6:* = this.getComponentData(_loc_5);
            var _loc_7:* = XData.create("displayList");
            _loc_6.appendChild(_loc_7);
            var _loc_8:* = 0;
            _loc_9 = XData.create("text");
            _loc_9.setAttribute("id", "n" + _loc_8++ + "_" + this._serialNumberSeed);
            _loc_9.setAttribute("name", "title");
            _loc_9.setAttribute("xy", "0,0");
            _loc_9.setAttribute("size", param2 + "," + param3);
            _loc_9.setAttribute("fontSize", this.getFontSize());
            _loc_9.setAttribute("autoSize", "none");
            _loc_9.setAttribute("align", "center");
            _loc_9.setAttribute("vAlign", "middle");
            _loc_9.setAttribute("singleLine", true);
            _loc_10 = XData.create("relation");
            _loc_10.setAttribute("target", "");
            _loc_10.setAttribute("sidePair", "width,height");
            _loc_9.appendChild(_loc_10);
            _loc_7.appendChild(_loc_9);
            UtilsFile.saveXData(_loc_5.file, _loc_6);
            _loc_6.dispose();
            return _loc_5;
        }// end function

        public function _-6u(param1:String, param2:String, param3:String, param4:Array, param5:Point, param6:Boolean, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean, param11:String) : FPackageItem
        {
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = 0;
            var _loc_17:* = 0;
            var _loc_21:* = 0;
            var _loc_22:* = 0;
            var _loc_23:* = null;
            var _loc_24:* = null;
            var _loc_25:* = null;
            if (param4 != null)
            {
                _loc_21 = 0;
                _loc_22 = 0;
                while (_loc_22 < 4)
                {
                    
                    _loc_23 = param4[_loc_22];
                    if (!_loc_23)
                    {
                        if (_loc_22 == 3 && param4[1])
                        {
                            param4[1].push(_loc_22);
                        }
                        else if (param4[0])
                        {
                            param4[0].push(_loc_22);
                        }
                        param4[_loc_22] = null;
                    }
                    else
                    {
                        _loc_24 = this._pkg.project.getItemByURL(_loc_23);
                        if (!_loc_24)
                        {
                            throw new Error("Resource not found \'" + _loc_23 + "\'");
                        }
                        _loc_21++;
                        param4[_loc_22] = [_loc_24, _loc_22];
                    }
                    _loc_22++;
                }
            }
            if (param5 == null)
            {
                if (param4 != null && param4[0])
                {
                    _loc_16 = param4[0][0].width;
                    _loc_17 = param4[0][0].height;
                }
            }
            else
            {
                _loc_16 = param5.x;
                _loc_17 = param5.y;
            }
            if (_loc_16 == 0)
            {
                _loc_16 = 100;
            }
            if (_loc_17 == 0)
            {
                _loc_17 = 20;
            }
            var _loc_18:* = this._pkg.createComponentItem(param1, _loc_16, _loc_17, param11, param2, param10);
            _loc_12 = this.getComponentData(_loc_18);
            _loc_13 = XData.create("controller");
            _loc_13.setAttribute("name", "button");
            _loc_13.setAttribute("pages", "0,up,1,down,2,over,3,selectedOver");
            _loc_12.appendChild(_loc_13);
            _loc_13 = XData.create("displayList");
            _loc_12.appendChild(_loc_13);
            var _loc_19:* = 0;
            var _loc_20:* = {};
            if (param4 != null && _loc_21 > 0)
            {
                _loc_22 = 0;
                while (_loc_22 < 4)
                {
                    
                    _loc_25 = param4[_loc_22];
                    if (_loc_25)
                    {
                        _loc_24 = _loc_25[0];
                        _loc_14 = XData.create(_loc_24.type);
                        _loc_14.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
                        if (_loc_24.owner != this._pkg)
                        {
                            _loc_14.setAttribute("pkg", _loc_24.owner.id);
                        }
                        _loc_14.setAttribute("src", _loc_24.id);
                        _loc_14.setAttribute("name", this._-MR(_loc_14.getAttribute("id"), _loc_24.type, _loc_20));
                        _loc_14.setAttribute("xy", int((_loc_16 - _loc_24.width) / 2) + "," + int((_loc_17 - _loc_24.height) / 2));
                        if (_loc_21 > 1)
                        {
                            _loc_15 = XData.create("gearDisplay");
                            _loc_15.setAttribute("controller", "button");
                            _loc_15.setAttribute("pages", _loc_25.slice(1).join(","));
                            _loc_14.appendChild(_loc_15);
                        }
                        if (param7)
                        {
                            _loc_15 = XData.create("relation");
                            _loc_15.setAttribute("target", "");
                            _loc_15.setAttribute("sidePair", "width,height");
                            _loc_14.appendChild(_loc_15);
                        }
                        _loc_13.appendChild(_loc_14);
                    }
                    _loc_22++;
                }
            }
            else
            {
                if (!param6)
                {
                    _loc_14 = XData.create("graph");
                    _loc_14.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
                    _loc_14.setAttribute("name", this._-MR(_loc_14.getAttribute("id"), "graph", _loc_20));
                    _loc_14.setAttribute("xy", "0,0");
                    _loc_14.setAttribute("size", _loc_16 + "," + _loc_17);
                    _loc_14.setAttribute("type", "rect");
                    _loc_14.setAttribute("lineSize", 0);
                    _loc_14.setAttribute("fillColor", "#F0F0F0");
                    _loc_14.setAttribute("touchable", false);
                    _loc_15 = XData.create("gearDisplay");
                    _loc_15.setAttribute("controller", "button");
                    _loc_15.setAttribute("pages", "0");
                    _loc_14.appendChild(_loc_15);
                    _loc_15 = XData.create("relation");
                    _loc_15.setAttribute("target", "");
                    _loc_15.setAttribute("sidePair", "width,height");
                    _loc_14.appendChild(_loc_15);
                    _loc_13.appendChild(_loc_14);
                }
                _loc_14 = XData.create("graph");
                _loc_14.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
                _loc_14.setAttribute("name", this._-MR(_loc_14.getAttribute("id"), "graph", _loc_20));
                _loc_14.setAttribute("xy", "0,0");
                _loc_14.setAttribute("size", _loc_16 + "," + _loc_17);
                _loc_14.setAttribute("type", "rect");
                _loc_14.setAttribute("lineSize", 0);
                if (param6)
                {
                    _loc_14.setAttribute("fillColor", "#3399FF");
                }
                else
                {
                    _loc_14.setAttribute("fillColor", "#FAFAFA");
                }
                _loc_14.setAttribute("touchable", false);
                _loc_15 = XData.create("gearDisplay");
                _loc_15.setAttribute("controller", "button");
                _loc_15.setAttribute("pages", "2");
                _loc_14.appendChild(_loc_15);
                _loc_15 = XData.create("relation");
                _loc_15.setAttribute("target", "");
                _loc_15.setAttribute("sidePair", "width,height");
                _loc_14.appendChild(_loc_15);
                _loc_13.appendChild(_loc_14);
                _loc_14 = XData.create("graph");
                _loc_14.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
                _loc_14.setAttribute("name", this._-MR(_loc_14.getAttribute("id"), "graph", _loc_20));
                _loc_14.setAttribute("xy", "0,0");
                _loc_14.setAttribute("size", _loc_16 + "," + _loc_17);
                _loc_14.setAttribute("type", "rect");
                _loc_14.setAttribute("lineSize", 0);
                _loc_14.setAttribute("fillColor", "#CCCCCC");
                _loc_14.setAttribute("touchable", false);
                _loc_15 = XData.create("gearDisplay");
                _loc_15.setAttribute("controller", "button");
                _loc_15.setAttribute("pages", "1,3");
                _loc_14.appendChild(_loc_15);
                _loc_15 = XData.create("relation");
                _loc_15.setAttribute("target", "");
                _loc_15.setAttribute("sidePair", "width,height");
                _loc_14.appendChild(_loc_15);
                _loc_13.appendChild(_loc_14);
            }
            if (param8)
            {
                _loc_14 = XData.create("text");
                _loc_14.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
                _loc_14.setAttribute("name", "title");
                _loc_14.setAttribute("xy", "0,0");
                _loc_14.setAttribute("size", _loc_16 + "," + _loc_17);
                _loc_14.setAttribute("fontSize", this.getFontSize());
                _loc_14.setAttribute("autoSize", "none");
                _loc_14.setAttribute("align", "center");
                _loc_14.setAttribute("vAlign", "middle");
                _loc_14.setAttribute("singleLine", "true");
                _loc_15 = XData.create("relation");
                _loc_15.setAttribute("target", "");
                _loc_15.setAttribute("sidePair", "width,height");
                _loc_14.appendChild(_loc_15);
                _loc_13.appendChild(_loc_14);
            }
            if (param9)
            {
                _loc_14 = XData.create("loader");
                _loc_14.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
                _loc_14.setAttribute("name", "icon");
                _loc_14.setAttribute("xy", "0,0");
                _loc_14.setAttribute("size", _loc_16 + "," + _loc_17);
                _loc_14.setAttribute("align", "center");
                _loc_14.setAttribute("vAlign", "middle");
                _loc_15 = XData.create("relation");
                _loc_15.setAttribute("target", "");
                _loc_15.setAttribute("sidePair", "width,height");
                _loc_14.appendChild(_loc_15);
                _loc_13.appendChild(_loc_14);
            }
            if (param3 != null && param3 != "Common")
            {
                _loc_13 = _loc_12.getChild(param2);
                _loc_13.setAttribute("mode", param3);
            }
            UtilsFile.saveXData(_loc_18.file, _loc_12);
            _loc_12.dispose();
            return _loc_18;
        }// end function

        public function _-9O(param1:String, param2:Array, param3:String, param4:Array, param5:String) : FPackageItem
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_18:* = null;
            var _loc_10:* = this._-6u(param1 + "_item", "Button", "Radio", param4, null, true, true, true, false, false, param5);
            _loc_6 = this.getComponentData(_loc_10);
            _loc_8 = _loc_6.getChild("displayList").getChild("text");
            _loc_8.removeAttribute("align");
            UtilsFile.saveXData(_loc_10.file, _loc_6);
            _loc_6.dispose();
            _loc_11 = 150;
            _loc_12 = 200;
            var _loc_13:* = this._pkg.createComponentItem(param1 + "_popup", _loc_11, _loc_12, param5);
            _loc_6 = this.getComponentData(_loc_13);
            _loc_7 = XData.create("displayList");
            _loc_6.appendChild(_loc_7);
            var _loc_14:* = 0;
            var _loc_15:* = {};
            if (param3)
            {
                _loc_18 = this._pkg.project.getItemByURL(param3);
                if (!_loc_18)
                {
                    throw new Error("Resource not found \'" + param3 + "\'");
                }
                _loc_8 = XData.create(_loc_18.type);
                _loc_8.setAttribute("id", "n" + _loc_14++ + "_" + this._serialNumberSeed);
                if (_loc_18.owner != this._pkg)
                {
                    _loc_8.setAttribute("pkg", _loc_18.owner.id);
                }
                _loc_8.setAttribute("src", _loc_18.id);
                _loc_8.setAttribute("name", this._-MR(_loc_8.getAttribute("id"), _loc_18.type, _loc_15));
                _loc_8.setAttribute("xy", "0,0");
                _loc_8.setAttribute("size", _loc_11 + "," + _loc_12);
                _loc_9 = XData.create("relation");
                _loc_9.setAttribute("target", "");
                _loc_9.setAttribute("sidePair", "width,height");
                _loc_8.appendChild(_loc_9);
                _loc_7.appendChild(_loc_8);
            }
            else
            {
                _loc_8 = XData.create("graph");
                _loc_8.setAttribute("id", "n" + _loc_14++ + "_" + this._serialNumberSeed);
                _loc_8.setAttribute("name", this._-MR(_loc_8.getAttribute("id"), "graph", _loc_15));
                _loc_8.setAttribute("xy", "0,0");
                _loc_8.setAttribute("size", _loc_11 + "," + _loc_12);
                _loc_8.setAttribute("type", "rect");
                _loc_8.setAttribute("lineSize", 1);
                _loc_8.setAttribute("lineColor", "#A0A0A0");
                _loc_8.setAttribute("fillColor", "#F0F0F0");
                _loc_8.setAttribute("touchable", false);
                _loc_9 = XData.create("relation");
                _loc_9.setAttribute("target", "");
                _loc_9.setAttribute("sidePair", "width,height");
                _loc_8.appendChild(_loc_9);
                _loc_7.appendChild(_loc_8);
            }
            _loc_8 = XData.create("list");
            var _loc_16:* = "n" + _loc_14++ + "_" + this._serialNumberSeed;
            _loc_8.setAttribute("id", _loc_16);
            _loc_8.setAttribute("name", "list");
            _loc_8.setAttribute("xy", "0,0");
            _loc_8.setAttribute("size", _loc_11 + "," + _loc_12);
            _loc_8.setAttribute("overflow", "scroll");
            _loc_8.setAttribute("defaultItem", "ui://" + _loc_10.owner.id + _loc_10.id);
            _loc_9 = XData.create("relation");
            _loc_9.setAttribute("target", "");
            _loc_9.setAttribute("sidePair", "width");
            _loc_8.appendChild(_loc_9);
            _loc_7.appendChild(_loc_8);
            _loc_7 = XData.create("relation");
            _loc_7.setAttribute("target", _loc_16);
            _loc_7.setAttribute("sidePair", "height");
            _loc_6.appendChild(_loc_7);
            UtilsFile.saveXData(_loc_13.file, _loc_6);
            _loc_6.dispose();
            var _loc_17:* = this._-6u(param1, "ComboBox", null, param2, null, false, true, true, false, true, param5);
            _loc_6 = this.getComponentData(_loc_17);
            _loc_11 = _loc_17.width;
            _loc_12 = _loc_17.height;
            _loc_8 = _loc_6.getChild("displayList").getChild("text");
            _loc_8.setAttribute("size", _loc_11 - 20 + "," + _loc_12);
            _loc_8.removeAttribute("align");
            _loc_7 = _loc_6.getChild("ComboBox");
            _loc_7.setAttribute("dropdown", "ui://" + _loc_13.owner.id + _loc_13.id);
            UtilsFile.saveXData(_loc_17.file, _loc_6);
            _loc_6.dispose();
            return _loc_17;
        }// end function

        public function _-5(param1:String, param2:int, param3:Boolean, param4:Array, param5:Array, param6:String, param7:Array, param8:String) : FPackageItem
        {
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_15:* = null;
            var _loc_21:* = null;
            var _loc_22:* = null;
            var _loc_23:* = null;
            if (param6)
            {
                _loc_21 = this._pkg.project.getItemByURL(param6);
                if (!_loc_21)
                {
                    throw new Error("Resource not found \'" + param6 + "\'");
                }
            }
            if (_loc_21)
            {
                if (param2 == 0)
                {
                    _loc_13 = _loc_21.width;
                    _loc_14 = 200;
                }
                else
                {
                    _loc_13 = 200;
                    _loc_14 = _loc_21.height;
                }
            }
            else if (param2 == 0)
            {
                _loc_13 = 17;
                _loc_14 = 200;
            }
            else
            {
                _loc_13 = 200;
                _loc_14 = 17;
            }
            if (param2 == 0)
            {
                _loc_15 = new Point(_loc_13, 20);
            }
            else
            {
                _loc_15 = new Point(20, _loc_14);
            }
            if (param3)
            {
                _loc_22 = this._-6u(param1 + "_arrow1", "Button", "Common", param4, _loc_15, false, false, false, false, false, param8);
                _loc_9 = this.getComponentData(_loc_22);
                if (_loc_9.getChild("displayList").getChild("graph"))
                {
                    _loc_9.getChild("displayList").getChild("graph").setAttribute("fillColor", "#A9DBF6");
                    UtilsFile.saveXData(_loc_22.file, _loc_9);
                }
                _loc_9.dispose();
                _loc_23 = this._-6u(param1 + "_arrow2", "Button", "Common", param5, _loc_15, false, false, false, false, false, param8);
                _loc_9 = this.getComponentData(_loc_23);
                if (_loc_9.getChild("displayList").getChild("graph"))
                {
                    _loc_9.getChild("displayList").getChild("graph").setAttribute("fillColor", "#A9DBF6");
                    UtilsFile.saveXData(_loc_23.file, _loc_9);
                }
                _loc_9.dispose();
            }
            var _loc_16:* = this._-6u(param1 + "_grip", "Button", "Common", param7, _loc_15, false, true, false, false, false, param8);
            _loc_9 = this.getComponentData(_loc_16);
            var _loc_17:* = _loc_9.getChild("displayList").getChildren();
            if (_loc_17.length >= 3)
            {
                if (_loc_17[0].getName() == "graph")
                {
                    _loc_17[0].setAttribute("fillColor", "#D0D1D7");
                }
                if (_loc_17[1].getName() == "graph")
                {
                    _loc_17[1].setAttribute("fillColor", "#888888");
                }
                if (_loc_17[2].getName() == "graph")
                {
                    _loc_17[2].setAttribute("fillColor", "#6A6A6A");
                }
                UtilsFile.saveXData(_loc_16.file, _loc_9);
            }
            _loc_9.dispose();
            var _loc_18:* = this._pkg.createComponentItem(param1, _loc_13, _loc_14, param8, "ScrollBar", true);
            _loc_9 = this.getComponentData(_loc_18);
            _loc_10 = XData.create("displayList");
            _loc_9.appendChild(_loc_10);
            var _loc_19:* = 0;
            var _loc_20:* = {};
            if (_loc_21)
            {
                _loc_11 = XData.create(_loc_21.type);
                _loc_11.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
                if (_loc_21.owner != this._pkg)
                {
                    _loc_11.setAttribute("pkg", _loc_21.owner.id);
                }
                _loc_11.setAttribute("src", _loc_21.id);
                _loc_11.setAttribute("name", this._-MR(_loc_11.getAttribute("id"), _loc_21.type, _loc_20));
                _loc_11.setAttribute("xy", "0,0");
                _loc_11.setAttribute("size", _loc_13 + "," + _loc_14);
                _loc_12 = XData.create("relation");
                _loc_12.setAttribute("target", "");
                if (param2 == 0)
                {
                    _loc_12.setAttribute("sidePair", "height");
                }
                else
                {
                    _loc_12.setAttribute("sidePair", "width");
                }
                _loc_11.appendChild(_loc_12);
                _loc_10.appendChild(_loc_11);
            }
            else
            {
                _loc_11 = XData.create("graph");
                _loc_11.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
                _loc_11.setAttribute("name", this._-MR(_loc_11.getAttribute("id"), "graph", _loc_20));
                _loc_11.setAttribute("xy", "0,0");
                _loc_11.setAttribute("size", _loc_13 + "," + _loc_14);
                _loc_11.setAttribute("type", "rect");
                _loc_11.setAttribute("lineSize", 0);
                _loc_11.setAttribute("fillColor", "#F0F0F0");
                _loc_11.setAttribute("touchable", false);
                _loc_12 = XData.create("relation");
                _loc_12.setAttribute("target", "");
                _loc_12.setAttribute("sidePair", "width,height");
                _loc_11.appendChild(_loc_12);
                _loc_10.appendChild(_loc_11);
            }
            _loc_11 = XData.create("graph");
            _loc_11.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
            _loc_11.setAttribute("name", "bar");
            if (param3)
            {
                if (param2 == 0)
                {
                    _loc_11.setAttribute("xy", "0," + _loc_15.y);
                    _loc_11.setAttribute("size", _loc_13 + "," + (_loc_14 - _loc_15.y * 2));
                }
                else
                {
                    _loc_11.setAttribute("xy", _loc_15.x + ",0");
                    _loc_11.setAttribute("size", _loc_13 - _loc_15.x * 2 + "," + _loc_14);
                }
            }
            else
            {
                _loc_11.setAttribute("xy", "0,0");
                _loc_11.setAttribute("size", _loc_13 + "," + _loc_14);
            }
            _loc_12 = XData.create("relation");
            _loc_12.setAttribute("target", "");
            if (param2 == 0)
            {
                _loc_12.setAttribute("sidePair", "height");
            }
            else
            {
                _loc_12.setAttribute("sidePair", "width");
            }
            _loc_11.appendChild(_loc_12);
            _loc_10.appendChild(_loc_11);
            if (param3)
            {
                _loc_11 = XData.create("component");
                _loc_11.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
                _loc_11.setAttribute("name", "arrow1");
                _loc_11.setAttribute("xy", "0,0");
                _loc_11.setAttribute("src", _loc_22.id);
                _loc_10.appendChild(_loc_11);
                _loc_11 = XData.create("component");
                _loc_11.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
                _loc_11.setAttribute("name", "arrow2");
                if (param2 == 0)
                {
                    _loc_11.setAttribute("xy", "0," + (_loc_14 - _loc_15.y));
                }
                else
                {
                    _loc_11.setAttribute("xy", _loc_13 - _loc_15.x + ",0");
                }
                _loc_11.setAttribute("src", _loc_23.id);
                _loc_12 = XData.create("relation");
                _loc_12.setAttribute("target", "");
                if (param2 == 0)
                {
                    _loc_12.setAttribute("sidePair", "bottom-bottom");
                }
                else
                {
                    _loc_12.setAttribute("sidePair", "right-right");
                }
                _loc_11.appendChild(_loc_12);
                _loc_10.appendChild(_loc_11);
            }
            _loc_11 = XData.create("component");
            _loc_11.setAttribute("id", "n" + _loc_19++ + "_" + this._serialNumberSeed);
            _loc_11.setAttribute("name", "grip");
            if (param2 == 0)
            {
                _loc_11.setAttribute("xy", "0," + _loc_15.y);
            }
            else
            {
                _loc_11.setAttribute("xy", _loc_15.x + ",0");
            }
            _loc_11.setAttribute("src", _loc_16.id);
            _loc_10.appendChild(_loc_11);
            UtilsFile.saveXData(_loc_18.file, _loc_9);
            _loc_9.dispose();
            return _loc_18;
        }// end function

        public function _-8O(param1:String, param2:String, param3:String, param4:String, param5:Boolean, param6:String) : FPackageItem
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_16:* = null;
            var _loc_17:* = null;
            if (param2)
            {
                _loc_16 = this._pkg.project.getItemByURL(param2);
                if (!_loc_16)
                {
                    throw new Error("Resource not found \'" + param2 + "\'");
                }
            }
            if (param3)
            {
                _loc_17 = this._pkg.project.getItemByURL(param3);
                if (!_loc_17)
                {
                    throw new Error("Resource not found \'" + param3 + "\'");
                }
            }
            if (_loc_16 && _loc_17)
            {
                _loc_11 = Math.max(_loc_16.width, _loc_17.width);
                _loc_12 = Math.max(_loc_16.height, _loc_17.height);
            }
            else if (_loc_16)
            {
                _loc_11 = _loc_16.width;
                _loc_12 = _loc_16.height;
            }
            else if (_loc_17)
            {
                _loc_11 = _loc_17.width;
                _loc_12 = _loc_17.height;
            }
            _loc_11 = Math.max(50, _loc_11);
            _loc_12 = Math.max(10, _loc_12);
            var _loc_13:* = this._pkg.createComponentItem(param1, _loc_11, _loc_12, param6, "ProgressBar");
            _loc_7 = this.getComponentData(_loc_13);
            _loc_8 = XData.create("displayList");
            _loc_7.appendChild(_loc_8);
            var _loc_14:* = 0;
            var _loc_15:* = {};
            if (_loc_16)
            {
                _loc_9 = XData.create(_loc_16.type);
                _loc_9.setAttribute("id", "n" + _loc_14++ + "_" + this._serialNumberSeed);
                if (_loc_16.owner != this._pkg)
                {
                    _loc_9.setAttribute("pkg", _loc_16.owner.id);
                }
                _loc_9.setAttribute("src", _loc_16.id);
                _loc_9.setAttribute("name", this._-MR(_loc_9.getAttribute("id"), _loc_16.type, _loc_15));
                _loc_9.setAttribute("xy", "0,0");
                _loc_9.setAttribute("size", _loc_11 + "," + _loc_12);
                _loc_10 = XData.create("relation");
                _loc_10.setAttribute("target", "");
                _loc_10.setAttribute("sidePair", "width,height");
                _loc_9.appendChild(_loc_10);
                _loc_8.appendChild(_loc_9);
            }
            else
            {
                _loc_9 = XData.create("graph");
                _loc_9.setAttribute("id", "n" + _loc_14++ + "_" + this._serialNumberSeed);
                _loc_9.setAttribute("name", this._-MR(_loc_9.getAttribute("id"), "graph", _loc_15));
                _loc_9.setAttribute("xy", "0,0");
                _loc_9.setAttribute("size", _loc_11 + "," + _loc_12);
                _loc_9.setAttribute("type", "rect");
                _loc_9.setAttribute("lineSize", 1);
                _loc_9.setAttribute("lineColor", "#A0A0A0");
                _loc_9.setAttribute("fillColor", "#F0F0F0");
                _loc_10 = XData.create("relation");
                _loc_10.setAttribute("target", "");
                _loc_10.setAttribute("sidePair", "width,height");
                _loc_9.appendChild(_loc_10);
                _loc_8.appendChild(_loc_9);
            }
            if (_loc_17)
            {
                _loc_9 = XData.create(_loc_17.type);
                _loc_9.setAttribute("id", "n" + _loc_14++ + "_" + this._serialNumberSeed);
                if (_loc_17.owner != this._pkg)
                {
                    _loc_9.setAttribute("pkg", _loc_17.owner.id);
                }
                _loc_9.setAttribute("src", _loc_17.id);
                _loc_9.setAttribute("name", "bar");
                _loc_9.setAttribute("xy", "0," + int((_loc_12 - _loc_17.height) / 2));
                _loc_9.setAttribute("size", _loc_11 + "," + _loc_17.height);
                _loc_8.appendChild(_loc_9);
            }
            else
            {
                _loc_9 = XData.create("graph");
                _loc_9.setAttribute("id", "n" + _loc_14++ + "_" + this._serialNumberSeed);
                _loc_9.setAttribute("name", "bar");
                _loc_9.setAttribute("xy", "0," + int((_loc_12 - 4) / 2));
                _loc_9.setAttribute("size", _loc_11 + ",4");
                _loc_9.setAttribute("type", "rect");
                _loc_9.setAttribute("lineSize", 0);
                _loc_9.setAttribute("fillColor", "#3399FF");
                _loc_8.appendChild(_loc_9);
            }
            if (param4 != "none")
            {
                _loc_9 = XData.create("text");
                _loc_9.setAttribute("id", "n" + _loc_14++ + "_" + this._serialNumberSeed);
                _loc_9.setAttribute("name", "title");
                _loc_9.setAttribute("xy", "0," + int((_loc_12 - this._-Bp()) / 2));
                _loc_9.setAttribute("size", _loc_11 + "," + _loc_12);
                _loc_9.setAttribute("autoSize", "none");
                _loc_9.setAttribute("align", "center");
                _loc_9.setAttribute("vAlign", "middle");
                _loc_9.setAttribute("fontSize", this.getFontSize());
                _loc_10 = XData.create("relation");
                _loc_10.setAttribute("target", "");
                _loc_10.setAttribute("sidePair", "width,height");
                _loc_9.appendChild(_loc_10);
                _loc_8.appendChild(_loc_9);
            }
            _loc_8 = _loc_7.getChild("ProgressBar");
            if (param4 != "none")
            {
                _loc_8.setAttribute("titleType", param4);
            }
            if (param5)
            {
                _loc_8.setAttribute("reverse", param5);
            }
            UtilsFile.saveXData(_loc_13.file, _loc_7);
            _loc_7.dispose();
            return _loc_13;
        }// end function

        private function _-I0(param1:Array) : Boolean
        {
            return !param1[0] && !param1[1] && !param1[2] && !param1[3];
        }// end function

        public function _-LD(param1:String, param2:int, param3:String, param4:String, param5:Array, param6:String, param7:String) : FPackageItem
        {
            var _loc_8:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_20:* = null;
            var _loc_21:* = null;
            if (this._-I0(param5))
            {
                if (param2 == 0)
                {
                    _loc_8 = new Point(10, 19);
                }
                else
                {
                    _loc_8 = new Point(19, 10);
                }
            }
            var _loc_9:* = this._-6u(param1 + "_grip", "Button", "Common", param5, _loc_8, false, false, false, false, false, param7);
            if (param3)
            {
                _loc_20 = this._pkg.project.getItemByURL(param3);
                if (!_loc_20)
                {
                    throw new Error("Resource not found \'" + param3 + "\'");
                }
            }
            if (param4)
            {
                _loc_21 = this._pkg.project.getItemByURL(param4);
                if (!_loc_21)
                {
                    throw new Error("Resource not found \'" + param4 + "\'");
                }
            }
            if (_loc_20 && _loc_21)
            {
                _loc_10 = Math.max(_loc_20.width, _loc_21.width);
                _loc_11 = Math.max(_loc_20.height, _loc_21.height);
            }
            else if (_loc_20)
            {
                _loc_10 = _loc_20.width;
                _loc_11 = _loc_20.height;
            }
            else if (_loc_21)
            {
                _loc_10 = _loc_21.width;
                _loc_11 = _loc_21.height;
            }
            if (param2 == 0)
            {
                _loc_10 = Math.max(50, _loc_10);
                _loc_11 = Math.max(10, _loc_11);
            }
            else
            {
                _loc_10 = Math.max(10, _loc_10);
                _loc_11 = Math.max(50, _loc_11);
            }
            var _loc_12:* = this._pkg.createComponentItem(param1, _loc_10, _loc_11, param7, "Slider");
            var _loc_13:* = this.getComponentData(_loc_12);
            var _loc_14:* = XData.create("displayList");
            _loc_13.appendChild(_loc_14);
            var _loc_17:* = 0;
            var _loc_18:* = {};
            if (_loc_20)
            {
                _loc_15 = XData.create(_loc_20.type);
                _loc_15.setAttribute("id", "n" + _loc_17++ + "_" + this._serialNumberSeed);
                if (_loc_20.owner != this._pkg)
                {
                    _loc_15.setAttribute("pkg", _loc_20.owner.id);
                }
                _loc_15.setAttribute("src", _loc_20.id);
                _loc_15.setAttribute("name", this._-MR(_loc_15.getAttribute("id"), _loc_20.type, _loc_18));
                _loc_15.setAttribute("xy", "0,0");
                _loc_15.setAttribute("size", _loc_10 + "," + _loc_11);
                _loc_16 = XData.create("relation");
                _loc_16.setAttribute("target", "");
                _loc_16.setAttribute("sidePair", "width,height");
                _loc_15.appendChild(_loc_16);
                _loc_14.appendChild(_loc_15);
            }
            else
            {
                _loc_15 = XData.create("graph");
                _loc_15.setAttribute("id", "n" + _loc_17++ + "_" + this._serialNumberSeed);
                _loc_15.setAttribute("name", this._-MR(_loc_15.getAttribute("id"), "graph", _loc_18));
                _loc_15.setAttribute("xy", "0,0");
                _loc_15.setAttribute("size", _loc_10 + "," + _loc_11);
                _loc_15.setAttribute("type", "rect");
                _loc_15.setAttribute("lineSize", 1);
                _loc_15.setAttribute("lineColor", "#A0A0A0");
                _loc_15.setAttribute("fillColor", "#F0F0F0");
                _loc_16 = XData.create("relation");
                _loc_16.setAttribute("target", "");
                _loc_16.setAttribute("sidePair", "width,height");
                _loc_15.appendChild(_loc_16);
                _loc_14.appendChild(_loc_15);
            }
            var _loc_19:* = "n" + _loc_17++ + "_" + this._serialNumberSeed;
            if (_loc_21)
            {
                _loc_15 = XData.create(_loc_21.type);
                _loc_15.setAttribute("id", _loc_19);
                if (_loc_21.owner != this._pkg)
                {
                    _loc_15.setAttribute("pkg", _loc_21.owner.id);
                }
                _loc_15.setAttribute("src", _loc_21.id);
                if (param2 == 0)
                {
                    _loc_15.setAttribute("name", "bar");
                }
                else
                {
                    _loc_15.setAttribute("name", "bar_v");
                }
                if (param2 == 0)
                {
                    _loc_15.setAttribute("xy", Math.ceil(_loc_9.width / 2) + "," + int((_loc_11 - _loc_21.height) / 2));
                    _loc_15.setAttribute("size", _loc_10 - _loc_9.width + "," + _loc_21.height);
                }
                else
                {
                    _loc_15.setAttribute("xy", int((_loc_10 - _loc_21.width) / 2) + "," + Math.ceil(_loc_9.width / 2));
                    _loc_15.setAttribute("size", _loc_21.width + "," + (_loc_11 - _loc_9.height));
                }
                _loc_14.appendChild(_loc_15);
            }
            else
            {
                _loc_15 = XData.create("graph");
                _loc_15.setAttribute("id", _loc_19);
                if (param2 == 0)
                {
                    _loc_15.setAttribute("name", "bar");
                }
                else
                {
                    _loc_15.setAttribute("name", "bar_v");
                }
                if (param2 == 0)
                {
                    _loc_15.setAttribute("xy", Math.ceil(_loc_9.width / 2) + "," + int((_loc_11 - 4) / 2));
                    _loc_15.setAttribute("size", _loc_10 - _loc_9.width + "," + 4);
                }
                else
                {
                    _loc_15.setAttribute("xy", int((_loc_10 - 4) / 2) + "," + Math.ceil(_loc_9.width / 2));
                    _loc_15.setAttribute("size", 4 + "," + (_loc_11 - _loc_9.height));
                }
                _loc_15.setAttribute("type", "rect");
                _loc_15.setAttribute("lineSize", 0);
                _loc_15.setAttribute("fillColor", "#3399FF");
                _loc_14.appendChild(_loc_15);
            }
            if (param6 != "none")
            {
                _loc_15 = XData.create("text");
                _loc_15.setAttribute("id", "n" + _loc_17++ + "_" + this._serialNumberSeed);
                _loc_15.setAttribute("name", "title");
                _loc_15.setAttribute("xy", "0," + int((_loc_11 - this._-Bp()) / 2));
                _loc_15.setAttribute("size", _loc_10 + ",16");
                _loc_15.setAttribute("autoSize", "none");
                _loc_15.setAttribute("align", "center");
                _loc_15.setAttribute("fontSize", this.getFontSize());
                _loc_16 = XData.create("relation");
                _loc_16.setAttribute("target", "");
                _loc_16.setAttribute("sidePair", "width");
                _loc_15.appendChild(_loc_16);
                _loc_14.appendChild(_loc_15);
            }
            _loc_15 = XData.create("component");
            _loc_15.setAttribute("id", "n" + _loc_17++ + "_" + this._serialNumberSeed);
            _loc_15.setAttribute("name", "grip");
            if (param2 == 0)
            {
                _loc_15.setAttribute("xy", _loc_10 - _loc_9.width + "," + int((_loc_11 - _loc_9.height) / 2));
            }
            else
            {
                _loc_15.setAttribute("xy", int((_loc_10 - _loc_9.width) / 2) + "," + (_loc_11 - _loc_9.height));
            }
            _loc_15.setAttribute("src", _loc_9.id);
            _loc_16 = XData.create("relation");
            _loc_16.setAttribute("target", _loc_19);
            if (param2 == 0)
            {
                _loc_16.setAttribute("sidePair", "right-right");
            }
            else
            {
                _loc_16.setAttribute("sidePair", "bottom-bottom");
            }
            _loc_15.appendChild(_loc_16);
            _loc_14.appendChild(_loc_15);
            _loc_14 = _loc_13.getChild("Slider");
            if (param6 != "none")
            {
                _loc_14.setAttribute("titleType", param6);
            }
            UtilsFile.saveXData(_loc_12.file, _loc_13);
            _loc_13.dispose();
            return _loc_12;
        }// end function

        public function _-7X(param1:String, param2:String, param3:Array, param4:String) : FPackageItem
        {
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_5:* = this._-6u(param1 + "_item", "Button", "Radio", param3, null, true, true, true, false, false, param4);
            var _loc_6:* = this.getComponentData(_loc_5);
            var _loc_7:* = XData.create("controller");
            _loc_7.setAttribute("name", "checked");
            _loc_7.setAttribute("pages", "0,no,1,yes");
            _loc_6.appendChild(_loc_7);
            UtilsFile.saveXData(_loc_5.file, _loc_6);
            _loc_6.dispose();
            if (param2)
            {
                _loc_14 = this._pkg.project.getItemByURL(param2);
                if (!_loc_14)
                {
                    throw new Error("Resource not found \'" + param2 + "\'");
                }
            }
            if (_loc_14)
            {
                _loc_8 = _loc_14.width;
                _loc_9 = _loc_14.height;
            }
            _loc_8 = Math.max(50, Math.max(_loc_5.width, _loc_8));
            _loc_9 = Math.max(100, _loc_9);
            var _loc_10:* = this._pkg.createComponentItem(param1, _loc_8, _loc_9, param4, null, true);
            _loc_6 = this.getComponentData(_loc_10);
            _loc_7 = XData.create("displayList");
            _loc_6.appendChild(_loc_7);
            var _loc_11:* = 0;
            var _loc_12:* = {};
            if (_loc_14 != null)
            {
                _loc_15 = XData.create(_loc_14.type);
                _loc_15.setAttribute("id", "n" + _loc_11++ + "_" + this._serialNumberSeed);
                if (_loc_14.owner != this._pkg)
                {
                    _loc_15.setAttribute("pkg", _loc_14.owner.id);
                }
                _loc_15.setAttribute("src", _loc_14.id);
                _loc_15.setAttribute("name", this._-MR(_loc_15.getAttribute("id"), _loc_14.type, _loc_12));
                _loc_15.setAttribute("xy", "0,0");
                _loc_15.setAttribute("size", _loc_8 + "," + _loc_9);
                _loc_16 = XData.create("relation");
                _loc_16.setAttribute("target", "");
                _loc_16.setAttribute("sidePair", "width,height");
                _loc_15.appendChild(_loc_16);
                _loc_7.appendChild(_loc_15);
            }
            else
            {
                _loc_15 = XData.create("graph");
                _loc_15.setAttribute("id", "n" + _loc_11++ + "_" + this._serialNumberSeed);
                _loc_15.setAttribute("name", this._-MR(_loc_15.getAttribute("id"), "graph", _loc_12));
                _loc_15.setAttribute("xy", "0,0");
                _loc_15.setAttribute("size", _loc_8 + "," + _loc_9);
                _loc_15.setAttribute("type", "rect");
                _loc_15.setAttribute("lineSize", 1);
                _loc_15.setAttribute("lineColor", "#A0A0A0");
                _loc_15.setAttribute("fillColor", "#F0F0F0");
                _loc_16 = XData.create("relation");
                _loc_16.setAttribute("target", "");
                _loc_16.setAttribute("sidePair", "width,height");
                _loc_15.appendChild(_loc_16);
                _loc_7.appendChild(_loc_15);
            }
            _loc_15 = XData.create("list");
            var _loc_13:* = "n" + _loc_11++ + "_" + this._serialNumberSeed;
            _loc_15.setAttribute("id", _loc_13);
            _loc_15.setAttribute("name", "list");
            _loc_15.setAttribute("xy", "0,0");
            _loc_15.setAttribute("size", _loc_8 + "," + _loc_9);
            _loc_15.setAttribute("defaultItem", "ui://" + _loc_5.owner.id + _loc_5.id);
            _loc_16 = XData.create("relation");
            _loc_16.setAttribute("target", "");
            _loc_16.setAttribute("sidePair", "width");
            _loc_15.appendChild(_loc_16);
            _loc_7.appendChild(_loc_15);
            _loc_7 = XData.create("relation");
            _loc_7.setAttribute("target", _loc_13);
            _loc_7.setAttribute("sidePair", "height");
            _loc_6.appendChild(_loc_7);
            UtilsFile.saveXData(_loc_10.file, _loc_6);
            _loc_6.dispose();
            return _loc_10;
        }// end function

        public function _-FE(param1:String, param2:String, param3:String, param4:Boolean, param5:Boolean, param6:String) : FPackageItem
        {
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = null;
            var _loc_18:* = null;
            if (param2)
            {
                _loc_14 = this._pkg.project.getItemByURL(param2);
                if (!_loc_14)
                {
                    throw new Error("Resource not found \'" + param2 + "\'");
                }
            }
            if (_loc_14)
            {
                _loc_7 = _loc_14.width;
                _loc_8 = _loc_14.height;
            }
            _loc_7 = Math.max(50, _loc_7);
            _loc_8 = Math.max(100, _loc_8);
            var _loc_9:* = this._pkg.createComponentItem(param1, _loc_7, _loc_8, param6, "Label", false, true);
            _loc_10 = this.getComponentData(_loc_9);
            _loc_10.setAttribute("initName", "frame");
            _loc_11 = XData.create("displayList");
            _loc_10.appendChild(_loc_11);
            var _loc_12:* = 0;
            var _loc_13:* = {};
            if (_loc_14 != null)
            {
                _loc_15 = XData.create(_loc_14.type);
                _loc_15.setAttribute("id", "n" + _loc_12++ + "_" + this._serialNumberSeed);
                if (_loc_14.owner != this._pkg)
                {
                    _loc_15.setAttribute("pkg", _loc_14.owner.id);
                }
                _loc_15.setAttribute("src", _loc_14.id);
                _loc_15.setAttribute("name", this._-MR(_loc_15.getAttribute("id"), _loc_14.type, _loc_13));
                _loc_15.setAttribute("xy", "0,0");
                _loc_15.setAttribute("size", _loc_7 + "," + _loc_8);
                _loc_16 = XData.create("relation");
                _loc_16.setAttribute("target", "");
                _loc_16.setAttribute("sidePair", "width,height");
                _loc_15.appendChild(_loc_16);
                _loc_11.appendChild(_loc_15);
            }
            if (param4)
            {
                _loc_15 = XData.create("text");
                _loc_15.setAttribute("id", "n" + _loc_12++ + "_" + this._serialNumberSeed);
                _loc_15.setAttribute("name", "title");
                _loc_15.setAttribute("xy", "0,2");
                _loc_15.setAttribute("size", _loc_7 + "," + this._-Bp());
                _loc_15.setAttribute("fontSize", this.getFontSize());
                _loc_15.setAttribute("autoSize", "none");
                _loc_15.setAttribute("align", "center");
                _loc_15.setAttribute("vAlign", "middle");
                _loc_15.setAttribute("singleLine", "true");
                _loc_16 = XData.create("relation");
                _loc_16.setAttribute("target", "");
                _loc_16.setAttribute("sidePair", "width-width");
                _loc_15.appendChild(_loc_16);
                _loc_11.appendChild(_loc_15);
            }
            if (param5)
            {
                _loc_15 = XData.create("loader");
                _loc_15.setAttribute("id", "n" + _loc_12++ + "_" + this._serialNumberSeed);
                _loc_15.setAttribute("name", "icon");
                _loc_15.setAttribute("xy", "0,0");
                _loc_15.setAttribute("size", _loc_7 + ",20");
                _loc_15.setAttribute("align", "center");
                _loc_15.setAttribute("vAlign", "middle");
                _loc_15.setAttribute("touchable", "false");
                _loc_16 = XData.create("relation");
                _loc_16.setAttribute("target", "");
                _loc_16.setAttribute("sidePair", "width-width");
                _loc_15.appendChild(_loc_16);
                _loc_11.appendChild(_loc_15);
            }
            if (param3)
            {
                _loc_17 = this._pkg.project.getItemByURL(param3);
                _loc_15 = XData.create("component");
                _loc_18 = "n" + _loc_12++ + "_" + this._serialNumberSeed;
                if (_loc_17.owner != this._pkg)
                {
                    _loc_15.setAttribute("pkg", _loc_17.owner.id);
                }
                _loc_15.setAttribute("src", _loc_17.id);
                _loc_15.setAttribute("id", _loc_18);
                _loc_15.setAttribute("name", "closeButton");
                _loc_15.setAttribute("xy", _loc_7 - _loc_17.width + ",0");
                _loc_16 = XData.create("relation");
                _loc_16.setAttribute("target", "");
                _loc_16.setAttribute("sidePair", "right-right");
                _loc_15.appendChild(_loc_16);
                _loc_11.appendChild(_loc_15);
            }
            _loc_15 = XData.create("graph");
            _loc_15.setAttribute("id", "n" + _loc_12++ + "_" + this._serialNumberSeed);
            _loc_15.setAttribute("name", "dragArea");
            _loc_15.setAttribute("xy", "0,0");
            if (_loc_17)
            {
                _loc_15.setAttribute("size", _loc_7 - _loc_17.width + ",20");
            }
            else
            {
                _loc_15.setAttribute("size", _loc_7 + ",20");
            }
            _loc_15.setAttribute("type", "empty");
            _loc_16 = XData.create("relation");
            _loc_16.setAttribute("target", "");
            _loc_16.setAttribute("sidePair", "width-width");
            _loc_15.appendChild(_loc_16);
            _loc_11.appendChild(_loc_15);
            _loc_15 = XData.create("graph");
            _loc_15.setAttribute("id", "n" + _loc_12++ + "_" + this._serialNumberSeed);
            _loc_15.setAttribute("name", "contentArea");
            _loc_15.setAttribute("xy", "0,21");
            _loc_15.setAttribute("size", _loc_7 + "," + (_loc_8 - 20));
            _loc_15.setAttribute("type", "empty");
            _loc_16 = XData.create("relation");
            _loc_16.setAttribute("target", "");
            _loc_16.setAttribute("sidePair", "width,height");
            _loc_15.appendChild(_loc_16);
            _loc_11.appendChild(_loc_15);
            UtilsFile.saveXData(_loc_9.file, _loc_10);
            _loc_10.dispose();
            return _loc_9;
        }// end function

    }
}
