package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;

    public class CreatePackageDialog extends _-3g
    {
        private var _name:GLabel;

        public function CreatePackageDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "CreatePackageDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._name = this.contentPane.getChild("n3").asLabel;
            this.contentPane.getChild("btnCreate").addClickListener(_-IJ);
            this.contentPane.getChild("btnCancel").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            this._name.getTextField().requestFocus();
            return;
        }// end function

        override public function _-2a() : void
        {
            try
            {
                _editor.project.createPackage(this._name.text);
                this.hide();
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
                return;
            }
            return;
        }// end function

    }
}
