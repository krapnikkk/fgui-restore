package fairygui.editor.publish
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.plugin.*;
    import fairygui.utils.*;

    public class _-6y extends _-CI
    {
        private var _index:int;
        private var _-6w:Callback;
        private var _handlers:Vector.<IPublishHandler>;
        private var _-2U:IPublishData;

        public function _-6y()
        {
            return;
        }// end function

        override public function run() : void
        {
            this._handlers = _-J.project.getVar("PublishPlugins");
            if (!this._handlers || this._handlers.length == 0)
            {
                _stepCallback.callOnSuccessImmediately();
                return;
            }
            this._index = 0;
            this._-2U = new PublishDataProxy(_-J);
            this._-6w = new Callback();
            this._-6w.success = function () : void
            {
                _stepCallback.addMsgs(_-6w.msgs);
                _-6w.msgs.length = 0;
                _-FF();
                return;
            }// end function
            ;
            this._-6w.failed = function () : void
            {
                _stepCallback.msgs.length = 0;
                _stepCallback.addMsgs(_-6w.msgs);
                _stepCallback.callOnFailImmediately();
                return;
            }// end function
            ;
            this._-FF();
            return;
        }// end function

        private function _-FF() : void
        {
            var ret:Boolean;
            if (this._index >= this._handlers.length)
            {
                _stepCallback.callOnSuccessImmediately();
                return;
            }
            var handler:* = this._handlers[this._index];
            var _loc_2:* = this;
            var _loc_3:* = this._index + 1;
            _loc_2._index = _loc_3;
            try
            {
                ret = handler.doExport(this._-2U, this._-6w);
            }
            catch (err:Error)
            {
                var _loc_3:* = null;
                _-6w.failed = null;
                _-6w.success = _loc_3;
                _stepCallback.msgs.length = 0;
                _-J.project.editor.consoleView.logError("Plugin error: ", err);
                _stepCallback.addMsg("Plugin error");
                _stepCallback.callOnFailImmediately();
                return;
            }
            if (!ret)
            {
                this._-FF();
            }
            return;
        }// end function

    }
}
