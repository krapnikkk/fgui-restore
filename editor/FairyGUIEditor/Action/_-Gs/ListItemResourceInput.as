package _-Gs
{
    import fairygui.event.*;
    import flash.text.*;

    public class ListItemResourceInput extends ResourceInput
    {
        public var _-Fw:int;

        public function ListItemResourceInput()
        {
            this._-Fw = 2;
            return;
        }// end function

        public function startEditing() : void
        {
            _-5N.selectedIndex = 0;
            var _loc_1:* = this._titleObject.displayObject as TextField;
            this.root.nativeStage.focus = _loc_1;
            var _loc_2:* = _loc_1.text.length;
            _loc_1.setSelection(_loc_2, 0);
            return;
        }// end function

        override protected function __click(event:GTouchEvent) : void
        {
            if (this._-Fw != 0 && event.clickCount == this._-Fw && this.editable && _-5N.selectedIndex == 1)
            {
                this.startEditing();
            }
            return;
        }// end function

    }
}
