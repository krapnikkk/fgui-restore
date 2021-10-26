package fairygui.editor.publish
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.gui.animation.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.geom.*;

    public class _-Ac extends _-CI
    {
        private var _loadTasks:BulkTasks;

        public function _-Ac()
        {
            this._loadTasks = new BulkTasks(40);
            return;
        }// end function

        override public function run() : void
        {
            var pi:FPackageItem;
            var ani:AniDef;
            var _loc_2:* = 0;
            var _loc_3:* = _-J.items;
            while (_loc_3 in _loc_2)
            {
                
                pi = _loc_3[_loc_2];
                if (pi.type == FPackageItemType.MOVIECLIP)
                {
                    if (_-J._-O4)
                    {
                        ani = pi.getAnimation();
                        if (ani && !ani.ready && !ani.queued)
                        {
                            DecodeSupport.inst.add(ani);
                        }
                    }
                    continue;
                }
                if (pi.type == FPackageItemType.IMAGE && !pi.isError)
                {
                    this._loadTasks.addTask(this.loadImage, pi);
                }
            }
            var _loc_2:* = 0;
            var _loc_3:* = _-J._-FW;
            while (_loc_3 in _loc_2)
            {
                
                pi = _loc_3[_loc_2];
                this._loadTasks.addTask(this._-LH, pi);
            }
            if (_-J._-O4)
            {
                this._loadTasks.addTask(this._-Fy);
            }
            this._loadTasks.start(function () : void
            {
                handleHitTestImages();
                _stepCallback.callOnSuccessImmediately();
                return;
            }// end function
            );
            return;
        }// end function

        private function loadImage() : void
        {
            var _loc_1:* = FPackageItem(this._loadTasks.taskData);
            _loc_1.getImage(this.onLoaded);
            return;
        }// end function

        private function _-LH() : void
        {
            var _loc_1:* = FPackageItem(this._loadTasks.taskData);
            _loc_1.getImage(this._-5c);
            return;
        }// end function

        private function _-Fy() : void
        {
            if (DecodeSupport.inst.busy)
            {
                GTimers.inst.callLater(this._-Fy);
            }
            else
            {
                this._loadTasks.finishItem();
            }
            return;
        }// end function

        private function onLoaded(param1:FPackageItem) : void
        {
            var _loc_2:* = null;
            if (_-J._-O4 && param1.image)
            {
                if (_-J.trimImage && param1.image.transparent && param1.imageSettings.scaleOption == "none" && !param1.getVar("pubInfo.keepOriginal"))
                {
                    _loc_2 = param1.image.getColorBoundsRect(4278190080, 0, false);
                    param1.imageInfo.trimmedRect.copyFrom(_loc_2);
                }
                else
                {
                    param1.imageInfo.trimmedRect.setTo(0, 0, param1.width, param1.height);
                }
            }
            this._loadTasks.finishItem();
            return;
        }// end function

        private function _-5c(param1:FPackageItem) : void
        {
            this._loadTasks.finishItem();
            return;
        }// end function

        private function handleHitTestImages() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            for each (_loc_1 in _-J._-FW)
            {
                
                _loc_2 = _loc_1.image;
                if (!_loc_2)
                {
                    continue;
                }
                _loc_3 = new BitmapData(_loc_2.width / 2, _loc_2.height / 2, true, 0);
                _loc_4 = new Matrix();
                _loc_4.scale(0.5, 0.5);
                _loc_3.draw(_loc_2, _loc_4);
                _loc_2 = _loc_3;
                _loc_5 = _loc_2.getVector(_loc_2.rect);
                _loc_6 = _loc_5.length;
                _-J.hitTestData.writeUTF(_loc_1.id);
                _-J.hitTestData.writeInt(0);
                _-J.hitTestData.writeInt(_loc_2.width);
                _-J.hitTestData.writeByte(2);
                _-J.hitTestData.writeInt(Math.ceil(_loc_6 / 8));
                _loc_2.dispose();
                _loc_7 = 0;
                _loc_8 = 0;
                _loc_9 = 0;
                while (_loc_9 < _loc_6)
                {
                    
                    if ((_loc_5[_loc_9] >> 24 & 255) > 10)
                    {
                        _loc_7 = _loc_7 + (1 << _loc_8);
                    }
                    _loc_8++;
                    if (_loc_8 == 8)
                    {
                        _-J.hitTestData.writeByte(_loc_7);
                        _loc_7 = 0;
                        _loc_8 = 0;
                    }
                    _loc_9++;
                }
                if (_loc_8 != 0)
                {
                    _-J.hitTestData.writeByte(_loc_7);
                }
            }
            return;
        }// end function

    }
}
