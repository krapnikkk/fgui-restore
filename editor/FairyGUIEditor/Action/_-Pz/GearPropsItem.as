package _-Pz
{
    import _-Gs.*;
    import fairygui.*;

    public class GearPropsItem extends GLabel
    {
        public var _-11:ControllerInput;
        public var _-6L:ControllerMultiPageInput;
        public var _-3r:GButton;
        public var _-R:GObject;
        public var _-L2:GObject;
        public var _-45:GButton;
        public var _-7y:GButton;

        public function GearPropsItem()
        {
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._-11 = getChild("controller") as ControllerInput;
            this._-6L = getChild("pages") as ControllerMultiPageInput;
            this._-3r = getChild("tween") as GButton;
            this._-R = getChild("gearSettings");
            this._-L2 = getChild("delete");
            this._-45 = getChild("cond") as GButton;
            this._-7y = getChild("positionsInPercent") as GButton;
            return;
        }// end function

    }
}
