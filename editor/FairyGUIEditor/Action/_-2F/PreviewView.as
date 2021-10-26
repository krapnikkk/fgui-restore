package _-2F
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class PreviewView extends GComponent
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _container:Sprite;
        private var _-Kz:PopupMenu;
        private var _item:FPackageItem;
        private var _-Q:GGraph;
        private var _previewLoader:FLoader;
        private var _-A6:GObject;
        private var _-KD:GObject;
        private var _needRefresh:Boolean;
        private var _-AQ:int;
        private var _caches:Array;

        public function PreviewView(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            this._panel = UIPackage.createObject("Builder", "PreviewView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._container = new Sprite();
            this._-Q = this._panel.getChild("holder").asGraph;
            this._-Q.setNativeObject(this._container);
            this._previewLoader = new FLoader();
            this._previewLoader._flags = FObjectFlags.ROOT;
            this._previewLoader.fill = FillConst.SCALE_SHOW_ALL;
            this._previewLoader.shrinkOnly = true;
            this._previewLoader.align = "center";
            this._previewLoader.verticalAlign = "middle";
            this._previewLoader.setSize(this._-Q.width, this._-Q.height);
            this._container.addChild(this._previewLoader.displayObject);
            this._-Q.addSizeChangeCallback(function () : void
            {
                _previewLoader.setSize(_-Q.width, _-Q.height);
                return;
            }// end function
            );
            this._-A6 = this._panel.getChild("play");
            this._-A6.visible = false;
            this._-A6.addClickListener(this._-4A);
            this._-KD = this._panel.getChild("desc");
            this._-Kz = new PopupMenu();
            this._-Kz.addItem(Consts.strings.text442, this._-D9).name = "genComPreview";
            this._-Kz.setItemCheckable("genComPreview", true);
            this._panel.getChild("option").addClickListener(function (event:Event) : void
            {
                _-Kz.show(GObject(event.currentTarget));
                return;
            }// end function
            );
            this._caches = [];
            this._editor.on(EditorEvent.ProjectOpened, this.onLoad);
            this._editor.on(EditorEvent.OnLateUpdate, this._-4v);
            this._editor.on(EditorEvent.Validate, this._-DU);
            return;
        }// end function

        private function onLoad() : void
        {
            this._-Kz.setItemChecked("genComPreview", Preferences.genComPreview);
            return;
        }// end function

        private function _-D9(event:Event) : void
        {
            Preferences.genComPreview = this._-Kz.isItemChecked("genComPreview");
            Preferences.save();
            return;
        }// end function

        private function _-DU() : void
        {
            if (this._item && this._item.type != FPackageItemType.COMPONENT)
            {
                this._item.touch();
                if (this._item.version != this._-AQ)
                {
                    this._needRefresh = true;
                    this._previewLoader.url = null;
                }
            }
            return;
        }// end function

        private function _-4v() : void
        {
            if (!this._needRefresh || !this.parent)
            {
                return;
            }
            this._needRefresh = false;
            if (!this._item || this._item.type == FPackageItemType.FOLDER)
            {
                return;
            }
            this._previewLoader._pkg = this._item.owner;
            this._item.touch();
            this._-AQ = this._item.version;
            if (this._item.type == FPackageItemType.IMAGE || this._item.type == FPackageItemType.MOVIECLIP || this._item.type == FPackageItemType.SWF)
            {
                this._previewLoader.url = "ui://" + this._item.owner.id + this._item.id;
                this._-KD.text = this._item.fileName + "    " + this._item.width + "x" + this._item.height;
            }
            else if (this._item.type == FPackageItemType.FONT)
            {
                this._previewLoader.url = this._item.getBitmapFont().getPreviewURL();
                this._-KD.text = "";
            }
            else if (this._item.type == FPackageItemType.COMPONENT)
            {
                this._previewLoader.bitmapData = this._-v(this._item);
                this._-KD.text = this._item.width + "x" + this._item.height;
            }
            else
            {
                this._previewLoader.url = null;
                this._-KD.text = this._item.fileName;
            }
            this._-A6.visible = this._item.type == FPackageItemType.SOUND;
            return;
        }// end function

        public function show(param1:FPackageItem = null) : void
        {
            if (param1 != null)
            {
                this._item = param1;
            }
            this._needRefresh = true;
            return;
        }// end function

        private function _-4A(event:Event) : void
        {
            if (this._item && this._item.type == FPackageItemType.SOUND)
            {
                this._editor.project.playSound(this._item.getURL(), 0);
            }
            return;
        }// end function

        private function _-v(param1:FPackageItem) : BitmapData
        {
            var info:Object;
            var pi:* = param1;
            if (!Preferences.genComPreview)
            {
                return null;
            }
            if (pi.getVar("generatingThumb"))
            {
                return null;
            }
            if (pi.isError || pi.isDisposed)
            {
                return null;
            }
            var now:* = getTimer();
            info = pi.getVar("componentThumb");
            if (info && info.modificationDate == pi.modificationTime && (info.timestamp == this._editor.project.lastChanged || now - info.genTime < 30000) && info.data)
            {
                return info.data;
            }
            pi.setVar("generatingThumb", true);
            var ao:* = new AsyncCreation();
            ao.callback = function (param1:FObject) : void
            {
                var _loc_5:* = 0;
                var _loc_6:* = null;
                if (!_editor.project)
                {
                    return;
                }
                pi.setVar("generatingThumb", false);
                if (!info)
                {
                    info = {};
                    pi.setVar("componentThumb", info);
                }
                else
                {
                    _loc_5 = _caches.indexOf(info);
                    if (_loc_5 != -1)
                    {
                        _caches.splice(_loc_5, 1);
                    }
                }
                if (_caches.length > 30)
                {
                    _loc_6 = _caches.shift();
                    _loc_6.data.dispose();
                    _loc_6.data = null;
                }
                _caches.push(info);
                info.modificationDate = pi.file.modificationDate.getTime();
                info.timestamp = _editor.project.lastChanged;
                info.genTime = getTimer();
                var _loc_2:* = info.data;
                if (_loc_2)
                {
                    _loc_2.dispose();
                }
                if (param1 == null || param1.width == 0 && param1.height == 0)
                {
                    info.data = new BitmapData(2, 2, true);
                    return;
                }
                var _loc_3:* = new Matrix();
                var _loc_4:* = Math.min(400 / param1.width, 400 / param1.height);
                if (Math.min(400 / param1.width, 400 / param1.height) > 1)
                {
                    _loc_4 = 1;
                }
                _loc_3.scale(_loc_4, _loc_4);
                _loc_2 = new BitmapData(Math.ceil(param1.width * _loc_4), Math.ceil(param1.height * _loc_4), true, 0);
                _loc_2.draw(param1.displayObject, _loc_3, null, null, null, true);
                info.data = _loc_2;
                param1.dispose();
                if (pi == _item)
                {
                    _previewLoader.bitmapData = _loc_2;
                }
                return;
            }// end function
            ;
            ao.createObject(pi, FObjectFlags.IN_PREVIEW | FObjectFlags.ROOT);
            return null;
        }// end function

    }
}
