package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import flash.events.*;

    public class AlertDialog extends _-3g
    {
        private var _callback:Function;

        public function AlertDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "AlertDialog").asCom;
            this.modal = true;
            this.frame.text = Consts.strings.text84;
            this.contentPane.removeRelation(this, RelationType.Size);
            contentPane.getChild("n1").addClickListener(this.closeEventHandler);
            return;
        }// end function

        public function open(param1:String, param2:Function = null) : void
        {
            show();
            if (param1 == null)
            {
                param1 = "";
            }
            else
            {
                param1 = param1.replace(/\r\n/g, "\n");
                param1 = param1.replace(/\r/g, "\n");
            }
            this.contentPane.getChild("n2").text = param1;
            this._callback = param2;
            this.setSize(contentPane.width, contentPane.height);
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
                this._loc_1();
            }
            return;
        }// end function

        override protected function closeEventHandler(event:Event) : void
        {
            this._-2a();
            return;
        }// end function

    }
}
