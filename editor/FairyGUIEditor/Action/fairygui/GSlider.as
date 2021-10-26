package fairygui
{
    import *.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.geom.*;

    public class GSlider extends GComponent
    {
        private var _min:Number;
        private var _max:Number;
        private var _value:Number;
        private var _titleType:int;
        private var _reverse:Boolean;
        private var _wholeNumbers:Boolean;
        private var _titleObject:GTextField;
        private var _barObjectH:GObject;
        private var _barObjectV:GObject;
        private var _barMaxWidth:int;
        private var _barMaxHeight:int;
        private var _barMaxWidthDelta:int;
        private var _barMaxHeightDelta:int;
        private var _gripObject:GObject;
        private var _clickPos:Point;
        private var _clickPercent:Number;
        private var _barStartX:int;
        private var _barStartY:int;
        public var changeOnClick:Boolean = true;
        public var canDrag:Boolean = true;

        public function GSlider()
        {
            _titleType = 0;
            _value = 50;
            _max = 100;
            _clickPos = new Point();
            return;
        }// end function

        final public function get titleType() : int
        {
            return _titleType;
        }// end function

        final public function set titleType(param1:int) : void
        {
            _titleType = param1;
            return;
        }// end function

        public function get wholeNumbers() : Boolean
        {
            return _wholeNumbers;
        }// end function

        public function set wholeNumbers(param1:Boolean) : void
        {
            if (_wholeNumbers != param1)
            {
                _wholeNumbers = param1;
                update();
            }
            return;
        }// end function

        public function get min() : Number
        {
            return _min;
        }// end function

        public function set min(param1:Number) : void
        {
            if (_min != param1)
            {
                _min = param1;
                update();
            }
            return;
        }// end function

        final public function get max() : Number
        {
            return _max;
        }// end function

        final public function set max(param1:Number) : void
        {
            if (_max != param1)
            {
                _max = param1;
                update();
            }
            return;
        }// end function

        final public function get value() : Number
        {
            return _value;
        }// end function

        final public function set value(param1:Number) : void
        {
            if (_value != param1)
            {
                _value = param1;
                update();
            }
            return;
        }// end function

        public function update() : void
        {
            updateWithPercent((_value - _min) / (_max - _min), false);
            return;
        }// end function

        private function updateWithPercent(param1:Number, param2:Boolean) : void
        {
            var _loc_3:* = NaN;
            param1 = ToolSet.clamp01(param1);
            if (param2)
            {
                _loc_3 = ToolSet.clamp(_min + (_max - _min) * param1, _min, _max);
                if (_wholeNumbers)
                {
                    _loc_3 = Math.round(_loc_3);
                    param1 = ToolSet.clamp01((_loc_3 - _min) / (_max - _min));
                }
                if (_loc_3 != _value)
                {
                    _value = _loc_3;
                    dispatchEvent(new StateChangeEvent("stateChanged"));
                }
            }
            if (_titleObject)
            {
                switch(_titleType) branch count is:<3>[17, 41, 61, 77] default offset is:<89>;
                _titleObject.text = Math.round(param1 * 100) + "%";
                ;
                _titleObject.text = _value + "/" + _max;
                ;
                _titleObject.text = "" + _value;
                ;
                _titleObject.text = "" + _max;
            }
            var _loc_5:* = this.width - this._barMaxWidthDelta;
            var _loc_4:* = this.height - this._barMaxHeightDelta;
            if (!_reverse)
            {
                if (_barObjectH)
                {
                    _barObjectH.width = Math.round(_loc_5 * param1);
                }
                if (_barObjectV)
                {
                    _barObjectV.height = Math.round(_loc_4 * param1);
                }
            }
            else
            {
                if (_barObjectH)
                {
                    _barObjectH.width = Math.round(_loc_5 * param1);
                    _barObjectH.x = _barStartX + (_loc_5 - _barObjectH.width);
                }
                if (_barObjectV)
                {
                    _barObjectV.height = Math.round(_loc_4 * param1);
                    _barObjectV.y = _barStartY + (_loc_4 - _barObjectV.height);
                }
            }
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            var _loc_2:* = null;
            super.constructFromXML(param1);
            param1 = param1.Slider[0];
            _loc_2 = param1.@titleType;
            if (_loc_2)
            {
                _titleType = ProgressTitleType.parse(_loc_2);
            }
            _reverse = param1.@reverse == "true";
            _wholeNumbers = param1.@wholeNumbers == "true";
            changeOnClick = param1.@changeOnClick != "false";
            _titleObject = getChild("title") as GTextField;
            _barObjectH = getChild("bar");
            _barObjectV = getChild("bar_v");
            _gripObject = getChild("grip");
            if (_barObjectH)
            {
                _barMaxWidth = _barObjectH.width;
                _barMaxWidthDelta = this.width - _barMaxWidth;
                _barStartX = _barObjectH.x;
            }
            if (_barObjectV)
            {
                _barMaxHeight = _barObjectV.height;
                _barMaxHeightDelta = this.height - _barMaxHeight;
                _barStartY = _barObjectV.y;
            }
            if (_gripObject)
            {
                _gripObject.addEventListener("beginGTouch", __gripMouseDown);
                _gripObject.addEventListener("dragGTouch", __gripMouseMove);
            }
            addEventListener("beginGTouch", __barMouseDown);
            return;
        }// end function

        override protected function handleSizeChanged() : void
        {
            super.handleSizeChanged();
            if (_barObjectH)
            {
                _barMaxWidth = this.width - _barMaxWidthDelta;
            }
            if (_barObjectV)
            {
                _barMaxHeight = this.height - _barMaxHeightDelta;
            }
            if (!this._underConstruct)
            {
                update();
            }
            return;
        }// end function

        override public function setup_afterAdd(param1:XML) : void
        {
            super.setup_afterAdd(param1);
            param1 = param1.Slider[0];
            if (param1)
            {
                _value = this.parseInt(param1.@value);
                if (this.isNaN(_value))
                {
                    _value = 0;
                }
                _max = this.parseInt(param1.@max);
                if (this.isNaN(_max))
                {
                    _max = 0;
                }
                _min = this.parseInt(param1.@min);
                if (this.isNaN(_min))
                {
                    _min = 0;
                }
            }
            update();
            return;
        }// end function

        private function __gripMouseDown(event:GTouchEvent) : void
        {
            this.canDrag = true;
            event.stopPropagation();
            _clickPos = this.globalToLocal(event.stageX, event.stageY);
            _clickPercent = ToolSet.clamp01((_value - _min) / (_max - _min));
            return;
        }// end function

        private function __gripMouseMove(event:GTouchEvent) : void
        {
            var _loc_5:* = NaN;
            if (!this.canDrag)
            {
                return;
            }
            var _loc_2:* = this.globalToLocal(event.stageX, event.stageY);
            var _loc_3:* = _loc_2.x - _clickPos.x;
            var _loc_4:* = _loc_2.y - _clickPos.y;
            if (_reverse)
            {
                _loc_3 = -_loc_3;
                _loc_4 = -_loc_4;
            }
            if (_barObjectH)
            {
                _loc_5 = _clickPercent + _loc_3 / _barMaxWidth;
            }
            else
            {
                _loc_5 = _clickPercent + _loc_4 / _barMaxHeight;
            }
            updateWithPercent(_loc_5, true);
            return;
        }// end function

        private function __barMouseDown(event:GTouchEvent) : void
        {
            var _loc_3:* = NaN;
            if (!changeOnClick)
            {
                return;
            }
            var _loc_2:* = _gripObject.globalToLocal(event.stageX, event.stageY);
            var _loc_4:* = ToolSet.clamp01((_value - _min) / (_max - _min));
            if (_barObjectH)
            {
                _loc_3 = (_loc_2.x - _gripObject.width / 2) / _barMaxWidth;
            }
            if (_barObjectV)
            {
                _loc_3 = (_loc_2.y - _gripObject.height / 2) / _barMaxHeight;
            }
            if (_reverse)
            {
                _loc_4 = _loc_4 - _loc_3;
            }
            else
            {
                _loc_4 = _loc_4 + _loc_3;
            }
            updateWithPercent(_loc_4, true);
            return;
        }// end function

    }
}
