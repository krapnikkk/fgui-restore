package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class CreateComDialog extends _-3g
    {
        private var _path:FPackageItem;
        private var _data:XData;
        private var _callback:Function;
        private var _name:GLabel;

        public function CreateComDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "CreateComDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._name = contentPane.getChild("n3").asLabel;
            contentPane.getChild("n8").text = "800";
            contentPane.getChild("n10").text = "600";
            contentPane.getChild("n13").asLabel.editable = false;
            this.contentPane.getChild("n6").addClickListener(_-IJ);
            this.contentPane.getChild("n14").addClickListener(this._-90);
            this.contentPane.getChild("n7").addClickListener(closeEventHandler);
            return;
        }// end function

        public function open(param1:XData = null, param2:Function = null) : void
        {
            this._data = param1;
            this._callback = param2;
            show();
            return;
        }// end function

        override protected function onShown() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            this._path = _editor.getActiveFolder();
            this._-2x(this._path);
            this._name.text = this._path.owner.getSequenceName("Component");
            if (this._data != null)
            {
                _loc_1 = this._data.getAttribute("size", "400,400");
                _loc_2 = _loc_1.split(",");
                contentPane.getChild("n8").text = _loc_2[0];
                contentPane.getChild("n10").text = _loc_2[1];
            }
            this._name.getTextField().requestFocus();
            return;
        }// end function

        override protected function onHide() : void
        {
            super.onHide();
            this._data = null;
            this._callback = null;
            return;
        }// end function

        override public function _-2a() : void
        {
            var pi:FPackageItem;
            try
            {
                pi = this._path.owner.createComponentItem(this._name.text, parseInt(contentPane.getChild("n8").text), parseInt(contentPane.getChild("n10").text), this._path.id);
                if (this._data != null)
                {
                    UtilsFile.saveXData(pi.file, this._data);
                    pi.setUptoDate();
                }
                if (this._callback != null)
                {
                    this._callback(pi);
                }
                else
                {
                    _editor.libView.openResource(pi);
                }
                this.hide();
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
            }
            return;
        }// end function

        private function _-90(event:Event) : void
        {
            ChooseFolderDialog(_editor.getDialog(ChooseFolderDialog)).open(this._path, this._-2x);
            return;
        }// end function

        private function _-2x(param1:FPackageItem) : void
        {
            this._path = param1;
            contentPane.getChild("n13").text = "/" + this._path.owner.name + this._path.id;
            return;
        }// end function

    }
}
