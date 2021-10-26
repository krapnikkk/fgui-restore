package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import flash.events.*;

    public class LinkButton extends GButton
    {

        public function LinkButton()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, this.__addedToStage);
            return;
        }// end function

        private function __addedToStage(event:Event) : void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.__addedToStage);
            var _loc_2:* = FairyGUIEditor._-Eb(this);
            _loc_2.cursorManager.setCursorForObject(this.displayObject, CursorType.FINGER);
            return;
        }// end function

    }
}
