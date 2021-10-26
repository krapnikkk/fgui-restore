package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import flash.events.*;
    import flash.text.*;

    public class _-A3 extends _-3g
    {
        private var _input:GLabel;
        private var _-P0:TextField;

        public function _-A3(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "TextInputDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._input = contentPane.getChild("input").asLabel;
            contentPane.getController("c1").selectedIndex = 1;
            contentPane.getChild("ok").addClickListener(_-IJ);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        public function open(param1:TextField) : void
        {
            show();
            this._-P0 = param1;
            this._input.text = param1.text;
            this._-P0.addEventListener(Event.REMOVED_FROM_STAGE, this._-5y);
            this._input.getChild("title").requestFocus();
            return;
        }// end function

        override protected function onHide() : void
        {
            if (this._-P0)
            {
                this._-P0.removeEventListener(Event.REMOVED_FROM_STAGE, this._-5y);
                this._-P0 = null;
            }
            super.onHide();
            return;
        }// end function

        private function _-5y(event:Event) : void
        {
            hide();
            return;
        }// end function

        override public function _-2a() : void
        {
            this._-P0.text = this._input.text;
            _editor.groot.nativeStage.focus = this._-P0;
            _editor.groot.nativeStage.focus = null;
            hide();
            return;
        }// end function

    }
}
