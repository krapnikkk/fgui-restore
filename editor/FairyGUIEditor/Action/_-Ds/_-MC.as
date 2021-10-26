package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class _-MC extends GButton
    {
        private var _page:FControllerPage;

        public function _-MC()
        {
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            getChild("name").addEventListener(_-Fr._-CF, this._-Kn);
            getChild("remark").addEventListener(_-Fr._-CF, this._-Kn);
            return;
        }// end function

        public function _-DQ(param1:int) : void
        {
            getChild("index").text = "" + param1;
            return;
        }// end function

        public function _-JE(param1:FControllerPage) : void
        {
            this._page = param1;
            this._-q();
            return;
        }// end function

        public function _-q() : void
        {
            getChild("name").text = this._page.name;
            getChild("remark").text = this._page.remark;
            return;
        }// end function

        protected function _-Kn(event:Event) : void
        {
            var _loc_2:* = GObject(event.currentTarget);
            this._page[event.currentTarget.name] = _loc_2.text;
            return;
        }// end function

    }
}
