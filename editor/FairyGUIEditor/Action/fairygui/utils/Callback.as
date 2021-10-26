package fairygui.utils
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.plugin.*;

    public class Callback extends Object implements ICallback
    {
        private var _success:Function;
        private var _failed:Function;
        private var _param:Object;
        private var _result:Object;
        private var _msgs:Vector.<String>;

        public function Callback()
        {
            this._msgs = new Vector.<String>;
            return;
        }// end function

        public function get failed() : Function
        {
            return this._failed;
        }// end function

        public function set failed(param1:Function) : void
        {
            this._failed = param1;
            return;
        }// end function

        public function get success() : Function
        {
            return this._success;
        }// end function

        public function set success(param1:Function) : void
        {
            this._success = param1;
            return;
        }// end function

        public function get param() : Object
        {
            return this._param;
        }// end function

        public function set param(param1:Object) : void
        {
            this._param = param1;
            return;
        }// end function

        public function get result() : Object
        {
            return this._result;
        }// end function

        public function set result(param1:Object) : void
        {
            this._result = param1;
            return;
        }// end function

        public function callOnSuccess() : void
        {
            if (this._success == null)
            {
                return;
            }
            GTimers.inst.callLater(this.callOnSuccessImmediately);
            return;
        }// end function

        public function callOnSuccessImmediately() : void
        {
            if (this._success != null)
            {
                if (this._success.length == 0)
                {
                    this._success();
                }
                else
                {
                    this._success(this);
                }
            }
            return;
        }// end function

        public function callOnFail() : void
        {
            if (this._failed == null)
            {
                return;
            }
            GTimers.inst.callLater(this.callOnFailImmediately);
            return;
        }// end function

        public function callOnFailImmediately() : void
        {
            if (this._failed != null)
            {
                if (this._failed.length == 0)
                {
                    this._failed();
                }
                else
                {
                    this._failed(this);
                }
            }
            return;
        }// end function

        public function addMsg(param1:String) : void
        {
            if (param1)
            {
                this._msgs.push(param1);
            }
            return;
        }// end function

        public function addMsgs(param1:Vector.<String>) : void
        {
            if (param1.length > 0)
            {
                this._msgs = this._msgs.concat(param1);
            }
            return;
        }// end function

        public function get msgs() : Vector.<String>
        {
            return this._msgs;
        }// end function

        public function clearMsgs() : void
        {
            this._msgs.length = 0;
            return;
        }// end function

    }
}
