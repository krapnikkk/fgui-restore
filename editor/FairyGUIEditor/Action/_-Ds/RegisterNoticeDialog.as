package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.settings.*;
    import flash.events.*;
    import flash.net.*;

    public class RegisterNoticeDialog extends _-3g
    {

        public function RegisterNoticeDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "RegisterNoticeDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.modal = true;
            contentPane.getChild("buy").addClickListener(this._-C2);
            contentPane.getChild("register").addClickListener(this._-GU);
            contentPane.getChild("cancel").addClickListener(this._-5Z);
            return;
        }// end function

        override protected function onShown() : void
        {
            contentPane.getController("c1").selectedIndex = _-D._-8J ? (1) : (_-D._-DB ? (2) : (0));
            contentPane.getChild("msg").asTextField.setVar("expire", _-D._-2Q).flushVars();
            return;
        }// end function

        private function _-C2(event:Event) : void
        {
            var _loc_2:* = null;
            hide();
            if (Consts.language == "zh-CN")
            {
                _loc_2 = "https://www.fairygui.com/buy.html";
            }
            else
            {
                _loc_2 = "https://en.fairygui.com/buy.html";
            }
            navigateToURL(new URLRequest(_loc_2));
            return;
        }// end function

        private function _-GU(event:Event) : void
        {
            hide();
            _editor.getDialog(RegisterDialog).show();
            return;
        }// end function

        private function _-5Z(event:Event) : void
        {
            hide();
            return;
        }// end function

    }
}
