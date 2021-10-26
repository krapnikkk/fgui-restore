package _-An
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.utils.*;

    class _-5U extends Object implements IDocHistory
    {
        private var _-1D:_-On;
        private var _-9s:Array;
        private var _-KN:Array;
        private var _-5u:Array;
        private var _-Gm:Array;
        private var _-p:Vector.<IDocHistoryItem>;
        private var _-Ap:Boolean;
        private var _-Es:int;
        private var _-Lc:Object;
        var _-KF:Boolean;

        function _-5U(param1:_-On)
        {
            this._-1D = param1;
            this._-9s = [];
            this._-KN = [];
            this._-p = new Vector.<IDocHistoryItem>;
            return;
        }// end function

        public function get processing() : Boolean
        {
            return this._-Ap;
        }// end function

        public function canUndo() : Boolean
        {
            return this._-9s.length > 0;
        }// end function

        public function canRedo() : Boolean
        {
            return this._-KN.length > 0;
        }// end function

        public function add(param1:IDocHistoryItem) : void
        {
            if (this._-Ap)
            {
                return;
            }
            this._-p.push(param1);
            GTimers.inst.add(250, 1, this.pack);
            if (param1.isPersists)
            {
                if (!this._-1D.isModified)
                {
                    this._-Lc = param1;
                    this._-Es = this._-1D._-6D;
                }
                this._-1D.setModified();
            }
            return;
        }// end function

        public function getPendingList() : Vector.<IDocHistoryItem>
        {
            return this._-p;
        }// end function

        public function reset() : void
        {
            if (this._-p.length > 0)
            {
                this._-HL();
            }
            this._-Ec(this._-9s);
            this._-Ec(this._-KN);
            if (this._-5u)
            {
                this._-Ec(this._-5u);
                this._-Ec(this._-Gm);
            }
            this._-Lc = null;
            return;
        }// end function

        private function _-Ec(param1:Array) : void
        {
            var _loc_2:* = param1.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                this._-6l(param1[_loc_3]);
                _loc_3++;
            }
            param1.length = 0;
            return;
        }// end function

        private function _-6l(param1:Vector.<IDocHistoryItem>) : void
        {
            var _loc_2:* = param1.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (param1[_loc_3] is IDisposable)
                {
                    IDisposable(param1[_loc_3]).dispose();
                }
                _loc_3++;
            }
            return;
        }// end function

        public function enterTimelineMode() : void
        {
            this._-HL();
            GTimers.inst.remove(this.pack);
            this._-5u = this._-9s.concat();
            this._-Gm = this._-KN.concat();
            this._-9s.length = 0;
            this._-KN.length = 0;
            this._-Lc = null;
            return;
        }// end function

        public function exitTimelineMode() : void
        {
            this._-HL();
            GTimers.inst.remove(this.pack);
            this._-9s = this._-5u;
            this._-KN = this._-Gm;
            this._-5u = null;
            this._-Gm = null;
            this._-Lc = null;
            return;
        }// end function

        private function pack() : void
        {
            if (this._-1D.editor.isInputing)
            {
                GTimers.inst.add(250, 1, this.pack);
                return;
            }
            this._-HL();
            return;
        }// end function

        private function _-HL() : void
        {
            this._-KN.length = 0;
            if (this._-p.length == 0)
            {
                return;
            }
            if (this._-9s.length > 100)
            {
                this._-6l(this._-9s.shift());
            }
            this._-9s.push(this._-p);
            this._-p = new Vector.<IDocHistoryItem>;
            return;
        }// end function

        public function undo() : Boolean
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            this._-Ap = true;
            this._-KF = false;
            while (true)
            {
                
                if (this._-9s.length == 0)
                {
                    this._-Ap = false;
                    return false;
                }
                _loc_1 = this._-9s.pop();
                _loc_2 = _loc_1.length;
                if (_loc_2 == 0)
                {
                    continue;
                }
                this._-KN.push(_loc_1);
                _loc_3 = _loc_2 - 1;
                while (_loc_3 >= 0)
                {
                    
                    _loc_4 = _loc_1[_loc_3];
                    if (_loc_4.process(this._-1D))
                    {
                        if (_loc_4 == this._-Lc && this._-Es == this._-1D._-6D)
                        {
                            this._-1D.setModified(false);
                        }
                        else if (_loc_4.isPersists)
                        {
                            this._-1D.setModified();
                        }
                    }
                    else
                    {
                        _loc_1.splice(_loc_3, 1);
                    }
                    _loc_3 = _loc_3 - 1;
                }
                break;
            }
            this._-Ap = false;
            return true;
        }// end function

        public function redo() : Boolean
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            this._-Ap = true;
            this._-KF = false;
            while (true)
            {
                
                if (this._-KN.length == 0)
                {
                    this._-Ap = false;
                    return false;
                }
                _loc_1 = this._-KN.pop();
                _loc_2 = _loc_1.length;
                if (_loc_2 == 0)
                {
                    continue;
                }
                this._-9s.push(_loc_1);
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = _loc_1[_loc_3];
                    if (_loc_4.process(this._-1D))
                    {
                        _loc_3++;
                        if (_loc_4.isPersists)
                        {
                            this._-1D.setModified();
                        }
                        continue;
                    }
                    _loc_1.splice(_loc_3, 1);
                    _loc_2 = _loc_2 - 1;
                }
                break;
            }
            this._-Ap = false;
            return true;
        }// end function

    }
}
