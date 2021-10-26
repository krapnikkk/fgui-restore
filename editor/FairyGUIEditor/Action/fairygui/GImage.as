package fairygui
{
    import *.*;
    import fairygui.display.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.geom.*;

    public class GImage extends GObject
    {
        private var _bmdSource:BitmapData;
        private var _content:Bitmap;
        private var _color:uint;
        private var _flip:int;
        private var _contentItem:PackageItem;

        public function GImage()
        {
            _color = 16777215;
            return;
        }// end function

        public function get color() : uint
        {
            return _color;
        }// end function

        public function set color(param1:uint) : void
        {
            if (_color != param1)
            {
                _color = param1;
                updateGear(4);
                applyColor();
            }
            return;
        }// end function

        private function applyColor() : void
        {
            var _loc_1:* = _content.transform.colorTransform;
            _loc_1.redMultiplier = (_color >> 16 & 255) / 255;
            _loc_1.greenMultiplier = (_color >> 8 & 255) / 255;
            _loc_1.blueMultiplier = (_color & 255) / 255;
            _content.transform.colorTransform = _loc_1;
            return;
        }// end function

        public function get flip() : int
        {
            return _flip;
        }// end function

        public function set flip(param1:int) : void
        {
            if (_flip != param1)
            {
                _flip = param1;
                updateBitmap();
            }
            return;
        }// end function

        public function get texture() : BitmapData
        {
            return _bmdSource;
        }// end function

        public function set texture(param1:BitmapData) : void
        {
            _bmdSource = param1;
            handleSizeChanged();
            return;
        }// end function

        override protected function createDisplayObject() : void
        {
            _content = new UIImage(this);
            setDisplayObject(_content);
            return;
        }// end function

        override public function dispose() : void
        {
            if (_contentItem && !_contentItem.loaded)
            {
                _contentItem.owner.removeItemCallback(_contentItem, __imageLoaded);
            }
            if (_content.bitmapData != null && _content.bitmapData != _bmdSource)
            {
                _content.bitmapData.dispose();
                _content.bitmapData = null;
            }
            super.dispose();
            return;
        }// end function

        override public function constructFromResource() : void
        {
            _contentItem = packageItem.getBranch();
            sourceWidth = _contentItem.width;
            sourceHeight = _contentItem.height;
            initWidth = sourceWidth;
            initHeight = sourceHeight;
            setSize(sourceWidth, sourceHeight);
            _contentItem = _contentItem.getHighResolution();
            if (_contentItem.loaded)
            {
                __imageLoaded(_contentItem);
            }
            else
            {
                _contentItem.owner.addItemCallback(_contentItem, __imageLoaded);
            }
            return;
        }// end function

        private function __imageLoaded(param1:PackageItem) : void
        {
            if (_bmdSource != null)
            {
                return;
            }
            _bmdSource = param1.image;
            _content.bitmapData = _bmdSource;
            _content.smoothing = _contentItem.smoothing;
            handleSizeChanged();
            return;
        }// end function

        override protected function handleSizeChanged() : void
        {
            handleScaleChanged();
            updateBitmap();
            return;
        }// end function

        override protected function handleScaleChanged() : void
        {
            if (_contentItem && _contentItem.scale9Grid == null && !_contentItem.scaleByTile && _bmdSource)
            {
                _displayObject.scaleX = _width / _bmdSource.width * _scaleX;
                _displayObject.scaleY = _height / _bmdSource.height * _scaleY;
            }
            else
            {
                _displayObject.scaleX = _scaleX;
                _displayObject.scaleY = _scaleY;
            }
            return;
        }// end function

        private function updateBitmap() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_10:* = null;
            if (_bmdSource == null)
            {
                return;
            }
            var _loc_3:* = _bmdSource;
            var _loc_5:* = _contentItem.width / sourceWidth;
            var _loc_6:* = _contentItem.height / sourceHeight;
            var _loc_7:* = _width * _loc_5;
            var _loc_8:* = _height * _loc_6;
            if (_loc_7 <= 0 || _loc_8 <= 0)
            {
                _loc_3 = null;
            }
            else if (_bmdSource == _contentItem.image && (_bmdSource.width != _loc_7 || _bmdSource.height != _loc_8))
            {
                if (_contentItem.scale9Grid != null)
                {
                    _loc_3 = ToolSet.scaleBitmapWith9Grid(_bmdSource, _contentItem.scale9Grid, _loc_7, _loc_8, _contentItem.smoothing, _contentItem.tileGridIndice);
                }
                else if (_contentItem.scaleByTile)
                {
                    _loc_3 = ToolSet.tileBitmap(_bmdSource, _bmdSource.rect, _loc_7, _loc_8);
                }
            }
            if (_loc_3 != null && _flip != 0)
            {
                _loc_1 = new Matrix();
                _loc_2 = 1;
                var _loc_4:* = 1;
                if (_flip == 3)
                {
                    _loc_1.scale(-1, -1);
                    _loc_1.translate(_loc_3.width, _loc_3.height);
                }
                else if (_flip == 1)
                {
                    _loc_1.scale(-1, 1);
                    _loc_1.translate(_loc_3.width, 0);
                }
                else
                {
                    _loc_1.scale(1, -1);
                    _loc_1.translate(0, _loc_3.height);
                }
                _loc_10 = new BitmapData(_loc_3.width, _loc_3.height, _loc_3.transparent, 0);
                _loc_10.draw(_loc_3, _loc_1, null, null, null, _contentItem.smoothing);
                if (_loc_3 != _bmdSource)
                {
                    _loc_3.dispose();
                }
                _loc_3 = _loc_10;
            }
            var _loc_9:* = _content.bitmapData;
            if (_content.bitmapData != _loc_3)
            {
                if (_loc_9 && _loc_9 != _bmdSource)
                {
                    _loc_9.dispose();
                }
                _content.bitmapData = _loc_3;
                _content.smoothing = _contentItem.smoothing;
            }
            _content.width = _width;
            _content.height = _height;
            return;
        }// end function

        override public function getProp(param1:int)
        {
            if (param1 == 2)
            {
                return this.color;
            }
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            if (param1 == 2)
            {
                this.color = param2;
            }
            else
            {
                super.setProp(param1, param2);
            }
            return;
        }// end function

        override public function setup_beforeAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            super.setup_beforeAdd(param1);
            _loc_2 = param1.@color;
            if (_loc_2)
            {
                this.color = ToolSet.convertFromHtmlColor(_loc_2);
            }
            _loc_2 = param1.@flip;
            if (_loc_2)
            {
                this.flip = FlipType.parse(_loc_2);
            }
            return;
        }// end function

    }
}
