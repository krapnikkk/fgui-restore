package fairygui.editor.gui
{
    import *.*;
    import fairygui.utils.*;

    public class FControllerAction extends Object
    {
        public var type:String;
        public var fromPage:Array;
        public var toPage:Array;
        public var transitionName:String;
        public var repeat:int;
        public var delay:Number;
        public var stopOnExit:Boolean;
        public var objectId:String;
        public var controllerName:String;
        public var targetPage:String;
        private var _currentTransition:FTransition;

        public function FControllerAction() : void
        {
            this.fromPage = [];
            this.toPage = [];
            this.repeat = 1;
            this.delay = 0;
            return;
        }// end function

        public function run(param1:FController, param2:String, param3:String) : void
        {
            var _loc_4:* = (this.fromPage.length == 0 || this.fromPage.indexOf(param2) != -1) && (this.toPage.length == 0 || this.toPage.indexOf(param3) != -1);
            if ((this.fromPage.length == 0 || this.fromPage.indexOf(param2) != -1) && (this.toPage.length == 0 || this.toPage.indexOf(param3) != -1))
            {
                this.enter(param1);
            }
            else
            {
                this.leave(param1);
            }
            return;
        }// end function

        public function copyFrom(param1:FControllerAction) : void
        {
            this.type = param1.type;
            this.copyArray(param1.fromPage, this.fromPage);
            this.copyArray(param1.toPage, this.toPage);
            if (this.type == "play_transition")
            {
                this.transitionName = param1.transitionName;
                this.repeat = param1.repeat;
                this.delay = param1.delay;
                this.stopOnExit = param1.stopOnExit;
            }
            else if (this.type == "change_page")
            {
                this.objectId = param1.objectId;
                this.controllerName = param1.controllerName;
                this.targetPage = param1.targetPage;
            }
            return;
        }// end function

        public function reset() : void
        {
            this.fromPage.length = 0;
            this.toPage.length = 0;
            this.transitionName = null;
            this.repeat = 1;
            this.delay = 0;
            this.stopOnExit = false;
            this.objectId = null;
            this.controllerName = null;
            this.targetPage = null;
            return;
        }// end function

        public function copyArray(param1:Array, param2:Array) : void
        {
            var _loc_3:* = param1.length;
            param2.length = _loc_3;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                param2[_loc_4] = param1[_loc_4];
                _loc_4++;
            }
            return;
        }// end function

        public function getFullControllerName(param1:FComponent) : String
        {
            var _loc_2:* = null;
            if (this.objectId)
            {
                _loc_2 = param1.getChildById(this.objectId);
                if (_loc_2)
                {
                    return _loc_2.name + "." + this.controllerName;
                }
                return "";
            }
            else
            {
            }
            return this.controllerName;
        }// end function

        public function getControllerObj(param1:FComponent) : FController
        {
            if (this.controllerName)
            {
                if (this.objectId)
                {
                    param1 = param1.getChildById(this.objectId) as FComponent;
                }
                if (param1)
                {
                    return param1.getController(this.controllerName);
                }
            }
            return null;
        }// end function

        public function read(param1:XData) : void
        {
            var _loc_2:* = null;
            this.type = param1.getAttribute("type");
            _loc_2 = param1.getAttribute("fromPage");
            if (_loc_2)
            {
                this.fromPage = _loc_2.split(",");
            }
            _loc_2 = param1.getAttribute("toPage");
            if (_loc_2)
            {
                this.toPage = _loc_2.split(",");
            }
            if (this.type == "play_transition")
            {
                this.transitionName = param1.getAttribute("transition");
                this.repeat = param1.getAttributeInt("repeat", 1);
                this.delay = param1.getAttributeFloat("delay");
                this.stopOnExit = param1.getAttributeBool("stopOnExit");
            }
            else if (this.type == "change_page")
            {
                this.objectId = param1.getAttribute("objectId");
                this.controllerName = param1.getAttribute("controller");
                this.targetPage = param1.getAttribute("targetPage");
            }
            return;
        }// end function

        public function write() : XData
        {
            var _loc_1:* = XData.create("action");
            _loc_1.setAttribute("type", this.type);
            _loc_1.setAttribute("fromPage", this.fromPage.join(","));
            _loc_1.setAttribute("toPage", this.toPage.join(","));
            if (this.type == "play_transition")
            {
                _loc_1.setAttribute("transition", this.transitionName ? (this.transitionName) : (""));
                if (this.repeat != 1)
                {
                    _loc_1.setAttribute("repeat", this.repeat);
                }
                if (this.delay != 0)
                {
                    _loc_1.setAttribute("delay", this.delay);
                }
                if (this.stopOnExit)
                {
                    _loc_1.setAttribute("stopOnExit", this.stopOnExit);
                }
            }
            else if (this.type == "change_page")
            {
                if (this.objectId)
                {
                    _loc_1.setAttribute("objectId", this.objectId);
                }
                _loc_1.setAttribute("controller", this.controllerName ? (this.controllerName) : (""));
                _loc_1.setAttribute("targetPage", this.targetPage);
            }
            return _loc_1;
        }// end function

        protected function enter(param1:FController) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            switch(this.type)
            {
                case "play_transition":
                {
                    if ((param1.parent._flags & FObjectFlags.IN_TEST) == 0)
                    {
                        return;
                    }
                    _loc_2 = param1.parent.transitions.getItem(this.transitionName);
                    if (_loc_2)
                    {
                        if (this._currentTransition && this._currentTransition.playing)
                        {
                            _loc_2.playTimes = this.repeat;
                        }
                        else
                        {
                            _loc_2.play(null, null, this.repeat, this.delay);
                        }
                        this._currentTransition = _loc_2;
                    }
                    break;
                }
                case "change_page":
                {
                    _loc_3 = this.getControllerObj(param1.parent);
                    if (_loc_3 && _loc_3 != param1 && !_loc_3.changing)
                    {
                        if (this.targetPage == "~1")
                        {
                            if (param1.selectedIndex < _loc_3.pageCount)
                            {
                                _loc_3.selectedIndex = param1.selectedIndex;
                            }
                        }
                        else if (this.targetPage == "~2")
                        {
                            _loc_3.selectedPage = param1.selectedPage;
                        }
                        else
                        {
                            _loc_3.selectedPageId = this.targetPage;
                        }
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function leave(param1:FController) : void
        {
            switch(this.type)
            {
                case "play_transition":
                {
                    if ((param1.parent._flags & FObjectFlags.IN_TEST) == 0)
                    {
                        return;
                    }
                    if (this.stopOnExit && this._currentTransition)
                    {
                        this._currentTransition.stop();
                        this._currentTransition = null;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
