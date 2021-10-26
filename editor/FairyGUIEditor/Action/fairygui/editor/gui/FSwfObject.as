package fairygui.editor.gui
{
    import *.*;
    import fairygui.*;
    import fairygui.utils.*;
    import fairygui.utils.loader.*;
    import flash.display.*;

    public class FSwfObject extends FObject
    {
        private var _playing:Boolean;
        private var _frame:int;
        private var _content:DisplayObject;

        public function FSwfObject()
        {
            this._objectType = FObjectType.SWF;
            this._playing = true;
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
                this.stateChanged();
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
            this.stateChanged();
            updateGear(5);
            return;
        }// end function

        public function advance(param1:int) : void
        {
            return;
        }// end function

        private function stateChanged() : void
        {
            if (this._content && this._content is MovieClip)
            {
                if (this._playing)
                {
                    MovieClip(this._content).gotoAndPlay((this._frame + 1));
                }
                else
                {
                    MovieClip(this._content).gotoAndStop((this._frame + 1));
                }
            }
            return;
        }// end function

        override protected function handleCreate() : void
        {
            _displayObject.container.removeChildren();
            if (!_res || _res.isMissing)
            {
                this.errorStatus = true;
                return;
            }
            sourceWidth = _res.sourceWidth;
            sourceHeight = _res.sourceHeight;
            setSize(sourceWidth, sourceHeight);
            aspectLocked = true;
            EasyLoader.load(_res.displayItem.file.url, null, this.__swfLoaded);
            return;
        }// end function

        private function __swfLoaded(param1:LoaderExt) : void
        {
            var l:* = param1;
            this._content = l.content;
            if (!this._content)
            {
                this.errorStatus = true;
                return;
            }
            try
            {
                Sprite(this._content).mouseChildren = false;
                _displayObject.container.addChild(this._content);
                this.errorStatus = false;
                this.stateChanged();
                this.handleSizeChanged();
            }
            catch (e:Error)
            {
                _content = null;
                this.errorStatus = true;
            }
            return;
        }// end function

        override public function handleSizeChanged() : void
        {
            super.handleSizeChanged();
            if (this._content != null)
            {
                this._content.scaleX = _width / sourceWidth;
                this._content.scaleY = _height / sourceHeight;
            }
            return;
        }// end function

        override public function getProp(param1:int)
        {
            switch(param1)
            {
                case ObjectPropID.Playing:
                {
                    return this.playing;
                }
                case ObjectPropID.Frame:
                {
                    return this.frame;
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
            super.read_beforeAdd(param1, param2);
            this._playing = param1.getAttributeBool("playing", true);
            this.stateChanged();
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_1:* = super.write();
            if (!this._playing)
            {
                _loc_1.setAttribute("playing", false);
            }
            return _loc_1;
        }// end function

    }
}
