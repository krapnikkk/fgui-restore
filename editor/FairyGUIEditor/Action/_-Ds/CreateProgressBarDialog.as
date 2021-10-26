package _-Ds
{
    import *.*;
    import _-NY.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class CreateProgressBarDialog extends _-3g
    {
        private var _path:FPackageItem;

        public function CreateProgressBarDialog(param1:IEditor)
        {
            var _loc_2:* = null;
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "CreateProgressBarDialog").asCom;
            this.centerOn(_editor.groot, true);
            contentPane.getChild("n13").asLabel.editable = false;
            _loc_2 = contentPane.getChild("titleType").asComboBox;
            _loc_2.items = [Consts.strings.text331, Consts.strings.text128, Consts.strings.text129, Consts.strings.text130, Consts.strings.text131];
            _loc_2.values = ["none", "percent", "valueAndmax", "value", "max"];
            _loc_2.selectedIndex = 0;
            this.contentPane.getChild("n6").addClickListener(_-IJ);
            this.contentPane.getChild("n14").addClickListener(this._-90);
            this.contentPane.getChild("n7").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            this._path = _editor.getActiveFolder();
            contentPane.getChild("n3").text = this._path.owner.getSequenceName("ProgressBar");
            this._-2x(this._path);
            contentPane.getChild("n38").text = null;
            contentPane.getChild("n83").text = null;
            return;
        }// end function

        override public function _-2a() : void
        {
            var pi:FPackageItem;
            try
            {
                pi = new _-Cs(this._path.owner)._-8O(contentPane.getChild("n3").text, contentPane.getChild("n38").text, contentPane.getChild("n83").text, contentPane.getChild("titleType").asComboBox.value, contentPane.getChild("reverse").asButton.selected, this._path.id);
                _editor.libView.openResource(pi);
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
