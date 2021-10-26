package _-Gs
{
    import *.*;
    import fairygui.*;
    import flash.events.*;
    import flash.text.*;

    public class TextInput extends GLabel
    {
        private var _-1V:String;
        private var _textField:GTextField;
        private var _-Km:Controller;
        private var _-C7:GObject;

        public function TextInput()
        {
            return;
        }// end function

        override public function set text(param1:String) : void
        {
            this._-C7.visible = param1 != null && param1.length > 0;
            super.text = param1;
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._textField = this.getTextField();
            TextField(this._textField.displayObject).mouseWheelEnabled = false;
            this._-Km = getController("showClear");
            this._-C7 = getChild("clear");
            this._-C7.addClickListener(this._-I1);
            this._-C7.visible = false;
            this._textField.addEventListener(Event.CHANGE, this.__textChanged);
            this._textField.addEventListener(FocusEvent.FOCUS_IN, this.__focusIn);
            this._textField.addEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
            return;
        }// end function

        private function __focusIn(event:Event) : void
        {
            TextField(this._textField.displayObject).mouseWheelEnabled = true;
            this._-1V = this.text;
            return;
        }// end function

        private function __focusOut(event:Event) : void
        {
            TextField(this._textField.displayObject).mouseWheelEnabled = false;
            if (this._-1V != this.text && this.displayObject.stage)
            {
                this.dispatchEvent(new _-Fr(_-Fr._-CF));
            }
            this._-1V = null;
            return;
        }// end function

        private function __textChanged(event:Event) : void
        {
            this._-C7.visible = this._textField.text.length > 0;
            return;
        }// end function

        private function _-I1(event:Event) : void
        {
            this.text = "";
            this.dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

    }
}
