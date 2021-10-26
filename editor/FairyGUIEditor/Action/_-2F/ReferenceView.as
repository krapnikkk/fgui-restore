package _-2F
{
    import *.*;
    import _-Gs.*;
    import _-NY.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.ui.*;

    public class ReferenceView extends GComponent
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _list:GList;
        private var _-8E:GLabel;
        private var _-M5:GLabel;
        private var _-B4:GTextField;
        private var _-PW:Controller;
        private var _-Kz:_-GW;
        private var _-7n:Boolean;
        private var _query:_-y;
        private var _-GE:String;
        private static var helperIntList:Vector.<int> = new Vector.<int>;

        public function ReferenceView(param1:IEditor)
        {
            this._editor = param1;
            this._query = new _-y();
            this._panel = UIPackage.createObject("Builder", "ReferenceView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._list = this._panel.getChild("list").asList;
            this._list.itemRenderer = this.renderListItem;
            this._list.addEventListener(ItemEvent.CLICK, this.__clickItem);
            this._list.setVirtual();
            this._-Kz = new _-GW(param1);
            this._-8E = this._panel.getChild("source").asLabel;
            this._-8E.addEventListener(_-Fr._-CF, this.__submit);
            this._-M5 = this._panel.getChild("replaceTarget").asLabel;
            this._panel.getChild("find").addClickListener(this.__find);
            this._panel.getChild("replace").addClickListener(this._-H6);
            this._-B4 = this._panel.getChild("result").asTextField;
            this._-B4.visible = false;
            this._-PW = this._panel.getController("queryType");
            this._-PW.addEventListener(StateChangeEvent.CHANGED, this._-34);
            addEventListener(_-4U._-76, this.handleKeyEvent);
            addEventListener(FocusChangeEvent.CHANGED, this._-AB);
            return;
        }// end function

        public function open(param1:String) : void
        {
            this._-PW.selectedIndex = 0;
            this._-8E.text = param1;
            this.__find(null);
            return;
        }// end function

        private function __find(event:Event) : void
        {
            if (this._-8E.text.length == 0)
            {
                return;
            }
            this._editor.cursorManager.setWaitCursor(true);
            this._-B4.visible = false;
            this._list.numItems = 0;
            this._-GE = this._-8E.text;
            GTimers.inst.callLater(this._-Fn);
            return;
        }// end function

        private function _-Fn() : void
        {
            var _loc_3:* = 0;
            if (this._-PW.selectedIndex == 0)
            {
                this._query._-Ea(this._editor.project, this._-GE);
            }
            else
            {
                this._query._-96(this._editor.project, this._-GE, _-y._-D0);
            }
            this._query._-CN.sort(_-FL);
            this._-B4.visible = true;
            var _loc_1:* = 0;
            var _loc_2:* = this._query._-CN.length;
            if (this._-PW.selectedIndex == 0)
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1 = _loc_1 + this._query._-CN[_loc_3]._-C4;
                    _loc_3++;
                }
            }
            else
            {
                _loc_1 = _loc_2;
            }
            this._-B4.setVar("file_count", "" + _loc_2).setVar("count", "" + _loc_1).flushVars();
            this._list.numItems = _loc_2;
            this._editor.cursorManager.setWaitCursor(false);
            return;
        }// end function

        private function _-H6(event:Event) : void
        {
            var pi2:FPackageItem;
            var evt:* = event;
            if (this._-M5.text.length == 0)
            {
                return;
            }
            var pi1:* = this._editor.project.getItemByURL(this._-GE);
            pi2 = this._editor.project.getItemByURL(this._-M5.text);
            if (pi1 != null && pi1.type != pi2.type)
            {
                this._editor.alert(Consts.strings.text267);
                return;
            }
            if (pi2 == null)
            {
                this._editor.alert(Consts.strings.text112);
                return;
            }
            this._editor.docView.queryToSaveAllDocuments(function (param1:String) : void
            {
                if (param1 != "yes")
                {
                    return;
                }
                _editor.cursorManager.setWaitCursor(true);
                _query.replaceReferences(pi2);
                _editor.cursorManager.setWaitCursor(false);
                __find(null);
                return;
            }// end function
            );
            return;
        }// end function

        private function renderListItem(param1:int, param2:GObject) : void
        {
            var _loc_3:* = ListItem(param2);
            var _loc_4:* = this._query._-CN[param1].item;
            var _loc_5:* = _loc_4.name + "@" + _loc_4.owner.name;
            if (_loc_4.branch.length > 0)
            {
                _loc_5 = _loc_5 + ("  (" + _loc_4.branch + ")");
            }
            _loc_3.text = _loc_5;
            _loc_3.icon = _loc_4.getIcon();
            _loc_3.data = _loc_4;
            _loc_3.draggable = true;
            _loc_3.addEventListener(DragEvent.DRAG_START, this._-5E);
            return;
        }// end function

        public function _-Nx() : void
        {
            helperIntList.length = 0;
            var _loc_1:* = this._list.getSelection(helperIntList);
            var _loc_2:* = this._-Kz._-H0;
            _loc_2.length = 0;
            var _loc_3:* = _loc_1.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2.push(this._query._-CN[_loc_1[_loc_4]].item);
                _loc_4++;
            }
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            var _loc_2:* = FPackageItem(event.itemObject.data);
            this._editor.showPreview(_loc_2);
            if (event.clickCount == 2)
            {
                this._editor.libView.openResource(_loc_2);
            }
            else if (event.rightButton)
            {
                this._-Nx();
                this._-Kz.show(event);
            }
            return;
        }// end function

        private function _-AB(event:FocusChangeEvent) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_2:* = event.newFocusedObject == this;
            if (this._-7n != _loc_2)
            {
                this._-7n = _loc_2;
                _loc_3 = this._list.numChildren;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_5 = ListItem(this._list.getChildAt(_loc_4));
                    _loc_5.setActive(_loc_2);
                    _loc_4++;
                }
            }
            return;
        }// end function

        private function handleKeyEvent(param1:_-4U) : void
        {
            if (param1._-2h != 0)
            {
                this._list.handleArrowKey(param1._-2h);
            }
            return;
        }// end function

        private function _-6W(event:KeyboardEvent) : void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                this.__find(null);
            }
            return;
        }// end function

        private function _-5E(event:DragEvent) : void
        {
            event.preventDefault();
            var _loc_2:* = GButton(event.currentTarget);
            if (!_loc_2.selected)
            {
                this._list.clearSelection();
                this._list.addSelection(this._list.childIndexToItemIndex(this._list.getChildIndex(_loc_2)));
            }
            this._editor.dragManager.startDrag(this._editor.libView, [_loc_2.data]);
            return;
        }// end function

        private function __submit(event:Event) : void
        {
            if (this._-8E.text != this._-GE)
            {
                this._list.numItems = 0;
                this._-B4.visible = false;
            }
            return;
        }// end function

        private function _-34(event:Event) : void
        {
            this._list.numItems = 0;
            this._-B4.visible = false;
            return;
        }// end function

        private static function _-FL(param1:_-1F, param2:_-1F) : int
        {
            var _loc_5:* = 0;
            var _loc_3:* = param1.item;
            var _loc_4:* = param2.item;
            _loc_5 = _loc_3.owner.name.localeCompare(_loc_4.owner.name);
            if (_loc_5 == 0)
            {
                _loc_5 = _loc_3.type.localeCompare(_loc_4.type);
            }
            if (_loc_5 == 0)
            {
                _loc_5 = _loc_3.path.localeCompare(_loc_4.path);
            }
            if (_loc_5 == 0)
            {
                _loc_5 = _loc_3.name.localeCompare(_loc_4.name);
            }
            return _loc_5;
        }// end function

    }
}
