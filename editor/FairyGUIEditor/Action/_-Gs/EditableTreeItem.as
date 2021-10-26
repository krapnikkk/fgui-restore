package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.text.*;
    import flash.ui.*;

    public class EditableTreeItem extends GButton
    {
        private var _-F9:GObject;
        private var _input:GTextInput;
        private var _editing:Controller;
        private var _-7n:Boolean;
        private var _-Cy:int;
        private var _-1V:String;

        public function EditableTreeItem()
        {
            this._-7n = true;
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

        public function setActive(param1:Boolean) : void
        {
            if (this._-7n != param1)
            {
                this._-7n = param1;
                this._-F9.alpha = this._-7n ? (1) : (0.5);
            }
            return;
        }// end function

        public function set editable(param1:Boolean) : void
        {
            this._input.editable = param1;
            return;
        }// end function

        public function get editable() : Boolean
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
            this._editing.selectedIndex = 1;
            var _loc_2:* = this._input.displayObject as TextField;
            this.root.nativeStage.focus = _loc_2;
            var _loc_3:* = _loc_2.text.length;
            _loc_2.setSelection(_loc_3, 0);
            return;
        }// end function

        public function get isEditing() : Boolean
        {
            return this._editing.selectedIndex == 1;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._-F9 = getChild("n1");
            this._input = getChild("input").asTextInput;
            this._editing = getController("editing");
            this._input.addEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
            this._input.addEventListener(KeyboardEvent.KEY_DOWN, this._-6W);
            addClickListener(this.__click);
            return;
        }// end function

        private function __click(event:GTouchEvent) : void
        {
            if (this._-Cy != 0 && event.clickCount == this._-Cy && this._input.editable)
            {
                this.startEditing();
            }
            return;
        }// end function

        private function __focusOut(event:Event) : void
        {
            this._editing.selectedIndex = 0;
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
                GTimers.inst.callLater(this.__focusOut, null);
            }
            else if (event.keyCode == Keyboard.ESCAPE)
            {
                this._editing.selectedIndex = 0;
            }
            return;
        }// end function

    }
}
