package _-Ds
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;

    public class FixConflictedNameDialog extends _-3g
    {
        private var _-IL:GTextField;
        private var _name:GLabel;
        private var _-Me:Vector.<FPackageItem>;
        private var _index:int;
        private var _-3s:Vector.<String>;
        private var _callback:Function;
        private var _targetPath:FPackageItem;

        public function FixConflictedNameDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "FixConflictedNameDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._-IL = this.contentPane.getChild("n1").asTextField;
            this._name = this.contentPane.getChild("n2").asLabel;
            this.contentPane.getChild("n3").addClickListener(_-IJ);
            this.contentPane.getChild("n4").addClickListener(closeEventHandler);
            return;
        }// end function

        public function open(param1:Vector.<FPackageItem>, param2:String, param3:Function) : void
        {
            show();
            this._-Me = param1;
            this._callback = param3;
            this._-3s = new Vector.<String>;
            this._index = 0;
            this._targetPath = this._-Me[this._index].owner.getItem(param2);
            this._-IL.text = UtilsStr.formatString(Consts.strings.text242, this._-Me[this._index].name);
            this._name.text = UtilsStr.getFileName(this._-Me[this._index].owner.getUniqueName(this._targetPath, this._-Me[this._index].fileName));
            return;
        }// end function

        override public function _-2a() : void
        {
            this._-3s.push(this._name.text);
            var _loc_2:* = this;
            var _loc_3:* = this._index + 1;
            _loc_2._index = _loc_3;
            var _loc_1:* = this._-Me.length;
            if (this._index < _loc_1)
            {
                this._-IL.text = UtilsStr.formatString(Consts.strings.text242, this._-Me[this._index].name);
                this._name.text = UtilsStr.getFileName(this._-Me[this._index].owner.getUniqueName(this._targetPath, this._-Me[this._index].fileName));
            }
            else
            {
                this._callback(this._-Me, this._-3s);
                this.hide();
            }
            return;
        }// end function

    }
}
