﻿package _-Ds
{
    import *.*;
    import _-NY.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class CreateLabelDialog extends _-3g
    {
        private var _path:FPackageItem;

        public function CreateLabelDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "CreateLabelDialog").asCom;
            this.centerOn(_editor.groot, true);
            contentPane.getChild("n8").text = "400";
            contentPane.getChild("n10").text = "400";
            contentPane.getChild("n13").asLabel.editable = false;
            this.contentPane.getChild("n6").addClickListener(_-IJ);
            this.contentPane.getChild("n14").addClickListener(this._-90);
            this.contentPane.getChild("n7").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            this._path = _editor.getActiveFolder();
            contentPane.getChild("n3").text = this._path.owner.getSequenceName("Label");
            this._-2x(this._path);
            return;
        }// end function

        override public function _-2a() : void
        {
            var pi:FPackageItem;
            try
            {
                pi = new _-Cs(this._path.owner)._-Fq(contentPane.getChild("n3").text, parseInt(contentPane.getChild("n8").text), parseInt(contentPane.getChild("n10").text), this._path.id);
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
