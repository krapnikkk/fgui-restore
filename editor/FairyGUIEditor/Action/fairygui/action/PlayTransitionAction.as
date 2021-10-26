package fairygui.action
{
    import *.*;
    import fairygui.*;

    public class PlayTransitionAction extends ControllerAction
    {
        public var transitionName:String;
        public var playTimes:int;
        public var delay:Number;
        public var stopOnExit:Boolean;
        private var _currentTransition:Transition;

        public function PlayTransitionAction()
        {
            playTimes = 1;
            delay = 0;
            return;
        }// end function

        override protected function enter(param1:Controller) : void
        {
            var _loc_2:* = param1.parent.getTransition(transitionName);
            if (_loc_2)
            {
                if (_currentTransition && _currentTransition.playing)
                {
                    _loc_2.changePlayTimes(playTimes);
                }
                else
                {
                    _loc_2.play(null, null, playTimes, delay);
                }
                _currentTransition = _loc_2;
            }
            return;
        }// end function

        override protected function leave(param1:Controller) : void
        {
            if (stopOnExit && _currentTransition)
            {
                _currentTransition.stop();
                _currentTransition = null;
            }
            return;
        }// end function

        override public function setup(param1:XML) : void
        {
            var _loc_2:* = null;
            super.setup(param1);
            transitionName = param1.@transition;
            _loc_2 = param1.@repeat;
            if (_loc_2)
            {
                playTimes = this.parseInt(_loc_2);
            }
            _loc_2 = param1.@delay;
            if (_loc_2)
            {
                delay = this.parseFloat(_loc_2);
            }
            _loc_2 = param1.@stopOnExit;
            stopOnExit = _loc_2 == "true";
            return;
        }// end function

    }
}
