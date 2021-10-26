package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class CreateMovieClipDialog extends _-3g
    {
        private var _path:FPackageItem;
        private var _name:GLabel;

        public function CreateMovieClipDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "CreateMovieClipDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._name = this.contentPane.getChild("n3").asLabel;
            contentPane.getChild("n9").asLabel.editable = false;
            this.contentPane.getChild("btnCreate").addClickListener(_-IJ);
            this.contentPane.getChild("n10").addClickListener(this._-90);
            this.contentPane.getChild("btnCancel").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            this._path = _editor.getActiveFolder();
            this._name.text = this._path.owner.getSequenceName("MovieClip");
            this._-2x(this._path);
            return;
        }// end function

        override public function _-2a() : void
        {
            var pi:FPackageItem;
            try
            {
                pi = this._path.owner.createMovieClipItem(this._name.text, this._path.id);
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
            contentPane.getChild("n9").text = "/" + this._path.owner.name + this._path.id;
            return;
        }// end function

    }
}
