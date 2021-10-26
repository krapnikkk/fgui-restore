package _-Ds
{
    import *.*;
    import _-NY.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;
    import flash.geom.*;

    public class CreateButtonDialog extends _-3g
    {
        private var _path:FPackageItem;

        public function CreateButtonDialog(param1:IEditor)
        {
            var _loc_2:* = null;
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "CreateButtonDialog").asCom;
            this.centerOn(_editor.groot, true);
            _loc_2 = contentPane.getChild("mode").asComboBox;
            _loc_2.items = [Consts.strings.text127, Consts.strings.text125, Consts.strings.text126];
            _loc_2.values = ["Common", "Check", "Radio"];
            _loc_2.selectedIndex = 0;
            contentPane.getChild("n19").text = "200";
            contentPane.getChild("n21").text = "100";
            contentPane.getChild("n16").asLabel.editable = false;
            this.contentPane.getChild("n13").addClickListener(_-IJ);
            this.contentPane.getChild("n17").addClickListener(this._-90);
            this.contentPane.getChild("n14").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            this._path = _editor.getActiveFolder();
            contentPane.getChild("n2").text = this._path.owner.getSequenceName("Button");
            contentPane.getChild("n7").text = null;
            contentPane.getChild("n8").text = null;
            contentPane.getChild("n9").text = null;
            contentPane.getChild("n10").text = null;
            this._-2x(this._path);
            return;
        }// end function

        override public function _-2a() : void
        {
            var pi:FPackageItem;
            try
            {
                pi = new _-Cs(this._path.owner)._-6u(contentPane.getChild("n2").text, "Button", contentPane.getChild("mode").asComboBox.value, [contentPane.getChild("n7").text, contentPane.getChild("n8").text, contentPane.getChild("n9").text, contentPane.getChild("n10").text], contentPane.getController("c1").selectedIndex == 0 ? (null) : (new Point(parseInt(contentPane.getChild("n19").text), parseInt(contentPane.getChild("n21").text))), false, true, contentPane.getChild("n11").asButton.selected, contentPane.getChild("n12").asButton.selected, false, this._path.id);
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
            contentPane.getChild("n16").text = "/" + this._path.owner.name + this._path.id;
            return;
        }// end function

    }
}
