package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class FController extends EventDispatcher
    {
        public var name:String;
        public var autoRadioGroupDepth:Boolean;
        public var exported:Boolean;
        public var alias:String;
        public var homePageType:String;
        public var homePage:String;
        public var parent:FComponent;
        public var changing:Boolean;
        private var _selectedIndex:int;
        private var _previousIndex:int;
        private var _nextPageId:int;
        private var _pages:Vector.<FControllerPage>;
        private var _actions:Vector.<FControllerAction>;

        public function FController()
        {
            this._pages = new Vector.<FControllerPage>;
            this._actions = new Vector.<FControllerAction>;
            this._selectedIndex = -1;
            this._previousIndex = -1;
            this.homePageType = "default";
            return;
        }// end function

        public function get selectedIndex() : int
        {
            return this._selectedIndex;
        }// end function

        public function set selectedIndex(param1:int) : void
        {
            if (this._selectedIndex != param1)
            {
                this._previousIndex = this._selectedIndex;
                this._selectedIndex = param1;
                if (this.parent)
                {
                    this.changing = true;
                    this.parent.applyController(this);
                    dispatchEvent(new StateChangeEvent(StateChangeEvent.CHANGED));
                    this.changing = false;
                }
            }
            return;
        }// end function

        public function setSelectedIndex(param1:int) : void
        {
            if (this._selectedIndex != param1)
            {
                this._previousIndex = this._selectedIndex;
                this._selectedIndex = param1;
                if (this.parent)
                {
                    this.changing = true;
                    this.parent.applyController(this);
                    this.changing = false;
                }
            }
            return;
        }// end function

        public function get previsousIndex() : int
        {
            return this._previousIndex;
        }// end function

        public function get selectedPage() : String
        {
            if (this._selectedIndex == -1)
            {
                return null;
            }
            return this._pages[this._selectedIndex].name;
        }// end function

        public function set selectedPage(param1:String) : void
        {
            var _loc_2:* = this._pages.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._pages[_loc_3].name == param1)
                {
                    this.selectedIndex = _loc_3;
                    return;
                }
                _loc_3++;
            }
            return;
        }// end function

        public function set selectedPageId(param1:String) : void
        {
            var _loc_2:* = this._pages.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._pages[_loc_3].id == param1)
                {
                    this.selectedIndex = _loc_3;
                    return;
                }
                _loc_3++;
            }
            return;
        }// end function

        public function set oppositePageId(param1:String) : void
        {
            var _loc_2:* = this._pages.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._pages[_loc_3].id == param1)
                {
                    break;
                }
                _loc_3++;
            }
            if (_loc_3 > 0)
            {
                this.selectedIndex = 0;
            }
            else if (this._pages.length > 1)
            {
                this.selectedIndex = 1;
            }
            return;
        }// end function

        public function get previousPage() : String
        {
            if (this._previousIndex == -1)
            {
                return null;
            }
            return this._pages[this._previousIndex].name;
        }// end function

        public function get selectedPageId() : String
        {
            if (this._selectedIndex == -1)
            {
                return null;
            }
            return this._pages[this._selectedIndex].id;
        }// end function

        public function get previousPageId() : String
        {
            if (this._previousIndex == -1)
            {
                return null;
            }
            return this._pages[this._previousIndex].id;
        }// end function

        public function getPages() : Vector.<FControllerPage>
        {
            return this._pages;
        }// end function

        public function getPageIds(param1:Array = null) : Array
        {
            if (!param1)
            {
                param1 = [];
            }
            var _loc_2:* = this._pages.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                param1.push(this._pages[_loc_3].id);
                _loc_3++;
            }
            return param1;
        }// end function

        public function getPageNames(param1:Array = null) : Array
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (!param1)
            {
                param1 = [];
            }
            var _loc_2:* = this._pages.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._pages[_loc_3];
                if (_loc_4.name)
                {
                    _loc_5 = _loc_3 + ":" + _loc_4.name;
                }
                else if (_loc_4.remark)
                {
                    _loc_5 = _loc_3 + ":" + _loc_4.remark;
                }
                else
                {
                    _loc_5 = "" + _loc_3;
                }
                param1.push(_loc_5);
                _loc_3++;
            }
            return param1;
        }// end function

        public function hasPageId(param1:String) : Boolean
        {
            var _loc_2:* = this._pages.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._pages[_loc_3].id == param1)
                {
                    return true;
                }
                _loc_3++;
            }
            return false;
        }// end function

        public function hasPageName(param1:String) : Boolean
        {
            var _loc_2:* = this._pages.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._pages[_loc_3].name == param1)
                {
                    return true;
                }
                _loc_3++;
            }
            return false;
        }// end function

        public function getNameById(param1:String, param2:String) : String
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_3:* = this._pages.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this._pages[_loc_4];
                if (_loc_5.id == param1)
                {
                    return _loc_4 + (_loc_5.name ? (":" + _loc_5.name) : (""));
                }
                _loc_4++;
            }
            return param2;
        }// end function

        public function getNamesByIds(param1:Array, param2:String) : String
        {
            var _loc_4:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            if (param1 == null || param1.length == 0)
            {
                return param2;
            }
            var _loc_3:* = this._pages.length;
            var _loc_5:* = "";
            var _loc_8:* = 0;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_6 = this._pages[_loc_4];
                if (param1.indexOf(_loc_6.id) != -1)
                {
                    if (_loc_5)
                    {
                        _loc_5 = _loc_5 + ",";
                    }
                    _loc_5 = _loc_5 + ("" + _loc_4);
                    _loc_7 = _loc_6;
                    _loc_8++;
                }
                _loc_4++;
            }
            if (_loc_8 > 0)
            {
                if (_loc_8 == 1 && _loc_7.name)
                {
                    return _loc_5 + ":" + _loc_7.name;
                }
                return _loc_5;
            }
            else
            {
                return param2;
            }
        }// end function

        public function get pageCount() : int
        {
            return this._pages.length;
        }// end function

        public function addPage(param1:String) : FControllerPage
        {
            return this.addPageAt(param1, this._pages.length);
        }// end function

        public function addPageAt(param1:String, param2:int) : FControllerPage
        {
            var _loc_3:* = new FControllerPage();
            var _loc_4:* = this;
            _loc_4._nextPageId = this._nextPageId + 1;
            _loc_3.id = "" + this._nextPageId++;
            _loc_3.name = param1;
            if (param2 == this._pages.length)
            {
                this._pages.push(_loc_3);
            }
            else
            {
                this._pages.splice(param2, 0, _loc_3);
            }
            return _loc_3;
        }// end function

        public function removePageAt(param1:int) : void
        {
            this._pages.splice(param1, 1);
            return;
        }// end function

        public function setPages(param1:Array) : void
        {
            var _loc_5:* = 0;
            var _loc_2:* = [];
            var _loc_3:* = this._pages.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = param1.indexOf(this._pages[_loc_4].name);
                if (_loc_5 != -1)
                {
                    _loc_2[_loc_5] = this._pages[_loc_4];
                }
                _loc_4++;
            }
            this._pages.length = 0;
            _loc_3 = param1.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (_loc_2[_loc_4])
                {
                    this._pages.push(_loc_2[_loc_4]);
                }
                else
                {
                    this.addPage(param1[_loc_4]);
                }
                _loc_4++;
            }
            return;
        }// end function

        public function swapPage(param1:int, param2:int) : void
        {
            var _loc_3:* = this._pages[param1];
            var _loc_4:* = this._pages[param2];
            this._pages[param1] = _loc_4;
            this._pages[param2] = _loc_3;
            return;
        }// end function

        public function getActions() : Vector.<FControllerAction>
        {
            return this._actions;
        }// end function

        public function addAction(param1:String) : FControllerAction
        {
            var _loc_2:* = new FControllerAction();
            _loc_2.type = param1;
            this._actions.push(_loc_2);
            return _loc_2;
        }// end function

        public function removeAction(param1:FControllerAction) : void
        {
            var _loc_2:* = this._actions.indexOf(param1);
            if (_loc_2 != -1)
            {
                this._actions.splice(_loc_2, 1);
            }
            return;
        }// end function

        public function swapAction(param1:int, param2:int) : void
        {
            var _loc_3:* = this._actions[param1];
            var _loc_4:* = this._actions[param2];
            this._actions[param1] = _loc_4;
            this._actions[param2] = _loc_3;
            return;
        }// end function

        public function runActions() : void
        {
            var _loc_1:* = null;
            if (this._actions.length)
            {
                for each (_loc_1 in this._actions)
                {
                    
                    _loc_1.run(this, this.previousPageId, this.selectedPageId);
                }
            }
            return;
        }// end function

        public function read(param1:XData) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            this.name = param1.getAttribute("name", "");
            this.alias = param1.getAttribute("alias", "");
            this.autoRadioGroupDepth = param1.getAttributeBool("autoRadioGroupDepth");
            this.exported = param1.getAttributeBool("exported");
            this.homePageType = param1.getAttribute("homePageType", "default");
            this.homePage = param1.getAttribute("homePage", "");
            var _loc_2:* = null;
            var _loc_3:* = 0;
            if (this.parent && !FObjectFlags.isDocRoot(this.parent._flags) && (this.parent._flags & FObjectFlags.IN_PREVIEW) == 0)
            {
                _loc_3 = this.homePageType == "default" ? (0) : (-1);
                if (this.homePageType == "branch")
                {
                    _loc_2 = this.parent._pkg.project.activeBranch;
                }
                else if (this.homePageType == "variable")
                {
                    _loc_2 = CustomProps(this.parent._pkg.project.getSettings("customProps")).all[this.homePage];
                }
            }
            this._pages.length = 0;
            var _loc_6:* = param1.getAttribute("pages");
            if (param1.getAttribute("pages"))
            {
                _loc_9 = _loc_6.split(",");
                _loc_10 = _loc_9.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_10)
                {
                    
                    _loc_11 = new FControllerPage();
                    _loc_11.id = _loc_9[_loc_4];
                    _loc_5 = int(_loc_11.id);
                    if (_loc_5 >= this._nextPageId)
                    {
                        this._nextPageId = _loc_5 + 1;
                    }
                    _loc_11.name = _loc_9[(_loc_4 + 1)];
                    if (_loc_3 == -1 && (_loc_2 == null ? (_loc_11.id == this.homePage) : (_loc_11.name == _loc_2)))
                    {
                        _loc_3 = this._pages.length;
                    }
                    this._pages.push(_loc_11);
                    _loc_4 = _loc_4 + 2;
                }
            }
            var _loc_7:* = param1.getChildren();
            this._actions.length = 0;
            for each (_loc_8 in _loc_7)
            {
                
                if (_loc_8.getName() == "remark")
                {
                    _loc_4 = _loc_8.getAttributeInt("page");
                    this._pages[_loc_4].remark = _loc_8.getAttribute("value", "");
                    continue;
                }
                if (_loc_8.getName() == "action")
                {
                    _loc_12 = new FControllerAction();
                    _loc_12.read(_loc_8);
                    this._actions.push(_loc_12);
                }
            }
            _loc_6 = param1.getAttribute("transitions");
            if (_loc_6)
            {
                _loc_9 = _loc_6.split(",");
                _loc_10 = _loc_9.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_10)
                {
                    
                    _loc_6 = _loc_9[_loc_4];
                    if (!_loc_6)
                    {
                    }
                    else
                    {
                        _loc_12 = new FControllerAction();
                        _loc_12.type = "play_transition";
                        _loc_5 = _loc_6.indexOf("=");
                        _loc_12.transitionName = _loc_6.substr((_loc_5 + 1));
                        _loc_6 = _loc_6.substring(0, _loc_5);
                        _loc_5 = _loc_6.indexOf("-");
                        _loc_13 = parseInt(_loc_6.substring((_loc_5 + 1)));
                        if (_loc_13 < this._pages.length)
                        {
                            _loc_12.toPage = [this._pages[_loc_13].id];
                        }
                        _loc_6 = _loc_6.substring(0, _loc_5);
                        if (_loc_6 != "*")
                        {
                            _loc_13 = parseInt(_loc_6);
                            if (_loc_13 < this._pages.length)
                            {
                                _loc_12.fromPage = [this._pages[_loc_13].id];
                            }
                        }
                        _loc_12.stopOnExit = true;
                        this._actions.push(_loc_12);
                    }
                    _loc_4++;
                }
            }
            if (this._pages.length > 0)
            {
                this._selectedIndex = _loc_3 < 0 ? (0) : (_loc_3);
                this._previousIndex = 0;
            }
            else
            {
                this._selectedIndex = -1;
                this._previousIndex = -1;
            }
            return;
        }// end function

        public function write() : XData
        {
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_1:* = XData.create("controller");
            _loc_1.setAttribute("name", this.name);
            if (this.alias)
            {
                _loc_1.setAttribute("alias", this.alias);
            }
            if (this.autoRadioGroupDepth)
            {
                _loc_1.setAttribute("autoRadioGroupDepth", true);
            }
            if (this.exported)
            {
                _loc_1.setAttribute("exported", true);
            }
            if (this.homePageType != "default")
            {
                _loc_1.setAttribute("homePageType", this.homePageType);
            }
            if (this.homePageType == "specific" || this.homePageType == "variable")
            {
                _loc_1.setAttribute("homePage", this.homePage);
            }
            var _loc_2:* = this._pages.length;
            var _loc_3:* = [];
            var _loc_5:* = 0;
            while (_loc_5 < _loc_2)
            {
                
                _loc_6 = this._pages[_loc_5];
                _loc_3.push(_loc_6.id, _loc_6.name);
                if (_loc_6.remark)
                {
                    _loc_4 = XData.create("remark");
                    _loc_4.setAttribute("page", _loc_5);
                    _loc_4.setAttribute("value", _loc_6.remark);
                    _loc_1.appendChild(_loc_4);
                }
                _loc_5++;
            }
            _loc_1.setAttribute("pages", _loc_3.join(","));
            _loc_1.setAttribute("selected", this._selectedIndex);
            if (this._actions.length > 0)
            {
                _loc_2 = this._actions.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_2)
                {
                    
                    _loc_4 = this._actions[_loc_5].write();
                    _loc_1.appendChild(_loc_4);
                    _loc_5++;
                }
            }
            return _loc_1;
        }// end function

        public function reset() : void
        {
            this.name = "";
            this.autoRadioGroupDepth = false;
            this.exported = false;
            this.alias = "";
            this.homePageType = "default";
            this.homePage = "";
            this._nextPageId = 0;
            this._pages.length = 0;
            this._actions.length = 0;
            return;
        }// end function

    }
}
