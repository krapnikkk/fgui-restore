package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import flash.events.*;

    public class SaveConfirmDialog extends _-3g
    {
        private var _list:GList;
        private var _callback:Function;

        public function SaveConfirmDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "SaveConfirmDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.modal = true;
            this.frame.text = Consts.strings.text84;
            contentPane.getChild("btnYes").addClickListener(_-IJ);
            contentPane.getChild("btnNo").addClickListener(this._-Cq);
            contentPane.getChild("btnCancel").addClickListener(this._-5Z);
            this._list = contentPane.getChild("list").asList;
            this._list.selectionMode = ListSelectionMode.None;
            return;
        }// end function

        public function open(param1:Array, param2:Function) : void
        {
            var _loc_5:* = null;
            this.show();
            this._callback = param2;
            this._list.removeChildrenToPool();
            var _loc_3:* = param1.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this._list.addItemFromPool().asButton;
                _loc_5.title = param1[_loc_4];
                _loc_4++;
            }
            this._list.scrollPane.scrollTop();
            this._list.selectNone();
            return;
        }// end function

        override public function _-2a() : void
        {
            this.hide();
            this._callback("yes");
            return;
        }// end function

        private function _-Cq(event:Event) : void
        {
            this.hide();
            this._callback("no");
            return;
        }// end function

        private function _-5Z(event:Event) : void
        {
            this.hide();
            this._callback("cancel");
            return;
        }// end function

    }
}
