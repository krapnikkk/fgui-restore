package fairygui.editor.gui
{
    import fairygui.utils.*;
    import flash.events.*;

    public class ComExtention extends EventDispatcher
    {
        protected var _owner:FComponent;
        public var _type:String;

        public function ComExtention()
        {
            return;
        }// end function

        public function get owner() : FComponent
        {
            return this._owner;
        }// end function

        public function set owner(param1:FComponent) : void
        {
            this._owner = param1;
            return;
        }// end function

        public function get title() : String
        {
            return null;
        }// end function

        public function set title(param1:String) : void
        {
            return;
        }// end function

        public function get icon() : String
        {
            return null;
        }// end function

        public function set icon(param1:String) : void
        {
            return;
        }// end function

        public function get color() : uint
        {
            return 0;
        }// end function

        public function set color(param1:uint) : void
        {
            return;
        }// end function

        public function create() : void
        {
            return;
        }// end function

        public function dispose() : void
        {
            return;
        }// end function

        public function read_editMode(param1:XData) : void
        {
            return;
        }// end function

        public function write_editMode() : XData
        {
            return null;
        }// end function

        public function read(param1:XData, param2:Object) : void
        {
            return;
        }// end function

        public function write() : XData
        {
            return null;
        }// end function

        public function handleControllerChanged(param1:FController) : void
        {
            return;
        }// end function

        public function getProp(param1:int)
        {
            return undefined;
        }// end function

        public function setProp(param1:int, param2) : void
        {
            return;
        }// end function

    }
}
