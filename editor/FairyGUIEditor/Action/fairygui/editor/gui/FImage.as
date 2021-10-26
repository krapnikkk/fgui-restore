package fairygui.editor.gui
{
    import *.*;
    import fairygui.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class FImage extends FObject
    {
        private var _content:Bitmap;
        private var _bmdSource:BitmapData;
        private var _color:uint;
        private var _flip:String;
        private var _fillMethod:String;
        private var _fillOrigin:int;
        private var _fillClockwise:Boolean;
        private var _fillAmount:int;

        public function FImage()
        {
            this._objectType = FObjectType.IMAGE;
            this._color = 16777215;
            this._flip = "none";
            this._fillMethod = "none";
            this._fillClockwise = true;
            this._fillAmount = 100;
            this._content = new Bitmap(null, "auto", true);
            _displayObject.container.addChild(this._content);
            return;
        }// end function

        public function get color() : uint
        {
            return this._color;
        }// end function

        public function set color(param1:uint) : void
        {
            if (this._color != param1)
            {
                this._color = param1;
                this.applyColor();
                updateGear(4);
            }
            return;
        }// end function

        private function applyColor() : void
        {
            var _loc_1:* = this._content.transform.colorTransform;
            _loc_1.redMultiplier = (this._color >> 16 & 255) / 255;
            _loc_1.greenMultiplier = (this._color >> 8 & 255) / 255;
            _loc_1.blueMultiplier = (this._color & 255) / 255;
            this._content.transform.colorTransform = _loc_1;
            return;
        }// end function

        public function get flip() : String
        {
            return this._flip;
        }// end function

        public function set flip(param1:String) : void
        {
            if (this._flip != param1)
            {
                this._flip = param1;
                this.updateBitmap();
            }
            return;
        }// end function

        public function get fillOrigin() : int
        {
            return this._fillOrigin;
        }// end function

        public function set fillOrigin(param1:int) : void
        {
            if (this._fillOrigin != param1)
            {
                this._fillOrigin = param1;
                this.updateBitmap();
            }
            return;
        }// end function

        public function get fillClockwise() : Boolean
        {
            return this._fillClockwise;
        }// end function

        public function set fillClockwise(param1:Boolean) : void
        {
            if (this._fillClockwise != param1)
            {
                this._fillClockwise = param1;
                this.updateBitmap();
            }
            return;
        }// end function

        public function get fillMethod() : String
        {
            return this._fillMethod;
        }// end function

        public function set fillMethod(param1:String) : void
        {
            if (this._fillMethod != param1)
            {
                this._fillMethod = param1;
                this.updateBitmap();
            }
            return;
        }// end function

        public function get fillAmount() : int
        {
            return this._fillAmount;
        }// end function

        public function set fillAmount(param1:int) : void
        {
            if (this._fillAmount != param1)
            {
                this._fillAmount = param1;
                this.updateBitmap();
            }
            return;
        }// end function

        public function get bitmap() : Bitmap
        {
            return this._content;
        }// end function

        public function get source() : BitmapData
        {
            return this._bmdSource;
        }// end function

        override protected function handleCreate() : void
        {
            this.touchDisabled = true;
            this._bmdSource = null;
            if (!_res || _res.isMissing)
            {
                this._content.bitmapData = null;
                this.errorStatus = true;
                return;
            }
            sourceWidth = _res.sourceWidth;
            sourceHeight = _res.sourceHeight;
            setSize(sourceWidth, sourceHeight);
            aspectLocked = true;
            _res.displayItem.getImage(this.__imageLoaded);
            if ((_flags & FObjectFlags.IN_PREVIEW) == 0 && _res.displayItem.getVar("converting"))
            {
                _displayObject.setLoading(true);
            }
            return;
        }// end function

        private function __imageLoaded(param1:FPackageItem) : void
        {
            if (_disposed || _res.displayItem != param1)
            {
                return;
            }
            _displayObject.setLoading(false);
            this._bmdSource = param1.image;
            if (this._bmdSource == null)
            {
                this._content.bitmapData = null;
                this.errorStatus = true;
            }
            else
            {
                this.errorStatus = false;
                this._content.bitmapData = this._bmdSource;
                this._content.smoothing = _res.displayItem.imageSettings.smoothing;
            }
            this.handleSizeChanged();
            if ((_flags & FObjectFlags.IN_PREVIEW) == 0 && GTimers.inst.exists(this.updateBitmap2))
            {
                GTimers.inst.remove(this.updateBitmap2);
                this.updateBitmap2();
            }
            return;
        }// end function

        override public function handleSizeChanged() : void
        {
            super.handleSizeChanged();
            if (_res && _res.displayItem && (_res.displayItem.imageSettings.scaleOption == "tile" || _res.displayItem.imageSettings.scaleOption == "9grid"))
            {
                this._content.scaleX = 1;
                this._content.scaleY = 1;
            }
            else if (this._bmdSource)
            {
                this._content.scaleX = _width / this._bmdSource.width;
                this._content.scaleY = _height / this._bmdSource.height;
            }
            else
            {
                this._content.scaleX = _width / sourceWidth;
                this._content.scaleY = _height / sourceHeight;
            }
            this.updateBitmap();
            return;
        }// end function

        override protected function handleDispose() : void
        {
            if (this._content.bitmapData != null)
            {
                if (this._content.bitmapData != this._bmdSource)
                {
                    this._content.bitmapData.dispose();
                }
                this._content.bitmapData = null;
            }
            this._bmdSource = null;
            return;
        }// end function

        override public function getProp(param1:int)
        {
            if (param1 == ObjectPropID.Color)
            {
                return this.color;
            }
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            if (param1 == ObjectPropID.Color)
            {
                this.color = param2;
            }
            else
            {
                super.setProp(param1, param2);
            }
            return;
        }// end function

        override public function read_beforeAdd(param1:XData, param2:Object) : void
        {
            var _loc_3:* = null;
            super.read_beforeAdd(param1, param2);
            this._color = param1.getAttributeColor("color", false, 16777215);
            this._flip = param1.getAttribute("flip", "none");
            this._fillMethod = param1.getAttribute("fillMethod", "none");
            if (this._fillMethod != "none")
            {
                this._fillOrigin = param1.getAttributeInt("fillOrigin");
                this._fillClockwise = param1.getAttributeBool("fillClockwise", true);
                this._fillAmount = param1.getAttributeInt("fillAmount", 100);
                this.updateBitmap();
            }
            this.applyColor();
            return;
        }// end function

        override public function read_afterAdd(param1:XData, param2:Object) : void
        {
            super.read_afterAdd(param1, param2);
            if (param1.getAttributeBool("forHitTest"))
            {
                _parent.hitTestSource = this;
            }
            if (param1.getAttributeBool("forMask"))
            {
                _parent.mask = this;
            }
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_1:* = super.write();
            if (this._color != 16777215)
            {
                _loc_1.setAttribute("color", UtilsStr.convertToHtmlColor(this._color));
            }
            if (this._flip != "none")
            {
                _loc_1.setAttribute("flip", this._flip);
            }
            if (this._fillMethod != "none")
            {
                _loc_1.setAttribute("fillMethod", this._fillMethod);
                if (this._fillOrigin != 0)
                {
                    _loc_1.setAttribute("fillOrigin", this._fillOrigin);
                }
                if (!this._fillClockwise)
                {
                    _loc_1.setAttribute("fillClockwise", this.fillClockwise);
                }
                if (this._fillAmount != 100)
                {
                    _loc_1.setAttribute("fillAmount", this._fillAmount);
                }
            }
            return _loc_1;
        }// end function

        private function updateBitmap() : void
        {
            var _loc_1:* = null;
            if (this._bmdSource != null)
            {
                _loc_1 = displayObject.stage;
                if (_loc_1 && (_flags & FObjectFlags.IN_PREVIEW) == 0)
                {
                    _loc_1.addEventListener(Event.RENDER, this.__render);
                    _loc_1.invalidate();
                }
                else
                {
                    GTimers.inst.callLater(this.updateBitmap2);
                }
            }
            return;
        }// end function

        private function __render(event:Event) : void
        {
            event.currentTarget.removeEventListener(Event.RENDER, this.__render);
            this.updateBitmap2();
            return;
        }// end function

        private function updateBitmap2() : void
        {
            var _loc_7:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            if (this._bmdSource == null)
            {
                return;
            }
            var _loc_1:* = this._bmdSource;
            var _loc_2:* = _res.displayItem;
            var _loc_3:* = _loc_2.width / _res.sourceWidth;
            var _loc_4:* = _loc_2.height / _res.sourceHeight;
            var _loc_5:* = _width * _loc_3;
            var _loc_6:* = _height * _loc_4;
            if (_loc_5 <= 0 || _loc_6 <= 0)
            {
                _loc_1 = null;
            }
            else if (this._bmdSource.width != _loc_5 || this._bmdSource.height != _loc_6)
            {
                if (this._fillMethod != "none" && (_loc_2.imageSettings.scaleOption == "9grid" || _loc_2.imageSettings.scaleOption == "tile"))
                {
                    _loc_1 = new BitmapData(_loc_5, _loc_6, this._bmdSource.transparent, 0);
                    _loc_7 = new Matrix();
                    _loc_7.scale(_loc_5 / this._bmdSource.width, _loc_6 / this._bmdSource.height);
                    _loc_1.draw(this._bmdSource, _loc_7, null, null, null, _loc_2.imageSettings.smoothing);
                }
                else if (_loc_2.imageSettings.scaleOption == "9grid")
                {
                    _loc_1 = ToolSet.scaleBitmapWith9Grid(this._bmdSource, _loc_2.imageSettings.scale9Grid, _loc_5, _loc_6, _loc_2.imageSettings.smoothing, _loc_2.imageSettings.gridTile);
                }
                else if (_loc_2.imageSettings.scaleOption == "tile")
                {
                    _loc_1 = ToolSet.tileBitmap(this._bmdSource, this._bmdSource.rect, _loc_5, _loc_6);
                }
            }
            if (_loc_1 != null && this._flip != "none")
            {
                _loc_7 = new Matrix();
                _loc_9 = 1;
                _loc_10 = 1;
                if (this._flip == "both")
                {
                    _loc_7.scale(-1, -1);
                    _loc_7.translate(_loc_1.width, _loc_1.height);
                }
                else if (this._flip == "hz")
                {
                    _loc_7.scale(-1, 1);
                    _loc_7.translate(_loc_1.width, 0);
                }
                else
                {
                    _loc_7.scale(1, -1);
                    _loc_7.translate(0, _loc_1.height);
                }
                _loc_11 = new BitmapData(_loc_1.width, _loc_1.height, _loc_1.transparent, 0);
                _loc_11.draw(_loc_1, _loc_7, null, null, null, _loc_2.imageSettings.smoothing);
                if (_loc_1 != this._bmdSource)
                {
                    _loc_1.dispose();
                }
                _loc_1 = _loc_11;
            }
            if (_loc_1 != null && this._fillMethod && this._fillMethod != "none")
            {
                if (_loc_1 == this._bmdSource)
                {
                    _loc_1 = this._bmdSource.clone();
                }
                _loc_1 = ImageFillUtils.fillImage(this._fillMethod, this._fillAmount / 100, this._fillOrigin, this._fillClockwise, _loc_1);
            }
            var _loc_8:* = this._content.bitmapData;
            if (this._content.bitmapData != _loc_1)
            {
                if (_loc_8 && _loc_8 != this._bmdSource)
                {
                    _loc_8.dispose();
                }
                this._content.bitmapData = _loc_1;
                this._content.smoothing = _loc_2.imageSettings.smoothing;
            }
            this._content.width = _width;
            this._content.height = _height;
            if (!_underConstruct && _parent && !FObjectFlags.isDocRoot(_parent._flags))
            {
                if (_parent.hitTestSource == this)
                {
                    _parent.displayObject.setHitArea(this);
                }
                if (_parent.mask == this)
                {
                    _parent.displayObject.setMask(this);
                }
            }
            return;
        }// end function

    }
}
