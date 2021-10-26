package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.gui.animation.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class MovieClipEditDialog extends _-3g
    {
        private var _-Cz:FPackageItem;
        private var _ani:AniDef;
        private var _container:Sprite;
        private var _-Q:GGraph;
        private var _aniSprite:AniSprite;
        private var _-BO:GComboBox;
        private var _frameLabel:GLabel;
        private var _-MI:GLabel;
        private var _-A6:GButton;
        private var _speed:GLabel;
        private var _-Bg:GLabel;
        private var _-5f:GButton;
        private var _-3U:GButton;
        private var _-69:GButton;
        private var _-LS:Boolean;

        public function MovieClipEditDialog(param1:IEditor)
        {
            var cb:GComboBox;
            var editor:* = param1;
            super(editor);
            this.contentPane = UIPackage.createObject("Builder", "MovieClipEditDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._-BO = contentPane.getChild("fps").asComboBox;
            this._-BO.addEventListener(StateChangeEvent.CHANGED, function () : void
            {
                _ani.fps = parseInt(_-BO.text);
                _-LS = true;
                return;
            }// end function
            );
            this._speed = contentPane.getChild("speed").asLabel;
            NumericInput(this._speed).min = 1;
            this._speed.addEventListener(_-Fr._-CF, function () : void
            {
                _ani.speed = parseInt(_speed.text);
                if (_ani.speed < 1)
                {
                    _ani.speed = 1;
                }
                _-LS = true;
                return;
            }// end function
            );
            this._-Bg = contentPane.getChild("repeatDelay").asLabel;
            this._-Bg.addEventListener(_-Fr._-CF, function () : void
            {
                _ani.repeatDelay = parseInt(_-Bg.text);
                _-LS = true;
                return;
            }// end function
            );
            this._-5f = contentPane.getChild("swing").asButton;
            this._-5f.addEventListener(StateChangeEvent.CHANGED, function () : void
            {
                _ani.swing = _-5f.selected;
                _-LS = true;
                return;
            }// end function
            );
            this._frameLabel = contentPane.getChild("currentFrame").asLabel;
            this._frameLabel.editable = false;
            this._frameLabel.getChild("title").asTextField.align = AlignType.Center;
            this._frameLabel.addEventListener(_-Fr._-CF, function () : void
            {
                var _loc_1:* = parseInt(_frameLabel.text);
                if (_ani.frameCount == 0)
                {
                    _loc_1 = 0;
                }
                else if (_loc_1 > _ani.frameCount)
                {
                    _loc_1 = _ani.frameCount;
                }
                else if (_loc_1 < 1)
                {
                    _loc_1 = 1;
                }
                _aniSprite.frame = _loc_1 - 1;
                return;
            }// end function
            );
            this._-MI = contentPane.getChild("frameDelay").asLabel;
            this._-MI.addEventListener(_-Fr._-CF, function () : void
            {
                if (_ani.frameCount == 0)
                {
                    return;
                }
                _ani.frameList[_aniSprite.frame].delay = parseInt(_-MI.text);
                _-LS = true;
                return;
            }// end function
            );
            this._-A6 = contentPane.getChild("play").asButton;
            this._-A6.addEventListener(StateChangeEvent.CHANGED, function () : void
            {
                _aniSprite.playing = _-A6.selected;
                return;
            }// end function
            );
            this._-3U = contentPane.getChild("prevFrame").asButton;
            this._-69 = contentPane.getChild("nextFrame").asButton;
            this._-3U.addClickListener(function () : void
            {
                if (_ani.frameCount == 0)
                {
                    return;
                }
                _aniSprite.stepPrev();
                _-5B();
                return;
            }// end function
            );
            this._-69.addClickListener(function () : void
            {
                if (_ani.frameCount == 0)
                {
                    return;
                }
                _aniSprite.stepNext();
                _-5B();
                return;
            }// end function
            );
            contentPane.getChild("btnSave").addClickListener(this._-Dd);
            contentPane.getChild("btnClose").addClickListener(closeEventHandler);
            contentPane.getChild("btnImport").addClickListener(this._-3d);
            contentPane.getChild("btnImport2").addClickListener(this._-6t);
            contentPane.getChild("btnExport").addClickListener(this._-P7);
            this._ani = new AniDef();
            this._container = new Sprite();
            this._container.mouseEnabled = false;
            this._-Q = new GGraph();
            this._-Q.setNativeObject(this._container);
            contentPane.getChild("container").asCom.addChild(this._-Q);
            contentPane.getChild("container").asCom.scrollPane.touchEffect = true;
            this._aniSprite = new AniSprite();
            this._aniSprite.mouseEnabled = false;
            this._container.addChild(this._aniSprite);
            this.addEventListener(DropEvent.DROP, this._-G6);
            return;
        }// end function

        public function open(param1:FPackageItem) : void
        {
            var cb:GComboBox;
            var pi:* = param1;
            if (this._-Cz)
            {
                this._-Cz.releaseRef();
            }
            this._-Cz = pi;
            this._-Cz.addRef();
            this._-LS = false;
            cb = contentPane.getChild("atlas").asComboBox;
            PublishSettings(this._-Cz.owner.publishSettings).fillCombo(cb);
            cb.value = this._-Cz.imageSettings.atlas;
            contentPane.getChild("smoothing").asButton.selected = this._-Cz.imageSettings.smoothing;
            this._ani.reset();
            var ba:* = UtilsFile.loadBytes(pi.file);
            if (ba != null)
            {
                try
                {
                    this._ani.load(ba);
                }
                catch (err:Error)
                {
                    _editor.alert(null, err);
                }
            }
            this._aniSprite.def = this._ani;
            this._aniSprite.playing = true;
            this._-A6.selected = true;
            this._aniSprite.clear();
            this.setActionToUI();
            GTimers.inst.add(1, 0, this._-2v);
            this.frame.text = this._-Cz.name + " - " + Consts.strings.text87;
            show();
            return;
        }// end function

        override protected function onHide() : void
        {
            super.onHide();
            if (this._-Cz)
            {
                this._-Cz.releaseRef();
                this._-Cz = null;
            }
            GTimers.inst.remove(this._-2v);
            return;
        }// end function

        private function setActionToUI() : void
        {
            this._-BO.text = "" + this._ani.fps;
            this._speed.text = "" + this._ani.speed;
            this._-Bg.text = "" + int(this._ani.repeatDelay);
            this._-5f.selected = this._ani.swing;
            this._-5B();
            var _loc_1:* = this._ani.boundsRect;
            if (_loc_1.width < this._-Q.parent.width)
            {
                this._-Q.x = -_loc_1.x + (this._-Q.parent.width - _loc_1.width) / 2;
            }
            else
            {
                this._-Q.x = -_loc_1.x;
            }
            if (_loc_1.height < this._-Q.parent.height)
            {
                this._-Q.y = -_loc_1.y + (this._-Q.parent.height - _loc_1.height) / 2;
            }
            else
            {
                this._-Q.y = -_loc_1.y;
            }
            this._-Q.setSize(_loc_1.width, _loc_1.height);
            this._-Q.parent.scrollPane.percX = 0;
            this._-Q.parent.scrollPane.percY = 0;
            return;
        }// end function

        private function _-2v() : void
        {
            if (this._aniSprite.playing)
            {
                this._-5B();
            }
            return;
        }// end function

        private function _-5B() : void
        {
            var _loc_1:* = this._aniSprite.frame;
            var _loc_2:* = "" + (_loc_1 + 1) + "/" + this._ani.frameCount;
            if (_loc_2 != this._frameLabel.text)
            {
                this._frameLabel.text = _loc_2;
            }
            if (this._aniSprite.def && _loc_1 >= 0 && _loc_1 < this._aniSprite.def.frameCount)
            {
                _loc_2 = "" + int(this._ani.frameList[_loc_1].delay);
            }
            else
            {
                _loc_2 = "0";
            }
            if (_loc_2 != this._-MI.text)
            {
                this._-MI.text = _loc_2;
            }
            return;
        }// end function

        private function _-Dd(event:Event) : void
        {
            var _loc_2:* = contentPane.getChild("atlas").asComboBox.value;
            var _loc_3:* = contentPane.getChild("smoothing").asButton.selected;
            var _loc_4:* = false;
            if (this._-Cz.imageSettings.atlas != _loc_2 || _loc_3 != this._-Cz.imageSettings.smoothing)
            {
                this._-Cz.imageSettings.atlas = _loc_2;
                this._-Cz.imageSettings.smoothing = _loc_3;
                this._-Cz.owner.save();
                _loc_4 = true;
            }
            if (this._-LS)
            {
                UtilsFile.saveBytes(this._-Cz.file, this._ani.save());
                _loc_4 = true;
            }
            if (_loc_4)
            {
                this._-Cz.setChanged();
                this._-Cz.owner.setChanged();
                _editor.emit(EditorEvent.PackageItemChanged, this._-Cz);
            }
            this.hide();
            return;
        }// end function

        private function setChanged() : void
        {
            this._-Cz.setChanged();
            this._-Cz.owner.setChanged();
            this._-LS = false;
            var _loc_1:* = this._-Cz.getAnimation();
            if (_loc_1 != this._ani)
            {
                this.open(this._-Cz);
            }
            return;
        }// end function

        private function __open(event:Event) : void
        {
            this._-Cz.file.openWithDefaultApplication();
            return;
        }// end function

        private function _-G6(event:DropEvent) : void
        {
            var callback:Callback;
            var pi:FPackageItem;
            var evt:* = event;
            if (evt.source != _editor.libView)
            {
                return;
            }
            var cnt:* = evt._-LE.length;
            var files:Array;
            var i:int;
            while (i < cnt)
            {
                
                pi = FPackageItem(evt._-LE[i]);
                if (pi.type != FPackageItemType.IMAGE)
                {
                }
                else
                {
                    files.push(pi.file);
                }
                i = (i + 1);
            }
            if (files.length == 0)
            {
                return;
            }
            callback = new Callback();
            callback.success = function () : void
            {
                _editor.closeWaiting();
                var _loc_1:* = AniDef(callback.result);
                _loc_1.copySettings(_ani);
                UtilsFile.saveBytes(_-Cz.file, _loc_1.save());
                setChanged();
                return;
            }// end function
            ;
            callback.failed = function () : void
            {
                _editor.closeWaiting();
                _editor.alert(callback.msgs.join("\n"));
                return;
            }// end function
            ;
            _editor.showWaiting(Consts.strings.text86 + "...");
            AniImporter.importImages(files, !_editor.project.supportAtlas, callback);
            return;
        }// end function

        private function _-3d(event:Event) : void
        {
            var evt:* = event;
            UtilsFile.browseForOpenMultiple(Consts.strings.text49, [new FileFilter(Consts.strings.text49, "*.jpg;*.png"), new FileFilter(Consts.strings.text48, "*.*")], function (param1:Array) : void
            {
                var callback:Callback;
                var files:* = param1;
                files.sortOn("name");
                callback = new Callback();
                callback.success = function () : void
                {
                    _editor.closeWaiting();
                    var _loc_1:* = AniDef(callback.result);
                    _loc_1.copySettings(_ani);
                    UtilsFile.saveBytes(_-Cz.file, _loc_1.save());
                    setChanged();
                    return;
                }// end function
                ;
                callback.failed = function () : void
                {
                    _editor.closeWaiting();
                    _editor.alert(callback.msgs.join("\n"));
                    return;
                }// end function
                ;
                _editor.showWaiting(Consts.strings.text86 + "...");
                AniImporter.importImages(files, !_editor.project.supportAtlas, callback);
                return;
            }// end function
            );
            return;
        }// end function

        private function _-6t(event:Event) : void
        {
            var evt:* = event;
            UtilsFile.browseForOpen(Consts.strings.text303, [new FileFilter(Consts.strings.text303, "*.eas;*.json;*.xml;*.plist")], function (param1:File) : void
            {
                var callback:Callback;
                var file:* = param1;
                callback = new Callback();
                callback.success = function () : void
                {
                    _editor.closeWaiting();
                    var _loc_1:* = AniDef(callback.result);
                    _loc_1.copySettings(_ani);
                    UtilsFile.saveBytes(_-Cz.file, _loc_1.save());
                    setChanged();
                    return;
                }// end function
                ;
                callback.failed = function () : void
                {
                    _editor.closeWaiting();
                    _editor.alert(callback.msgs.join("\n"));
                    return;
                }// end function
                ;
                _editor.showWaiting(Consts.strings.text86 + "...");
                try
                {
                    AniImporter.importSpriteSheet(file, !_editor.project.supportAtlas, callback);
                }
                catch (err:Error)
                {
                    _editor.closeWaiting();
                    _editor.alert("Import movieClip failed!", err);
                    setActionToUI();
                }
                return;
            }// end function
            );
            return;
        }// end function

        private function _-P7(event:Event) : void
        {
            var evt:* = event;
            UtilsFile.browseForDirectory(Consts.strings.text456, function (param1:File) : void
            {
                var cnt:int;
                var ordLen:int;
                var offset:Point;
                var i:int;
                var frame:AniFrame;
                var texture:AniTexture;
                var bmd:BitmapData;
                var ba:ByteArray;
                var folder:* = param1;
                _editor.cursorManager.setWaitCursor(true);
                try
                {
                    cnt = _ani.frameList.length;
                    ordLen = Math.ceil(Math.log(cnt) * Math.LOG10E);
                    offset = new Point();
                    i;
                    while (i < cnt)
                    {
                        
                        frame = _ani.frameList[i];
                        if (frame.textureIndex != -1)
                        {
                            texture = _ani.textureList[frame.textureIndex];
                            bmd = new BitmapData(_-Cz.width, _-Cz.height, true, 0);
                            offset.x = frame.rect.x;
                            offset.y = frame.rect.y;
                            bmd.copyPixels(texture.bitmapData, texture.bitmapData.rect, offset);
                            ba = bmd.encode(bmd.rect, new PNGEncoderOptions());
                            UtilsFile.saveBytes(folder.resolvePath(_-Cz.name + "_" + UtilsStr.padString("" + i, ordLen, "0") + ".png"), ba);
                            ba.clear();
                            bmd.dispose();
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
                    _editor.cursorManager.setWaitCursor(false);
                }
                return;
            }// end function
            );
            return;
        }// end function

    }
}
