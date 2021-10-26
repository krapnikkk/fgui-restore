package _-Gs
{
    import *.*;
    import fairygui.*;
    import flash.events.*;
    import flash.ui.*;

    public class InlineSearchBar extends GButton
    {
        private var _-8U:RegExp;

        public function InlineSearchBar()
        {
            return;
        }// end function

        public function get _-P2() : RegExp
        {
            return this._-8U;
        }// end function

        public function reset() : void
        {
            this.text = "";
            this.visible = false;
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            getChild("cancel").addClickListener(this._-5Z);
            return;
        }// end function

        private function _-5Z(event:Event) : void
        {
            this.text = "";
            this.visible = false;
            this.dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

        public function handleKeyEvent(param1:_-4U) : Boolean
        {
            var _loc_3:* = null;
            if (param1.charCode == Keyboard.BACKSPACE && this.visible)
            {
                _loc_3 = this.text;
                _loc_3 = _loc_3.substr(0, (_loc_3.length - 1));
                this.text = _loc_3;
                if (_loc_3.length == 0)
                {
                    this.visible = false;
                }
                else
                {
                    this._-8U = new RegExp(_loc_3, "i");
                }
                this.dispatchEvent(new _-Fr(_-Fr._-CF));
                return true;
            }
            if (param1.ctrlKey || param1.commandKey || param1.altKey || param1.charCode < 48 || param1.charCode > 122)
            {
                return false;
            }
            var _loc_2:* = String.fromCharCode(param1.charCode).toLowerCase();
            _loc_3 = this.text;
            _loc_3 = _loc_3 + _loc_2;
            this._-8U = new RegExp(_loc_3, "i");
            this.text = _loc_3;
            this.visible = true;
            this.dispatchEvent(new _-Fr(_-Fr._-CF));
            return true;
        }// end function

    }
}
