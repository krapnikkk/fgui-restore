package _-Pz
{
    import *.*;
    import fairygui.*;

    public class RelationLabel extends GLabel
    {
        private var _title:GButton;
        private var _-M0:GButton;

        public function RelationLabel() : void
        {
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            var xml:* = param1;
            super.constructFromXML(xml);
            this._-M0 = getChild("percent").asButton;
            this._title = getChild("title").asButton;
            this._title.addClickListener(function () : void
            {
                if (_-M0.selected)
                {
                    _-M0.selected = false;
                    _title.selected = false;
                }
                return;
            }// end function
            );
            this._-M0.addClickListener(function () : void
            {
                _title.selected = !_-M0.selected;
                return;
            }// end function
            );
            return;
        }// end function

        public function get selected() : Boolean
        {
            return this._title.selected || this._-M0.selected;
        }// end function

        public function set selected(param1:Boolean) : void
        {
            this._title.selected = param1;
            if (!param1)
            {
                this._-M0.selected = false;
            }
            return;
        }// end function

        public function get _-4P() : Boolean
        {
            return this._-M0.selected;
        }// end function

        public function set _-4P(param1:Boolean) : void
        {
            this._-M0.selected = param1;
            if (param1)
            {
                this._title.selected = false;
            }
            return;
        }// end function

    }
}
