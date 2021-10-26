package _-Gs
{
    import *.*;
    import fairygui.*;

    public class ListItem extends GButton
    {
        private var _-F9:GObject;
        private var _-7n:Boolean;

        public function ListItem()
        {
            this._-7n = true;
            return;
        }// end function

        public function setActive(param1:Boolean) : void
        {
            if (this._-7n != param1)
            {
                this._-7n = param1;
                this._-F9.alpha = this._-7n ? (1) : (0.5);
            }
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._-F9 = getChild("n1");
            return;
        }// end function

    }
}
