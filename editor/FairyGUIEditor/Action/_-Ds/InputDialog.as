package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;

    public class InputDialog extends _-3g
    {
        private var _callback:Function;

        public function InputDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "InputDialog").asCom;
            this.modal = true;
            this.frame.text = Consts.strings.text84;
            contentPane.getChild("ok").addClickListener(_-IJ);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        public function open(param1:String, param2:String = null, param3:Function = null) : void
        {
            show();
            this.contentPane.getChild("prompt").text = param1;
            this.contentPane.getChild("input").text = param2;
            this._callback = param3;
            this.center(true);
            return;
        }// end function

        override public function _-2a() : void
        {
            this.hide();
            var _loc_1:* = this._callback;
            this._callback = null;
            if (_loc_1 != null)
            {
                this._loc_1(this.contentPane.getChild("input").text);
            }
            return;
        }// end function

    }
}
