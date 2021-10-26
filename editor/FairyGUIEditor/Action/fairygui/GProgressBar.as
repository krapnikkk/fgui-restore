package fairygui
{
    import *.*;
    import fairygui.tween.*;
    import fairygui.utils.*;

    public class GProgressBar extends GComponent
    {
        private var _min:Number;
        private var _max:Number;
        private var _value:Number;
        private var _titleType:int;
        private var _reverse:Boolean;
        private var _titleObject:GTextField;
        private var _aniObject:GObject;
        private var _barObjectH:GObject;
        private var _barObjectV:GObject;
        private var _barMaxWidth:int;
        private var _barMaxHeight:int;
        private var _barMaxWidthDelta:int;
        private var _barMaxHeightDelta:int;
        private var _barStartX:int;
        private var _barStartY:int;

        public function GProgressBar()
        {
            _titleType = 0;
            _value = 50;
            _max = 100;
            return;
        }// end function

        final public function get titleType() : int
        {
            return _titleType;
        }// end function

        final public function set titleType(param1:int) : void
        {
            if (_titleType != param1)
            {
                _titleType = param1;
                update(_value);
            }
            return;
        }// end function

        final public function get min() : Number
        {
            return _min;
        }// end function

        final public function set min(param1:Number) : void
        {
            if (_min != param1)
            {
                _min = param1;
                update(_value);
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
                update(_value);
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
                GTween.kill(this, false, this.update);
                _value = param1;
                if (_value < _min)
                {
                    _value = _min;
                }
                if (_value > _max)
                {
                    _value = _max;
                }
                update(_value);
            }
            return;
        }// end function

        public function tweenValue(param1:Number, param2:Number) : GTweener
        {
            var _loc_3:* = NaN;
            var _loc_4:* = GTween.getTween(this, this.update);
            if (GTween.getTween(this, this.update) != null)
            {
                _loc_3 = _loc_4.value.x;
                _loc_4.kill();
            }
            else
            {
                _loc_3 = _value;
            }
            _value = param1;
            return GTween.to(_loc_3, _value, param2).setTarget(this, this.update).setEase(0);
        }// end function

        public function update(param1:int) : void
        {
            var _loc_4:* = ToolSet.clamp01((_value - _min) / (_max - _min));
            if (_titleObject)
            {
                switch(_titleType) branch count is:<3>[17, 42, 74, 95] default offset is:<114>;
                _titleObject.text = Math.round(_loc_4 * 100) + "%";
                ;
                _titleObject.text = Math.round(param1) + "/" + Math.round(_max);
                ;
                _titleObject.text = "" + Math.round(param1);
                ;
                _titleObject.text = "" + Math.round(_max);
            }
            var _loc_3:* = this.width - this._barMaxWidthDelta;
            var _loc_2:* = this.height - this._barMaxHeightDelta;
            if (!_reverse)
            {
                if (_barObjectH)
                {
                    _barObjectH.width = Math.round(_loc_3 * _loc_4);
                }
                if (_barObjectV)
                {
                    _barObjectV.height = Math.round(_loc_2 * _loc_4);
                }
            }
            else
            {
                if (_barObjectH)
                {
                    _barObjectH.width = Math.round(_loc_3 * _loc_4);
                    _barObjectH.x = _barStartX + (_loc_3 - _barObjectH.width);
                }
                if (_barObjectV)
                {
                    _barObjectV.height = Math.round(_loc_2 * _loc_4);
                    _barObjectV.y = _barStartY + (_loc_2 - _barObjectV.height);
                }
            }
            if (_aniObject is GMovieClip)
            {
                this.GMovieClip(_aniObject).frame = Math.round(_loc_4 * 100);
            }
            else if (_aniObject is GSwfObject)
            {
                this.GSwfObject(_aniObject).frame = Math.round(_loc_4 * 100);
            }
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            var _loc_2:* = null;
            super.constructFromXML(param1);
            param1 = param1.ProgressBar[0];
            _loc_2 = param1.@titleType;
            if (_loc_2)
            {
                _titleType = ProgressTitleType.parse(_loc_2);
            }
            _reverse = param1.@reverse == "true";
            _titleObject = getChild("title") as GTextField;
            _barObjectH = getChild("bar");
            _barObjectV = getChild("bar_v");
            _aniObject = getChild("ani");
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
                update(_value);
            }
            return;
        }// end function

        override public function setup_afterAdd(param1:XML) : void
        {
            super.setup_afterAdd(param1);
            param1 = param1.ProgressBar[0];
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
            update(_value);
            return;
        }// end function

    }
}
