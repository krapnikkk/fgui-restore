package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.tween.*;

    public class PromptDialog extends _-3g
    {

        public function PromptDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "PromptDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.focusable = false;
            return;
        }// end function

        public function open(param1:String) : void
        {
            show();
            this.alpha = 1;
            contentPane.getChild("title").text = param1;
            GTween.to(1, 0.2, 2).setEase(EaseType.Linear).setTarget(this, "alpha").onComplete(hide);
            return;
        }// end function

        private function _-7m() : void
        {
            hide();
            return;
        }// end function

    }
}
