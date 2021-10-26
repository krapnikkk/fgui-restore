package _-Gs
{
    import *.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;

    public class _-Al extends Object
    {
        private var _-C6:NativeWindow;

        public function _-Al(param1:Stage) : void
        {
            this._-C6 = param1.nativeWindow;
            return;
        }// end function

        public function dispose() : void
        {
            this._-C6.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, this._-Aa);
            var _loc_1:* = LocalStore.data;
            if (this._-C6.displayState == NativeWindowDisplayState.NORMAL)
            {
                _loc_1.win_x = this._-C6.x;
                _loc_1.win_y = this._-C6.y;
                _loc_1.win_width = this._-C6.width;
                _loc_1.win_height = this._-C6.height;
            }
            _loc_1.win_state = this._-C6.displayState;
            return;
        }// end function

        public function _-D8(param1:Function) : void
        {
            var _loc_2:* = LocalStore.data;
            if (_loc_2.win_x != undefined && _loc_2.win_x > 0 && _loc_2.win_x < Capabilities.screenResolutionX - 100)
            {
                this._-C6.x = _loc_2.win_x;
            }
            if (_loc_2.win_y != undefined && _loc_2.win_y > 0 && _loc_2.win_y < Capabilities.screenResolutionY - 100)
            {
                this._-C6.y = _loc_2.win_y;
            }
            if (_loc_2.win_width != undefined && _loc_2.win_width < Capabilities.screenResolutionX)
            {
                this._-C6.width = _loc_2.win_width;
            }
            if (_loc_2.win_height != undefined && _loc_2.win_height < Capabilities.screenResolutionY)
            {
                this._-C6.height = _loc_2.win_height;
            }
            var _loc_3:* = _loc_2.win_state == "maximized";
            if (_loc_3)
            {
                this._-C6.maximize();
            }
            this._-C6.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, this._-Aa);
            if (!_loc_3)
            {
                this.param1();
            }
            else
            {
                GTimers.inst.add(10, 1, param1);
            }
            return;
        }// end function

        private function _-Aa(event:NativeWindowDisplayStateEvent) : void
        {
            var _loc_2:* = LocalStore.data;
            if (event.afterDisplayState != NativeWindowDisplayState.NORMAL)
            {
                _loc_2.win_x = this._-C6.x;
                _loc_2.win_y = this._-C6.y;
                _loc_2.win_width = this._-C6.width;
                _loc_2.win_height = this._-C6.height;
            }
            _loc_2.win_state = event.afterDisplayState;
            return;
        }// end function

    }
}
