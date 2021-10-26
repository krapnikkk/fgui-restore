package _-An
{
    import *.*;
    import _-Ds.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;

    class _-4i extends Object
    {
        private var _panel:GComponent;
        private var _parent:DocumentView;
        private var _list:GList;
        private var _-4k:GButton;

        function _-4i(param1:DocumentView)
        {
            var parent:* = param1;
            this._parent = parent;
            this._panel = GComponent(parent).getChildAt(0).asCom.getChild("controllerPanel").asCom;
            this._list = this._panel.getChild("list").asList;
            this._list.addSizeChangeCallback(this._-a);
            this._list.addEventListener(ItemEvent.CLICK, this.__clickItem);
            this._-4k = this._list.getChildAt((this._list.numChildren - 1)).asButton;
            this._-4k.addClickListener(function () : void
            {
                if (!_parent.activeDocument.timelineMode)
                {
                    ControllerEditDialog(_parent._editor.getDialog(ControllerEditDialog)).open(null);
                }
                return;
            }// end function
            );
            this._list.removeChildrenToPool();
            return;
        }// end function

        public function refresh() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            this._list.removeChildrenToPool();
            var _loc_1:* = this._parent.activeDocument;
            for each (_loc_2 in _loc_1.content.controllers)
            {
                
                _loc_3 = this._list.addItemFromPool().asButton;
                _loc_3.name = _loc_2.name;
                _loc_3.title = _loc_2.name + (_loc_2.alias ? (" - " + _loc_2.alias) : (""));
                _loc_2.addEventListener(StateChangeEvent.CHANGED, this._-7A);
                this.setPages(_loc_2, _loc_3, -1);
            }
            this._list.addChild(this._-4k);
            this._list.resizeToFit();
            return;
        }// end function

        public function _-Jf(param1:FController) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_2:* = this._parent.activeDocument;
            var _loc_3:* = this._list.getChild(param1.name) as GComponent;
            if (_loc_3 == null)
            {
                this.refresh();
            }
            else
            {
                _loc_3.text = param1.name + (param1.alias ? (" - " + param1.alias) : (""));
                _loc_4 = this._list.getChildIndex(_loc_3);
                _loc_5 = this._list.numChildren;
                _loc_6 = _loc_4 + 1;
                while (_loc_6 < _loc_5)
                {
                    
                    _loc_7 = this._list.getChildAt(_loc_6) as GButton;
                    if (!_loc_7.data)
                    {
                        break;
                    }
                    this._list.removeChildAt(_loc_6);
                    _loc_5 = _loc_5 - 1;
                }
                this.setPages(param1, _loc_3, _loc_6);
                this._list.resizeToFit();
            }
            return;
        }// end function

        public function clear() : void
        {
            this._list.removeChildrenToPool();
            return;
        }// end function

        private function _-7A(event:Event) : void
        {
            var _loc_9:* = null;
            var _loc_2:* = FController(event.currentTarget);
            var _loc_3:* = this._parent.activeDocument;
            if (_loc_3 == null || _loc_2.parent != _loc_3.content)
            {
                return;
            }
            var _loc_4:* = this._list.getChild(_loc_2.name) as GComponent;
            if (this._list.getChild(_loc_2.name) as GComponent == null)
            {
                return;
            }
            var _loc_5:* = this._list.getChildIndex(_loc_4) + 1;
            var _loc_6:* = this._list.numChildren;
            var _loc_7:* = 0;
            var _loc_8:* = _loc_5;
            while (_loc_8 < _loc_6)
            {
                
                _loc_9 = this._list.getChildAt(_loc_8) as GButton;
                if (!_loc_9.data)
                {
                    break;
                }
                if (_loc_7 == _loc_2.selectedIndex)
                {
                    _loc_9.selected = true;
                }
                else
                {
                    _loc_9.selected = false;
                }
                _loc_7++;
                _loc_8++;
            }
            return;
        }// end function

        private function setPages(param1:FController, param2:GComponent, param3:int) : void
        {
            var _loc_4:* = null;
            var _loc_8:* = null;
            var _loc_5:* = param3 < 0;
            var _loc_6:* = param1.getPages();
            var _loc_7:* = 0;
            while (_loc_7 < _loc_6.length)
            {
                
                if (_loc_5)
                {
                    _loc_4 = this._list.addItemFromPool("ui://Builder/ControllerItem").asButton;
                }
                else
                {
                    _loc_4 = this._list.addChildAt(this._list.getFromPool("ui://Builder/ControllerItem"), param3++).asButton;
                }
                _loc_8 = _loc_6[_loc_7];
                if (_loc_8.name)
                {
                    _loc_4.text = _loc_7 + ":" + _loc_8.name;
                }
                else if (_loc_8.remark)
                {
                    _loc_4.text = _loc_7 + ":" + _loc_8.remark;
                }
                else
                {
                    _loc_4.text = "" + _loc_7;
                }
                _loc_4.data = param2;
                _loc_4.selected = _loc_7 == param1.selectedIndex;
                _loc_7++;
            }
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_2:* = this._parent.activeDocument;
            var _loc_3:* = event.itemObject as GButton;
            if (_loc_3.data)
            {
                _loc_3.selected = true;
                _loc_4 = GComponent(_loc_3.data);
                _loc_5 = _loc_2.content.getController(_loc_4.name);
                _loc_6 = this._list.getChildIndex(_loc_4);
                _loc_7 = this._list.numChildren;
                _loc_8 = _loc_5.selectedIndex;
                _loc_10 = _loc_6 + 1;
                while (_loc_10 < _loc_7)
                {
                    
                    _loc_11 = this._list.getChildAt(_loc_10) as GButton;
                    if (!_loc_11.data)
                    {
                        break;
                    }
                    else if (_loc_11 == _loc_3)
                    {
                        _loc_9 = _loc_10 - _loc_6 - 1;
                    }
                    else
                    {
                        GButton(_loc_11).selected = false;
                    }
                    _loc_10++;
                }
                _loc_2.switchPage(_loc_5.name, _loc_9);
            }
            else if (!_loc_2.timelineMode)
            {
                _loc_5 = _loc_2.content.getController(_loc_3.name);
                ControllerEditDialog(this._parent._editor.getDialog(ControllerEditDialog)).open(_loc_5);
            }
            return;
        }// end function

        private function _-a() : void
        {
            GTimers.inst.callLater(this._-6G);
            return;
        }// end function

        private function _-6G() : void
        {
            this._list.resizeToFit(int.MAX_VALUE, this._list.initHeight);
            return;
        }// end function

    }
}
