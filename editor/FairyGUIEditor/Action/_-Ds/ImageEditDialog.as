package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.geom.*;
    import flash.utils.*;

    public class ImageEditDialog extends _-3g
    {
        private var _-Pd:FPackageItem;
        private var _-9K:ImageSettings;
        private var _-3j:GComponent;
        private var _-PM:Sprite;
        private var _-73:Sprite;
        private var _-Lk:Sprite;
        private var _-P6:Sprite;
        private var _container:Sprite;
        private var _-7O:FImage;
        private var _-79:GGraph;
        private var _-Gq:Controller;
        private var _-GF:Controller;
        private var _-CB:Point;
        private var _-5s:int;
        private var _-Hq:Sprite;
        private var _-JI:Point;
        private const _-Kk:int = 50;

        public function ImageEditDialog(param1:IEditor)
        {
            var _loc_2:* = null;
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "ImageEditDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._-JI = new Point();
            this._-CB = new Point();
            this._container = new Sprite();
            this._-PM = new Sprite();
            this._container.addChild(this._-PM);
            this._-73 = new Sprite();
            this._container.addChild(this._-73);
            this._-Lk = new Sprite();
            this._container.addChild(this._-Lk);
            this._-P6 = new Sprite();
            this._container.addChild(this._-P6);
            this._-PM.addEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDown);
            this._-73.addEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDown);
            this._-Lk.addEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDown);
            this._-P6.addEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDown);
            this._-79 = new GGraph();
            this._-79.setNativeObject(this._container);
            this._-3j = this.contentPane.getChild("imageContainer").asCom;
            this._-3j.addChild(this._-79);
            this._-3j.scrollPane.touchEffect = true;
            NumericInput(contentPane.getChild("quality")).max = 100;
            this._-Gq = contentPane.getController("c2");
            this._-Gq.addEventListener(StateChangeEvent.CHANGED, this._-7B);
            this._-GF = contentPane.getController("noAtlas");
            contentPane.getChild("grid0").addEventListener(_-Fr._-CF, this._-H);
            contentPane.getChild("grid1").addEventListener(_-Fr._-CF, this._-H);
            contentPane.getChild("grid2").addEventListener(_-Fr._-CF, this._-H);
            contentPane.getChild("grid3").addEventListener(_-Fr._-CF, this._-H);
            contentPane.getController("scaleOption").addEventListener(StateChangeEvent.CHANGED, this._-Dn);
            contentPane.getChild("2x").addClickListener(this._-r);
            contentPane.getChild("3x").addClickListener(this._-r);
            contentPane.getChild("4x").addClickListener(this._-r);
            this.contentPane.getChild("save").addClickListener(this._-1);
            this.contentPane.getChild("apply").addClickListener(this._-2p);
            this.contentPane.getChild("close").addClickListener(closeEventHandler);
            this.contentPane.getChild("import").addClickListener(this._-3d);
            this.contentPane.getChild("cutAlpha").addClickListener(this._-Ad);
            return;
        }// end function

        public function open(param1:FPackageItem) : void
        {
            this._-Pd = param1;
            this._-9K = param1.imageSettings;
            if (this._-7O != null)
            {
                this._container.removeChild(this._-7O.displayObject);
                this._-7O.dispose();
                this._-7O = null;
            }
            this._-7O = FImage(FObjectFactory.createObject(this._-Pd, FObjectFlags.ROOT));
            this._container.addChildAt(this._-7O.displayObject, 0);
            this.frame.text = this._-Pd.fileName;
            var _loc_2:* = this._-Pd.imageInfo.format == "svg";
            NumericInput(contentPane.getChild("width")).value = param1.width;
            NumericInput(contentPane.getChild("height")).value = param1.height;
            var _loc_5:* = _loc_2;
            NumericInput(contentPane.getChild("height")).enabled = _loc_2;
            NumericInput(contentPane.getChild("width")).enabled = _loc_5;
            contentPane.getChild("fileSize").text = "";
            contentPane.getController("scaleOption").selectedPage = this._-9K.scaleOption;
            this._-EW(this._-9K.scale9Grid.x, this._-9K.scale9Grid.y, this._-9K.scale9Grid.width, this._-9K.scale9Grid.height);
            contentPane.getController("qualityOption").selectedPage = this._-9K.qualityOption;
            contentPane.getChild("quality").text = "" + this._-9K.quality;
            var _loc_3:* = contentPane.getChild("atlas").asComboBox;
            PublishSettings(this._-Pd.owner.publishSettings).fillCombo(_loc_3);
            _loc_3.value = this._-9K.atlas;
            this._-Gq.setSelectedIndex(0);
            this._-GF.selectedIndex = _editor.project.supportAtlas ? (0) : (1);
            contentPane.getChild("smoothing").asComboBox.selectedIndex = this._-9K.smoothing ? (1) : (0);
            contentPane.getChild("duplicatePadding").asButton.selected = this._-9K.duplicatePadding;
            contentPane.getController("tileGrid").selectedIndex = this._-9K.gridTile != 0 ? (1) : (0);
            var _loc_4:* = 0;
            while (_loc_4 < 5)
            {
                
                contentPane.getChild("gridTile" + _loc_4).asButton.selected = (this._-9K.gridTile & 1 << _loc_4) != 0;
                _loc_4++;
            }
            contentPane.getController("svg").selectedIndex = _loc_2 ? (1) : (0);
            this._-Pd.getImage(this.__imageLoaded);
            show();
            return;
        }// end function

        override protected function onHide() : void
        {
            super.onHide();
            if (this._-7O != null)
            {
                this._container.removeChild(this._-7O.displayObject);
                this._-7O.dispose();
                this._-7O = null;
            }
            return;
        }// end function

        private function _-Fb() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            if (this._-7O == null)
            {
                return;
            }
            var _loc_1:* = this._-Gq.selectedIndex;
            if (_loc_1 == 0)
            {
                _loc_7 = this._-7O.width / (this._-3j.width - this._-Kk * 2);
                _loc_8 = this._-7O.height / (this._-3j.height - this._-Kk * 2);
                if (_loc_7 > 1 || _loc_8 > 1)
                {
                    _loc_4 = 1 / Math.max(_loc_7, _loc_8);
                }
                else
                {
                    _loc_4 = 1;
                }
            }
            else
            {
                _loc_4 = _loc_1 == 3 ? (4) : (_loc_1);
            }
            var _loc_9:* = _loc_4;
            this._container.scaleY = _loc_4;
            this._container.scaleX = _loc_9;
            this._-7O.setXY(this._-Kk / _loc_4, this._-Kk / _loc_4);
            _loc_2 = this._-7O.width * _loc_4;
            _loc_3 = this._-7O.height * _loc_4;
            this._-79.setSize(_loc_2 + this._-Kk * 2, _loc_3 + this._-Kk * 2);
            var _loc_5:* = int((this._-3j.width - this._-79.width) / 2);
            var _loc_6:* = int((this._-3j.height - this._-79.height) / 2);
            if (_loc_5 < 0)
            {
                _loc_5 = 0;
            }
            if (_loc_6 < 0)
            {
                _loc_6 = 0;
            }
            this._-79.setXY(_loc_5, _loc_6);
            this._-9o(this._-PM.graphics, false);
            this._-9o(this._-73.graphics, false);
            this._-9o(this._-Lk.graphics, true);
            this._-9o(this._-P6.graphics, true);
            this._-6m();
            return;
        }// end function

        private function _-9o(param1:Graphics, param2:Boolean) : void
        {
            var _loc_3:* = this._-79.width / this._container.scaleX;
            var _loc_4:* = this._-79.height / this._container.scaleY;
            param1.clear();
            param1.lineStyle(1, 0, 1);
            if (param2)
            {
                Utils.drawDashedLine(param1, 0, 0, 0, _loc_4, 4);
            }
            else
            {
                Utils.drawDashedLine(param1, 0, 0, _loc_3, 0, 4);
            }
            param1.lineStyle(0, 0, 0);
            param1.beginFill(0, 0);
            if (param2)
            {
                param1.drawRect(-2, 0, 4, _loc_4);
            }
            else
            {
                param1.drawRect(0, -2, _loc_3, 4);
            }
            param1.endFill();
            return;
        }// end function

        public function get imageItem() : FPackageItem
        {
            return this._-Pd;
        }// end function

        private function apply(param1:Boolean) : void
        {
            var _loc_3:* = 0;
            this._-9K.scaleOption = contentPane.getController("scaleOption").selectedPage;
            this._-9K.scale9Grid.x = NumericInput(contentPane.getChild("grid2")).value;
            this._-9K.scale9Grid.y = NumericInput(contentPane.getChild("grid0")).value;
            this._-9K.scale9Grid.width = this._-Pd.width - this._-9K.scale9Grid.x - NumericInput(contentPane.getChild("grid3")).value;
            this._-9K.scale9Grid.height = this._-Pd.height - this._-9K.scale9Grid.y - NumericInput(contentPane.getChild("grid1")).value;
            this._-9K.qualityOption = contentPane.getController("qualityOption").selectedPage;
            this._-9K.quality = NumericInput(contentPane.getChild("quality")).value;
            this._-9K.smoothing = contentPane.getChild("smoothing").asComboBox.selectedIndex == 1;
            this._-9K.duplicatePadding = contentPane.getChild("duplicatePadding").asButton.selected;
            var _loc_2:* = this._-Pd.imageInfo.format == "svg";
            if (_loc_2)
            {
                this._-9K.width = NumericInput(contentPane.getChild("width")).value;
                this._-9K.height = NumericInput(contentPane.getChild("height")).value;
            }
            this._-9K.gridTile = 0;
            if (contentPane.getController("tileGrid").selectedIndex == 1)
            {
                _loc_3 = 0;
                while (_loc_3 < 5)
                {
                    
                    if (contentPane.getChild("gridTile" + _loc_3).asButton.selected)
                    {
                        this._-9K.gridTile = this._-9K.gridTile | 1 << _loc_3;
                    }
                    _loc_3++;
                }
            }
            this._-9K.atlas = contentPane.getChild("atlas").asComboBox.value;
            this._-Pd.owner.save();
            this._-Pd.setChanged();
            this._-7O.validate();
            this._-Pd.getImage(this.__imageLoaded);
            _editor.emit(EditorEvent.PackageItemChanged, this._-Pd);
            _editor.closeWaiting();
            if (param1)
            {
                hide();
            }
            return;
        }// end function

        private function _-EW(param1:int, param2:int, param3:int, param4:int) : void
        {
            this._-9K.scale9Grid.x = param1;
            this._-9K.scale9Grid.y = param2;
            this._-9K.scale9Grid.width = param3;
            this._-9K.scale9Grid.height = param4;
            contentPane.getChild("grid2").text = "" + this._-9K.scale9Grid.x;
            contentPane.getChild("grid0").text = "" + this._-9K.scale9Grid.y;
            contentPane.getChild("grid3").text = "" + (this._-Pd.width - this._-9K.scale9Grid.right);
            contentPane.getChild("grid1").text = "" + (this._-Pd.height - this._-9K.scale9Grid.bottom);
            return;
        }// end function

        private function _-6m() : void
        {
            var _loc_1:* = this._-9K.scale9Grid;
            var _loc_2:* = contentPane.getController("scaleOption").selectedIndex == 1;
            this._-PM.visible = _loc_2;
            this._-73.visible = _loc_2;
            this._-Lk.visible = _loc_2;
            this._-P6.visible = _loc_2;
            this._-PM.y = _loc_1.y + this._-7O.x;
            this._-73.y = _loc_1.bottom + this._-7O.y;
            this._-Lk.x = _loc_1.x + this._-7O.x;
            this._-P6.x = _loc_1.right + this._-7O.y;
            return;
        }// end function

        private function _-H(event:Event) : void
        {
            this._-9K.scale9Grid.x = parseInt(contentPane.getChild("grid2").text);
            this._-9K.scale9Grid.y = parseInt(contentPane.getChild("grid0").text);
            this._-9K.scale9Grid.width = this._-Pd.width - this._-9K.scale9Grid.x - parseInt(contentPane.getChild("grid3").text);
            this._-9K.scale9Grid.height = this._-Pd.height - this._-9K.scale9Grid.y - parseInt(contentPane.getChild("grid1").text);
            this._-6m();
            return;
        }// end function

        private function _-Dn(event:Event) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            this._-9K.scaleOption = contentPane.getController("scaleOption").selectedPage;
            if (this._-9K.scaleOption == ImageSettings.SCALE_9GRID && this._-9K.scale9Grid.isEmpty())
            {
                _loc_2 = Math.ceil(this._-Pd.width / 4);
                _loc_3 = Math.ceil(this._-Pd.height / 4);
                this._-EW(_loc_2, _loc_3, _loc_2 * 2, _loc_3 * 2);
            }
            this._-6m();
            return;
        }// end function

        private function _-1(event:Event) : void
        {
            this.apply(true);
            return;
        }// end function

        private function _-2p(event:Event) : void
        {
            this.apply(false);
            return;
        }// end function

        private function _-3d(event:Event) : void
        {
            _editor.libView.showUpdateResourceDialog(this._-Pd);
            return;
        }// end function

        private function __mouseDown(event:MouseEvent) : void
        {
            event.stopPropagation();
            this._-Hq = Sprite(event.currentTarget);
            this._-JI.x = this._-Hq.x;
            this._-JI.y = this._-Hq.y;
            this._-CB.x = this._container.mouseX;
            this._-CB.y = this._container.mouseY;
            this._-5s = getTimer();
            displayObject.stage.addEventListener(MouseEvent.MOUSE_UP, this.__mouseUp);
            displayObject.addEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            return;
        }// end function

        private function __mouseUp(event:MouseEvent) : void
        {
            if (this._-Hq)
            {
                event.stopPropagation();
                this._-Hq = null;
                displayObject.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__mouseUp);
                displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            }
            return;
        }// end function

        private function __mouseMove(event:MouseEvent) : void
        {
            if (!this._-Hq || this._-5s && getTimer() - this._-5s < 100)
            {
                return;
            }
            var _loc_2:* = this._container.mouseX - this._-CB.x;
            var _loc_3:* = this._container.mouseY - this._-CB.y;
            if (this._-Hq == this._-PM || this._-Hq == this._-73)
            {
                this._-Hq.y = Math.min(this._-7O.height + this._-7O.y, Math.max(this._-7O.y, this._-JI.y + _loc_3));
            }
            else if (this._-Hq == this._-Lk || this._-Hq == this._-P6)
            {
                this._-Hq.x = Math.min(this._-7O.width + this._-7O.x, Math.max(this._-7O.x, this._-JI.x + _loc_2));
            }
            this._-EW(Math.min(this._-Lk.x, this._-P6.x) - this._-7O.x, Math.min(this._-PM.y, this._-73.y) - this._-7O.y, Math.abs(this._-Lk.x - this._-P6.x), Math.abs(this._-PM.y - this._-73.y));
            return;
        }// end function

        private function _-7B(event:Event) : void
        {
            this._-Fb();
            return;
        }// end function

        private function __imageLoaded(param1:FPackageItem) : void
        {
            var pi:* = param1;
            if (pi == this._-Pd)
            {
                try
                {
                    if (!this._-Pd.file.exists)
                    {
                        contentPane.getChild("fileSize").text = "0";
                    }
                    else if (this._-Pd.file == this._-Pd.imageInfo.file || this._-Pd.imageInfo.file == null)
                    {
                        contentPane.getChild("fileSize").text = UtilsStr.getSizeName(this._-Pd.file.size);
                    }
                    else
                    {
                        contentPane.getChild("fileSize").text = UtilsStr.getSizeName(this._-Pd.file.size) + " => " + UtilsStr.getSizeName(this._-Pd.imageInfo.file.size);
                    }
                }
                catch (err:Error)
                {
                    _editor.consoleView.logError(null, err);
                }
                this._-Fb();
            }
            return;
        }// end function

        private function _-Ad(event:Event) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_2:* = this._-Pd.image;
            if (_loc_2 == null || !_loc_2.transparent)
            {
                return;
            }
            var _loc_3:* = _loc_2.getColorBoundsRect(4278190080, 0, false);
            if (!_loc_3.isEmpty() && !_loc_3.equals(_loc_2.rect))
            {
                _loc_4 = new BitmapData(_loc_3.width, _loc_3.height, _loc_2.transparent, 0);
                _loc_4.copyPixels(_loc_2, _loc_3, new Point(0, 0));
                _loc_2.dispose();
                _loc_2 = _loc_4;
                _loc_5 = _loc_2.encode(_loc_2.rect, new PNGEncoderOptions());
                UtilsFile.saveBytes(this._-Pd.file, _loc_5);
                this._-Pd.setChanged();
                this._-Pd.owner.setChanged();
                this._-7O.validate();
            }
            return;
        }// end function

        private function _-r(event:Event) : void
        {
            var _loc_2:* = this._-Pd.name + "@" + event.currentTarget.name;
            var _loc_3:* = parseInt(event.currentTarget.name.substr(0, 1));
            var _loc_4:* = this._-Pd.owner.getItemByName(this._-Pd.parent, _loc_2);
            if (this._-Pd.owner.getItemByName(this._-Pd.parent, _loc_2) && _loc_4.file.extension.toLowerCase() == "svg")
            {
                _loc_4.imageSettings.width = this._-Pd.width * _loc_3;
                _loc_4.imageSettings.height = this._-Pd.height * _loc_3;
                _loc_4.owner.save();
                _loc_4.setChanged();
                return;
            }
            _editor.cursorManager.setWaitCursor(true);
            var _loc_5:* = File.createTempFile();
            _editor.project.asyncRequest("svgToPng", {sourceFile:this._-Pd.file.nativePath, targetFile:_loc_5.nativePath + ".png", width:this._-Pd.width * _loc_3, height:this._-Pd.height * _loc_3, resName:_loc_2}, this._-Ke, this._-NC);
            return;
        }// end function

        private function _-Ke(param1:Object) : void
        {
            var callback:Callback;
            var data:* = param1;
            _editor.cursorManager.setWaitCursor(false);
            callback = new Callback();
            callback.success = function () : void
            {
                return;
            }// end function
            ;
            callback.failed = function () : void
            {
                _editor.alert(callback.msgs.join("\n"));
                return;
            }// end function
            ;
            var item:* = this._-Pd.owner.getItemByName(this._-Pd.parent, data.resName);
            if (item)
            {
                this._-Pd.owner.updateResource(item, new File(data.targetFile), callback);
            }
            else
            {
                _editor.importResource(this._-Pd.owner).add(new File(data.targetFile), this._-Pd.path, data.resName + ".png").process();
            }
            return;
        }// end function

        private function _-NC(param1:String, param2:Object) : void
        {
            _editor.cursorManager.setWaitCursor(false);
            UtilsFile.deleteFile(new File(param2.targetFile));
            _editor.consoleView.logError(param1);
            return;
        }// end function

    }
}
