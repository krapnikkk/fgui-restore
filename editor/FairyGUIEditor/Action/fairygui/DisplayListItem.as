package fairygui
{

    public class DisplayListItem extends Object
    {
        public var packageItem:PackageItem;
        public var type:String;
        public var desc:XML;
        public var listItemCount:int;

        public function DisplayListItem(param1:PackageItem, param2:String)
        {
            this.packageItem = param1;
            this.type = param2;
            return;
        }// end function

    }
}
