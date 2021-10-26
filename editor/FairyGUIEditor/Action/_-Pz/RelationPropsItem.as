package _-Pz
{
    import _-Gs.*;
    import fairygui.*;

    public class RelationPropsItem extends GLabel
    {
        public var _-Iu:ChildObjectInput;
        public var _-14:GObject;
        public var _-8T:GObject;
        public var _-Hy:GObject;
        public var _-Cp:Controller;
        public var _-H1:Controller;

        public function RelationPropsItem()
        {
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._-Iu = getChild("target") as ChildObjectInput;
            this._-14 = getChild("relations");
            this._-8T = getChild("clear");
            this._-Hy = getChild("sizeRelation");
            this._-Cp = getController("c1");
            this._-H1 = getController("valid");
            return;
        }// end function

    }
}
