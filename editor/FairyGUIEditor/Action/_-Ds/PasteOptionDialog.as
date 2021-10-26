package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;

    public class PasteOptionDialog extends _-3g
    {
        private var _callback:Function;
        private var _-IF:Controller;

        public function PasteOptionDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "PasteOptionDialog").asCom;
            this.modal = true;
            this.centerOn(_editor.groot, true);
            this._-IF = this.contentPane.getController("c1");
            this.contentPane.getChild("n3").addClickListener(_-IJ);
            this.contentPane.getChild("n4").addClickListener(closeEventHandler);
            return;
        }// end function

        public function open(param1:Function) : void
        {
            this._callback = param1;
            show();
            return;
        }// end function

        override public function _-2a() : void
        {
            this._callback(this._-IF.selectedIndex);
            this.hide();
            return;
        }// end function

    }
}
