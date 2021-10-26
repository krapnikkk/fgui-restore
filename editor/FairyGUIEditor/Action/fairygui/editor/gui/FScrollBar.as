package fairygui.editor.gui
{
    import *.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.geom.*;

    public class FScrollBar extends ComExtention
    {
        private var _grip:FObject;
        private var _arrowButton1:FObject;
        private var _arrowButton2:FObject;
        private var _bar:FObject;
        private var _scrollPane:FScrollPane;
        private var _vertical:Boolean;
        private var _scrollPerc:Number;
        private var _dragging:Boolean;
        private var _dragOffset:Point;
        private var _fixedGripSize:Boolean;
        private var _mouseIn:Boolean;

        public function FScrollBar()
        {
            this._dragOffset = new Point();
            return;
        }// end function

        public function setScrollPane(param1:FScrollPane, param2:Boolean) : void
        {
            this._scrollPane = param1;
            this._vertical = param2;
            return;
        }// end function

        public function setDisplayPerc(param1:Number) : void
        {
            if (!this._grip || !this._bar)
            {
                return;
            }
            if (this._vertical)
            {
                if (!this._fixedGripSize)
                {
                    this._grip.height = Math.floor(param1 * this._bar.height);
                }
                this._grip.y = this._bar.y + (this._bar.height - this._grip.height) * this._scrollPerc;
            }
            else
            {
                if (!this._fixedGripSize)
                {
                    this._grip.width = Math.floor(param1 * this._bar.width);
                }
                this._grip.x = this._bar.x + (this._bar.width - this._grip.width) * this._scrollPerc;
            }
            this._grip.visible = param1 != 0 && param1 != 1;
            return;
        }// end function

        public function setScrollPerc(param1:Number) : void
        {
            if (!this._grip || !this._bar)
            {
                return;
            }
            this._scrollPerc = param1;
            if (this._vertical)
            {
                this._grip.y = this._bar.y + (this._bar.height - this._grip.height) * this._scrollPerc;
            }
            else
            {
                this._grip.x = this._bar.x + (this._bar.width - this._grip.width) * this._scrollPerc;
            }
            return;
        }// end function

        public function get minSize() : int
        {
            if (this._vertical)
            {
                return (this._arrowButton1 != null ? (this._arrowButton1.height) : (0)) + (this._arrowButton2 != null ? (this._arrowButton2.height) : (0));
            }
            else
            {
            }
            return (this._arrowButton1 != null ? (this._arrowButton1.width) : (0)) + (this._arrowButton2 != null ? (this._arrowButton2.width) : (0));
        }// end function

        public function get fixedGripSize() : Boolean
        {
            return this._fixedGripSize;
        }// end function

        public function set fixedGripSize(param1:Boolean) : void
        {
            this._fixedGripSize = param1;
            return;
        }// end function

        public function get gripDragging() : Boolean
        {
            return this._grip && this._grip.isDown;
        }// end function

        override public function create() : void
        {
            this._grip = owner.getChild("grip");
            this._bar = owner.getChild("bar");
            this._arrowButton1 = owner.getChild("arrow1");
            this._arrowButton2 = owner.getChild("arrow2");
            if ((_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                if (this._grip)
                {
                    this._grip.displayObject.addEventListener(MouseEvent.MOUSE_DOWN, this.__gripMouseDown);
                }
                if (this._arrowButton1)
                {
                    this._arrowButton1.addEventListener(GTouchEvent.BEGIN, this.__arrowButton1Click);
                }
                if (this._arrowButton2)
                {
                    this._arrowButton2.addEventListener(GTouchEvent.BEGIN, this.__arrowButton2Click);
                }
                _owner.addEventListener(GTouchEvent.BEGIN, this.__barMouseDown);
            }
            return;
        }// end function

        override public function dispose() : void
        {
            if ((_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                if (this._grip)
                {
                    this._grip.displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, this.__gripMouseDown);
                }
                if (this._arrowButton1)
                {
                    this._arrowButton1.removeEventListener(GTouchEvent.BEGIN, this.__arrowButton1Click);
                }
                if (this._arrowButton2)
                {
                    this._arrowButton2.removeEventListener(GTouchEvent.BEGIN, this.__arrowButton2Click);
                }
                _owner.removeEventListener(GTouchEvent.BEGIN, this.__barMouseDown);
            }
            return;
        }// end function

        override public function read_editMode(param1:XData) : void
        {
            this._fixedGripSize = param1.getAttributeBool("fixedGripSize");
            return;
        }// end function

        override public function write_editMode() : XData
        {
            var _loc_1:* = XData.create("ScrollBar");
            if (this._fixedGripSize)
            {
                _loc_1.setAttribute("fixedGripSize", true);
            }
            return _loc_1;
        }// end function

        private function __gripMouseDown(event:MouseEvent) : void
        {
            if (!this._bar)
            {
                return;
            }
            event.stopPropagation();
            this._dragOffset.x = this._grip.displayObject.stage.mouseX - this._grip.x;
            this._dragOffset.y = this._grip.displayObject.stage.mouseY - this._grip.y;
            this._dragging = true;
            this._grip.displayObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.__stageMouseMove);
            this._grip.displayObject.stage.addEventListener(MouseEvent.MOUSE_UP, this.__stageMouseUp);
            return;
        }// end function

        private function __stageMouseMove(event:MouseEvent) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            if (this._scrollPane == null)
            {
                return;
            }
            if (this._vertical)
            {
                _loc_2 = event.stageY - this._dragOffset.y;
                _loc_3 = this._bar.height - this._grip.height;
                if (_loc_3 == 0)
                {
                    this._scrollPane.setPercY(0, false);
                }
                else
                {
                    this._scrollPane.setPercY((_loc_2 - this._bar.y) / _loc_3, false);
                }
            }
            else
            {
                _loc_4 = event.stageX - this._dragOffset.x;
                _loc_3 = this._bar.width - this._grip.width;
                if (_loc_3 == 0)
                {
                    this._scrollPane.setPercX(0, false);
                }
                else
                {
                    this._scrollPane.setPercX((_loc_4 - this._bar.x) / _loc_3, false);
                }
            }
            return;
        }// end function

        private function __stageMouseUp(event:Event) : void
        {
            if (this._dragging)
            {
                this._dragging = false;
                this._scrollPane.updateScrollBarVisible();
                event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, this.__stageMouseUp);
                event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, this.__stageMouseMove);
            }
            return;
        }// end function

        private function __arrowButton1Click(event:Event) : void
        {
            if (this._scrollPane == null)
            {
                return;
            }
            event.stopPropagation();
            if (this._vertical)
            {
                this._scrollPane.scrollUp();
            }
            else
            {
                this._scrollPane.scrollLeft();
            }
            return;
        }// end function

        private function __arrowButton2Click(event:Event) : void
        {
            if (this._scrollPane == null)
            {
                return;
            }
            event.stopPropagation();
            if (this._vertical)
            {
                this._scrollPane.scrollDown();
            }
            else
            {
                this._scrollPane.scrollRight();
            }
            return;
        }// end function

        private function __barMouseDown(event:GTouchEvent) : void
        {
            if (this._scrollPane == null || !this._grip)
            {
                return;
            }
            var _loc_2:* = this._grip.displayObject.globalToLocal(new Point(event.stageX, event.stageY));
            if (this._vertical)
            {
                if (_loc_2.y < 0)
                {
                    this._scrollPane.scrollUp(4);
                }
                else
                {
                    this._scrollPane.scrollDown(4);
                }
            }
            else if (_loc_2.x < 0)
            {
                this._scrollPane.scrollLeft(4);
            }
            else
            {
                this._scrollPane.scrollRight(4);
            }
            return;
        }// end function

    }
}
