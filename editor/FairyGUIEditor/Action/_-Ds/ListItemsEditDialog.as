package _-Ds
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import flash.events.*;

    public class ListItemsEditDialog extends _-3g
    {
        private var _-8e:FList;
        private var _list:GList;
        private var _-M1:Vector.<ListItemData>;
        private var _-AD:_-Gg;

        public function ListItemsEditDialog(param1:IEditor)
        {
            super(param1);
            UIObjectFactory.setPackageItemExtension("ui://Builder/ListItemsEdit_item", ListItemUI);
            this.contentPane = UIPackage.createObject("Builder", "ListItemsEditDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._list = contentPane.getChild("list").asList;
            this._list.addEventListener(ItemEvent.CLICK, this._-3M);
            this._-AD = new _-Gg(this._list, "index");
            this._-AD._-Pt = this._-8f;
            this._-AD._-K9 = this._-7t;
            this._-AD._-Mm = this._-1r;
            contentPane.getChild("save").addClickListener(_-IJ);
            contentPane.getChild("apply").addClickListener(this._-2p);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            contentPane.getChild("addItem").addClickListener(this._-AD.add);
            contentPane.getChild("insertItem").addClickListener(this._-AD.insert);
            contentPane.getChild("removeItem").addClickListener(this._-AD.remove);
            contentPane.getChild("moveUp").addClickListener(this._-AD.moveUp);
            contentPane.getChild("moveDown").addClickListener(this._-AD.moveDown);
            this._-M1 = new Vector.<ListItemData>;
            return;
        }// end function

        public function get _-56() : FList
        {
            return this._-8e;
        }// end function

        public function get _-IK() : ListItemData
        {
            var _loc_1:* = this._list.selectedIndex;
            if (_loc_1 == -1)
            {
                return null;
            }
            return this._-M1[_loc_1];
        }// end function

        public function refresh() : void
        {
            var _loc_1:* = this._list.selectedIndex;
            if (_loc_1 != -1)
            {
                ListItemUI(this._list.getChildAt(_loc_1).asButton).setData(this._-M1[_loc_1], this._-8e.treeViewEnabled);
            }
            return;
        }// end function

        private function _-8f(param1:int, param2:ListItemUI) : void
        {
            var _loc_3:* = new ListItemData();
            _loc_3.url = this._-8e.defaultItem;
            if (param1 > 0)
            {
                _loc_3.level = parseInt(this._list.getChildAt((param1 - 1)).asCom.getChild("level").text);
            }
            else
            {
                _loc_3.level = 0;
            }
            this._-M1.splice(param1, 0, _loc_3);
            param2.setData(_loc_3, this._-8e.treeViewEnabled);
            this._-Bf();
            return;
        }// end function

        private function _-7t(param1:int) : void
        {
            this._-M1.splice(param1, 1);
            this._-Bf();
            return;
        }// end function

        private function _-1r(param1:int, param2:int) : void
        {
            var _loc_3:* = this._-M1[param1];
            this._-M1[param1] = this._-M1[param2];
            this._-M1[param2] = _loc_3;
            return;
        }// end function

        override protected function onShown() : void
        {
            var _loc_1:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            this._-8e = FList(_editor.docView.activeDocument.inspectingTarget);
            var _loc_2:* = this._-8e.items.length;
            this._-M1.length = _loc_2;
            this._list.removeChildrenToPool();
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                _loc_3 = this._-M1[_loc_1];
                _loc_4 = this._-8e.items[_loc_1];
                if (!_loc_3)
                {
                    _loc_3 = new ListItemData();
                    this._-M1[_loc_1] = _loc_3;
                }
                _loc_3.copyFrom(_loc_4);
                _loc_5 = this._list.addItemFromPool() as ListItemUI;
                _loc_5.setData(_loc_3, this._-8e.treeViewEnabled);
                _loc_5.m_index.text = "" + _loc_1;
                _loc_1++;
            }
            contentPane.getChild("clearOnPublish").asButton.selected = this._-8e.clearOnPublish;
            contentPane.getChild("indentColumn").visible = this._-8e.treeViewEnabled;
            this._list.selectedIndex = 0;
            this._-Bf();
            contentPane.getChild("clearOnPublish").asButton.selected = this._-8e.clearOnPublish;
            contentPane.getChild("indentColumn").visible = this._-8e.treeViewEnabled;
            return;
        }// end function

        override protected function onHide() : void
        {
            super.onHide();
            if (_editor.docView.activeDocument)
            {
                _editor.docView.activeDocument.refreshInspectors();
            }
            return;
        }// end function

        private function _-Bf() : void
        {
            _editor.inspectorView.show(["listItem"]);
            return;
        }// end function

        private function _-2p(event:Event) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_7:* = 0;
            var _loc_2:* = this._-M1.length;
            if (this._-8e.treeViewEnabled)
            {
                _loc_7 = -1;
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_3 = this._-M1[_loc_4];
                    if (_loc_3.level < 0 || _loc_3.level > (_loc_7 + 1))
                    {
                        _loc_3.level = _loc_7 + 1;
                    }
                    _loc_7 = _loc_3.level;
                    _loc_4++;
                }
            }
            var _loc_5:* = this._-M1.concat();
            _loc_4 = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3 = new ListItemData();
                _loc_3.copyFrom(_loc_5[_loc_4]);
                _loc_5[_loc_4] = _loc_3;
                _loc_4++;
            }
            var _loc_6:* = contentPane.getChild("clearOnPublish").asButton.selected;
            this._-8e.docElement.setProperty("items", _loc_5);
            this._-8e.docElement.setProperty("clearOnPublish", _loc_6);
            return;
        }// end function

        private function _-3M(event:ItemEvent) : void
        {
            this._-Bf();
            return;
        }// end function

        override public function _-2a() : void
        {
            this._-2p(null);
            this.hide();
            return;
        }// end function

        override protected function handleKeyEvent(param1:_-4U) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (param1._-2h != 0)
            {
                this._list.handleArrowKey(param1._-2h);
                this._-Bf();
            }
            else if (param1._-T == "0000")
            {
                _loc_2 = this._list.selectedIndex;
                if (_loc_2 != -1)
                {
                    _loc_3 = this._list.getChildAt(_loc_2).asButton;
                    _loc_4 = ListItemInput(_loc_3.getChild("title"));
                    if (_loc_4.getChild("input").displayObject != param1.target)
                    {
                        _loc_4.startEditing();
                        param1.preventDefault();
                    }
                }
            }
            return;
        }// end function

    }
}

