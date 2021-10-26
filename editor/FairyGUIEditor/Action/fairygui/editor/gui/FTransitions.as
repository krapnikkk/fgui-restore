package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.utils.*;

    public class FTransitions extends Object
    {
        private var _owner:FComponent;
        private var _items:Vector.<FTransition>;
        private var _nextId:int;
        private var _snapshot:Vector.<ObjectSnapshot>;
        private var _controllerSnapshot:Vector.<String>;
        public var _loadingSnapshot:Boolean;
        private static var helperArray:Array = [];

        public function FTransitions(param1:FComponent)
        {
            this._owner = param1;
            this._items = new Vector.<FTransition>;
            return;
        }// end function

        public function get items() : Vector.<FTransition>
        {
            return this._items;
        }// end function

        public function get isEmpty() : Boolean
        {
            return this._items.length == 0;
        }// end function

        public function addItem(param1:String = null) : FTransition
        {
            var _loc_2:* = new FTransition(this._owner);
            if (param1 == null)
            {
                var _loc_3:* = this;
                _loc_3._nextId = this._nextId + 1;
                _loc_2.name = "t" + this._nextId++;
            }
            this._items.push(_loc_2);
            return _loc_2;
        }// end function

        public function removeItem(param1:FTransition) : void
        {
            var _loc_2:* = this._items.indexOf(param1);
            param1.dispose();
            this._items.splice(_loc_2, 1);
            return;
        }// end function

        public function getItem(param1:String) : FTransition
        {
            var _loc_2:* = null;
            for each (_loc_2 in this._items)
            {
                
                if (_loc_2.name == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function read(param1:XData) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            this._items.length = 0;
            this._nextId = 0;
            var _loc_2:* = param1.getEnumerator("transition");
            while (_loc_2.moveNext())
            {
                
                _loc_3 = this.addItem();
                _loc_3.read(_loc_2.current);
                if (_loc_3.name.length > 1 && _loc_3.name.charAt(0) == "t")
                {
                    _loc_4 = parseInt(_loc_3.name.substr(1));
                    if (_loc_4 >= this._nextId)
                    {
                        this._nextId = _loc_4 + 1;
                    }
                }
            }
            return;
        }// end function

        public function write(param1:XData = null) : XData
        {
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_2:* = true;
            if (!param1)
            {
                param1 = XData.create("transitions");
                _loc_2 = false;
            }
            var _loc_3:* = this._items.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_4 = this._items[_loc_5];
                _loc_6 = _loc_4.write(_loc_2);
                param1.appendChild(_loc_6);
                _loc_5++;
            }
            return param1;
        }// end function

        public function dispose() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in this._items)
            {
                
                _loc_1.stop();
            }
            if (this._snapshot && this._snapshot.length > 0)
            {
                ObjectSnapshot.returnToPool(this._snapshot);
            }
            return;
        }// end function

        private function collectSnapshots(param1:Vector.<ObjectSnapshot>) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_2:* = this._items.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._items[_loc_3];
                _loc_5 = _loc_4.items;
                _loc_6 = _loc_5.length;
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_8 = _loc_5[_loc_7];
                    if (_loc_8.target && _loc_8.target != this._owner && _loc_8.type == "Transition" && _loc_8.target is FComponent)
                    {
                        FComponent(_loc_8.target).transitions.collectSnapshots(param1);
                    }
                    _loc_7++;
                }
                _loc_3++;
            }
            _loc_2 = this._owner.numChildren;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_9 = ObjectSnapshot.getFromPool(this._owner.getChildAt(_loc_3));
                param1.push(_loc_9);
                _loc_3++;
            }
            return;
        }// end function

        public function clearSnapshot() : void
        {
            if (!this._snapshot)
            {
                return;
            }
            ObjectSnapshot.returnToPool(this._snapshot);
            this._snapshot.length = 0;
            return;
        }// end function

        public function takeSnapshot() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            if (!this._snapshot)
            {
                this._snapshot = new Vector.<ObjectSnapshot>;
                this._controllerSnapshot = new Vector.<String>;
            }
            if (this._snapshot.length == 0)
            {
                this.collectSnapshots(this._snapshot);
                _loc_3 = ObjectSnapshot.getFromPool(this._owner);
                this._snapshot.push(_loc_3);
            }
            _loc_2 = this._snapshot.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                this._snapshot[_loc_1].take();
                _loc_1++;
            }
            _loc_2 = this._owner.controllers.length;
            this._controllerSnapshot.length = _loc_2;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                this._controllerSnapshot[_loc_1] = this._owner.controllers[_loc_1].selectedPageId;
                _loc_1++;
            }
            return;
        }// end function

        public function readSnapshot(param1:Boolean = true) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            this._loadingSnapshot = true;
            var _loc_4:* = this._owner.controllers.length;
            if (param1)
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    helperArray[_loc_3] = this._owner.controllers[_loc_3].selectedIndex;
                    this._owner.controllers[_loc_3].selectedPageId = this._controllerSnapshot[_loc_3];
                    _loc_3++;
                }
            }
            _loc_2 = this._snapshot.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                this._snapshot[_loc_3].load();
                _loc_3++;
            }
            if (param1)
            {
                _loc_2 = this._owner.controllers.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    this._owner.controllers[_loc_3].selectedIndex = helperArray[_loc_3];
                    _loc_3++;
                }
            }
            this._loadingSnapshot = false;
            return;
        }// end function

    }
}
