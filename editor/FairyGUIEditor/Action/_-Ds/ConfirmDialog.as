package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import flash.events.*;

    public class ConfirmDialog extends _-3g
    {
        private var _callback:Function;

        public function ConfirmDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "ConfirmDialog").asCom;
            this.modal = true;
            this.frame.text = Consts.strings.text84;
            this.contentPane.removeRelation(this, RelationType.Size);
            this.contentPane.getChild("n1").addClickListener(_-IJ);
            this.contentPane.getChild("n3").addClickListener(this.closeEventHandler);
            return;
        }// end function

        public function open(param1:String, param2:Function) : void
        {
            show();
            this.contentPane.getChild("n2").text = param1;
            this._callback = param2;
            this.setSize(contentPane.width, contentPane.height);
            this.center(true);
            return;
        }// end function

        override public function _-2a() : void
        {
            hide();
            var _loc_1:* = this._callback;
            this._callback = null;
            if (_loc_1 != null)
            {
                if (_loc_1.length == 1)
                {
                    this._loc_1("ok");
                }
                else
                {
                    this._loc_1();
                }
            }
            return;
        }// end function

        override protected function closeEventHandler(event:Event) : void
        {
            hide();
            var _loc_2:* = this._callback;
            this._callback = null;
            if (_loc_2 != null && _loc_2.length == 1)
            {
                this._loc_2("cancel");
            }
            return;
        }// end function

    }
}
