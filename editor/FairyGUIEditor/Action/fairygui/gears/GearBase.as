package fairygui.gears
{
    import *.*;
    import fairygui.*;
    import fairygui.tween.*;

    public class GearBase extends Object
    {
        protected var _owner:GObject;
        protected var _controller:Controller;
        protected var _tweenConfig:GearTweenConfig;
        public static var disableAllTweenEffect:Boolean = false;
        private static var Classes:Array = null;
        private static const NameToIndex:Object = {gearDisplay:0, gearXY:1, gearSize:2, gearLook:3, gearColor:4, gearAni:5, gearText:6, gearIcon:7, gearDisplay2:8, gearFontSize:9};

        public function GearBase(param1:GObject)
        {
            _owner = param1;
            return;
        }// end function

        public function dispose() : void
        {
            if (_tweenConfig != null && _tweenConfig._tweener != null)
            {
                _tweenConfig._tweener.kill();
                _tweenConfig._tweener = null;
            }
            return;
        }// end function

        final public function get controller() : Controller
        {
            return _controller;
        }// end function

        public function set controller(param1:Controller) : void
        {
            if (param1 != _controller)
            {
                _controller = param1;
                if (_controller)
                {
                    init();
                }
            }
            return;
        }// end function

        public function get tweenConfig() : GearTweenConfig
        {
            if (_tweenConfig == null)
            {
                _tweenConfig = new GearTweenConfig();
            }
            return _tweenConfig;
        }// end function

        public function setup(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            _controller = _owner.parent.getController(param1.@controller);
            if (!_controller)
            {
                return;
            }
            init();
            _loc_2 = param1.@tween;
            if (_loc_2)
            {
                _tweenConfig = new GearTweenConfig();
                _loc_2 = param1.@ease;
                if (_loc_2)
                {
                    _tweenConfig.easeType = EaseType.parseEaseType(_loc_2);
                }
                _loc_2 = param1.@duration;
                if (_loc_2)
                {
                    _tweenConfig.duration = this.parseFloat(_loc_2);
                }
                _loc_2 = param1.@delay;
                if (_loc_2)
                {
                    _tweenConfig.delay = this.parseFloat(_loc_2);
                }
            }
            _loc_2 = param1.@pages;
            if (_loc_2)
            {
                _loc_3 = _loc_2.split(",");
            }
            if (this is GearDisplay)
            {
                this.GearDisplay(this).pages = _loc_3;
            }
            else if (this is GearDisplay2)
            {
                this.GearDisplay2(this).pages = _loc_3;
                this.GearDisplay2(this).condition = param1.@condition;
            }
            else
            {
                if (_loc_3)
                {
                    _loc_2 = param1.@values;
                    _loc_4 = _loc_2.split("|");
                    _loc_5 = 0;
                    while (_loc_5 < _loc_3.length)
                    {
                        
                        _loc_2 = _loc_4[_loc_5];
                        if (_loc_2 == null)
                        {
                            _loc_2 = "";
                        }
                        addStatus(_loc_3[_loc_5], _loc_2);
                        _loc_5++;
                    }
                }
                _loc_2 = param1["default"];
                if (_loc_2)
                {
                    addStatus(null, _loc_2);
                }
            }
            return;
        }// end function

        public function updateFromRelations(param1:Number, param2:Number) : void
        {
            return;
        }// end function

        protected function addStatus(param1:String, param2:String) : void
        {
            return;
        }// end function

        protected function init() : void
        {
            return;
        }// end function

        public function apply() : void
        {
            return;
        }// end function

        public function updateState() : void
        {
            return;
        }// end function

        public static function create(param1:GObject, param2:int) : GearBase
        {
            if (!Classes)
            {
                Classes = [GearDisplay, GearXY, GearSize, GearLook, GearColor, GearAnimation, GearText, GearIcon, GearDisplay2, GearFontSize];
            }
            return new Classes[param2](param1);
        }// end function

        public static function getIndexByName(param1:String) : int
        {
            var _loc_2:* = NameToIndex[param1];
            if (_loc_2 == undefined)
            {
                return -1;
            }
            return _loc_2;
        }// end function

    }
}
