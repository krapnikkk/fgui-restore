package fairygui.editor.publish
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.gui.animation.*;
    import fairygui.editor.settings.*;
    import fairygui.editor.worker.*;
    import fairygui.utils.*;
    import fairygui.utils.pack.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import mx.graphics.codec.*;

    public class _-60 extends _-CI
    {
        private var _compressTasks:BulkTasks;
        private var _-8j:int;
        private var _-Je:int;
        private var _pages:Vector.<Page>;
        private var _-N3:AtlasSettings;

        public function _-60()
        {
            this._-N3 = new AtlasSettings();
            this._compressTasks = new BulkTasks(1);
            return;
        }// end function

        override public function run() : void
        {
            if (_-J._-K2.length == 0)
            {
                this.allCompleted();
            }
            else
            {
                this._-8j = 0;
                this._-HL();
            }
            return;
        }// end function

        private function allCompleted() : void
        {
            _stepCallback.callOnSuccessImmediately();
            return;
        }// end function

        private function _-3i() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this._-8j + 1;
            _loc_1._-8j = _loc_2;
            if (this._-8j >= _-J._-K2.length)
            {
                this.allCompleted();
            }
            else
            {
                this._-HL();
            }
            return;
        }// end function

        private function _-HL() : void
        {
            var _loc_2:* = null;
            var _loc_5:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_1:* = _-J._-K2[this._-8j];
            if (_loc_1.index == -1)
            {
                this._-N3.copyFrom(PublishSettings(_-J.pkg.publishSettings).atlasList[0]);
                this._-N3.packSettings.pot = !_loc_1.npot;
                this._-N3.packSettings.mof = _loc_1.mof;
                if (_loc_1.items[0].type == FPackageItemType.MOVIECLIP)
                {
                    this._-N3.packSettings.padding = 1;
                    this._-N3.packSettings.duplicatePadding = false;
                }
            }
            else
            {
                this._-N3.copyFrom(PublishSettings(_-J.pkg.publishSettings).atlasList[_loc_1.index]);
            }
            var _loc_3:* = new Vector.<NodeRect>;
            var _loc_4:* = 0;
            var _loc_6:* = this._-N3.packSettings.rotation && (_-J.project.type == ProjectType.COCOS2DX || _-J.project.type == ProjectType.COCOSCREATOR);
            var _loc_7:* = _-J.project.type == ProjectType.EGRET;
            for each (_loc_2 in _loc_1.items)
            {
                
                if (_loc_2.type == FPackageItemType.MOVIECLIP)
                {
                    _loc_8 = _loc_2.getAnimation();
                    if (_loc_8)
                    {
                        _loc_9 = 0;
                        for each (_loc_10 in _loc_8.textureList)
                        {
                            
                            if (_loc_10.exportFrame != -1)
                            {
                                _loc_11 = _loc_8.frameList[_loc_10.exportFrame].rect;
                                if (_loc_11.width == 0 && _loc_11.height == 0)
                                {
                                    continue;
                                }
                                _loc_5 = new NodeRect();
                                _loc_5.index = _loc_4;
                                _loc_5.subIndex = _loc_9;
                                _loc_5.width = _loc_11.width;
                                _loc_5.height = _loc_11.height;
                                _loc_3.push(_loc_5);
                            }
                            _loc_9++;
                        }
                    }
                }
                else if (_loc_2.width > 0 && _loc_2.height > 0)
                {
                    _loc_5 = new NodeRect();
                    _loc_5.index = _loc_4;
                    _loc_5.width = _loc_2.imageInfo.trimmedRect.width;
                    _loc_5.height = _loc_2.imageInfo.trimmedRect.height;
                    _loc_5.flags = _loc_2.imageSettings.duplicatePadding ? (NodeRect.DUPLICATE_PADDING) : (0);
                    if (_loc_6 && _loc_2.getVar("pubInfo.isFontLetter") || _loc_7 && _loc_2.imageSettings && _loc_2.imageSettings.scaleOption == ImageSettings.SCALE_9GRID)
                    {
                        _loc_5.flags = _loc_5.flags | NodeRect.NO_ROTATION;
                    }
                    _loc_3.push(_loc_5);
                }
                _loc_4++;
            }
            if (_loc_3.length == 0)
            {
                GTimers.inst.callLater(this._-JL, new Vector.<Page>);
            }
            else if (_loc_3.length == 1)
            {
                this._-PK(_loc_3[0]);
            }
            else
            {
                this.pack(_loc_3);
            }
            return;
        }// end function

        private function _-PK(param1:NodeRect) : void
        {
            var _loc_2:* = this._-N3.packSettings;
            var _loc_3:* = new Vector.<Page>;
            var _loc_4:* = param1.width;
            var _loc_5:* = param1.height;
            var _loc_6:* = _loc_2.padding;
            if (param1.duplicatePadding)
            {
                _loc_4 = _loc_4 + _loc_6;
                _loc_5 = _loc_5 + _loc_6;
            }
            if (_loc_2.pot)
            {
                _loc_4 = Utils.getNextPowerOfTwo(_loc_4);
                _loc_5 = Utils.getNextPowerOfTwo(_loc_5);
            }
            if (_loc_2.square)
            {
                var _loc_8:* = Math.max(_loc_4, _loc_5);
                _loc_5 = Math.max(_loc_4, _loc_5);
                _loc_4 = _loc_8;
            }
            if (param1.duplicatePadding)
            {
                if (!_loc_2.pot && !_loc_2.square)
                {
                    _loc_4 = _loc_4 - _loc_6;
                    _loc_5 = _loc_5 - _loc_6;
                }
                param1.x = param1.x + Math.floor(_loc_6 / 2);
                param1.y = param1.y + Math.floor(_loc_6 / 2);
            }
            var _loc_7:* = new Page();
            _loc_7.width = _loc_4;
            _loc_7.height = _loc_5;
            _loc_7.occupancy = 1;
            _loc_7.outputRects.push(param1);
            _loc_3.push(_loc_7);
            GTimers.inst.callLater(this._-JL, _loc_3);
            return;
        }// end function

        private function _-JL(param1:Vector.<Page>) : void
        {
            this._pages = param1;
            if (param1 == null || param1.length > 1 && !this._-N3.packSettings.multiPage)
            {
                _stepCallback.msgs.length = 0;
                _stepCallback.addMsg(UtilsStr.formatString(Consts.strings.text122, this._-N3.packSettings.maxWidth, this._-N3.packSettings.maxHeight));
                _stepCallback.callOnFailImmediately();
                return;
            }
            this._-4W();
            return;
        }// end function

        private function _-4W() : void
        {
            var pi:FPackageItem;
            var ao:_-4E;
            var page:Page;
            var pageIndex:int;
            var maxQuality:int;
            var bmd:BitmapData;
            var tmpBmd:BitmapData;
            var binBmd:BitmapData;
            var binIndex:int;
            var texture:AniTexture;
            var rect:NodeRect;
            var mcPage:Object;
            var mp:*;
            var tmp:Number;
            var ai:* = _-J._-K2[this._-8j];
            if (this._pages.length == 0)
            {
                this._-3i();
                return;
            }
            if (this._pages.length > 1 && _-J.project.type == ProjectType.UNITY)
            {
                pageIndex;
                mcPage;
                var _loc_2:* = 0;
                var _loc_3:* = this._pages;
                while (_loc_3 in _loc_2)
                {
                    
                    page = _loc_3[_loc_2];
                    var _loc_4:* = 0;
                    var _loc_5:* = page.outputRects;
                    while (_loc_5 in _loc_4)
                    {
                        
                        rect = _loc_5[_loc_4];
                        pi = ai.items[rect.index];
                        if (pi.type == FPackageItemType.MOVIECLIP)
                        {
                            mp = mcPage[rect.index];
                            if (mp == undefined)
                            {
                                mcPage[rect.index] = pageIndex;
                                continue;
                                continue;
                            }
                            if (mp != pageIndex)
                            {
                                _stepCallback.msgs.length = 0;
                                _stepCallback.addMsg(UtilsStr.formatString(Consts.strings.text376, pi.name));
                                _stepCallback.callOnFailImmediately();
                                return;
                            }
                        }
                    }
                    pageIndex = (pageIndex + 1);
                }
                mcPage;
            }
            var rotateMatrix:* = new Matrix();
            var extractAlpha:* = ai._-E0 && _-J.extractAlpha;
            var rotationDir:* = _-J.project.type == ProjectType.COCOS2DX || _-J.project.type == ProjectType.COCOSCREATOR || _-J.project.type == ProjectType.EGRET ? (1) : (0);
            if (_-J.project.type == ProjectType.UNITY)
            {
                ai._-E0 = true;
            }
            pageIndex;
            var _loc_2:* = 0;
            var _loc_3:* = this._pages;
            while (_loc_3 in _loc_2)
            {
                
                page = _loc_3[_loc_2];
                ao = new _-4E();
                _-J._-F8.push(ao);
                binIndex = ai.index;
                if (pageIndex == 0)
                {
                    binIndex = ai.index;
                    ao.id = ai.id;
                    ao.fileName = ai.id + (ai._-E0 ? (".png") : (".jpg"));
                }
                else
                {
                    var _loc_4:* = this;
                    _loc_4._-Je = this._-Je + 1;
                    binIndex = 100 + this._-Je++;
                    ao.id = "atlas" + binIndex;
                    ao.fileName = ai.id + "_" + pageIndex + (ai._-E0 ? (".png") : (".jpg"));
                }
                ao.width = page.width;
                ao.height = page.height;
                pageIndex = (pageIndex + 1);
                if (page.outputRects.length == 1)
                {
                    rect = page.outputRects[0];
                    pi = ai.items[0];
                    if (ai.items.length == 1 && pi.type == FPackageItemType.IMAGE && ao.width == pi.width && ao.height == pi.height && (pi.imageInfo.format == "png" || _-J.project.type != ProjectType.UNITY) && !extractAlpha)
                    {
                        if (!_-J.exportDescOnly)
                        {
                            ao.data = UtilsFile.loadBytes(pi.imageInfo.file);
                        }
                        this._-Ot(pi._-e, ai.index, _loc_3[0].outputRects[0], null, null, false);
                        continue;
                    }
                }
                binBmd = new BitmapData(page.width, page.height, true, 0);
                var _loc_4:* = 0;
                var _loc_5:* = page.outputRects;
                while (_loc_5 in _loc_4)
                {
                    
                    rect = _loc_5[_loc_4];
                    pi = ai.items[rect.index];
                    if (pi.type == FPackageItemType.MOVIECLIP)
                    {
                        texture = pi.getAnimation().textureList[rect.subIndex];
                        if (texture.bitmapData)
                        {
                            if (!_-J.exportDescOnly)
                            {
                                if (rect.rotated)
                                {
                                    rotateMatrix.identity();
                                    if (rotationDir == 0)
                                    {
                                        rotateMatrix.rotate(-90 * Math.PI / 180);
                                        rotateMatrix.translate(rect.x, rect.y + rect.height);
                                    }
                                    else
                                    {
                                        rotateMatrix.rotate(90 * Math.PI / 180);
                                        rotateMatrix.translate(rect.x + rect.width, rect.y);
                                    }
                                    binBmd.draw(texture.bitmapData, rotateMatrix);
                                }
                                else
                                {
                                    binBmd.copyPixels(texture.bitmapData, new Rectangle(0, 0, rect.width, rect.height), new Point(rect.x, rect.y));
                                }
                                if (rect.duplicatePadding)
                                {
                                    binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y, rect.width, 1), new Point(rect.x, (rect.y - 1)));
                                    binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y + rect.height - 1, rect.width, 1), new Point(rect.x, rect.y + rect.height));
                                    binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y, 1, rect.height), new Point((rect.x - 1), rect.y));
                                    binBmd.copyPixels(binBmd, new Rectangle(rect.x + rect.width - 1, rect.y, 1, rect.height), new Point(rect.x + rect.width, rect.y));
                                }
                            }
                            if (rect.rotated && rotationDir == 1)
                            {
                                tmp = rect.width;
                                rect.width = rect.height;
                                rect.height = tmp;
                            }
                            this._-Ot(pi._-e + "_" + texture.exportFrame, binIndex, rect, null, null, rect.rotated);
                        }
                        continue;
                    }
                    bmd = pi.image;
                    if (bmd != null)
                    {
                        if (!_-J.exportDescOnly)
                        {
                            if (pi.imageInfo.targetQuality > maxQuality)
                            {
                                maxQuality = pi.imageInfo.targetQuality;
                            }
                            if (rect.rotated)
                            {
                                rotateMatrix.identity();
                                rotateMatrix.translate(-pi.imageInfo.trimmedRect.x, -pi.imageInfo.trimmedRect.y);
                                if (rotationDir == 0)
                                {
                                    rotateMatrix.rotate(-90 * Math.PI / 180);
                                    rotateMatrix.translate(rect.x, rect.y + rect.height);
                                }
                                else
                                {
                                    rotateMatrix.rotate(90 * Math.PI / 180);
                                    rotateMatrix.translate(rect.x + rect.width, rect.y);
                                }
                                binBmd.draw(bmd, rotateMatrix);
                            }
                            else
                            {
                                binBmd.copyPixels(bmd, new Rectangle(pi.imageInfo.trimmedRect.x, pi.imageInfo.trimmedRect.y, rect.width, rect.height), new Point(rect.x, rect.y));
                            }
                            if (rect.duplicatePadding)
                            {
                                binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y, rect.width, 1), new Point(rect.x, (rect.y - 1)));
                                binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y + rect.height - 1, rect.width, 1), new Point(rect.x, rect.y + rect.height));
                                binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y, 1, rect.height), new Point((rect.x - 1), rect.y));
                                binBmd.copyPixels(binBmd, new Rectangle(rect.x + rect.width - 1, rect.y, 1, rect.height), new Point(rect.x + rect.width, rect.y));
                            }
                        }
                        if (rect.rotated && rotationDir == 1)
                        {
                            tmp = rect.width;
                            rect.width = rect.height;
                            rect.height = tmp;
                        }
                        this._-Ot(pi._-e, binIndex, rect, pi.imageInfo.trimmedRect.topLeft, new Point(pi.width, pi.height), rect.rotated);
                    }
                }
                if (!_-J.exportDescOnly)
                {
                    binBmd.threshold(binBmd, binBmd.rect, new Point(0, 0), "<", 50331648, 0, 4278190080, true);
                    if (extractAlpha)
                    {
                        tmpBmd = new BitmapData(binBmd.width, binBmd.height, false, 0);
                        tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
                        tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
                        tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.BLUE);
                        try
                        {
                            ao._-8I = new PNGEncoder().encode(tmpBmd);
                        }
                        catch (err:Error)
                        {
                            _stepCallback.msgs.length = 0;
                            _-J.project.editor.consoleView.logError(null, err);
                            _stepCallback.addMsg("Create atlas failed");
                            _stepCallback.callOnFailImmediately();
                            return;
                        }
                        tmpBmd.dispose();
                        tmpBmd;
                    }
                    if (!ai._-E0 || extractAlpha)
                    {
                        tmpBmd = new BitmapData(binBmd.width, binBmd.height, false, 0);
                        tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.RED, BitmapDataChannel.RED);
                        tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
                        tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
                        binBmd.dispose();
                        binBmd = tmpBmd;
                        tmpBmd;
                    }
                    if (ai._-E0)
                    {
                        if (this._-N3.compression)
                        {
                            this._compressTasks.addTask(this._-C0, [ao, binBmd]);
                        }
                        else
                        {
                            try
                            {
                                ao.data = new PNGEncoder().encode(binBmd);
                            }
                            catch (err:Error)
                            {
                                _stepCallback.msgs.length = 0;
                                _-J.project.editor.consoleView.logError(null, err);
                                _stepCallback.addMsg("Create atlas failed");
                                _stepCallback.callOnFailImmediately();
                                return;
                            }
                            binBmd.dispose();
                            binBmd;
                        }
                        continue;
                    }
                    if (maxQuality == 0)
                    {
                        maxQuality;
                    }
                    ao.data = new JPEGEncoder(maxQuality).encode(binBmd);
                    binBmd.dispose();
                    binBmd;
                }
            }
            if (this._compressTasks.itemCount > 0)
            {
                this._compressTasks.start(this._-3i);
            }
            else
            {
                this._-3i();
            }
            return;
        }// end function

        private function _-C0() : void
        {
            var ao:_-4E;
            var callback:Callback;
            ao = _-4E(this._compressTasks.taskData[0]);
            var binBmd:* = BitmapData(this._compressTasks.taskData[1]);
            callback = new Callback();
            callback.success = function () : void
            {
                BitmapData(callback.result[0]).dispose();
                ao.data = ByteArray(callback.result[1]);
                _compressTasks.finishItem();
                return;
            }// end function
            ;
            callback.failed = function () : void
            {
                _stepCallback.msgs.length = 0;
                _stepCallback.addMsgs(callback.msgs);
                _compressTasks.clear();
                _stepCallback.callOnFailImmediately();
                return;
            }// end function
            ;
            ImageTool.compressBitmapData(binBmd, callback);
            return;
        }// end function

        private function _-Ot(param1:String, param2:int, param3:NodeRect, param4:Point, param5:Point, param6:Boolean) : void
        {
            var _loc_7:* = null;
            var _loc_9:* = null;
            if (_-J.trimImage && param4 != null)
            {
                _loc_7 = [param1, param2, param3.x, param3.y, param3.width, param3.height, param6 ? (1) : (0), param4.x, param4.y, param5.x, param5.y];
            }
            else
            {
                _loc_7 = [param1, param2, param3.x, param3.y, param3.width, param3.height, param6 ? (1) : (0)];
            }
            _-J._-Fc.push(_loc_7);
            var _loc_8:* = _-J._-BD[param1];
            if (_-J._-BD[param1])
            {
                _loc_9 = _loc_7.concat();
                _loc_9[0] = _loc_8.id;
                _-J._-Fc.push(_loc_9);
            }
            return;
        }// end function

        private function pack(param1:Vector.<NodeRect>) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = new ByteArray();
            _loc_3.shareable = true;
            var _loc_4:* = param1.length;
            _loc_3.writeInt(_loc_4);
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_2 = param1[_loc_5];
                _loc_3.writeInt(_loc_2.index);
                _loc_3.writeInt(_loc_2.subIndex);
                _loc_3.writeInt(_loc_2.x);
                _loc_3.writeInt(_loc_2.y);
                _loc_3.writeInt(_loc_2.width);
                _loc_3.writeInt(_loc_2.height);
                _loc_3.writeInt(_loc_2.flags);
                _loc_5++;
            }
            WorkerClient.inst.setSharedProperty("rects", _loc_3);
            WorkerClient.inst.setSharedProperty("settings", this._-N3.packSettings);
            _-J.project.asyncRequest("pack", null, this._-A, this._-A);
            return;
        }// end function

        private function _-A() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            if (!_-J.project)
            {
                return;
            }
            var _loc_1:* = WorkerClient.inst.getSharedProperty("rects");
            _loc_1.position = 0;
            var _loc_2:* = _loc_1.readByte();
            if (_loc_2 > 0)
            {
                _loc_3 = new Vector.<Page>;
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_5 = new Page();
                    _loc_5.width = _loc_1.readInt();
                    _loc_5.height = _loc_1.readInt();
                    _loc_5.outputRects = new Vector.<NodeRect>;
                    _loc_3.push(_loc_5);
                    _loc_6 = _loc_1.readInt();
                    _loc_7 = 0;
                    while (_loc_7 < _loc_6)
                    {
                        
                        _loc_8 = new NodeRect();
                        _loc_8.index = _loc_1.readInt();
                        _loc_8.subIndex = _loc_1.readInt();
                        _loc_8.x = _loc_1.readInt();
                        _loc_8.y = _loc_1.readInt();
                        _loc_8.width = _loc_1.readInt();
                        _loc_8.height = _loc_1.readInt();
                        _loc_8.flags = _loc_1.readInt();
                        _loc_8.rotated = _loc_1.readByte() == 1;
                        _loc_5.outputRects.push(_loc_8);
                        _loc_7++;
                    }
                    _loc_4++;
                }
            }
            _loc_1.clear();
            this._-JL(_loc_3);
            return;
        }// end function

    }
}
