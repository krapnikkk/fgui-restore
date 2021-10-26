package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import flash.events.*;

    public class ComPropertyInput extends GLabel
    {
        private var _-NV:Controller;
        private var _-Ew:GButton;
        private var _pages:GComboBox;
        private var _-2T:GObject;
        private var _-Pw:GObject;

        public function ComPropertyInput()
        {
            return;
        }// end function

        public function update(param1:ComProperty, param2:Object) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            this.title = param1.label ? (param1.label) : (param1.target);
            this._-NV.selectedPage = "" + param1.propertyId;
            this._-Ew.selected = param1.value != undefined;
            if (param1.propertyId == -1)
            {
                _loc_3 = this._pages.items;
                _loc_4 = this._pages.values;
                _loc_3.length = 0;
                _loc_4.length = 0;
                if (param2 is FPackageItem)
                {
                    FPackageItem(param2).getComponentData().getControllerPages(param1.target, _loc_3, _loc_4);
                }
                else
                {
                    _loc_5 = FComponent(param2).getController(param1.target);
                    if (_loc_5 != null)
                    {
                        _loc_5.getPageNames(_loc_3);
                        _loc_5.getPageIds(_loc_4);
                    }
                }
                this._pages.items = _loc_3;
                this._pages.values = _loc_4;
            }
            switch(param1.propertyId)
            {
                case -1:
                {
                    this._pages.value = param1.value;
                    break;
                }
                case 0:
                {
                    this._-2T.text = param1.value ? (param1.value) : ("");
                    break;
                }
                case 1:
                {
                    this._-Pw.text = param1.value ? (param1.value) : ("");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get value()
        {
            if (!this._-Ew.selected)
            {
                return undefined;
            }
            switch(this._-NV.selectedIndex)
            {
                case 0:
                {
                    return this._pages.value;
                }
                case 1:
                {
                    return this._-2T.text;
                }
                case 2:
                {
                    return this._-Pw.text;
                }
                default:
                {
                    break;
                }
            }
            return undefined;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._-NV = getController("propertyId");
            this._-Ew = getChild("title").asButton;
            this._pages = getChild("pages").asComboBox;
            this._-2T = getChild("textValue");
            this._-Pw = getChild("iconValue");
            this._-Ew.addEventListener(StateChangeEvent.CHANGED, this._-Ps);
            this._pages.addEventListener(StateChangeEvent.CHANGED, this._-Ps);
            this._-2T.addEventListener(_-Fr._-CF, this._-Ps);
            this._-Pw.addEventListener(_-Fr._-CF, this._-Ps);
            return;
        }// end function

        private function _-Ps(event:Event) : void
        {
            this.dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

    }
}
