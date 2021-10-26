package _-Gs
{
    import *.*;
    import _-Ds.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import flash.events.*;
    import flash.text.*;

    public class TextArea extends GLabel
    {
        private var _-1V:String;
        private var _textField:GTextField;
        public var inInspector:Boolean;

        public function TextArea()
        {
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._textField = this.getTextField();
            TextField(this._textField.displayObject).mouseWheelEnabled = false;
            getChild("textEdit").addClickListener(this._-JC);
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

        private function _-JC(event:Event) : void
        {
            var _loc_2:* = FairyGUIEditor._-Eb(this);
            if (this.inInspector)
            {
                TextInputDialog(_loc_2.getDialog(TextInputDialog)).open(this, _loc_2.docView.activeDocument.inspectingTarget);
            }
            else
            {
                _-A3(_loc_2.getDialog(_-A3)).open(TextField(this._textField.displayObject));
            }
            return;
        }// end function

    }
}
