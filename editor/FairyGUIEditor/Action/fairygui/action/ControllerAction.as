package fairygui.action
{
    import fairygui.*;

    public class ControllerAction extends Object
    {
        public var fromPage:Array;
        public var toPage:Array;

        public function ControllerAction()
        {
            return;
        }// end function

        public function run(param1:Controller, param2:String, param3:String) : void
        {
            if ((fromPage == null || fromPage.length == 0 || fromPage.indexOf(param2) != -1) && (toPage == null || toPage.length == 0 || toPage.indexOf(param3) != -1))
            {
                enter(param1);
            }
            else
            {
                leave(param1);
            }
            return;
        }// end function

        protected function enter(param1:Controller) : void
        {
            return;
        }// end function

        protected function leave(param1:Controller) : void
        {
            return;
        }// end function

        public function setup(param1:XML) : void
        {
            var _loc_2:* = null;
            _loc_2 = param1.@fromPage;
            if (_loc_2)
            {
                fromPage = _loc_2.split(",");
            }
            _loc_2 = param1.@toPage;
            if (_loc_2)
            {
                toPage = _loc_2.split(",");
            }
            return;
        }// end function

        public static function createAction(param1:String) : ControllerAction
        {
            var _loc_2:* = param1;
            while (_loc_2 === "play_transition")
            {
                
                return new PlayTransitionAction();
                
                return new ChangePageAction();
            }
            if ("change_page" === _loc_2) goto 17;
            return null;
        }// end function

    }
}
