package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class ComboBoxEditDialog extends _-3g
    {
        private var _-9b:FComboBox;
        private var _itemList:GList;
        private var _-AD:_-Gg;

        public function ComboBoxEditDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "ComboBoxEditDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._itemList = contentPane.getChild("list").asList;
            this._-AD = new _-Gg(this._itemList);
            this._-AD._-Pt = this._-8f;
            contentPane.getChild("save").addClickListener(this._-Dd);
            contentPane.getChild("close").addClickListener(closeEventHandler);
            contentPane.getChild("addItem").addClickListener(this._-AD.add);
            contentPane.getChild("insertItem").addClickListener(this._-AD.insert);
            contentPane.getChild("removeItem").addClickListener(this._-AD.remove);
            contentPane.getChild("moveUp").addClickListener(this._-AD.moveUp);
            contentPane.getChild("moveDown").addClickListener(this._-AD.moveDown);
            return;
        }// end function

        private function _-IY(param1:GButton, param2:String, param3:String, param4:String) : void
        {
            param1.getChild("text").text = param2;
            param1.getChild("value").text = param3;
            param1.getChild("icon").text = param4;
            return;
        }// end function

        private function _-8f(param1:int, param2:GButton) : void
        {
            this._-IY(param2, "", "", "");
            return;
        }// end function

        override protected function onShown() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            this._-9b = FComboBox(FComponent(_editor.docView.activeDocument.inspectingTarget).extention);
            var _loc_1:* = this._-9b.items;
            this._itemList.removeChildrenToPool();
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                _loc_3 = _loc_1[_loc_2];
                _loc_4 = this._itemList.addItemFromPool().asButton;
                this._-IY(_loc_4, _loc_3[0], _loc_3[1], _loc_3[2]);
                _loc_2++;
            }
            this._itemList.selectedIndex = 0;
            contentPane.getChild("clearOnPublish").asButton.selected = this._-9b.clearOnPublish;
            return;
        }// end function

        private function _-Dd(event:Event) : void
        {
            var _loc_6:* = null;
            var _loc_2:* = [];
            var _loc_3:* = this._itemList.numChildren;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_6 = this._itemList.getChildAt(_loc_4).asCom;
                _loc_2.push([_loc_6.getChild("text").text, _loc_6.getChild("value").text, _loc_6.getChild("icon").text]);
                _loc_4++;
            }
            var _loc_5:* = contentPane.getChild("clearOnPublish").asButton.selected;
            this._-9b.owner.docElement.setExtensionProperty("items", _loc_2);
            this._-9b.owner.docElement.setExtensionProperty("clearOnPublish", _loc_5);
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
                this._itemList.handleArrowKey(param1._-2h);
            }
            else if (param1._-T == "0000")
            {
                _loc_2 = this._itemList.selectedIndex;
                if (_loc_2 != -1)
                {
                    _loc_3 = this._itemList.getChildAt(_loc_2).asButton;
                    _loc_4 = ListItemInput(_loc_3.getChild("text"));
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
