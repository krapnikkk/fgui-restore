package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import flash.events.*;

    public class WaitingDialog extends _-3g
    {
        private var _-Mn:Function;

        public function WaitingDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "WaitingDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.modal = true;
            contentPane.getChild("cancel").addClickListener(this._-5Z);
            return;
        }// end function

        public function open(param1:String = null, param2:Function = null) : void
        {
            show();
            if (param1 == null)
            {
                contentPane.getChild("title").text = Consts.strings.text102 + "...";
            }
            else
            {
                contentPane.getChild("title").text = param1;
            }
            contentPane.getChild("cancel").visible = param2 != null;
            this._-Mn = param2;
            return;
        }// end function

        public function _-5Z(event:Event) : void
        {
            hide();
            var _loc_2:* = this._-Mn;
            this._-Mn = null;
            if (_loc_2 != null)
            {
                this._loc_2();
            }
            return;
        }// end function

    }
}
