package _-Gs
{
    import fairygui.editor.api.*;
    import flash.display.*;
    import flash.events.*;

    public class _-6j extends Object implements IMenu
    {
        public var realMenu:NativeMenu;

        public function _-6j()
        {
            this.realMenu = new NativeMenu();
            return;
        }// end function

        public function createMenu(param1:int = 0, param2:Function = null) : IMenu
        {
            var _loc_3:* = new _-6j();
            if (param2 != null)
            {
                _loc_3.realMenu.addEventListener(Event.PREPARING, param2);
            }
            return _loc_3;
        }// end function

        public function getSubMenu(param1:String) : IMenu
        {
            var _loc_2:* = this.realMenu.getItemByName(param1);
            return _-6j(_loc_2.data);
        }// end function

        public function removeItem(param1:String) : void
        {
            var _loc_2:* = this.realMenu.getItemByName(param1);
            this.realMenu.removeItem(_loc_2);
            return;
        }// end function

        public function addItem(param1:String, param2:String = null, param3:Function = null, param4:String = null, param5:int = -1, param6:IMenu = null) : void
        {
            var _loc_7:* = null;
            if (param6)
            {
                if (param5 == -1)
                {
                    _loc_7 = this.realMenu.addSubmenu(_-6j(param6).realMenu, param1);
                }
                else
                {
                    _loc_7 = this.realMenu.addSubmenuAt(_-6j(param6).realMenu, param5, param1);
                }
                _loc_7.data = _-6j(param6);
            }
            else
            {
                _loc_7 = new NativeMenuItem(param1);
                if (param5 == -1)
                {
                    _loc_7 = this.realMenu.addItem(_loc_7);
                }
                else
                {
                    _loc_7 = this.realMenu.addItemAt(_loc_7, param5);
                }
            }
            if (param3 != null)
            {
                _loc_7.addEventListener(Event.SELECT, param3);
            }
            _loc_7.name = param2;
            return;
        }// end function

        public function addSeperator(param1:int = -1) : void
        {
            var _loc_2:* = new NativeMenuItem("", true);
            if (param1 == -1)
            {
                _loc_2 = this.realMenu.addItem(_loc_2);
            }
            else
            {
                _loc_2 = this.realMenu.addItemAt(_loc_2, param1);
            }
            return;
        }// end function

        public function setItemEnabled(param1:String, param2:Boolean) : void
        {
            var _loc_3:* = this.realMenu.getItemByName(param1);
            _loc_3.enabled = param2;
            return;
        }// end function

        public function setItemChecked(param1:String, param2:Boolean) : void
        {
            var _loc_3:* = this.realMenu.getItemByName(param1);
            _loc_3.checked = param2;
            return;
        }// end function

        public function clearItems() : void
        {
            this.realMenu.removeAllItems();
            return;
        }// end function

        public function invoke(param1:String) : void
        {
            var _loc_2:* = this.realMenu.getItemByName(param1);
            _loc_2.dispatchEvent(new Event(Event.SELECT));
            return;
        }// end function

    }
}
