package _-Gs
{
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import flash.events.*;

    public class _-Eg extends Object implements IMenu
    {
        public var menu:PopupMenu;

        public function _-Eg(param1:PopupMenu = null)
        {
            if (param1)
            {
                this.menu = param1;
            }
            else
            {
                this.menu = new PopupMenu();
            }
            return;
        }// end function

        public function createMenu(param1:int = 0, param2:Function = null) : IMenu
        {
            var width:* = param1;
            var prepareCallback:* = param2;
            var pm:* = new _-Eg();
            if (width != 0)
            {
                pm.menu.contentPane.width = width;
            }
            if (prepareCallback != null)
            {
                pm.menu.contentPane.addEventListener(Event.ADDED_TO_STAGE, function (event:Event) : void
            {
                prepareCallback(event);
                return;
            }// end function
            , false, 1);
            }
            return pm;
        }// end function

        public function getSubMenu(param1:String) : IMenu
        {
            return null;
        }// end function

        public function removeItem(param1:String) : void
        {
            throw new Error("not supported");
        }// end function

        public function addItem(param1:String, param2:String = null, param3:Function = null, param4:String = null, param5:int = -1, param6:IMenu = null) : void
        {
            var _loc_7:* = null;
            if (param5 == -1)
            {
                _loc_7 = this.menu.addItem(param1, param3).asButton;
            }
            else
            {
                _loc_7 = this.menu.addItemAt(param1, param5, param3);
            }
            _loc_7.name = param2;
            if (Consts.isMacOS)
            {
                param4 = param4.replace("Ctrl+", "⌘");
            }
            _loc_7.getChild("shortcut").text = param4;
            if (param6)
            {
                _loc_7.data = _-Eg(param6).menu;
                _loc_7.getChild("arrow").visible = true;
            }
            else
            {
                _loc_7.getChild("arrow").visible = false;
            }
            return;
        }// end function

        public function addSeperator(param1:int = -1) : void
        {
            this.menu.addSeperator();
            return;
        }// end function

        public function setItemEnabled(param1:String, param2:Boolean) : void
        {
            this.menu.setItemGrayed(param1, !param2);
            return;
        }// end function

        public function setItemChecked(param1:String, param2:Boolean) : void
        {
            this.menu.setItemChecked(param1, param2);
            return;
        }// end function

        public function clearItems() : void
        {
            this.menu.clearItems();
            return;
        }// end function

        public function invoke(param1:String) : void
        {
            var _loc_2:* = this.menu.list.getChild(param1).asButton;
            if (_loc_2 == null)
            {
                throw new Error("Menu not found: " + param1);
            }
            var _loc_3:* = _loc_2.data as Function;
            if (_loc_3 != null)
            {
                if (_loc_3.length == 1)
                {
                    this._loc_3(null);
                }
                else
                {
                    this._loc_3();
                }
            }
            return;
        }// end function

    }
}
