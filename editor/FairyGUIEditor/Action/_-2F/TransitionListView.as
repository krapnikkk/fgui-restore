package _-2F
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import flash.events.*;

    public class TransitionListView extends GComponent
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _list:GList;
        private var _-FY:Controller;

        public function TransitionListView(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            this._panel = UIPackage.createObject("Builder", "TransitionListView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._-FY = this._panel.getController("testMode");
            this._list = this._panel.getChild("list").asList;
            this._list.addEventListener(ItemEvent.CLICK, this.__clickItem);
            this._panel.getChild("add").addClickListener(this._-Ik);
            this._panel.getChild("delete").addClickListener(this._-M6);
            this._panel.getChild("duplicate").addClickListener(this._-7F);
            this._panel.getChild("rename").addClickListener(this._-Fa);
            addEventListener(_-4U._-76, this.handleKeyEvent);
            addEventListener(FocusChangeEvent.CHANGED, this._-AB);
            this._editor.on(EditorEvent.DocumentActivated, this._-A2);
            this._editor.on(EditorEvent.DocumentDeactivated, this._-1f);
            this._editor.on(EditorEvent.TestStart, function () : void
            {
                _-FY.selectedIndex = 1;
                return;
            }// end function
            );
            this._editor.on(EditorEvent.TestStop, function () : void
            {
                _-FY.selectedIndex = 0;
                return;
            }// end function
            );
            return;
        }// end function

        public function refresh() : void
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_1:* = this._editor.docView.activeDocument;
            var _loc_2:* = _loc_1.content.transitions.items;
            var _loc_3:* = _loc_2.length;
            this._list.removeChildrenToPool();
            var _loc_4:* = this._editor.testView.running;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_7 = this._list.addItemFromPool().asButton;
                _loc_7.title = _loc_2[_loc_5].name;
                _loc_8 = ListItemInput(_loc_7.getChild("title"));
                _loc_8.addEventListener(_-Fr._-CF, this._-NA);
                _loc_8._-Fw = 0;
                _loc_5++;
            }
            var _loc_6:* = Consts.strings.text322;
            if (_loc_3 > 0)
            {
                _loc_6 = _loc_6 + (" (" + _loc_3 + ")");
            }
            this._editor.viewManager.setViewTitle("fairygui.TransitionListView", _loc_6);
            return;
        }// end function

        private function _-A2() : void
        {
            this.refresh();
            return;
        }// end function

        private function _-1f() : void
        {
            this._list.removeChildrenToPool();
            this._editor.viewManager.setViewTitle("fairygui.TransitionListView", Consts.strings.text322);
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (event.clickCount == 2)
            {
                _loc_2 = this._list.getChildIndex(event.itemObject);
                _loc_3 = this._editor.docView.activeDocument;
                _loc_4 = _loc_3.content.transitions.items[_loc_2];
                if (this._editor.testView.running)
                {
                    this._editor.testView.playTransition(_loc_4.name);
                }
                else
                {
                    _loc_3.enterTimelineMode(_loc_4.name);
                    this._editor.docView.requestFocus();
                }
            }
            return;
        }// end function

        private function _-Ik(event:Event) : void
        {
            var _loc_2:* = this._editor.docView.activeDocument;
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = _loc_2.addTransition(null);
            _loc_2.enterTimelineMode(_loc_3.name);
            return;
        }// end function

        private function _-M6(event:Event) : void
        {
            var _loc_2:* = this._list.selectedIndex;
            if (_loc_2 == -1)
            {
                return;
            }
            var _loc_3:* = this._editor.docView.activeDocument;
            _loc_3.removeTransition(_loc_3.content.transitions.items[_loc_2].name);
            this._list.selectedIndex = _loc_2;
            return;
        }// end function

        private function _-7F(event:Event) : void
        {
            var _loc_2:* = this._list.selectedIndex;
            if (_loc_2 == -1)
            {
                return;
            }
            var _loc_3:* = this._editor.docView.activeDocument;
            _loc_3.duplicateTransition(_loc_3.content.transitions.items[_loc_2].name, null);
            return;
        }// end function

        private function handleKeyEvent(param1:_-4U) : void
        {
            if (param1._-2h != 0)
            {
                this._list.handleArrowKey(param1._-2h);
                return;
            }
            switch(param1._-T)
            {
                case "0201":
                {
                    if (this._-FY.selectedIndex == 0)
                    {
                        this._-Fa(null);
                    }
                    break;
                }
                default:
                {
                    if (this._-FY.selectedIndex == 0)
                    {
                        this._editor.docView.handleKeyEvent(param1);
                    }
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function _-AB(event:FocusChangeEvent) : void
        {
            var _loc_2:* = event.newFocusedObject == this;
            if (!_loc_2)
            {
                this._list.clearSelection();
            }
            return;
        }// end function

        private function _-Fa(event:Event) : void
        {
            var _loc_2:* = this._list.selectedIndex;
            if (_loc_2 == -1)
            {
                return;
            }
            var _loc_3:* = this._list.getChildAt(_loc_2).asButton;
            var _loc_4:* = ListItemInput(_loc_3.getChild("title"));
            _loc_4.startEditing();
            return;
        }// end function

        private function _-NA(event:Event) : void
        {
            var _loc_2:* = this._editor.docView.activeDocument;
            var _loc_3:* = this._list.selectedIndex;
            var _loc_4:* = _loc_2.content.transitions.items[_loc_3];
            _loc_2.setTransitionProperty(_loc_4, "name", event.currentTarget.text);
            return;
        }// end function

    }
}
