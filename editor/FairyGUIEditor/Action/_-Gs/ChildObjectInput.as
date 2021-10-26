package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class ChildObjectInput extends GLabel
    {
        private var _-5N:Controller;
        private var _value:FObject;
        public var typeFilter:Array;

        public function ChildObjectInput()
        {
            return;
        }// end function

        public function set value(param1:FObject) : void
        {
            this._value = param1;
            if (this._value && this._value.docElement.isValid)
            {
                this._-5N.selectedIndex = 0;
                if (this._value.docElement.isRoot)
                {
                    this.title = Consts.strings.text170;
                }
                else
                {
                    this.title = this._value.toString();
                }
                this.icon = this._value.docElement.displayIcon;
            }
            else
            {
                this._-5N.selectedIndex = 1;
            }
            return;
        }// end function

        public function get value() : FObject
        {
            return this._value;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._-5N = getController("c1");
            addClickListener(this.__click);
            getChild("clear").addClickListener(this.__clear);
            return;
        }// end function

        public function start() : void
        {
            if (!this.enabled)
            {
                return;
            }
            var _loc_1:* = FairyGUIEditor._-Eb(this);
            _loc_1.docView.activeDocument.pickObject(this._value, this.__objectSelected, this._-Dp, this.__cancelled);
            return;
        }// end function

        private function __click(event:Event) : void
        {
            this.start();
            return;
        }// end function

        private function _-Dp(param1:FObject) : Boolean
        {
            var _loc_2:* = null;
            if (this.typeFilter != null)
            {
                if (this.typeFilter.indexOf(param1._objectType) == -1)
                {
                    _loc_2 = FairyGUIEditor._-Eb(this);
                    _loc_2.alert(Consts.strings.text326);
                    return false;
                }
            }
            return true;
        }// end function

        private function __objectSelected(param1:FObject) : void
        {
            this.value = param1;
            this.dispatchEvent(new _-Fr(_-Fr._-CF, false, false));
            return;
        }// end function

        private function __cancelled() : void
        {
            this.dispatchEvent(new _-Fr(_-Fr._-DP, false, false));
            return;
        }// end function

        private function __clear(event:Event) : void
        {
            if (!this.enabled)
            {
                return;
            }
            event.stopPropagation();
            this.value = null;
            this.dispatchEvent(new _-Fr(_-Fr._-CF, false, false));
            return;
        }// end function

    }
}
