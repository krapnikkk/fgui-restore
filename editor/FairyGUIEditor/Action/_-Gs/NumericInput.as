package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.ui.*;

    public class NumericInput extends GLabel
    {
        private var _min:Number;
        private var _max:Number;
        private var _value:Number;
        private var _-Q:GObject;
        private var _-Dx:Point;
        private var _-Mi:Boolean;
        private var _-K3:int;
        private var _-7J:Number;
        private var _-Au:Number;
        private var _textField:GTextInput;

        public function NumericInput()
        {
            this._min = 0;
            this._max = int.MAX_VALUE;
            this._value = 0;
            this._-7J = 1;
            this._-Au = 0;
            this._-K3 = 0;
            this._-Dx = new Point();
            return;
        }// end function

        public function get max() : Number
        {
            return this._max;
        }// end function

        public function set max(param1:Number) : void
        {
            this._max = param1;
            return;
        }// end function

        public function get min() : Number
        {
            return this._min;
        }// end function

        public function set min(param1:Number) : void
        {
            this._min = param1;
            return;
        }// end function

        public function get value() : Number
        {
            return this._value;
        }// end function

        public function set value(param1:Number) : void
        {
            if (this._-Au != 0)
            {
                param1 = Math.round(param1 * this._-Au) / this._-Au;
            }
            this._value = param1;
            if (this._value > this._max)
            {
                this._value = this._max;
            }
            else if (this._value < this._min)
            {
                this._value = this._min;
            }
            super.text = UtilsStr.toFixed(this._value, this._-K3);
            return;
        }// end function

        public function get step() : Number
        {
            return this._-7J;
        }// end function

        public function set step(param1:Number) : void
        {
            this._-7J = param1;
            return;
        }// end function

        public function get fractionDigits() : int
        {
            return this._-K3;
        }// end function

        public function set fractionDigits(param1:int) : void
        {
            this._-K3 = param1;
            if (this._-K3 != 0)
            {
                this._-Au = Math.pow(10, this._-K3);
            }
            else
            {
                this._-Au = 0;
            }
            return;
        }// end function

        override public function set text(param1:String) : void
        {
            this._value = parseFloat(param1);
            if (isNaN(this._value))
            {
                this._value = 0;
            }
            if (this._value > this._max)
            {
                this._value = this._max;
            }
            else if (this._value < this._min)
            {
                this._value = this._min;
            }
            super.text = UtilsStr.toFixed(this._value, this._-K3);
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this.opaque = true;
            this._-Q = getChild("holder");
            this._-Q.draggable = true;
            this._-Q.addEventListener(DragEvent.DRAG_START, this._-b);
            this._-Q.addEventListener(DragEvent.DRAG_END, this._-FN);
            this._textField = this.getTextField() as GTextInput;
            this._textField.touchable = false;
            TextField(this._textField.displayObject).mouseWheelEnabled = false;
            this._textField.disableIME = true;
            this._textField.addEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
            this._textField.addEventListener(KeyboardEvent.KEY_DOWN, this._-6W);
            this._-Q.addClickListener(this.__click);
            this._textField.displayObject.addEventListener(MouseEvent.MOUSE_WHEEL, this.__mouseWheel);
            this.displayObject.addEventListener(MouseEvent.MOUSE_DOWN, this.__mousedown);
            this.addEventListener(Event.ADDED_TO_STAGE, this.__addedToStage);
            return;
        }// end function

        private function __addedToStage(event:Event) : void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.__addedToStage);
            var _loc_2:* = FairyGUIEditor._-Eb(this);
            _loc_2.cursorManager.setCursorForObject(this.displayObject, CursorType.ADJUST, this._-EU, true);
            return;
        }// end function

        private function _-b(event:Event) : void
        {
            if (this._textField.touchable || !this._textField.editable)
            {
                event.preventDefault();
            }
            else
            {
                this._-Mi = true;
                this._-Q.addXYChangeCallback(this._-BI);
            }
            return;
        }// end function

        private function _-FN(event:Event) : void
        {
            this._-Q.removeXYChangeCallback(this._-BI);
            this._-Q.setXY(0, 0);
            this._-Dx.x = 0;
            this._-Dx.y = 0;
            return;
        }// end function

        private function _-BI() : void
        {
            var _loc_4:* = NaN;
            var _loc_1:* = this._-Q.x - this._-Dx.x;
            var _loc_2:* = this._-Q.y - this._-Dx.y;
            var _loc_3:* = Math.abs(_loc_1) > Math.abs(_loc_2) ? (_loc_1) : (_loc_2);
            if (_loc_3 != 0)
            {
                this._-Dx.x = this._-Q.x;
                this._-Dx.y = this._-Q.y;
                _loc_4 = this._value + _loc_3 * this._-7J;
                if (this._-Au != 0)
                {
                    _loc_4 = Math.round(_loc_4 * this._-Au) / this._-Au;
                }
                this.text = "" + _loc_4;
                this.dispatchEvent(new _-Fr(_-Fr._-CF));
            }
            return;
        }// end function

        private function __click(event:Event) : void
        {
            if (this._-Mi)
            {
                this._-Mi = false;
                return;
            }
            if (!this._textField.editable)
            {
                return;
            }
            this._textField.touchable = true;
            var _loc_2:* = FairyGUIEditor._-Eb(this);
            _loc_2.cursorManager.updateCursor();
            this._textField.requestFocus();
            TextField(this._textField.displayObject).setSelection(0, TextField(this._textField.displayObject).length);
            return;
        }// end function

        private function __focusOut(event:Event) : void
        {
            var _loc_2:* = parseFloat(this.text);
            if (isNaN(_loc_2))
            {
                _loc_2 = 0;
            }
            if (_loc_2 < this._min)
            {
                _loc_2 = this._min;
            }
            else if (_loc_2 > this._max)
            {
                _loc_2 = this._max;
            }
            this._textField.touchable = false;
            if (_loc_2 != this._value)
            {
                this.text = "" + _loc_2;
                this.dispatchEvent(new _-Fr(_-Fr._-CF));
            }
            return;
        }// end function

        private function _-6W(event:KeyboardEvent) : void
        {
            var _loc_2:* = NaN;
            if (event.keyCode == Keyboard.ENTER)
            {
                _loc_2 = parseFloat(this.text);
                if (isNaN(_loc_2))
                {
                    _loc_2 = 0;
                }
                if (_loc_2 < this._min)
                {
                    _loc_2 = this._min;
                }
                else if (_loc_2 > this._max)
                {
                    _loc_2 = this._max;
                }
                event.preventDefault();
                if (_loc_2 != this._value)
                {
                    this._value = _loc_2;
                    this.dispatchEvent(new _-Fr(_-Fr._-CF));
                }
            }
            return;
        }// end function

        private function _-EU() : Boolean
        {
            return !this._textField.touchable;
        }// end function

        private function __mouseWheel(event:MouseEvent) : void
        {
            if (!this._textField.touchable)
            {
                return;
            }
            event.stopPropagation();
            if (event.delta < 0)
            {
                this.value = this.value + this._-7J;
            }
            else
            {
                this.value = this.value - this._-7J;
            }
            this.dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

        private function __mousedown(event:Event) : void
        {
            event.stopPropagation();
            return;
        }// end function

    }
}
