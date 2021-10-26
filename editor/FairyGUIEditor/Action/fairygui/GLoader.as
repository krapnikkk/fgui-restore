package fairygui
{
    import *.*;
    import fairygui.display.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;

    public class GLoader extends GObject
    {
        private var _url:String;
        private var _align:int;
        private var _verticalAlign:int;
        private var _autoSize:Boolean;
        private var _fill:int;
        private var _shrinkOnly:Boolean;
        private var _showErrorSign:Boolean;
        private var _playing:Boolean;
        private var _frame:int;
        private var _color:uint;
        private var _contentItem:PackageItem;
        private var _contentSourceWidth:int;
        private var _contentSourceHeight:int;
        private var _contentWidth:int;
        private var _contentHeight:int;
        private var _container:Sprite;
        private var _content:DisplayObject;
        private var _errorSign:GObject;
        private var _content2:GComponent;
        private var _updatingLayout:Boolean;
        private var _loading:int;
        private var _externalLoader:Loader;
        private var _initExternalURLBeforeLoadSuccess:String;
        private static var _errorSignPool:GObjectPool = new GObjectPool();

        public function GLoader()
        {
            _playing = true;
            _url = "";
            _align = 0;
            _verticalAlign = 0;
            _showErrorSign = true;
            _color = 16777215;
            return;
        }// end function

        override protected function createDisplayObject() : void
        {
            _container = new UISprite(this);
            setDisplayObject(_container);
            return;
        }// end function

        override public function dispose() : void
        {
            if (_contentItem != null)
            {
                if (_loading == 1)
                {
                    _contentItem.owner.removeItemCallback(_contentItem, __imageLoaded);
                }
                else if (_loading == 2)
                {
                    _contentItem.owner.removeItemCallback(_contentItem, __movieClipLoaded);
                }
            }
            else if (_content != null)
            {
                freeExternal(_content);
            }
            if (_content2 != null)
            {
                _content2.dispose();
            }
            super.dispose();
            return;
        }// end function

        final public function get url() : String
        {
            return _url;
        }// end function

        public function set url(param1:String) : void
        {
            if (_url == param1)
            {
                return;
            }
            _url = param1;
            loadContent();
            updateGear(7);
            return;
        }// end function

        override public function get icon() : String
        {
            return _url;
        }// end function

        override public function set icon(param1:String) : void
        {
            this.url = param1;
            return;
        }// end function

        final public function get align() : int
        {
            return _align;
        }// end function

        public function set align(param1:int) : void
        {
            if (_align != param1)
            {
                _align = param1;
                updateLayout();
            }
            return;
        }// end function

        final public function get verticalAlign() : int
        {
            return _verticalAlign;
        }// end function

        public function set verticalAlign(param1:int) : void
        {
            if (_verticalAlign != param1)
            {
                _verticalAlign = param1;
                updateLayout();
            }
            return;
        }// end function

        final public function get fill() : int
        {
            return _fill;
        }// end function

        public function set fill(param1:int) : void
        {
            if (_fill != param1)
            {
                _fill = param1;
                updateLayout();
            }
            return;
        }// end function

        final public function get shrinkOnly() : Boolean
        {
            return _shrinkOnly;
        }// end function

        public function set shrinkOnly(param1:Boolean) : void
        {
            if (_shrinkOnly != param1)
            {
                _shrinkOnly = param1;
                updateLayout();
            }
            return;
        }// end function

        final public function get autoSize() : Boolean
        {
            return _autoSize;
        }// end function

        public function set autoSize(param1:Boolean) : void
        {
            if (_autoSize != param1)
            {
                _autoSize = param1;
                updateLayout();
            }
            return;
        }// end function

        final public function get playing() : Boolean
        {
            return _playing;
        }// end function

        public function set playing(param1:Boolean) : void
        {
            if (_playing != param1)
            {
                _playing = param1;
                if (_content is MovieClip)
                {
                    this.MovieClip(_content).playing = param1;
                }
                else if (_content is MovieClip)
                {
                    this.MovieClip(_content).stop();
                }
                updateGear(5);
            }
            return;
        }// end function

        final public function get frame() : int
        {
            return _frame;
        }// end function

        public function set frame(param1:int) : void
        {
            if (_frame != param1)
            {
                _frame = param1;
                if (_content is MovieClip)
                {
                    this.MovieClip(_content).frame = param1;
                }
                else if (_content is MovieClip)
                {
                    if (_playing)
                    {
                        this.MovieClip(_content).gotoAndPlay((_frame + 1));
                    }
                    else
                    {
                        this.MovieClip(_content).gotoAndStop((_frame + 1));
                    }
                }
                updateGear(5);
            }
            return;
        }// end function

        final public function get color() : uint
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
            var _loc_1:* = _container.transform.colorTransform;
            _loc_1.redMultiplier = (_color >> 16 & 255) / 255;
            _loc_1.greenMultiplier = (_color >> 8 & 255) / 255;
            _loc_1.blueMultiplier = (_color & 255) / 255;
            _container.transform.colorTransform = _loc_1;
            return;
        }// end function

        final public function get showErrorSign() : Boolean
        {
            return _showErrorSign;
        }// end function

        public function set showErrorSign(param1:Boolean) : void
        {
            _showErrorSign = param1;
            return;
        }// end function

        public function get texture() : BitmapData
        {
            if (_content is Bitmap)
            {
                return this.Bitmap(_content).bitmapData;
            }
            return null;
        }// end function

        public function set texture(param1:BitmapData) : void
        {
            this.url = null;
            if (!(_content is Bitmap))
            {
                _content = new Bitmap();
                _container.addChild(_content);
            }
            else
            {
                _container.addChild(_content);
            }
            this.Bitmap(_content).bitmapData = param1;
            _contentSourceWidth = param1.width;
            _contentSourceHeight = param1.height;
            updateLayout();
            return;
        }// end function

        public function get component() : GComponent
        {
            return _content2;
        }// end function

        protected function loadContent() : void
        {
            clearContent();
            if (!_url)
            {
                return;
            }
            if (ToolSet.startsWith(_url, "ui://"))
            {
                loadFromPackage(_url);
            }
            else
            {
                loadExternal();
            }
            return;
        }// end function

        protected function loadFromPackage(param1:String) : void
        {
            var _loc_2:* = null;
            _contentItem = UIPackage.getItemByURL(param1);
            if (_contentItem != null)
            {
                _contentItem = _contentItem.getBranch();
                _contentSourceWidth = _contentItem.width;
                _contentSourceHeight = _contentItem.height;
                if (_autoSize)
                {
                    this.setSize(_contentSourceWidth, _contentSourceHeight);
                }
                _contentItem = _contentItem.getHighResolution();
                if (_contentItem.type == 0)
                {
                    if (_contentItem.loaded)
                    {
                        __imageLoaded(_contentItem);
                    }
                    else
                    {
                        _loading = 1;
                        _contentItem.owner.addItemCallback(_contentItem, __imageLoaded);
                    }
                }
                else if (_contentItem.type == 2)
                {
                    if (_contentItem.loaded)
                    {
                        __movieClipLoaded(_contentItem);
                    }
                    else
                    {
                        _loading = 2;
                        _contentItem.owner.addItemCallback(_contentItem, __movieClipLoaded);
                    }
                }
                else if (_contentItem.type == 1)
                {
                    _loading = 2;
                    _contentItem.owner.addItemCallback(_contentItem, __swfLoaded);
                }
                else if (_contentItem.type == 4)
                {
                    _loc_2 = UIPackage.createObjectFromURL(param1);
                    if (!_loc_2)
                    {
                        setErrorState();
                    }
                    else if (!(_loc_2 is GComponent))
                    {
                        _loc_2.dispose();
                        setErrorState();
                    }
                    else
                    {
                        _content2 = _loc_2.asCom;
                        _container.addChild(_content2.displayObject);
                        updateLayout();
                    }
                }
                else
                {
                    setErrorState();
                }
            }
            else
            {
                setErrorState();
            }
            return;
        }// end function

        private function __imageLoaded(param1:PackageItem) : void
        {
            _loading = 0;
            if (param1.image == null)
            {
                setErrorState();
            }
            else
            {
                if (!(_content is Bitmap))
                {
                    _content = new Bitmap();
                    _container.addChild(_content);
                }
                else
                {
                    _container.addChild(_content);
                }
                this.Bitmap(_content).bitmapData = param1.image;
                this.Bitmap(_content).smoothing = param1.smoothing;
                updateLayout();
            }
            return;
        }// end function

        private function __movieClipLoaded(param1:PackageItem) : void
        {
            _loading = 0;
            if (!(_content is MovieClip))
            {
                _content = new MovieClip();
                _container.addChild(_content);
            }
            else
            {
                _container.addChild(_content);
            }
            this.MovieClip(_content).interval = param1.interval;
            this.MovieClip(_content).frames = param1.frames;
            this.MovieClip(_content).repeatDelay = param1.repeatDelay;
            this.MovieClip(_content).swing = param1.swing;
            this.MovieClip(_content).boundsRect = new Rectangle(0, 0, param1.width, param1.height);
            updateLayout();
            return;
        }// end function

        private function __swfLoaded(param1:DisplayObject) : void
        {
            _loading = 0;
            if (_content)
            {
                _container.removeChild(_content);
            }
            _content = this.DisplayObject(param1);
            if (_content)
            {
                try
                {
                    _container.addChild(_content);
                }
                catch (e:Error)
                {
                    this.trace("__swfLoaded:" + e);
                    _content = null;
                }
            }
            if (_content && _content is MovieClip)
            {
                if (_playing)
                {
                    this.MovieClip(_content).gotoAndPlay((_frame + 1));
                }
                else
                {
                    this.MovieClip(_content).gotoAndStop((_frame + 1));
                }
            }
            updateLayout();
            return;
        }// end function

        protected function loadExternal() : void
        {
            if (!_externalLoader)
            {
                _externalLoader = new Loader();
                _externalLoader.contentLoaderInfo.addEventListener("complete", __externalLoadCompleted);
                _externalLoader.contentLoaderInfo.addEventListener("ioError", __externalLoadFailed);
            }
            _initExternalURLBeforeLoadSuccess = _url;
            _externalLoader.load(new URLRequest(url));
            return;
        }// end function

        protected function freeExternal(param1:DisplayObject) : void
        {
            return;
        }// end function

        final protected function onExternalLoadSuccess(param1:DisplayObject) : void
        {
            _content = param1;
            _container.addChild(_content);
            if (param1.loaderInfo && param1.loaderInfo != displayObject.loaderInfo)
            {
                _contentSourceWidth = param1.loaderInfo.width;
                _contentSourceHeight = param1.loaderInfo.height;
            }
            else
            {
                _contentSourceWidth = param1.width;
                _contentSourceHeight = param1.height;
            }
            updateLayout();
            return;
        }// end function

        final protected function onExternalLoadFailed() : void
        {
            setErrorState();
            return;
        }// end function

        private function __externalLoadCompleted(event:Event) : void
        {
            if (_initExternalURLBeforeLoadSuccess == _url)
            {
                onExternalLoadSuccess(_externalLoader.content);
            }
            _initExternalURLBeforeLoadSuccess = null;
            return;
        }// end function

        private function __externalLoadFailed(event:Event) : void
        {
            onExternalLoadFailed();
            return;
        }// end function

        private function setErrorState() : void
        {
            if (!_showErrorSign)
            {
                return;
            }
            if (_errorSign == null)
            {
                if (UIConfig.loaderErrorSign != null)
                {
                    _errorSign = _errorSignPool.getObject(UIConfig.loaderErrorSign);
                }
            }
            if (_errorSign != null)
            {
                _errorSign.setSize(this.width, this.height);
                _container.addChild(_errorSign.displayObject);
            }
            return;
        }// end function

        private function clearErrorState() : void
        {
            if (_errorSign != null)
            {
                _container.removeChild(_errorSign.displayObject);
                _errorSignPool.returnObject(_errorSign);
                _errorSign = null;
            }
            return;
        }// end function

        private function updateLayout() : void
        {
            var _loc_4:* = NaN;
            var _loc_3:* = NaN;
            if (_content2 == null && _content == null)
            {
                if (_autoSize)
                {
                    _updatingLayout = true;
                    this.setSize(50, 30);
                    _updatingLayout = false;
                }
                return;
            }
            _contentWidth = _contentSourceWidth;
            _contentHeight = _contentSourceHeight;
            var _loc_1:* = 1;
            var _loc_2:* = 1;
            if (_autoSize)
            {
                _updatingLayout = true;
                if (_contentWidth == 0)
                {
                    _contentWidth = 50;
                }
                if (_contentHeight == 0)
                {
                    _contentHeight = 30;
                }
                this.setSize(_contentWidth, _contentHeight);
                _updatingLayout = false;
                if (_width == _contentWidth && _height == _contentHeight)
                {
                    if (_content2 != null)
                    {
                        _content2.setXY(0, 0);
                        _content2.setScale(_loc_1, _loc_2);
                    }
                    else
                    {
                        _content.x = 0;
                        _content.y = 0;
                        if (_content is Bitmap)
                        {
                            _loc_1 = _contentSourceWidth / _content.width;
                            _loc_2 = _contentSourceHeight / _content.height;
                        }
                        _content.scaleX = _loc_1;
                        _content.scaleY = _loc_2;
                    }
                    return;
                }
            }
            if (_fill != 0)
            {
                _loc_1 = _width / _contentSourceWidth;
                _loc_2 = _height / _contentSourceHeight;
                if (_loc_1 != 1 || _loc_2 != 1)
                {
                    if (_fill == 2)
                    {
                        _loc_1 = _loc_2;
                    }
                    else if (_fill == 3)
                    {
                        _loc_2 = _loc_1;
                    }
                    else if (_fill == 1)
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
                    else if (_fill == 5)
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
                    if (_shrinkOnly)
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
                    _contentWidth = _contentSourceWidth * _loc_1;
                    _contentHeight = _contentSourceHeight * _loc_2;
                }
            }
            if (_content2 != null)
            {
                _content2.setScale(_loc_1, _loc_2);
            }
            else if (_contentItem && _contentItem.type == 0)
            {
                resizeImage();
            }
            else
            {
                _content.scaleX = _loc_1;
                _content.scaleY = _loc_2;
            }
            if (_align == 1)
            {
                _loc_3 = (this.width - _contentWidth) / 2;
            }
            else if (_align == 2)
            {
                _loc_3 = this.width - _contentWidth;
            }
            else
            {
                _loc_3 = 0;
            }
            if (_verticalAlign == 1)
            {
                _loc_4 = (this.height - _contentHeight) / 2;
            }
            else if (_verticalAlign == 2)
            {
                _loc_4 = this.height - _contentHeight;
            }
            else
            {
                _loc_4 = 0;
            }
            if (_content2 != null)
            {
                _content2.setXY(_loc_3, _loc_4);
            }
            else
            {
                _content.x = _loc_3;
                _content.y = _loc_4;
            }
            return;
        }// end function

        private function clearContent() : void
        {
            clearErrorState();
            if (_content != null && _content.parent != null)
            {
                _container.removeChild(_content);
            }
            if (_content2 != null)
            {
                _container.removeChild(_content2.displayObject);
                _content2.dispose();
                _content2 = null;
            }
            if (_contentItem != null)
            {
                if (_loading == 1)
                {
                    _contentItem.owner.removeItemCallback(_contentItem, __imageLoaded);
                }
                else if (_loading == 2)
                {
                    _contentItem.owner.removeItemCallback(_contentItem, __movieClipLoaded);
                }
            }
            else if (_content != null)
            {
                freeExternal(_content);
            }
            _contentItem = null;
            _loading = 0;
            return;
        }// end function

        override protected function handleSizeChanged() : void
        {
            if (!_updatingLayout)
            {
                updateLayout();
            }
            return;
        }// end function

        private function resizeImage() : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_1:* = null;
            var _loc_7:* = _contentItem.image;
            if (_contentItem.image == null)
            {
                return;
            }
            if (_contentItem.scale9Grid != null || _contentItem.scaleByTile)
            {
                _content.scaleX = 1;
                _content.scaleY = 1;
                _loc_2 = _contentItem.width / _contentSourceWidth;
                _loc_3 = _contentItem.height / _contentSourceHeight;
                _loc_4 = _contentWidth * _loc_2;
                _loc_5 = _contentHeight * _loc_3;
                _loc_6 = this.Bitmap(_content).bitmapData;
                if (_loc_7.width == _loc_4 && _loc_7.height == _loc_5)
                {
                    _loc_1 = _loc_7;
                }
                else if (_loc_4 == 0 || _loc_5 == 0)
                {
                    _loc_1 = null;
                }
                else if (_contentItem.scale9Grid != null)
                {
                    _loc_1 = ToolSet.scaleBitmapWith9Grid(_loc_7, _contentItem.scale9Grid, _loc_4, _loc_5, _contentItem.smoothing, _contentItem.tileGridIndice);
                }
                else
                {
                    _loc_1 = ToolSet.tileBitmap(_loc_7, _loc_7.rect, _loc_4, _loc_5);
                }
                if (_loc_6 != _loc_1)
                {
                    if (_loc_6 && _loc_6 != _loc_7)
                    {
                        _loc_6.dispose();
                    }
                    this.Bitmap(_content).bitmapData = _loc_1;
                }
                this.Bitmap(_content).width = _contentWidth;
                this.Bitmap(_content).height = _contentHeight;
            }
            else
            {
                _content.scaleX = _contentWidth / _loc_7.width;
                _content.scaleY = _contentHeight / _loc_7.height;
            }
            return;
        }// end function

        override public function getProp(param1:int)
        {
            switch(param1 - 2) branch count is:<5>[23, 65, 28, 33, 65, 38] default offset is:<65>;
            return this.color;
            return this.playing;
            return this.frame;
            if (_content is MovieClip)
            {
                return this.MovieClip(_content).timeScale;
            }
            return 1;
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            switch(param1 - 2) branch count is:<5>[23, 107, 32, 41, 78, 50] default offset is:<107>;
            this.color = param2;
            ;
            this.playing = param2;
            ;
            this.frame = param2;
            ;
            if (_content is MovieClip)
            {
                this.MovieClip(_content).timeScale = param2;
            }
            ;
            if (_content is MovieClip)
            {
                this.MovieClip(_content).advance(param2);
            }
            ;
            super.setProp(param1, param2);
            return;
        }// end function

        override public function setup_beforeAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            super.setup_beforeAdd(param1);
            _loc_2 = param1.@url;
            if (_loc_2)
            {
                _url = _loc_2;
            }
            _loc_2 = param1.@align;
            if (_loc_2)
            {
                _align = AlignType.parse(_loc_2);
            }
            _loc_2 = param1.@vAlign;
            if (_loc_2)
            {
                _verticalAlign = VertAlignType.parse(_loc_2);
            }
            _loc_2 = param1.@fill;
            if (_loc_2)
            {
                _fill = LoaderFillType.parse(_loc_2);
            }
            _shrinkOnly = param1.@shrinkOnly == "true";
            _autoSize = param1.@autoSize == "true";
            _loc_2 = param1.@errorSign;
            if (_loc_2)
            {
                _showErrorSign = _loc_2 == "true";
            }
            _playing = param1.@playing != "false";
            _loc_2 = param1.@color;
            if (_loc_2)
            {
                this.color = ToolSet.convertFromHtmlColor(_loc_2);
            }
            if (_url)
            {
                loadContent();
            }
            return;
        }// end function

    }
}
