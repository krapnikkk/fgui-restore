package fairygui
{
    import *.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;

    public class PopupMenu extends Object
    {
        protected var _contentPane:GComponent;
        protected var _list:GList;
        protected var _expandingItem:GObject;
        private var _parentMenu:PopupMenu;
        public var visibleItemCount:int = 2147483647;
        public var hideOnClickItem:Boolean = true;

        public function PopupMenu(param1:String = null)
        {
            if (!param1)
            {
                param1 = UIConfig.popupMenu;
                if (!param1)
                {
                    throw new Error("UIConfig.popupMenu not defined");
                }
            }
            _contentPane = this.GComponent(UIPackage.createObjectFromURL(param1));
            _contentPane.addEventListener("addedToStage", __addedToStage);
            _contentPane.addEventListener("removedFromStage", __removeFromStage);
            _list = this.GList(_contentPane.getChild("list"));
            _list.removeChildrenToPool();
            _list.addRelation(_contentPane, 14);
            _list.removeRelation(_contentPane, 15);
            _contentPane.addRelation(_list, 15);
            _list.addEventListener("itemClick", __clickItem);
            return;
        }// end function

        public function dispose() : void
        {
            _contentPane.dispose();
            return;
        }// end function

        public function addItem(param1:String, param2 = null) : GButton
        {
            var _loc_3:* = _list.addItemFromPool().asButton;
            _loc_3.title = param1;
            _loc_3.data = param2;
            _loc_3.grayed = false;
            _loc_3.useHandCursor = false;
            var _loc_4:* = _loc_3.getController("checked");
            if (_loc_3.getController("checked") != null)
            {
                _loc_4.selectedIndex = 0;
            }
            if (Mouse.supportsCursor)
            {
                _loc_3.addEventListener("rollOver", __rollOver);
                _loc_3.addEventListener("rollOut", __rollOut);
            }
            return _loc_3;
        }// end function

        public function addItemAt(param1:String, param2:int, param3 = null) : GButton
        {
            var _loc_4:* = _list.getFromPool().asButton;
            _list.addChildAt(_loc_4, param2);
            _loc_4.title = param1;
            _loc_4.data = param3;
            _loc_4.grayed = false;
            _loc_4.useHandCursor = false;
            var _loc_5:* = _loc_4.getController("checked");
            if (_loc_4.getController("checked") != null)
            {
                _loc_5.selectedIndex = 0;
            }
            if (Mouse.supportsCursor)
            {
                _loc_4.addEventListener("rollOver", __rollOver);
                _loc_4.addEventListener("rollOut", __rollOut);
            }
            return _loc_4;
        }// end function

        public function addSeperator() : void
        {
            if (UIConfig.popupMenu_seperator == null)
            {
                throw new Error("UIConfig.popupMenu_seperator not defined");
            }
            var _loc_1:* = list.addItemFromPool(UIConfig.popupMenu_seperator);
            if (Mouse.supportsCursor)
            {
                _loc_1.addEventListener("rollOver", __rollOver);
                _loc_1.addEventListener("rollOut", __rollOut);
            }
            return;
        }// end function

        public function getItemName(param1:int) : String
        {
            var _loc_2:* = this.GButton(_list.getChildAt(param1));
            return _loc_2.name;
        }// end function

        public function setItemText(param1:String, param2:String) : void
        {
            var _loc_3:* = _list.getChild(param1).asButton;
            _loc_3.title = param2;
            return;
        }// end function

        public function setItemVisible(param1:String, param2:Boolean) : void
        {
            var _loc_3:* = _list.getChild(param1).asButton;
            if (_loc_3.visible != param2)
            {
                _loc_3.visible = param2;
                _list.setBoundsChangedFlag();
            }
            return;
        }// end function

        public function setItemGrayed(param1:String, param2:Boolean) : void
        {
            var _loc_3:* = _list.getChild(param1).asButton;
            _loc_3.grayed = param2;
            return;
        }// end function

        public function setItemCheckable(param1:String, param2:Boolean) : void
        {
            var _loc_3:* = _list.getChild(param1).asButton;
            var _loc_4:* = _loc_3.getController("checked");
            if (_loc_3.getController("checked") != null)
            {
                if (param2)
                {
                    if (_loc_4.selectedIndex == 0)
                    {
                        _loc_4.selectedIndex = 1;
                    }
                }
                else
                {
                    _loc_4.selectedIndex = 0;
                }
            }
            return;
        }// end function

        public function setItemChecked(param1:String, param2:Boolean) : void
        {
            var _loc_3:* = _list.getChild(param1).asButton;
            var _loc_4:* = _loc_3.getController("checked");
            if (_loc_3.getController("checked") != null)
            {
                _loc_4.selectedIndex = param2 ? (2) : (1);
            }
            return;
        }// end function

        public function isItemChecked(param1:String) : Boolean
        {
            var _loc_2:* = _list.getChild(param1).asButton;
            var _loc_3:* = _loc_2.getController("checked");
            if (_loc_3 != null)
            {
                return _loc_3.selectedIndex == 2;
            }
            return false;
        }// end function

        public function removeItem(param1:String) : Boolean
        {
            var _loc_3:* = 0;
            var _loc_2:* = this.GButton(_list.getChild(param1));
            if (_loc_2 != null)
            {
                _loc_3 = _list.getChildIndex(_loc_2);
                _list.removeChildToPoolAt(_loc_3);
                return true;
            }
            return false;
        }// end function

        public function clearItems() : void
        {
            _list.removeChildrenToPool();
            return;
        }// end function

        public function get itemCount() : int
        {
            return _list.numChildren;
        }// end function

        public function get contentPane() : GComponent
        {
            return _contentPane;
        }// end function

        public function get list() : GList
        {
            return _list;
        }// end function

        public function show(param1:GObject = null, param2:Object = null, param3:PopupMenu = null) : void
        {
            var _loc_4:* = param1 != null ? (param1.root) : (GRoot.inst);
            (_loc_4).showPopup(this.contentPane, param1 is GRoot ? (null) : (param1), param2);
            _parentMenu = param3;
            return;
        }// end function

        public function hide() : void
        {
            if (contentPane.parent)
            {
                this.GRoot(contentPane.parent).hidePopup(contentPane);
            }
            return;
        }// end function

        private function showSecondLevelMenu(param1:GObject) : void
        {
            _expandingItem = param1;
            var _loc_2:* = this.PopupMenu(param1.data);
            if (param1 is GButton)
            {
                this.GButton(param1).selected = true;
            }
            _loc_2.show(param1, null, this);
            var _loc_3:* = contentPane.localToRoot(param1.x + param1.width - 5, param1.y - 5);
            _loc_2.contentPane.setXY(_loc_3.x, _loc_3.y);
            return;
        }// end function

        private function closeSecondLevelMenu() : void
        {
            if (!_expandingItem)
            {
                return;
            }
            if (_expandingItem is GButton)
            {
                this.GButton(_expandingItem).selected = false;
            }
            var _loc_1:* = this.PopupMenu(_expandingItem.data);
            if (!_loc_1)
            {
                return;
            }
            _expandingItem = null;
            _loc_1.hide();
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = event.itemObject.asButton;
            if (_loc_2 == null)
            {
                return;
            }
            if (_loc_2.grayed)
            {
                _list.selectedIndex = -1;
                return;
            }
            var _loc_3:* = _loc_2.getController("checked");
            if (_loc_3 != null && _loc_3.selectedIndex != 0)
            {
                if (_loc_3.selectedIndex == 1)
                {
                    _loc_3.selectedIndex = 2;
                }
                else
                {
                    _loc_3.selectedIndex = 1;
                }
            }
            if (hideOnClickItem)
            {
                if (_parentMenu)
                {
                    _parentMenu.hide();
                }
                hide();
            }
            if (_loc_2.data != null && !(_loc_2.data is PopupMenu))
            {
                _loc_4 = _loc_2.data as Function;
                if (_loc_4 != null)
                {
                    if (_loc_4.length == 1)
                    {
                        this._loc_4(event);
                    }
                    else
                    {
                        this._loc_4();
                    }
                }
            }
            return;
        }// end function

        private function __addedToStage(event:Event) : void
        {
            _list.selectedIndex = -1;
            _list.resizeToFit(visibleItemCount, 10);
            return;
        }// end function

        private function __removeFromStage(event:Event) : void
        {
            _parentMenu = null;
            if (_expandingItem)
            {
                GTimers.inst.callLater(closeSecondLevelMenu);
            }
            return;
        }// end function

        private function __rollOver(event:MouseEvent) : void
        {
            var _loc_2:* = this.GObject(event.currentTarget);
            if (_loc_2.data is PopupMenu || _expandingItem)
            {
                GTimers.inst.callDelay(100, __showSubMenu, _loc_2);
            }
            return;
        }// end function

        private function __showSubMenu(param1:GObject) : void
        {
            var _loc_2:* = contentPane.root;
            if (!_loc_2)
            {
                return;
            }
            if (_expandingItem)
            {
                if (_expandingItem == param1)
                {
                    return;
                }
                closeSecondLevelMenu();
            }
            var _loc_3:* = param1.data as PopupMenu;
            if (!_loc_3)
            {
                return;
            }
            showSecondLevelMenu(param1);
            return;
        }// end function

        private function __rollOut(event:MouseEvent) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (!_expandingItem)
            {
                return;
            }
            GTimers.inst.remove(__showSubMenu);
            var _loc_2:* = contentPane.root;
            if (_loc_2)
            {
                _loc_3 = this.PopupMenu(_expandingItem.data);
                _loc_4 = _loc_3.contentPane.globalToLocal(_loc_2.nativeStage.mouseX, _loc_2.nativeStage.mouseY);
                if (_loc_4.x >= 0 && _loc_4.y >= 0 && _loc_4.x < _loc_3.contentPane.width && _loc_4.y < _loc_3.contentPane.height)
                {
                    return;
                }
            }
            closeSecondLevelMenu();
            return;
        }// end function

    }
}
