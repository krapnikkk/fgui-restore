package fairygui
{
    import *.*;
    import fairygui.display.*;
    import flash.display.*;

    public class GSwfObject extends GObject
    {
        protected var _container:Sprite;
        protected var _content:DisplayObject;
        protected var _playing:Boolean;
        protected var _frame:int;

        public function GSwfObject()
        {
            _playing = true;
            return;
        }// end function

        override protected function createDisplayObject() : void
        {
            _container = new UISprite(this);
            setDisplayObject(_container);
            return;
        }// end function

        final public function get movieClip() : MovieClip
        {
            return this.MovieClip(_content);
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
                updateGear(5);
            }
            return;
        }// end function

        override public function dispose() : void
        {
            packageItem.owner.removeItemCallback(packageItem, __swfLoaded);
            super.dispose();
            return;
        }// end function

        override public function constructFromResource() : void
        {
            sourceWidth = packageItem.width;
            sourceHeight = packageItem.height;
            initWidth = sourceWidth;
            initHeight = sourceHeight;
            setSize(sourceWidth, sourceHeight);
            packageItem.owner.addItemCallback(packageItem, __swfLoaded);
            return;
        }// end function

        private function __swfLoaded(param1:Object) : void
        {
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
            return;
        }// end function

        override protected function handleSizeChanged() : void
        {
            handleScaleChanged();
            return;
        }// end function

        override protected function handleScaleChanged() : void
        {
            _displayObject.scaleX = _width / sourceWidth * _scaleX;
            _displayObject.scaleY = _height / sourceHeight * _scaleY;
            return;
        }// end function

        override public function getProp(param1:int)
        {
            switch(param1 - 4) branch count is:<1>[11, 16] default offset is:<21>;
            return this.playing;
            return this.frame;
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            switch(param1 - 4) branch count is:<1>[11, 20] default offset is:<29>;
            this.playing = param2;
            ;
            this.frame = param2;
            ;
            super.setProp(param1, param2);
            return;
        }// end function

        override public function setup_beforeAdd(param1:XML) : void
        {
            super.setup_beforeAdd(param1);
            var _loc_2:* = param1.@playing;
            _playing = _loc_2 != "false";
            return;
        }// end function

    }
}
