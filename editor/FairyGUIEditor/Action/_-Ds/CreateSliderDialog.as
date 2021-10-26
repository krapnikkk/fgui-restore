package _-Ds
{
    import *.*;
    import _-NY.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class CreateSliderDialog extends _-3g
    {
        private var _path:FPackageItem;
        private var _-5N:Controller;
        private var _-Bs:Controller;

        public function CreateSliderDialog(param1:IEditor)
        {
            var _loc_2:* = null;
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "CreateSliderDialog").asCom;
            this.centerOn(_editor.groot, true);
            contentPane.getChild("n13").asLabel.editable = false;
            this._-5N = contentPane.getController("c1");
            this._-Bs = contentPane.getController("c4");
            _loc_2 = contentPane.getChild("titleType").asComboBox;
            _loc_2.items = [Consts.strings.text331, Consts.strings.text128, Consts.strings.text129, Consts.strings.text130, Consts.strings.text131];
            _loc_2.values = ["none", "percent", "valueAndmax", "value", "max"];
            _loc_2.selectedIndex = 0;
            this.contentPane.getChild("n18").addClickListener(this._-MZ);
            this.contentPane.getChild("n63").addClickListener(this._-N1);
            this.contentPane.getChild("n6").addClickListener(this._-1);
            this.contentPane.getChild("n14").addClickListener(this._-90);
            this.contentPane.getChild("n7").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            this._path = _editor.getActiveFolder();
            contentPane.getChild("n3").text = this._path.owner.getSequenceName("Slider");
            this._-2x(this._path);
            contentPane.getChild("n38").text = null;
            contentPane.getChild("n84").text = null;
            contentPane.getChild("n75").text = null;
            contentPane.getChild("n76").text = null;
            contentPane.getChild("n77").text = null;
            contentPane.getChild("n78").text = null;
            this._-5N.selectedIndex = 0;
            return;
        }// end function

        override public function _-2a() : void
        {
            if (this._-5N.selectedIndex == 3)
            {
                this._-1(null);
            }
            else
            {
                this._-MZ(null);
            }
            return;
        }// end function

        private function _-MZ(event:Event) : void
        {
            var _loc_2:* = this._-5N;
            var _loc_3:* = _loc_2.selectedIndex + 1;
            _loc_2.selectedIndex = _loc_3;
            return;
        }// end function

        private function _-N1(event:Event) : void
        {
            var _loc_2:* = this._-5N;
            var _loc_3:* = _loc_2.selectedIndex - 1;
            _loc_2.selectedIndex = _loc_3;
            return;
        }// end function

        private function _-1(event:Event) : void
        {
            var gripImages:Array;
            var pi:FPackageItem;
            var evt:* = event;
            try
            {
                gripImages;
                pi = new _-Cs(this._path.owner)._-LD(contentPane.getChild("n3").text, this._-Bs.selectedIndex, contentPane.getChild("n38").text, contentPane.getChild("n84").text, gripImages, contentPane.getChild("titleType").asComboBox.value, this._path.id);
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
