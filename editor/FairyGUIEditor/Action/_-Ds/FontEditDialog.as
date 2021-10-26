package _-Ds
{
    import *.*;
    import _-2F.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;

    public class FontEditDialog extends _-3g
    {
        private var _-Cx:FPackageItem;
        private var _-Pd:FPackageItem;
        private var _container:Sprite;
        private var _bitmap:Bitmap;
        private var _-3x:GGraph;
        private var _ttf:Boolean;
        private var _list:GList;

        public function FontEditDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "FontEditDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._list = contentPane.getChild("list").asList;
            this._list.addEventListener(ItemEvent.CLICK, this.__clickItem);
            this._bitmap = new Bitmap();
            this._-3x = new GGraph();
            this._-3x.setNativeObject(this._bitmap);
            contentPane.getChild("imageContainer").asCom.addChild(this._-3x);
            this.contentPane.getChild("fontTexture").asLabel.editable = false;
            contentPane.getChild("save").addClickListener(this._-Dd);
            contentPane.getChild("apply").addClickListener(this._-2p);
            contentPane.getChild("deleteChar").addClickListener(this._-Iy);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            this.addEventListener(DropEvent.DROP, this._-G6);
            return;
        }// end function

        public function open(param1:FPackageItem) : void
        {
            var content:String;
            var lines:Array;
            var lineCount:int;
            var i:int;
            var kv:Object;
            var str:String;
            var arr:Array;
            var j:int;
            var arr2:Array;
            var pi:* = param1;
            show();
            this._-Cx = pi;
            this.frame.text = this._-Cx.name;
            this._list.removeChildrenToPool();
            var xadvance:int;
            var size:int;
            var resizable:Boolean;
            var colored:Boolean;
            try
            {
                content = UtilsFile.loadString(pi.file);
                if (content == null)
                {
                    return;
                }
                lines = content.split("\n");
                lineCount = lines.length;
                kv;
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
                        if (str == "char")
                        {
                            this._-MS(kv);
                        }
                        else if (str == "info")
                        {
                            this._ttf = kv.face != null;
                            colored = this._ttf;
                            size = kv.size;
                            resizable = kv.resizable == "true";
                            if (kv.colored != undefined)
                            {
                                colored = kv.colored == "true";
                            }
                        }
                        else if (str == "common")
                        {
                            if (size == 0)
                            {
                                size = kv.lineHeight;
                            }
                            xadvance = kv.xadvance;
                        }
                    }
                    i = (i + 1);
                }
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
                return;
            }
            this.contentPane.getChild("size").text = "" + int(size);
            this.contentPane.getChild("xadvance").text = "" + int(xadvance);
            this.contentPane.getChild("resizable").asButton.selected = resizable;
            this.contentPane.getChild("colored").asButton.selected = colored;
            this.contentPane.getController("ttf").selectedIndex = this._ttf ? (1) : (0);
            this._bitmap.bitmapData = null;
            if (this._-Pd)
            {
                this._-Pd.releaseRef();
            }
            this._-Pd = null;
            if (this._-Cx.fontSettings.texture)
            {
                this.contentPane.getChild("atlas").visible = true;
                this.contentPane.getChild("fontTexture").text = "ui://" + this._-Cx.owner.id + this._-Cx.fontSettings.texture;
                this._-Pd = this._-Cx.owner.getItem(this._-Cx.fontSettings.texture);
                if (this._-Pd)
                {
                    this._-Pd.addRef();
                    this._-Pd.getImage(this.__imageLoaded);
                }
            }
            else
            {
                this.contentPane.getChild("atlas").visible = false;
            }
            return;
        }// end function

        override protected function onHide() : void
        {
            super.onHide();
            if (this._-Pd)
            {
                this._-Pd.releaseRef();
                this._-Pd = null;
            }
            return;
        }// end function

        private function _-MS(param1:Object) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = this._list.addItemFromPool().asCom;
            _loc_2.name = param1.img ? (param1.img) : ("");
            if (this._ttf)
            {
                _loc_2.getChild("res").text = "";
            }
            else
            {
                _loc_3 = this._-Cx.owner.getItem(param1.img);
                if (_loc_3)
                {
                    _loc_2.getChild("res").text = _loc_3.name;
                }
                else
                {
                    _loc_2.getChild("res").text = "";
                }
            }
            _loc_2.getChild("char").text = String.fromCharCode(param1.id);
            _loc_2.getChild("xoffset").text = "" + int(param1.xoffset);
            _loc_2.getChild("yoffset").text = "" + int(param1.yoffset);
            _loc_2.getChild("xadvance").text = "" + int(param1.xadvance);
            ListItemInput(_loc_2.getChild("char")).enabled = !this._ttf;
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            if (this._ttf)
            {
                return;
            }
            if (this._-Pd)
            {
                this._-Pd.releaseRef();
                this._-Pd = null;
            }
            var _loc_2:* = event.itemObject.name;
            if (_loc_2)
            {
                this._-Pd = this._-Cx.owner.getItem(_loc_2);
                if (this._-Pd)
                {
                    this._-Pd.addRef();
                    this._-Pd.getImage(this.__imageLoaded);
                }
            }
            else
            {
                this._bitmap.bitmapData = null;
                this.contentPane.getChild("imageInfo").text = "";
            }
            return;
        }// end function

        private function __imageLoaded(param1:FPackageItem) : void
        {
            var _loc_2:* = param1.image;
            if (!_loc_2)
            {
                return;
            }
            this._bitmap.bitmapData = _loc_2;
            this._-3x.width = _loc_2.width;
            this._-3x.height = _loc_2.height;
            this.contentPane.getChild("imageInfo").text = _loc_2.width + "x" + _loc_2.height;
            return;
        }// end function

        private function _-Iy(event:Event) : void
        {
            var _loc_2:* = this._list.selectedIndex;
            if (_loc_2 != -1)
            {
                this._list.removeChildToPoolAt(_loc_2);
                _loc_2 = Math.min(_loc_2, this._list.numChildren);
                this._list.selectedIndex = _loc_2;
            }
            return;
        }// end function

        private function _-Dd(event:Event) : void
        {
            this._-2p(event);
            this.hide();
            return;
        }// end function

        private function _-2p(event:Event) : void
        {
            var _loc_6:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = 0;
            var _loc_18:* = 0;
            var _loc_19:* = 0;
            var _loc_2:* = parseInt(this.contentPane.getChild("size").text);
            var _loc_3:* = parseInt(this.contentPane.getChild("xadvance").text);
            var _loc_4:* = this.contentPane.getChild("resizable").asButton.selected;
            var _loc_5:* = this.contentPane.getChild("colored").asButton.selected;
            var _loc_7:* = this._-Cx.file;
            if (this._ttf)
            {
                _loc_8 = UtilsFile.loadString(_loc_7);
                _loc_9 = _loc_8.split("\n");
                _loc_6 = _loc_9[0];
                _loc_6 = UtilsStr.trim(_loc_6);
                _loc_13 = _loc_6.indexOf("resizable=");
                if (_loc_13 != -1)
                {
                    _loc_10 = _loc_6.indexOf(" ", _loc_13);
                    if (_loc_10 == -1)
                    {
                        _loc_10 = _loc_6.length;
                    }
                    _loc_6 = _loc_6.substring(0, _loc_13 + 10) + _loc_4 + _loc_6.substring(_loc_10);
                }
                else if (_loc_4)
                {
                    _loc_6 = _loc_6 + " resizable=" + _loc_4;
                }
                _loc_13 = _loc_6.indexOf("colored=");
                if (_loc_13 != -1)
                {
                    _loc_10 = _loc_6.indexOf(" ", _loc_13);
                    if (_loc_10 == -1)
                    {
                        _loc_10 = _loc_6.length;
                    }
                    _loc_6 = _loc_6.substring(0, _loc_13 + 8) + _loc_5 + _loc_6.substring(_loc_10);
                }
                else
                {
                    _loc_6 = _loc_6 + " colored=" + _loc_5;
                }
                _loc_9[0] = _loc_6;
                _loc_12 = new FileStream();
                _loc_12.open(_loc_7, FileMode.WRITE);
                _loc_12.writeUTFBytes(_loc_9.join("\n"));
                _loc_12.close();
            }
            else
            {
                _loc_11 = this._list.numChildren;
                _loc_12 = new FileStream();
                _loc_12.open(_loc_7, FileMode.WRITE);
                if (_loc_4 && _loc_2 == 0)
                {
                    _loc_2 = 12;
                }
                _loc_6 = "info creator=UIBuilder";
                if (_loc_2)
                {
                    _loc_6 = _loc_6 + (" size=" + _loc_2);
                }
                if (_loc_4)
                {
                    _loc_6 = _loc_6 + " resizable=true";
                }
                if (_loc_5 && !this._ttf)
                {
                    _loc_6 = _loc_6 + " colored=true";
                }
                else if (!_loc_5 && this._ttf)
                {
                    _loc_6 = _loc_6 + " colored=false";
                }
                _loc_12.writeUTFBytes(_loc_6 + "\n");
                if (_loc_3 != 0)
                {
                    _loc_6 = "common xadvance=" + _loc_3;
                    _loc_12.writeUTFBytes(_loc_6 + "\n");
                }
                _loc_13 = 0;
                while (_loc_13 < _loc_11)
                {
                    
                    _loc_14 = this._list.getChildAt(_loc_13).asCom;
                    _loc_15 = _loc_14.name;
                    _loc_16 = _loc_14.getChild("char").text;
                    if (!_loc_15 || !_loc_16)
                    {
                    }
                    else
                    {
                        _loc_17 = parseInt(_loc_14.getChild("xoffset").text);
                        _loc_18 = parseInt(_loc_14.getChild("yoffset").text);
                        _loc_19 = parseInt(_loc_14.getChild("xadvance").text);
                        _loc_6 = "char id=" + String(_loc_16).charCodeAt(0) + " img=" + _loc_15 + " xoffset=" + _loc_17 + " yoffset=" + _loc_18 + " xadvance=" + _loc_19 + "\n";
                        _loc_12.writeUTFBytes(_loc_6);
                    }
                    _loc_13++;
                }
                _loc_12.close();
            }
            this._-Cx.setChanged();
            this._-Cx.owner.setChanged();
            _editor.emit(EditorEvent.PackageItemChanged, this._-Cx);
            return;
        }// end function

        private function _-G6(event:DropEvent) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_7:* = null;
            if (!(event.source is LibraryView))
            {
                return;
            }
            if (this._ttf)
            {
                return;
            }
            var _loc_2:* = event._-LE;
            var _loc_3:* = _loc_2.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_3)
            {
                
                _loc_7 = _loc_2[_loc_6];
                if (_loc_7.type != FPackageItemType.IMAGE)
                {
                    _editor.alert(Consts.strings.text78);
                    return;
                }
                if (_loc_7.owner != this._-Cx.owner)
                {
                    _editor.alert(Consts.strings.text79);
                    return;
                }
                _loc_5 = _loc_7.name.indexOf(".");
                if (_loc_5 >= 1)
                {
                    _loc_4 = _loc_7.name.charCodeAt((_loc_5 - 1));
                }
                else
                {
                    _loc_4 = _loc_7.name.charCodeAt((_loc_7.name.length - 1));
                }
                this._-MS({img:_loc_7.id, id:_loc_4, xoffset:"", yoffset:"", advance:""});
                _loc_6++;
            }
            return;
        }// end function

        override protected function handleKeyEvent(param1:_-4U) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (param1._-2h != 0)
            {
                this._list.handleArrowKey(param1._-2h);
            }
            else if (param1._-T == "0000")
            {
                _loc_2 = this._list.selectedIndex;
                if (_loc_2 != -1)
                {
                    _loc_3 = this._list.getChildAt(_loc_2).asButton;
                    _loc_4 = ListItemInput(_loc_3.getChild("char"));
                    if (_loc_4.getChild("input").displayObject != param1.target)
                    {
                        _loc_4.startEditing();
                        param1.preventDefault();
                    }
                }
            }
            return;
        }// end function

    }
}
