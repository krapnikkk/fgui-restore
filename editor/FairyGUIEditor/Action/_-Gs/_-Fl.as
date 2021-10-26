package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import flash.events.*;

    public class _-Fl extends Object implements IMenu
    {
        private var _panel:GComponent;
        private var _list:GList;
        private var _popup:PopupMenu;

        public function _-Fl(param1:GComponent)
        {
            this._panel = param1;
            this._list = this._panel.getChild("list").asList;
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

        public function addItem(param1:String, param2:String = null, param3:Function = null, param4:String = null, param5:int = -1, param6:IMenu = null) : void
        {
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_7:* = this._list.getFromPool().asButton;
            _loc_7.name = param2;
            _loc_7.title = param1;
            _loc_7.addEventListener(GTouchEvent.BEGIN, this.__mouseDown);
            _loc_7.addEventListener(MouseEvent.ROLL_OVER, this.__rollOver);
            if (param6)
            {
                _loc_7.data = param6;
            }
            if (param5 == -1)
            {
                this._list.addChild(_loc_7);
            }
            else
            {
                _loc_8 = this._list.getChildAt(param5);
                if (_loc_8 != null)
                {
                    _loc_9 = this._list.getChildIndex(_loc_8);
                    this._list.addChildAt(_loc_7, _loc_9);
                }
                else
                {
                    this._list.addChild(_loc_7);
                }
            }
            return;
        }// end function

        public function getSubMenu(param1:String) : IMenu
        {
            return this._list.getChild(param1).data as IMenu;
        }// end function

        public function removeItem(param1:String) : void
        {
            this._list.removeChild(this._list.getChild(param1));
            return;
        }// end function

        public function addSeperator(param1:int = -1) : void
        {
            throw new Error("not supported");
        }// end function

        public function setItemEnabled(param1:String, param2:Boolean) : void
        {
            throw new Error("not supported");
        }// end function

        public function setItemChecked(param1:String, param2:Boolean) : void
        {
            throw new Error("not supported");
        }// end function

        public function clearItems() : void
        {
            this._list.removeChildrenToPool();
            return;
        }// end function

        public function invoke(param1:String) : void
        {
            throw new Error("not supported");
        }// end function

        private function _-Mb(param1:GObject) : void
        {
            var _loc_2:* = _-Eg(param1.data);
            _loc_2.menu.show(param1, true);
            this._popup = _loc_2.menu;
            _loc_2.menu.contentPane.addEventListener(Event.REMOVED_FROM_STAGE, this.__popupWinClosed);
            return;
        }// end function

        private function __rollOver(event:Event) : void
        {
            var _loc_2:* = null;
            if (this._popup)
            {
                this._list.root.hidePopup(this._popup.contentPane);
                _loc_2 = event.currentTarget as GObject;
                this._-Mb(_loc_2);
                this._list.selectedIndex = this._list.getChildIndex(_loc_2);
            }
            return;
        }// end function

        private function __mouseDown(event:GTouchEvent) : void
        {
            var _loc_2:* = GObject(event.currentTarget);
            this._-Mb(_loc_2);
            return;
        }// end function

        private function __popupWinClosed(event:Event) : void
        {
            this._list.selectedIndex = -1;
            this._popup = null;
            return;
        }// end function

    }
}
