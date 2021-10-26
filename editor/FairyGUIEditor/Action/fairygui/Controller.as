package fairygui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.action.*;
    import fairygui.event.*;
    import flash.events.*;

    public class Controller extends EventDispatcher
    {
        private var _name:String;
        private var _selectedIndex:int;
        private var _previousIndex:int;
        private var _pageIds:Array;
        private var _pageNames:Array;
        private var _actions:Vector.<ControllerAction>;
        var _parent:GComponent;
        var _autoRadioGroupDepth:Boolean;
        public var changing:Boolean;
        private static var _nextPageId:uint;

        public function Controller()
        {
            _pageIds = [];
            _pageNames = [];
            _selectedIndex = -1;
            _previousIndex = -1;
            return;
        }// end function

        public function get name() : String
        {
            return _name;
        }// end function

        public function set name(param1:String) : void
        {
            _name = param1;
            return;
        }// end function

        public function get parent() : GComponent
        {
            return _parent;
        }// end function

        public function get selectedIndex() : int
        {
            return _selectedIndex;
        }// end function

        public function set selectedIndex(param1:int) : void
        {
            if (_selectedIndex != param1)
            {
                if (param1 > (_pageIds.length - 1))
                {
                    throw new Error("index out of bounds: " + param1);
                }
                changing = true;
                _previousIndex = _selectedIndex;
                _selectedIndex = param1;
                _parent.applyController(this);
                this.dispatchEvent(new StateChangeEvent("stateChanged"));
                changing = false;
            }
            return;
        }// end function

        public function setSelectedIndex(param1:int) : void
        {
            if (_selectedIndex != param1)
            {
                if (param1 > (_pageIds.length - 1))
                {
                    throw new Error("index out of bounds: " + param1);
                }
                changing = true;
                _previousIndex = _selectedIndex;
                _selectedIndex = param1;
                _parent.applyController(this);
                changing = false;
            }
            return;
        }// end function

        public function get previsousIndex() : int
        {
            return _previousIndex;
        }// end function

        public function get selectedPage() : String
        {
            if (_selectedIndex == -1)
            {
                return null;
            }
            return _pageNames[_selectedIndex];
        }// end function

        public function set selectedPage(param1:String) : void
        {
            var _loc_2:* = _pageNames.indexOf(param1);
            if (_loc_2 == -1)
            {
                _loc_2 = 0;
            }
            this.selectedIndex = _loc_2;
            return;
        }// end function

        public function setSelectedPage(param1:String) : void
        {
            var _loc_2:* = _pageNames.indexOf(param1);
            if (_loc_2 == -1)
            {
                _loc_2 = 0;
            }
            this.setSelectedIndex(_loc_2);
            return;
        }// end function

        public function get previousPage() : String
        {
            if (_previousIndex == -1)
            {
                return null;
            }
            return _pageNames[_previousIndex];
        }// end function

        public function get pageCount() : int
        {
            return _pageIds.length;
        }// end function

        public function getPageName(param1:int) : String
        {
            return _pageNames[param1];
        }// end function

        public function addPage(param1:String = "") : void
        {
            addPageAt(param1, _pageIds.length);
            return;
        }// end function

        public function addPageAt(param1:String, param2:int) : void
        {
            (_nextPageId + 1);
            var _loc_3:* = "_" + _nextPageId;
            if (param2 == _pageIds.length)
            {
                _pageIds.push(_loc_3);
                _pageNames.push(param1);
            }
            else
            {
                _pageIds.splice(param2, 0, _loc_3);
                _pageNames.splice(param2, 0, param1);
            }
            return;
        }// end function

        public function removePage(param1:String) : void
        {
            var _loc_2:* = _pageNames.indexOf(param1);
            if (_loc_2 != -1)
            {
                _pageIds.splice(_loc_2, 1);
                _pageNames.splice(_loc_2, 1);
                if (_selectedIndex >= _pageIds.length)
                {
                    this.selectedIndex = _selectedIndex - 1;
                }
                else
                {
                    _parent.applyController(this);
                }
            }
            return;
        }// end function

        public function removePageAt(param1:int) : void
        {
            _pageIds.splice(param1, 1);
            _pageNames.splice(param1, 1);
            if (_selectedIndex >= _pageIds.length)
            {
                this.selectedIndex = _selectedIndex - 1;
            }
            else
            {
                _parent.applyController(this);
            }
            return;
        }// end function

        public function clearPages() : void
        {
            _pageIds.length = 0;
            _pageNames.length = 0;
            if (_selectedIndex != -1)
            {
                this.selectedIndex = -1;
            }
            else
            {
                _parent.applyController(this);
            }
            return;
        }// end function

        public function hasPage(param1:String) : Boolean
        {
            return _pageNames.indexOf(param1) != -1;
        }// end function

        public function getPageIndexById(param1:String) : int
        {
            return _pageIds.indexOf(param1);
        }// end function

        public function getPageIdByName(param1:String) : String
        {
            var _loc_2:* = _pageNames.indexOf(param1);
            if (_loc_2 != -1)
            {
                return _pageIds[_loc_2];
            }
            return null;
        }// end function

        public function getPageNameById(param1:String) : String
        {
            var _loc_2:* = _pageIds.indexOf(param1);
            if (_loc_2 != -1)
            {
                return _pageNames[_loc_2];
            }
            return null;
        }// end function

        public function getPageId(param1:int) : String
        {
            return _pageIds[param1];
        }// end function

        public function get selectedPageId() : String
        {
            if (_selectedIndex == -1)
            {
                return null;
            }
            return _pageIds[_selectedIndex];
        }// end function

        public function set selectedPageId(param1:String) : void
        {
            var _loc_2:* = _pageIds.indexOf(param1);
            this.selectedIndex = _loc_2;
            return;
        }// end function

        public function set oppositePageId(param1:String) : void
        {
            var _loc_2:* = _pageIds.indexOf(param1);
            if (_loc_2 > 0)
            {
                this.selectedIndex = 0;
            }
            else if (_pageIds.length > 1)
            {
                this.selectedIndex = 1;
            }
            return;
        }// end function

        public function get previousPageId() : String
        {
            if (_previousIndex == -1)
            {
                return null;
            }
            return _pageIds[_previousIndex];
        }// end function

        public function runActions() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            if (_actions)
            {
                _loc_1 = _actions.length;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _actions[_loc_2].run(this, previousPageId, selectedPageId);
                    _loc_2++;
                }
            }
            return;
        }// end function

        public function setup(param1:XML) : void
        {
            var _loc_12:* = null;
            var _loc_15:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_2:* = null;
            var _loc_7:* = 0;
            var _loc_11:* = null;
            var _loc_13:* = null;
            var _loc_16:* = null;
            var _loc_3:* = 0;
            var _loc_8:* = null;
            _name = param1.@name;
            _autoRadioGroupDepth = param1.@autoRadioGroupDepth == "true";
            var _loc_5:* = param1.@homePageType;
            var _loc_6:* = 0;
            if (_loc_5)
            {
                _loc_12 = param1.@homePage;
                _loc_6 = -1;
                if (_loc_5 == "branch")
                {
                    _loc_15 = UIPackage.branch;
                }
                else if (_loc_5 == "variable")
                {
                    _loc_15 = UIPackage.getVar(_loc_12);
                }
            }
            var _loc_14:* = param1.@pages;
            if (param1.@pages)
            {
                _loc_2 = _loc_14.split(",");
                _loc_7 = _loc_2.length;
                _loc_9 = 0;
                while (_loc_9 < _loc_7)
                {
                    
                    _loc_11 = _loc_2[_loc_9];
                    _loc_13 = _loc_2[(_loc_9 + 1)];
                    if (_loc_6 == -1 && (_loc_15 == null ? (_loc_11 == _loc_12) : (_loc_13 == _loc_15)))
                    {
                        _loc_6 = _pageIds.length;
                    }
                    _pageIds.push(_loc_11);
                    _pageNames.push(_loc_13);
                    _loc_9 = _loc_9 + 2;
                }
            }
            var _loc_4:* = param1.action;
            if (_loc_4.length() > 0)
            {
                _actions = new Vector.<ControllerAction>;
                for each (_loc_17 in _loc_4)
                {
                    
                    _loc_16 = ControllerAction.createAction(_loc_17.@type);
                    _loc_16.setup(_loc_17);
                    _actions.push(_loc_16);
                }
            }
            _loc_14 = param1.@transitions;
            if (_loc_14)
            {
                if (!_actions)
                {
                    _actions = new Vector.<ControllerAction>;
                }
                _loc_2 = _loc_14.split(",");
                _loc_7 = _loc_2.length;
                _loc_9 = 0;
                while (_loc_9 < _loc_7)
                {
                    
                    _loc_14 = _loc_2[_loc_9];
                    if (_loc_14)
                    {
                        _loc_8 = new PlayTransitionAction();
                        _loc_10 = _loc_14.indexOf("=");
                        _loc_8.transitionName = _loc_14.substr((_loc_10 + 1));
                        _loc_14 = _loc_14.substring(0, _loc_10);
                        _loc_10 = _loc_14.indexOf("-");
                        _loc_3 = this.parseInt(_loc_14.substring((_loc_10 + 1)));
                        if (_loc_3 < _pageIds.length)
                        {
                            _loc_8.toPage = [_pageIds[_loc_3]];
                        }
                        _loc_14 = _loc_14.substring(0, _loc_10);
                        if (_loc_14 != "*")
                        {
                            _loc_3 = this.parseInt(_loc_14);
                            if (_loc_3 < _pageIds.length)
                            {
                                _loc_8.fromPage = [_pageIds[_loc_3]];
                            }
                        }
                        _loc_8.stopOnExit = true;
                        _actions.push(_loc_8);
                    }
                    _loc_9++;
                }
            }
            if (_parent && _pageIds.length > 0)
            {
                _selectedIndex = _loc_6 < 0 ? (0) : (_loc_6);
            }
            else
            {
                _selectedIndex = -1;
            }
            return;
        }// end function

    }
}
