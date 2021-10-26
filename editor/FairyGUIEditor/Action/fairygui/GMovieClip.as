package fairygui
{
    import *.*;
    import fairygui.display.*;
    import fairygui.utils.*;
    import flash.geom.*;

    public class GMovieClip extends GObject
    {
        private var _movieClip:UIMovieClip;
        private var _color:uint;

        public function GMovieClip()
        {
            _color = 16777215;
            return;
        }// end function

        override protected function createDisplayObject() : void
        {
            _movieClip = new UIMovieClip(this);
            _movieClip.mouseEnabled = false;
            _movieClip.mouseChildren = false;
            setDisplayObject(_movieClip);
            return;
        }// end function

        final public function get playing() : Boolean
        {
            return _movieClip.playing;
        }// end function

        final public function set playing(param1:Boolean) : void
        {
            if (_movieClip.playing != param1)
            {
                _movieClip.playing = param1;
                updateGear(5);
            }
            return;
        }// end function

        final public function get frame() : int
        {
            return _movieClip.frame;
        }// end function

        public function set frame(param1:int) : void
        {
            if (_movieClip.frame != param1)
            {
                _movieClip.frame = param1;
                updateGear(5);
            }
            return;
        }// end function

        final public function get timeScale() : Number
        {
            return _movieClip.timeScale;
        }// end function

        public function set timeScale(param1:Number) : void
        {
            _movieClip.timeScale = param1;
            return;
        }// end function

        public function rewind() : void
        {
            _movieClip.rewind();
            return;
        }// end function

        public function syncStatus(param1:GMovieClip) : void
        {
            _movieClip.syncStatus(param1._movieClip);
            return;
        }// end function

        public function advance(param1:int) : void
        {
            _movieClip.advance(param1);
            return;
        }// end function

        public function setPlaySettings(param1:int = 0, param2:int = -1, param3:int = 0, param4:int = -1, param5:Function = null) : void
        {
            _movieClip.setPlaySettings(param1, param2, param3, param4, param5);
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
            var _loc_1:* = _movieClip.transform.colorTransform;
            _loc_1.redMultiplier = (_color >> 16 & 255) / 255;
            _loc_1.greenMultiplier = (_color >> 8 & 255) / 255;
            _loc_1.blueMultiplier = (_color & 255) / 255;
            _movieClip.transform.colorTransform = _loc_1;
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            return;
        }// end function

        override public function constructFromResource() : void
        {
            var _loc_1:* = packageItem.getBranch();
            sourceWidth = _loc_1.width;
            sourceHeight = _loc_1.height;
            initWidth = sourceWidth;
            initHeight = sourceHeight;
            setSize(sourceWidth, sourceHeight);
            _loc_1 = _loc_1.getHighResolution();
            if (_loc_1.loaded)
            {
                __movieClipLoaded(_loc_1);
            }
            else
            {
                _loc_1.owner.addItemCallback(_loc_1, __movieClipLoaded);
            }
            return;
        }// end function

        private function __movieClipLoaded(param1:PackageItem) : void
        {
            _movieClip.interval = param1.interval;
            _movieClip.swing = param1.swing;
            _movieClip.repeatDelay = param1.repeatDelay;
            _movieClip.frames = param1.frames;
            _movieClip.boundsRect = new Rectangle(0, 0, sourceWidth, sourceHeight);
            _movieClip.smoothing = param1.smoothing;
            handleSizeChanged();
            return;
        }// end function

        override protected function handleSizeChanged() : void
        {
            handleScaleChanged();
            return;
        }// end function

        override protected function handleScaleChanged() : void
        {
            if (_movieClip.boundsRect)
            {
                _displayObject.scaleX = _width / _movieClip.boundsRect.width * _scaleX;
                _displayObject.scaleY = _height / _movieClip.boundsRect.height * _scaleY;
            }
            else
            {
                _displayObject.scaleX = _scaleX;
                _displayObject.scaleY = _scaleY;
            }
            return;
        }// end function

        override public function getProp(param1:int)
        {
            switch(param1 - 2) branch count is:<5>[23, 43, 28, 33, 43, 38] default offset is:<43>;
            return this.color;
            return this.playing;
            return this.frame;
            return this.timeScale;
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            switch(param1 - 2) branch count is:<5>[23, 69, 32, 41, 59, 50] default offset is:<69>;
            this.color = param2;
            ;
            this.playing = param2;
            ;
            this.frame = param2;
            ;
            this.timeScale = param2;
            ;
            this.advance(param2);
            ;
            super.setProp(param1, param2);
            return;
        }// end function

        override public function setup_beforeAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            super.setup_beforeAdd(param1);
            _loc_2 = param1.@frame;
            if (_loc_2)
            {
                _movieClip.frame = this.parseInt(_loc_2);
            }
            _loc_2 = param1.@playing;
            _movieClip.playing = _loc_2 != "false";
            _loc_2 = param1.@color;
            if (_loc_2)
            {
                this.color = ToolSet.convertFromHtmlColor(_loc_2);
            }
            return;
        }// end function

    }
}
