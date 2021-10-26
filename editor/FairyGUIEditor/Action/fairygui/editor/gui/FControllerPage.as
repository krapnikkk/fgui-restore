package fairygui.editor.gui
{

    public class FControllerPage extends Object
    {
        public var id:String;
        public var name:String;
        public var remark:String;

        public function FControllerPage()
        {
            return;
        }// end function

        public function copyFrom(param1:FControllerPage) : void
        {
            this.id = param1.id;
            this.name = param1.name;
            this.remark = param1.remark;
            return;
        }// end function

    }
}
