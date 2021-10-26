package fairygui.editor.gui
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.gui.animation.*;
    import fairygui.utils.*;
    import fairygui.utils.loader.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.geom.*;

    public class FLoader extends FObject
    {
        public var clearOnPublish:Boolean;
        private var _url:String;
        private var _align:String;
        private var _verticalAlign:String;
        private var _autoSize:Boolean;
        private var _fill:String;
        private var _shrinkOnly:Boolean;
        private var _showErrorSign:Boolean;
        private var _playing:Boolean;
        private var _frame:int;
        private var _color:uint;
        private var _fillMethod:String;
        private var _fillOrigin:int;
        private var _fillClockwise:Boolean;
        private var _fillAmount:int;
        private var _contentSourceWidth:int;
        private var _contentSourceHeight:int;
        private var _contentWidth:int;
        private var _contentHeight:int;
        private var _bitmapData:BitmapData;
        private var _contentRes:ResourceRef;
        private var _loader:LoaderExt;
        private var _jtSprite:AniSprite;
        private var _content2:FObject;
        private var _content:Object;
        private var _errorSign:DisplayObject;
        private var _updatingLayout:Boolean;

        public function FLoader()
        {
            this._objectType = FObjectType.LOADER;
            this._playing = true;
            this._url = "";
            this._align = "left";
            this._verticalAlign = "top";
            this._fill = FillConst.NONE;
            _useSourceSize = false;
            this._color = 16777215;
            this._fillMethod = "none";
            this._fillClockwise = true;
            this._fillAmount = 100;
            this._contentRes = new ResourceRef();
            return;
        }// end function

        public function get url() : String
        {
            return this._url;
        }// end function

        public function set url(param1:String) : void
        {
            if (this._url == param1)
            {
                if (!this._url && this._content)
                {
                    this.clearContent();
                }
                return;
            }
            this._url = param1;
            this.loadContent();
            updateGear(7);
            return;
        }// end function

        override public function get icon() : String
        {
            return this._url;
        }// end function

        override public function set icon(param1:String) : void
        {
            this.url = param1;
            return;
        }// end function

        public function get align() : String
        {
            return this._align;
        }// end function

        public function set align(param1:String) : void
        {
            if (this._align != param1)
            {
                this._align = param1;
                this.updateLayout();
            }
            return;
        }// end function

        public function get verticalAlign() : String
        {
            return this._verticalAlign;
        }// end function

        public function set verticalAlign(param1:String) : void
        {
            if (this._verticalAlign != param1)
            {
                this._verticalAlign = param1;
                this.updateLayout();
            }
            return;
        }// end function

        public function get fill() : String
        {
            return this._fill;
        }// end function

        public function set fill(param1:String) : void
        {
            if (this._fill != param1)
            {
                this._fill = param1;
                this.updateLayout();
            }
            return;
        }// end function

        public function get shrinkOnly() : Boolean
        {
            return this._shrinkOnly;
        }// end function

        public function set shrinkOnly(param1:Boolean) : void
        {
            if (this._shrinkOnly != param1)
            {
                this._shrinkOnly = param1;
                this.updateLayout();
            }
            return;
        }// end function

        public function get autoSize() : Boolean
        {
            return this._autoSize;
        }// end function

        public function set autoSize(param1:Boolean) : void
        {
            if (this._autoSize != param1)
            {
                this._autoSize = param1;
                this.updateLayout();
            }
            return;
        }// end function

        public function get playing() : Boolean
        {
            return this._playing;
        }// end function

        public function set playing(param1:Boolean) : void
        {
            if (this._playing != param1)
            {
                this._playing = param1;
                if (this._content)
                {
                    if (this._content == this._jtSprite)
                    {
                        this._jtSprite.playing = this._playing;
                    }
                    else if (this._content is MovieClip)
                    {
                        MovieClip(this._content).gotoAndStop((this._frame + 1));
                    }
                }
                updateGear(5);
            }
            return;
        }// end function

        public function get frame() : int
        {
            return this._frame;
        }// end function

        public function set frame(param1:int) : void
        {
            this._frame = param1;
            if (this._content)
            {
                if (this._content == this._jtSprite)
                {
                    this._jtSprite.frame = this._frame;
                }
                else if (this._content is MovieClip)
                {
                    MovieClip(this._content).gotoAndStop(this._frame);
                }
            }
            updateGear(5);
            return;
        }// end function

        public function get showErrorSign() : Boolean
        {
            return this._showErrorSign;
        }// end function

        public function set showErrorSign(param1:Boolean) : void
        {
            this._showErrorSign = param1;
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
            var _loc_1:* = _displayObject.container.transform.colorTransform;
            _loc_1.redMultiplier = (this._color >> 16 & 255) / 255;
            _loc_1.greenMultiplier = (this._color >> 8 & 255) / 255;
            _loc_1.blueMultiplier = (this._color & 255) / 255;
            _displayObject.container.transform.colorTransform = _loc_1;
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

        public function get contentRes() : ResourceRef
        {
            return this._contentRes;
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

        public function set bitmapData(param1:BitmapData) : void
        {
            var _loc_2:* = null;
            this._url = null;
            this.clearContent();
            if (param1)
            {
                this._contentSourceWidth = param1.width;
                this._contentSourceHeight = param1.height;
                _loc_2 = new Bitmap(param1);
                _loc_2.smoothing = true;
                this.setContent(_loc_2);
            }
            return;
        }// end function

        protected function loadContent() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            this.clearContent();
            if (this._url == null || this._url.length == 0)
            {
                return;
            }
            if (UtilsStr.startsWith(this._url, "ui://"))
            {
                this._contentRes.setPackageItem(_pkg.project.getItemByURL(this._url), _flags);
                if (!this._contentRes.isMissing)
                {
                    this._contentSourceWidth = this._contentRes.sourceWidth;
                    this._contentSourceHeight = this._contentRes.sourceHeight;
                    _loc_1 = this._contentRes.displayItem;
                    if (_loc_1.type == FPackageItemType.IMAGE)
                    {
                        _loc_1.getImage(this.__imageLoaded);
                        if ((_flags & FObjectFlags.IN_PREVIEW) == 0 && _loc_1.getVar("converting"))
                        {
                            _displayObject.setLoading(true);
                        }
                    }
                    else if (_loc_1.type == FPackageItemType.MOVIECLIP)
                    {
                        _loc_2 = _loc_1.getAnimation();
                        if (_loc_2 != null)
                        {
                            if (!this._jtSprite)
                            {
                                this._jtSprite = new AniSprite();
                            }
                            this._jtSprite.def = _loc_2;
                            this._jtSprite.playing = this._playing;
                            this._jtSprite.frame = this._frame;
                            this._jtSprite.smoothing = _loc_1.imageSettings.smoothing;
                            this.setContent(this._jtSprite);
                        }
                        else
                        {
                            this.setErrorState();
                        }
                    }
                    else if (_loc_1.type == FPackageItemType.SWF)
                    {
                        if ((_flags & FObjectFlags.IN_PREVIEW) == 0)
                        {
                            EasyLoader.load(_loc_1.file.url, null, this.__swfLoaded);
                        }
                    }
                    else if (_loc_1.type == FPackageItemType.COMPONENT)
                    {
                        this._content2 = FObjectFactory.createObject(_loc_1, _flags & 255);
                        this._content2.dispatcher.on(FObject.SIZE_CHANGED, this.onContent2SizeChanged);
                        if ((_flags & FObjectFlags.IN_TEST) != 0)
                        {
                            FComponent(this._content2).playAutoPlayTransitions();
                        }
                        this.setContent(this._content2.displayObject);
                    }
                }
                else
                {
                    this.setErrorState();
                }
                return;
            }
            if ((_flags & FObjectFlags.IN_PREVIEW) == 0)
            {
                if (!this._loader)
                {
                    this._loader = new LoaderExt();
                    this._loader.addEventListener(Event.COMPLETE, this.__etcLoaded);
                    this._loader.addEventListener(ErrorEvent.ERROR, this.__etcLoadFailed);
                }
                _loc_3 = this._url;
                if (_pkg && _loc_3.indexOf("://") == -1)
                {
                    try
                    {
                        _loc_3 = new File(_pkg.project.basePath).resolvePath(_loc_3).url;
                    }
                    catch (err:Error)
                    {
                    }
                }
                this._loader.load(_loc_3, {type:"image"});
            }
            return;
        }// end function

        private function __etcLoaded(event:Event) : void
        {
            if (_disposed || this._loader == null || this._loader.content == null)
            {
                return;
            }
            this._contentSourceWidth = this._loader.content.width;
            this._contentSourceHeight = this._loader.content.height;
            if (this._loader.content is Bitmap)
            {
                Bitmap(this._loader.content).smoothing = true;
            }
            this.setContent(this._loader.content);
            return;
        }// end function

        private function __etcLoadFailed(event:Event) : void
        {
            if (_disposed)
            {
                return;
            }
            event.preventDefault();
            this.setErrorState();
            return;
        }// end function

        private function __imageLoaded(param1:FPackageItem) : void
        {
            if (_disposed || this._contentRes.displayItem != param1)
            {
                return;
            }
            _displayObject.setLoading(false);
            this._bitmapData = param1.image;
            if (this._bitmapData == null)
            {
                this.setErrorState();
                return;
            }
            var _loc_2:* = new Bitmap(this._bitmapData);
            _loc_2.smoothing = this._contentRes.displayItem.imageSettings.smoothing;
            this.setContent(_loc_2);
            return;
        }// end function

        private function __swfLoaded(param1:LoaderExt) : void
        {
            var l:* = param1;
            if (_disposed)
            {
                return;
            }
            try
            {
                this.setContent(l.content);
            }
            catch (e:Error)
            {
                setErrorState();
            }
            return;
        }// end function

        private function onContent2SizeChanged() : void
        {
            if (!this._updatingLayout)
            {
                this.updateLayout();
            }
            return;
        }// end function

        protected function setContent(param1:Object) : void
        {
            this._content = param1;
            if (!this._playing && this._content is MovieClip)
            {
                MovieClip(this._content).gotoAndStop((this._frame + 1));
            }
            if (this._content is DisplayObject)
            {
                _displayObject.container.addChild(DisplayObject(this._content));
            }
            this.updateLayout();
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

        protected function setErrorState() : void
        {
            this._contentWidth = 0;
            this._contentHeight = 0;
            this.updateLayout();
            return;
        }// end function

        protected function updateLayout() : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            if (!this._content || !(this._content is DisplayObject))
            {
                if (this._autoSize)
                {
                    this._updatingLayout = true;
                    this.setSize(50, 30);
                    this._updatingLayout = false;
                }
                return;
            }
            this._contentWidth = this._contentSourceWidth;
            this._contentHeight = this._contentSourceHeight;
            var _loc_1:* = 1;
            var _loc_2:* = 1;
            if (this._autoSize)
            {
                this._updatingLayout = true;
                if (this._contentWidth == 0)
                {
                    this._contentWidth = 50;
                }
                if (this._contentHeight == 0)
                {
                    this._contentHeight = 30;
                }
                this.setSize(this._contentWidth, this._contentHeight);
                this._updatingLayout = false;
                if (this._contentWidth == _width && this._contentHeight == _height)
                {
                    if (this._content2)
                    {
                        this._content2.setXY(0, 0);
                        this._content2.setScale(_loc_1, _loc_2);
                    }
                    else
                    {
                        this._content.x = 0;
                        this._content.y = 0;
                        if (this._bitmapData)
                        {
                            _loc_1 = _loc_1 * (this._contentSourceWidth / this._bitmapData.width);
                            _loc_2 = _loc_2 * (this._contentSourceHeight / this._bitmapData.height);
                        }
                        this._content.scaleX = _loc_1;
                        this._content.scaleY = _loc_2;
                    }
                    return;
                }
            }
            if (this._fill != FillConst.NONE && this._content != this._errorSign)
            {
                _loc_1 = _width / this._contentSourceWidth;
                _loc_2 = _height / this._contentSourceHeight;
                if (this._fill == FillConst.SCALE_MATCH_HEIGHT)
                {
                    _loc_1 = _loc_2;
                }
                else if (this._fill == FillConst.SCALE_MATCH_WIDTH)
                {
                    _loc_2 = _loc_1;
                }
                else if (this._fill == FillConst.SCALE_SHOW_ALL)
                {
                    if (_loc_1 > _loc_2)
                    {
                        _loc_1 = _loc_2;
                    }
                    else
                    {
                        _loc_2 = _loc_1;
                    }
                }
                else if (this._fill == FillConst.SCALE_NO_BORDER)
                {
                    if (_loc_1 > _loc_2)
                    {
                        _loc_2 = _loc_1;
                    }
                    else
                    {
                        _loc_1 = _loc_2;
                    }
                }
                if (this._shrinkOnly)
                {
                    if (_loc_1 > 1)
                    {
                        _loc_1 = 1;
                    }
                    if (_loc_2 > 1)
                    {
                        _loc_2 = 1;
                    }
                }
                this._contentWidth = this._contentSourceWidth * _loc_1;
                this._contentHeight = this._contentSourceHeight * _loc_2;
            }
            if (this._content2)
            {
                this._content2.setScale(_loc_1, _loc_2);
            }
            else if (this._bitmapData)
            {
                if (this._contentRes.displayItem.imageSettings.scaleOption != "9grid" && this._contentRes.displayItem.imageSettings.scaleOption != "tile")
                {
                    if (this._bitmapData)
                    {
                        _loc_1 = _loc_1 * (this._contentSourceWidth / this._bitmapData.width);
                        _loc_2 = _loc_2 * (this._contentSourceHeight / this._bitmapData.height);
                    }
                    this._content.scaleX = _loc_1;
                    this._content.scaleY = _loc_2;
                }
                else
                {
                    this.updateBitmap();
                }
            }
            else
            {
                this._content.scaleX = _loc_1;
                this._content.scaleY = _loc_2;
            }
            if (this._align == "center")
            {
                _loc_3 = int((_width - this._contentWidth) / 2);
            }
            else if (this._align == "right")
            {
                _loc_3 = _width - this._contentWidth;
            }
            else
            {
                _loc_3 = 0;
            }
            if (this._verticalAlign == "middle")
            {
                _loc_4 = int((_height - this._contentHeight) / 2);
            }
            else if (this._verticalAlign == "bottom")
            {
                _loc_4 = _height - this._contentHeight;
            }
            else
            {
                _loc_4 = 0;
            }
            if (this._content2)
            {
                this._content2.setXY(_loc_3, _loc_4);
            }
            else
            {
                this._content.x = _loc_3;
                this._content.y = _loc_4;
            }
            return;
        }// end function

        protected function clearContent() : void
        {
            if (this._errorSign && this._errorSign.parent)
            {
                this._errorSign.parent.removeChild(this._errorSign);
            }
            _displayObject.setLoading(false);
            if (!this._contentRes.isMissing)
            {
                this._contentRes.displayItem.removeLoadedCallback(this.__imageLoaded);
                this._contentRes.release();
            }
            if (this._loader)
            {
                try
                {
                    this._loader.close();
                }
                catch (e:Error)
                {
                }
                this._loader = null;
            }
            if (this._jtSprite != null)
            {
                this._jtSprite.dispose();
            }
            if (this._content2 != null)
            {
                this._content2.dispose();
                this._content2 = null;
            }
            if (this._content)
            {
                if (this._content is DisplayObject && this._content.parent == _displayObject.container)
                {
                    _displayObject.container.removeChild(DisplayObject(this._content));
                }
                this._content = null;
            }
            this._bitmapData = null;
            return;
        }// end function

        override public function handleSizeChanged() : void
        {
            super.handleSizeChanged();
            if (!this._updatingLayout && !_underConstruct)
            {
                this.updateLayout();
            }
            return;
        }// end function

        private function updateBitmap() : void
        {
            var _loc_2:* = null;
            if (!this._bitmapData)
            {
                return;
            }
            var _loc_1:* = this._bitmapData;
            var _loc_3:* = this._contentRes.displayItem;
            var _loc_4:* = _loc_3.width / this._contentSourceWidth;
            var _loc_5:* = _loc_3.height / this._contentSourceHeight;
            var _loc_6:* = this._contentWidth * _loc_4;
            var _loc_7:* = this._contentHeight * _loc_5;
            if (_loc_6 <= 0 || _loc_7 <= 0)
            {
                _loc_1 = null;
            }
            else if (this._bitmapData.width != _loc_6 || this._bitmapData.height != _loc_7)
            {
                if (this._fillMethod != "none" && (_loc_3.imageSettings.scaleOption == "9grid" || _loc_3.imageSettings.scaleOption == "tile"))
                {
                    _loc_1 = new BitmapData(_loc_6, _loc_7, this._bitmapData.transparent, 0);
                    _loc_2 = new Matrix();
                    _loc_2.scale(_loc_6 / this._bitmapData.width, _loc_7 / this._bitmapData.height);
                    _loc_1.draw(this._bitmapData, _loc_2, null, null, null, _loc_3.imageSettings.smoothing);
                }
                else if (_loc_3.imageSettings.scaleOption == "9grid")
                {
                    _loc_1 = ToolSet.scaleBitmapWith9Grid(this._bitmapData, _loc_3.imageSettings.scale9Grid, _loc_6, _loc_7, _loc_3.imageSettings.smoothing, _loc_3.imageSettings.gridTile);
                }
                else if (_loc_3.imageSettings.scaleOption == "tile")
                {
                    _loc_1 = ToolSet.tileBitmap(this._bitmapData, this._bitmapData.rect, _loc_6, _loc_7);
                }
            }
            if (_loc_1 != null && this._fillMethod && this._fillMethod != "none")
            {
                if (_loc_1 == this._bitmapData)
                {
                    _loc_1 = this._bitmapData.clone();
                }
                _loc_1 = ImageFillUtils.fillImage(this._fillMethod, this._fillAmount / 100, this._fillOrigin, this._fillClockwise, _loc_1);
            }
            var _loc_8:* = this._content.bitmapData;
            if (this._content.bitmapData != _loc_1)
            {
                if (_loc_8 && _loc_8 != this._bitmapData)
                {
                    _loc_8.dispose();
                }
                this._content.bitmapData = _loc_1;
                this._content.smoothing = _loc_3.imageSettings.smoothing;
            }
            this._content.width = this._contentWidth;
            this._content.height = this._contentHeight;
            return;
        }// end function

        override public function get deprecated() : Boolean
        {
            return this._contentRes.deprecated;
        }// end function

        override protected function handleDispose() : void
        {
            if (this._jtSprite != null)
            {
                this._jtSprite.dispose();
                this._jtSprite = null;
            }
            if (!this._contentRes.isMissing)
            {
                this._contentRes.displayItem.removeLoadedCallback(this.__imageLoaded);
                this._contentRes.release();
            }
            if (this._content2)
            {
                this._content2.dispose();
            }
            return;
        }// end function

        override public function getProp(param1:int)
        {
            switch(param1)
            {
                case ObjectPropID.Color:
                {
                    return this.color;
                }
                case ObjectPropID.Playing:
                {
                    return this.playing;
                }
                case ObjectPropID.Frame:
                {
                    return this.frame;
                }
                case ObjectPropID.TimeScale:
                {
                    return 1;
                }
                default:
                {
                    return super.getProp(param1);
                    break;
                }
            }
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            switch(param1)
            {
                case ObjectPropID.Color:
                {
                    this.color = param2;
                    break;
                }
                case ObjectPropID.Playing:
                {
                    this.playing = param2;
                    break;
                }
                case ObjectPropID.Frame:
                {
                    this.frame = param2;
                    break;
                }
                case ObjectPropID.TimeScale:
                {
                    break;
                }
                case ObjectPropID.DeltaTime:
                {
                    if (this._content == this._jtSprite)
                    {
                        this._jtSprite.advance(param2);
                    }
                    break;
                }
                default:
                {
                    super.setProp(param1, param2);
                    break;
                    break;
                }
            }
            return;
        }// end function

        override public function read_beforeAdd(param1:XData, param2:Object) : void
        {
            var _loc_3:* = null;
            super.read_beforeAdd(param1, param2);
            this._url = param1.getAttribute("url", "");
            this._align = param1.getAttribute("align", "left");
            this._verticalAlign = param1.getAttribute("vAlign", "top");
            this._fill = param1.getAttribute("fill", FillConst.NONE);
            this._shrinkOnly = param1.getAttributeBool("shrinkOnly");
            this._autoSize = param1.getAttributeBool("autoSize");
            this._showErrorSign = param1.getAttributeBool("errorSign");
            this._playing = param1.getAttributeBool("playing", true);
            this._frame = param1.getAttributeInt("frame");
            this._color = param1.getAttributeColor("color", false, 16777215);
            this.applyColor();
            this._fillMethod = param1.getAttribute("fillMethod", "none");
            if (this._fillMethod != "none")
            {
                this._fillOrigin = param1.getAttributeInt("fillOrigin");
                this._fillClockwise = param1.getAttributeBool("fillClockwise", true);
                this._fillAmount = param1.getAttributeInt("fillAmount", 100);
            }
            this.clearOnPublish = param1.getAttributeBool("clearOnPublish");
            if (this._url)
            {
                this.loadContent();
            }
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_1:* = super.write();
            if (this._url)
            {
                _loc_1.setAttribute("url", this._url);
            }
            if (this._align != "left")
            {
                _loc_1.setAttribute("align", this._align);
            }
            if (this._verticalAlign != "top")
            {
                _loc_1.setAttribute("vAlign", this._verticalAlign);
            }
            if (this._fill != FillConst.NONE)
            {
                _loc_1.setAttribute("fill", this._fill);
            }
            if (this._shrinkOnly)
            {
                _loc_1.setAttribute("shrinkOnly", this._shrinkOnly);
            }
            if (this._autoSize)
            {
                _loc_1.setAttribute("autoSize", this._autoSize);
            }
            if (this._showErrorSign)
            {
                _loc_1.setAttribute("errorSign", this._showErrorSign);
            }
            if (!this._playing)
            {
                _loc_1.setAttribute("playing", false);
            }
            if (this._frame != 0)
            {
                _loc_1.setAttribute("frame", this._frame);
            }
            if (this._color != 16777215)
            {
                _loc_1.setAttribute("color", UtilsStr.convertToHtmlColor(this._color));
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
            if (this.clearOnPublish)
            {
                _loc_1.setAttribute("clearOnPublish", true);
            }
            return _loc_1;
        }// end function

    }
}
