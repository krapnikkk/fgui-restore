package fairygui
{
    import *.*;
    import fairygui.event.*;
    import flash.events.*;
    import flash.geom.*;

    public class GScrollBar extends GComponent
    {
        private var _grip:GObject;
        private var _arrowButton1:GObject;
        private var _arrowButton2:GObject;
        private var _bar:GObject;
        private var _target:ScrollPane;
        private var _vertical:Boolean;
        private var _scrollPerc:Number;
        private var _fixedGripSize:Boolean;
        private var _dragOffset:Point;

        public function GScrollBar()
        {
            _dragOffset = new Point();
            _scrollPerc = 0;
            return;
        }// end function

        public function setScrollPane(param1:ScrollPane, param2:Boolean) : void
        {
            _target = param1;
            _vertical = param2;
            return;
        }// end function

        public function setDisplayPerc(param1:Number) : void
        {
            if (_vertical)
            {
                if (!_fixedGripSize)
                {
                    _grip.height = Math.floor(param1 * _bar.height);
                }
                _grip.y = _bar.y + (_bar.height - _grip.height) * _scrollPerc;
            }
            else
            {
                if (!_fixedGripSize)
                {
                    _grip.width = Math.floor(param1 * _bar.width);
                }
                _grip.x = _bar.x + (_bar.width - _grip.width) * _scrollPerc;
            }
            _grip.visible = param1 != 0 && param1 != 1;
            return;
        }// end function

        public function setScrollPerc(param1:Number) : void
        {
            _scrollPerc = param1;
            if (_vertical)
            {
                _grip.y = _bar.y + (_bar.height - _grip.height) * _scrollPerc;
            }
            else
            {
                _grip.x = _bar.x + (_bar.width - _grip.width) * _scrollPerc;
            }
            return;
        }// end function

        public function get minSize() : int
        {
            if (_vertical)
            {
                return (_arrowButton1 != null ? (_arrowButton1.height) : (0)) + (_arrowButton2 != null ? (_arrowButton2.height) : (0));
            }
            return (_arrowButton1 != null ? (_arrowButton1.width) : (0)) + (_arrowButton2 != null ? (_arrowButton2.width) : (0));
        }// end function

        public function get gripDragging() : Boolean
        {
            return _grip && _grip.isDown;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            param1 = param1.ScrollBar[0];
            if (param1 != null)
            {
                _fixedGripSize = param1.@fixedGripSize == "true";
            }
            _grip = getChild("grip");
            if (!_grip)
            {
                return;
            }
            _bar = getChild("bar");
            if (!_bar)
            {
                return;
            }
            _arrowButton1 = getChild("arrow1");
            _arrowButton2 = getChild("arrow2");
            _grip.addEventListener("beginGTouch", __gripMouseDown);
            _grip.addEventListener("dragGTouch", __gripDragging);
            _grip.addEventListener("endGTouch", __gripMouseUp);
            if (_arrowButton1)
            {
                _arrowButton1.addEventListener("beginGTouch", __arrowButton1Click);
            }
            if (_arrowButton2)
            {
                _arrowButton2.addEventListener("beginGTouch", __arrowButton2Click);
            }
            addEventListener("beginGTouch", __barMouseDown);
            return;
        }// end function

        private function __gripMouseDown(event:GTouchEvent) : void
        {
            if (!_bar)
            {
                return;
            }
            event.stopPropagation();
            _dragOffset = this.globalToLocal(event.stageX, event.stageY);
            _dragOffset.x = _dragOffset.x - _grip.x;
            _dragOffset.y = _dragOffset.y - _grip.y;
            return;
        }// end function

        private function __gripMouseUp(event:GTouchEvent) : void
        {
            _target.updateScrollBarVisible();
            return;
        }// end function

        private function __gripDragging(event:GTouchEvent) : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_3:* = NaN;
            var _loc_2:* = this.globalToLocal(event.stageX, event.stageY);
            if (_vertical)
            {
                _loc_4 = _loc_2.y - _dragOffset.y;
                _loc_5 = _bar.height - _grip.height;
                if (_loc_5 == 0)
                {
                    _target.setPercY(0, false);
                }
                else
                {
                    _target.setPercY((_loc_4 - _bar.y) / _loc_5, false);
                }
            }
            else
            {
                _loc_3 = _loc_2.x - _dragOffset.x;
                _loc_5 = _bar.width - _grip.width;
                if (_loc_5 == 0)
                {
                    _target.setPercX(0, false);
                }
                else
                {
                    _target.setPercX((_loc_3 - _bar.x) / _loc_5, false);
                }
            }
            return;
        }// end function

        private function __arrowButton1Click(event:Event) : void
        {
            event.stopPropagation();
            if (_vertical)
            {
                _target.scrollUp();
            }
            else
            {
                _target.scrollLeft();
            }
            return;
        }// end function

        private function __arrowButton2Click(event:Event) : void
        {
            event.stopPropagation();
            if (_vertical)
            {
                _target.scrollDown();
            }
            else
            {
                _target.scrollRight();
            }
            return;
        }// end function

        private function __barMouseDown(event:GTouchEvent) : void
        {
            var _loc_2:* = _grip.globalToLocal(event.stageX, event.stageY);
            if (_vertical)
            {
                if (_loc_2.y < 0)
                {
                    _target.scrollUp(4);
                }
                else
                {
                    _target.scrollDown(4);
                }
            }
            else if (_loc_2.x < 0)
            {
                _target.scrollLeft(4);
            }
            else
            {
                _target.scrollRight(4);
            }
            return;
        }// end function

    }
}
