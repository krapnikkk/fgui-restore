package fairygui.utils
{
    import *.*;

    public class SEventDispatcher extends Object
    {
        private var _elements:Object;
        private var _dispatching:Object;
        public var errorHandler:Function;

        public function SEventDispatcher() : void
        {
            this._elements = {};
            this._dispatching = {};
            return;
        }// end function

        public function on(param1:String, param2:Function) : void
        {
            var _loc_3:* = this._elements[param1];
            if (!_loc_3)
            {
                _loc_3 = new Array();
                this._elements[param1] = _loc_3;
                _loc_3.push(param2);
            }
            else if (_loc_3.indexOf(param2) == -1)
            {
                _loc_3.push(param2);
            }
            return;
        }// end function

        public function off(param1:String, param2:Function) : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = this._elements[param1];
            if (_loc_3)
            {
                _loc_4 = _loc_3.indexOf(param2);
                if (_loc_4 != -1)
                {
                    _loc_3[_loc_4] = null;
                }
            }
            return;
        }// end function

        public function emit(param1:String, param2 = undefined) : void
        {
            var func:Function;
            var j:int;
            var type:* = param1;
            var param:* = param2;
            var arr:* = this._elements[type];
            if (!arr || arr.length == 0 || this._dispatching[type])
            {
                return;
            }
            this._dispatching[type] = true;
            var cnt:* = arr.length;
            var freePosStart:int;
            var i:int;
            while (i < cnt)
            {
                
                func = arr[i];
                if (func == null)
                {
                    if (freePosStart == -1)
                    {
                        freePosStart = i;
                    }
                }
                else
                {
                    if (this.errorHandler != null)
                    {
                        try
                        {
                            if (func.length == 1)
                            {
                                this.func(param);
                            }
                            else
                            {
                                this.func();
                            }
                        }
                        catch (err:Error)
                        {
                            errorHandler(err);
                        }
                    }
                    else if (func.length == 1)
                    {
                        this.func(param);
                    }
                    else
                    {
                        this.func();
                    }
                    if (freePosStart != -1)
                    {
                        arr[freePosStart] = func;
                        arr[i] = null;
                        freePosStart = (freePosStart + 1);
                    }
                }
                i = (i + 1);
            }
            if (freePosStart >= 0)
            {
                if (arr.length != cnt)
                {
                    j = cnt;
                    cnt = arr.length - cnt;
                    i;
                    while (i < cnt)
                    {
                        
                        freePosStart = (freePosStart + 1);
                        var _loc_4:* = freePosStart;
                        j = (j + 1);
                        arr[freePosStart] = arr[j];
                        i = (i + 1);
                    }
                }
                arr.length = freePosStart;
            }
            this._dispatching[type] = false;
            return;
        }// end function

    }
}
