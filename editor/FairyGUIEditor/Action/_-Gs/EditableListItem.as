package _-Gs
{
    import *.*;
    import flash.events.*;

    public class EditableListItem extends ListItem
    {
        private var _input:ListItemInput;

        public function EditableListItem()
        {
            return;
        }// end function

        public function set editable(param1:Boolean) : void
        {
            this._input.editable = param1;
            return;
        }// end function

        public function get editable() : Boolean
        {
            return this._input.editable;
        }// end function

        public function get _-Fw() : int
        {
            return this._input._-Fw;
        }// end function

        public function set _-Fw(param1:int) : void
        {
            this._input._-Fw = param1;
            return;
        }// end function

        public function startEditing(param1:String = null) : void
        {
            this._input.startEditing(param1);
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._input = getChild("title") as ListItemInput;
            this._input._-Fw = 0;
            this._input.addEventListener(_-Fr._-CF, this.__submit);
            return;
        }// end function

        private function __submit(event:Event) : void
        {
            this.text = this._input.text;
            this.dispatchEvent(event);
            return;
        }// end function

    }
}
