package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import fairygui.tween.*;
    import flash.events.*;
    import flash.ui.*;

    public class _-3g extends Window
    {
        protected var _editor:IEditor;
        protected var _-3P:Boolean;
        protected var _-Ba:GObject;

        public function _-3g(param1:IEditor)
        {
            this._editor = param1;
            addEventListener(_-4U._-76, this.handleKeyEvent);
            addEventListener(FocusChangeEvent.CHANGED, this._-AB);
            return;
        }// end function

        public function get _-OW() : GObject
        {
            return this._-Ba;
        }// end function

        final override public function show() : void
        {
            if (this._editor)
            {
                this._editor.groot.showWindow(this);
            }
            else
            {
                super.show();
            }
            return;
        }// end function

        override protected function doShowAnimation() : void
        {
            try
            {
                this.onShown();
            }
            catch (err:Error)
            {
                _editor.consoleView.logError(null, err);
            }
            if (!this._-3P)
            {
                this.setPivot(0.5, 0.5);
                this.setScale(0.7, 0.7);
                GTween.to2(0.7, 0.7, 1, 1, 0.1).setEase(EaseType.BackOut).setTarget(this, this.setScale);
            }
            return;
        }// end function

        override protected function onHide() : void
        {
            if (this._editor.focusedView != this._editor.docView && this._-Ba && this._-Ba.onStage)
            {
                this._-Ba.requestFocus();
            }
            this._-Ba = null;
            return;
        }// end function

        protected function _-IJ(event:Event) : void
        {
            this._-2a();
            return;
        }// end function

        public function _-2a() : void
        {
            return;
        }// end function

        public function _-E4() : void
        {
            this.hide();
            return;
        }// end function

        protected function handleKeyEvent(param1:_-4U) : void
        {
            if (param1.keyCode == Keyboard.ENTER)
            {
                this._-2a();
            }
            else if (param1.keyCode == Keyboard.ESCAPE)
            {
                this._-E4();
            }
            return;
        }// end function

        private function _-AB(event:FocusChangeEvent) : void
        {
            if (event.newFocusedObject == this && !(event.oldFocusedObject is Window))
            {
                this._-Ba = event.oldFocusedObject;
            }
            return;
        }// end function

    }
}
