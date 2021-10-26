package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;

    public class RegisterDialog extends _-3g
    {
        private var _code:GLabel;

        public function RegisterDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "RegisterDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.modal = true;
            this._code = contentPane.getChild("code").asLabel;
            contentPane.getChild("ok").addClickListener(_-IJ);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            this._code.text = "";
            if (_-D._-8J)
            {
                _editor.getDialog(RegisterNoticeDialog).show();
                this.hide();
            }
            return;
        }// end function

        override public function _-2a() : void
        {
            var code:* = this._code.text;
            try
            {
                _-D.setKey(UtilsStr.trim(code));
                _editor.alert("Thank you for registeration!");
                _-1L(_editor).mainView.updateUserInfo();
                hide();
            }
            catch (err:Error)
            {
                _editor.alert(err.message);
            }
            return;
        }// end function

    }
}
