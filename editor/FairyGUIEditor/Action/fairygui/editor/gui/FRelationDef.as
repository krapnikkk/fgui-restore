package fairygui.editor.gui
{

    public class FRelationDef extends Object
    {
        public var affectBySelfSizeChanged:Boolean;
        public var percent:Boolean;
        public var type:int;

        public function FRelationDef()
        {
            return;
        }// end function

        public function toString() : String
        {
            return FRelationType.Names[this.type] + (this.percent ? ("%") : (""));
        }// end function

    }
}
