package fairygui.gears
{
    import fairygui.tween.*;

    public class GearTweenConfig extends Object
    {
        public var tween:Boolean;
        public var easeType:int;
        public var duration:Number;
        public var delay:Number;
        var _tweener:GTweener;
        var _displayLockToken:uint;

        public function GearTweenConfig()
        {
            tween = true;
            easeType = 5;
            duration = 0.3;
            delay = 0;
            _displayLockToken = 0;
            return;
        }// end function

    }
}
