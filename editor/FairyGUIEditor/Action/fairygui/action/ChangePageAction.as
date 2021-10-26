package fairygui.action
{
    import fairygui.*;

    public class ChangePageAction extends ControllerAction
    {
        public var objectId:String;
        public var controllerName:String;
        public var targetPage:String;

        public function ChangePageAction()
        {
            return;
        }// end function

        override protected function enter(param1:Controller) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = null;
            if (!controllerName)
            {
                return;
            }
            if (objectId)
            {
                _loc_3 = param1.parent.getChildById(objectId) as GComponent;
            }
            else
            {
                _loc_3 = param1.parent;
            }
            if (_loc_3)
            {
                _loc_2 = _loc_3.getController(controllerName);
                if (_loc_2 && _loc_2 != param1 && !_loc_2.changing)
                {
                    if (targetPage == "~1")
                    {
                        if (param1.selectedIndex < _loc_2.pageCount)
                        {
                            _loc_2.selectedIndex = param1.selectedIndex;
                        }
                    }
                    else if (targetPage == "~2")
                    {
                        _loc_2.selectedPage = param1.selectedPage;
                    }
                    else
                    {
                        _loc_2.selectedPageId = targetPage;
                    }
                }
            }
            return;
        }// end function

        override public function setup(param1:XML) : void
        {
            super.setup(param1);
            objectId = param1.@objectId;
            controllerName = param1.@controller;
            targetPage = param1.@targetPage;
            return;
        }// end function

    }
}
