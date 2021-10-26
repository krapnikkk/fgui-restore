package fairygui.editor.gui
{

    public class ComProperty extends Object
    {
        public var target:String;
        public var propertyId:int;
        public var label:String;
        public var value:Object;

        public function ComProperty(param1:String = null, param2:int = 0, param3:String = null, param4 = undefined) : void
        {
            this.target = param1;
            this.propertyId = param2;
            this.label = param3;
            this.value = param4;
            return;
        }// end function

        public function copyFrom(param1:ComProperty) : void
        {
            this.target = param1.target;
            this.propertyId = param1.propertyId;
            this.label = param1.label;
            this.value = param1.value;
            return;
        }// end function

    }
}
