package _-Ds
{
    import *.*;
    import _-2F.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class ChooseFolderDialog extends _-3g
    {
        private var _projectView:_-Dc;
        private var _callback:Function;
        private var _-4R:FPackageItem;
        private static const _-Gj:Array = ["folder"];

        public function ChooseFolderDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "ChooseFolderDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.modal = true;
            this._projectView = new _-Dc(param1, contentPane.getChild("list").asTree);
            this._projectView._-FC = this._-FC;
            contentPane.getChild("n40").addClickListener(_-IJ);
            contentPane.getChild("n41").addClickListener(closeEventHandler);
            return;
        }// end function

        public function open(param1:FPackageItem, param2:Function) : void
        {
            this._callback = param2;
            this._projectView._-5Q(null, true, true);
            if ((!param1 || !this._projectView.select(param1)) && this._-4R)
            {
                this._projectView.select(this._-4R);
            }
            show();
            return;
        }// end function

        override public function _-2a() : void
        {
            var _loc_1:* = this._callback;
            this._callback = null;
            this._-4R = this._projectView.getSelectedResource();
            if (this._-4R)
            {
                this._loc_1(this._-4R);
            }
            this.hide();
            return;
        }// end function

        private function _-FC(param1:FPackageItem, param2:Array, param3:Vector.<FPackageItem>) : Vector.<FPackageItem>
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (!param3)
            {
                param3 = new Vector.<FPackageItem>;
            }
            if (param1 == null)
            {
                _loc_4 = _editor.project.allPackages;
                for each (_loc_5 in _loc_4)
                {
                    
                    if (!_loc_5.getVar("hide_in_lib"))
                    {
                        param3.push(_loc_5.rootItem);
                    }
                }
            }
            else
            {
                param1.owner.getItemListing(param1, _-Gj, true, false, param3);
            }
            return param3;
        }// end function

    }
}
