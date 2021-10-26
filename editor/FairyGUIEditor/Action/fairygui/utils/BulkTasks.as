package fairygui.utils
{
    import *.*;
    import __AS3__.vec.*;

    public class BulkTasks extends Object
    {
        private var _numConcurrent:int;
        private var _items:Vector.<Function>;
        private var _itemDatas:Vector.<Object>;
        private var _runningCount:int;
        private var _running:Boolean;
        private var _onCompleted:Function;
        private var _errorMsgs:Vector.<String>;
        private var _itemData:Object;

        public function BulkTasks(param1:int = 2)
        {
            this._numConcurrent = param1;
            this._items = new Vector.<Function>;
            this._itemDatas = new Vector.<Object>;
            this._errorMsgs = new Vector.<String>;
            return;
        }// end function

        public function addTask(param1:Function, param2:Object = null) : void
        {
            this._items.push(param1);
            this._itemDatas.push(param2);
            return;
        }// end function

        public function getRemainingTasks() : Vector.<Object>
        {
            return this._itemDatas.concat();
        }// end function

        public function get itemCount() : int
        {
            return this._items.length;
        }// end function

        public function get taskData() : Object
        {
            return this._itemData;
        }// end function

        public function clear() : void
        {
            this._items.length = 0;
            this._errorMsgs.length = 0;
            this._runningCount = 0;
            this._running = false;
            this._onCompleted = null;
            this._itemData = null;
            this._itemDatas.length = 0;
            GTimers.inst.remove(this.run);
            return;
        }// end function

        public function start(param1:Function) : void
        {
            this._onCompleted = param1;
            this._running = true;
            GTimers.inst.add(50, 0, this.run);
            return;
        }// end function

        public function addErrorMsg(param1:String) : void
        {
            if (param1)
            {
                this._errorMsgs.push(param1);
            }
            return;
        }// end function

        public function addErrorMsgs(param1:Vector.<String>) : void
        {
            if (param1.length > 0)
            {
                this._errorMsgs = this._errorMsgs.concat(param1);
            }
            return;
        }// end function

        public function get errorMsgs() : Vector.<String>
        {
            return this._errorMsgs;
        }// end function

        public function finishItem() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this._runningCount - 1;
            _loc_1._runningCount = _loc_2;
            return;
        }// end function

        public function get running() : Boolean
        {
            return this._running;
        }// end function

        private function run() : void
        {
            var _loc_1:* = null;
            while (this._runningCount < this._numConcurrent && this._items.length > 0)
            {
                
                _loc_1 = this._items.pop();
                this._itemData = this._itemDatas.pop();
                var _loc_2:* = this;
                var _loc_3:* = this._runningCount + 1;
                _loc_2._runningCount = _loc_3;
                if (_loc_1.length == 1)
                {
                    this._loc_1(this);
                    continue;
                }
                this._loc_1();
            }
            if (this._runningCount == 0)
            {
                this._running = false;
                GTimers.inst.remove(this.run);
                _loc_1 = this._onCompleted;
                this._onCompleted = null;
                if (_loc_1 != null)
                {
                    if (_loc_1.length == 1)
                    {
                        this._loc_1(this);
                    }
                    else
                    {
                        this._loc_1();
                    }
                }
            }
            return;
        }// end function

    }
}
