package fairygui.editor.gui
{
    import *.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.geom.*;

    public class FSlider extends ComExtention
    {
        private var _min:Number;
        private var _max:Number;
        private var _value:Number;
        private var _titleType:String;
        private var _wholeNumbers:Boolean;
        private var _reverse:Boolean;
        private var _titleObject:FTextField;
        private var _barObjectH:FObject;
        private var _barObjectV:FObject;
        private var _barMaxWidth:int;
        private var _barMaxHeight:int;
        private var _gripObject:FObject;
        private var _clickPos:Point;
        private var _clickPercent:Number;
        private var _barMaxWidthDelta:int;
        private var _barMaxHeightDelta:int;
        private var _barStartX:int;
        private var _barStartY:int;
        public var changeOnClick:Boolean = true;
        public static const TITLE_PERCENT:String = "percent";
        public static const TITLE_VALUE_AND_MAX:String = "valueAndmax";
        public static const TITLE_VALUE_ONLY:String = "value";
        public static const TITLE_MAX_ONLY:String = "max";

        public function FSlider()
        {
            this._titleType = TITLE_PERCENT;
            this._value = 50;
            this._min = 0;
            this._max = 100;
            this._clickPos = new Point();
            return;
        }// end function

        public function get titleType() : String
        {
            return this._titleType;
        }// end function

        public function set titleType(param1:String) : void
        {
            this._titleType = param1;
            this.update();
            return;
        }// end function

        public function get min() : Number
        {
            return this._min;
        }// end function

        public function set min(param1:Number) : void
        {
            this._min = param1;
            this.update();
            return;
        }// end function

        public function get max() : Number
        {
            return this._max;
        }// end function

        public function set max(param1:Number) : void
        {
            this._max = param1;
            this.update();
            return;
        }// end function

        public function get value() : Number
        {
            return this._value;
        }// end function

        public function set value(param1:Number) : void
        {
            this._value = param1;
            if (this._value < this._min)
            {
                this._value = this._min;
            }
            if (this._value > this._max)
            {
                this._value = this._max;
            }
            this.update();
            return;
        }// end function

        public function get reverse() : Boolean
        {
            return this._reverse;
        }// end function

        public function set reverse(param1:Boolean) : void
        {
            this._reverse = param1;
            return;
        }// end function

        public function get wholeNumbers() : Boolean
        {
            return this._wholeNumbers;
        }// end function

        public function set wholeNumbers(param1:Boolean) : void
        {
            this._wholeNumbers = param1;
            return;
        }// end function

        override public function create() : void
        {
            this._titleObject = owner.getChild("title") as FTextField;
            this._barObjectH = owner.getChild("bar");
            this._barObjectV = owner.getChild("bar_v");
            this._gripObject = owner.getChild("grip");
            _owner.dispatcher.on(FObject.SIZE_CHANGED, this.__ownerSizeChanged);
            if (this._barObjectH)
            {
                this._barMaxWidth = this._barObjectH.width;
                this._barMaxWidthDelta = _owner.width - this._barMaxWidth;
                this._barStartX = this._barObjectH.x;
            }
            if (this._barObjectV)
            {
                this._barMaxHeight = this._barObjectV.height;
                this._barMaxHeightDelta = _owner.height - this._barMaxHeight;
                this._barStartY = this._barObjectV.y;
            }
            if ((_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                if (this._gripObject)
                {
                    this._gripObject.displayObject.addEventListener(MouseEvent.MOUSE_DOWN, this.__gripMouseDown);
                    _owner.displayObject.addEventListener(MouseEvent.MOUSE_DOWN, this.__barMouseDown);
                }
            }
            this.update();
            return;
        }// end function

        private function __ownerSizeChanged() : void
        {
            if (this._barObjectH)
            {
                this._barMaxWidth = _owner.width - this._barMaxWidthDelta;
            }
            if (this._barObjectV)
            {
                this._barMaxHeight = _owner.height - this._barMaxHeightDelta;
            }
            this.update();
            return;
        }// end function

        override public function dispose() : void
        {
            if ((_owner._flags & FObjectFlags.IN_TEST) != 0)
            {
                if (this._gripObject)
                {
                    this._gripObject.displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, this.__gripMouseDown);
                    _owner.displayObject.addEventListener(MouseEvent.MOUSE_DOWN, this.__barMouseDown);
                }
            }
            return;
        }// end function

        public function update() : void
        {
            if (FObjectFlags.isDocRoot(_owner._flags) != 0)
            {
                return;
            }
            this.updateWidthPercent((this._value - this._min) / (this._max - this._min), false);
            return;
        }// end function

        private function updateWidthPercent(param1:Number, param2:Boolean) : void
        {
            var _loc_5:* = NaN;
            param1 = ToolSet.clamp01(param1);
            if (param2)
            {
                _loc_5 = ToolSet.clamp(this._min + (this._max - this._min) * param1, this._min, this._max);
                if (this._wholeNumbers)
                {
                    _loc_5 = Math.round(_loc_5);
                    param1 = ToolSet.clamp01((_loc_5 - this._min) / (this._max - this._min));
                }
                if (_loc_5 != this._value)
                {
                    this._value = _loc_5;
                }
            }
            if (this._titleObject)
            {
                switch(this._titleType)
                {
                    case TITLE_PERCENT:
                    {
                        this._titleObject.text = Math.round(param1 * 100) + "%";
                        break;
                    }
                    case TITLE_VALUE_AND_MAX:
                    {
                        this._titleObject.text = this._value + "/" + this.max;
                        break;
                    }
                    case TITLE_VALUE_ONLY:
                    {
                        this._titleObject.text = "" + this._value;
                        break;
                    }
                    case TITLE_MAX_ONLY:
                    {
                        this._titleObject.text = "" + this._max;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            var _loc_3:* = _owner.width - this._barMaxWidthDelta;
            var _loc_4:* = _owner.height - this._barMaxHeightDelta;
            if (!this._reverse)
            {
                if (this._barObjectH)
                {
                    this._barObjectH.width = _loc_3 * param1;
                }
                if (this._barObjectV)
                {
                    this._barObjectV.height = _loc_4 * param1;
                }
            }
            else
            {
                if (this._barObjectH)
                {
                    this._barObjectH.width = Math.round(_loc_3 * param1);
                    this._barObjectH.x = this._barStartX + (_loc_3 - this._barObjectH.width);
                }
                if (this._barObjectV)
                {
                    this._barObjectV.height = Math.round(_loc_4 * param1);
                    this._barObjectV.y = this._barStartY + (_loc_4 - this._barObjectV.height);
                }
            }
            return;
        }// end function

        private function __gripMouseDown(event:MouseEvent) : void
        {
            event.stopPropagation();
            this._clickPos = _owner.globalToLocal(event.stageX, event.stageY);
            this._clickPercent = ToolSet.clamp01((this._value - this._min) / (this._max - this._min));
            this._gripObject.displayObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.__gripMouseMove);
            this._gripObject.displayObject.stage.addEventListener(MouseEvent.MOUSE_UP, this.__gripMouseUp);
            return;
        }// end function

        private function __gripMouseMove(event:MouseEvent) : void
        {
            var _loc_5:* = NaN;
            var _loc_2:* = _owner.globalToLocal(event.stageX, event.stageY);
            var _loc_3:* = _loc_2.x - this._clickPos.x;
            var _loc_4:* = _loc_2.y - this._clickPos.y;
            if (this._reverse)
            {
                _loc_3 = -_loc_3;
                _loc_4 = -_loc_4;
            }
            if (this._barObjectH)
            {
                _loc_5 = this._clickPercent + _loc_3 / this._barMaxWidth;
            }
            else
            {
                _loc_5 = this._clickPercent + _loc_4 / this._barMaxHeight;
            }
            this.updateWidthPercent(_loc_5, true);
            return;
        }// end function

        private function __gripMouseUp(event:MouseEvent) : void
        {
            this._gripObject.displayObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__gripMouseMove);
            this._gripObject.displayObject.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__gripMouseUp);
            return;
        }// end function

        private function __barMouseDown(event:MouseEvent) : void
        {
            var _loc_4:* = NaN;
            if (!this.changeOnClick)
            {
                return;
            }
            var _loc_2:* = this._gripObject.globalToLocal(event.stageX, event.stageY);
            var _loc_3:* = ToolSet.clamp01((this._value - this._min) / (this._max - this._min));
            if (this._barObjectH)
            {
                _loc_4 = _loc_2.x / this._barMaxWidth;
            }
            if (this._barObjectV)
            {
                _loc_4 = _loc_2.y / this._barMaxHeight;
            }
            if (this._reverse)
            {
                _loc_3 = _loc_3 - _loc_4;
            }
            else
            {
                _loc_3 = _loc_3 + _loc_4;
            }
            this.updateWidthPercent(_loc_3, true);
            return;
        }// end function

        override public function read_editMode(param1:XData) : void
        {
            this._titleType = param1.getAttribute("titleType", TITLE_PERCENT);
            this._reverse = param1.getAttributeBool("reverse");
            this._wholeNumbers = param1.getAttributeBool("wholeNumbers");
            this.changeOnClick = param1.getAttributeBool("changeOnClick", true);
            return;
        }// end function

        override public function write_editMode() : XData
        {
            var _loc_1:* = XData.create("Slider");
            if (this._titleType != TITLE_PERCENT)
            {
                _loc_1.setAttribute("titleType", this._titleType);
            }
            if (this._reverse)
            {
                _loc_1.setAttribute("reverse", true);
            }
            if (this._wholeNumbers)
            {
                _loc_1.setAttribute("wholeNumbers", true);
            }
            if (!this.changeOnClick)
            {
                _loc_1.setAttribute("changeOnClick", false);
            }
            return _loc_1;
        }// end function

        override public function read(param1:XData, param2:Object) : void
        {
            this._value = param1.getAttributeInt("value");
            this._max = param1.getAttributeInt("max");
            this._min = param1.getAttributeInt("min");
            if (this._max == 0)
            {
                this._max = 100;
            }
            this.update();
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_1:* = XData.create("Slider");
            if (this._value)
            {
                _loc_1.setAttribute("value", this._value);
            }
            if (this._max)
            {
                _loc_1.setAttribute("max", this._max);
            }
            if (this._min)
            {
                _loc_1.setAttribute("min", this._min);
            }
            if (_loc_1.hasAttributes())
            {
                return _loc_1;
            }
            return null;
        }// end function

    }
}
