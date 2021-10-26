package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.event.*;
    import flash.events.*;
    import flash.text.*;
    import flash.ui.*;

    public class ListItemInput extends GLabel
    {
        private var _-Cy:int;
        private var _-5N:Controller;
        private var _input:GTextInput;
        private var _-1V:String;

        public function ListItemInput()
        {
            this._-Cy = 2;
            return;
        }// end function

        public function get _-Fw() : int
        {
            return this._-Cy;
        }// end function

        public function set _-Fw(param1:int) : void
        {
            this._-Cy = param1;
            return;
        }// end function

        override public function set editable(param1:Boolean) : void
        {
            this._input.editable = param1;
            return;
        }// end function

        override public function get editable() : Boolean
        {
            return this._input.editable;
        }// end function

        public function startEditing(param1:String = null) : void
        {
            if (param1 != null)
            {
                this._input.text = param1;
            }
            else
            {
                this._input.text = this.text;
            }
            this._-1V = this._input.text;
            this._-5N.selectedIndex = 1;
            var _loc_2:* = this._input.displayObject as TextField;
            this.root.nativeStage.focus = _loc_2;
            var _loc_3:* = _loc_2.text.length;
            _loc_2.setSelection(_loc_3, 0);
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._-5N = getController("c1");
            this._-5N.selectedIndex = 0;
            this._input = this.getChild("input").asTextInput;
            this._input.addEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
            this._input.addEventListener(KeyboardEvent.KEY_DOWN, this._-6W);
            addClickListener(this.__click);
            return;
        }// end function

        private function __click(event:GTouchEvent) : void
        {
            if (this._-Cy != 0 && event.clickCount == this._-Cy && this._input.editable && this._-5N.selectedIndex == 0)
            {
                this.startEditing();
            }
            return;
        }// end function

        private function __focusOut(event:Event) : void
        {
            this._-5N.selectedIndex = 0;
            var _loc_2:* = this._input.text;
            if (_loc_2 != this._-1V)
            {
                this._-1V = null;
                this.text = _loc_2;
                this.dispatchEvent(new _-Fr(_-Fr._-CF));
            }
            return;
        }// end function

        private function _-6W(event:KeyboardEvent) : void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                this.__focusOut(null);
            }
            else if (event.keyCode == Keyboard.ESCAPE)
            {
                this._-5N.selectedIndex = 0;
            }
            return;
        }// end function

    }
}