import *.*;

import _-Gs.*;

import __AS3__.vec.*;

import fairygui.*;

import fairygui.editor.api.*;

import fairygui.editor.gui.*;

import fairygui.event.*;

import flash.events.*;

class ListItemUI extends GButton
{
    public var _status:GButton;
    public var _lock:GButton;
    public var m_index:GObject;
    public var m_url:GObject;
    public var m_title:GObject;
    public var m_icon:GObject;
    public var m_name:GObject;
    public var m_level:GObject;

    function ListItemUI()
    {
        return;
    }// end function

    override protected function constructFromXML(param1:XML) : void
    {
        super.constructFromXML(param1);
        this.m_index = getChild("index");
        this.m_url = getChild("url");
        this.m_url.addEventListener(_-Fr._-CF, this.__submit);
        this.m_title = getChild("title");
        this.m_title.addEventListener(_-Fr._-CF, this.__submit);
        this.m_icon = getChild("icon");
        this.m_icon.addEventListener(_-Fr._-CF, this.__submit);
        this.m_name = getChild("name");
        this.m_name.addEventListener(_-Fr._-CF, this.__submit);
        this.m_level = getChild("level");
        this.m_level.addEventListener(_-Fr._-CF, this.__submit);
        return;
    }// end function

    public function setData(param1:ListItemData, param2:Boolean) : void
    {
        this.data = param1;
        this.m_url.text = param1.url;
        this.m_title.text = param1.title;
        this.m_icon.text = param1.icon;
        this.m_name.text = param1.name;
        this.m_level.visible = param2;
        this.m_level.text = "" + int(param1.level);
        return;
    }// end function

    private function __submit(event:Event) : void
    {
        var _loc_2:* = ListItemData(this.data);
        _loc_2[event.currentTarget.name] = event.currentTarget.text;
        return;
    }// end function

}

