package _-Gs
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;
    import flash.utils.*;

    public class _-LG extends Object implements ICursorManager
    {
        private var _-6X:String;
        private var _-Hg:String;
        private var _-C8:Function;
        private var _-By:DisplayObject;
        private var _-6r:Object;
        private var _-Mq:Boolean;
        private var _-2I:Dictionary;
        private var _-21:Boolean;
        private var _editor:IEditor;
        private static var _-Cu:Boolean;

        public function _-LG(param1:IEditor)
        {
            this._editor = param1;
            this._-2I = new Dictionary(true);
            if (!_-Cu)
            {
                _-Cu = true;
                _-Iq(CursorType.H_RESIZE, "cursor_hResize");
                _-Iq(CursorType.V_RESIZE, "cursor_vResize");
                _-Iq(CursorType.TL_RESIZE, "cursor_d1Resize");
                _-Iq(CursorType.TR_RESIZE, "cursor_d2Resize");
                _-Iq(CursorType.BL_RESIZE, "cursor_d2Resize");
                _-Iq(CursorType.BR_RESIZE, "cursor_d1Resize");
                _-Iq(CursorType.SELECT, "cursor_select");
                _-Iq(CursorType.HAND, "cursor_hand");
                _-Iq(CursorType.DRAG, "cursor_drag", new Point(2, 1));
                _-Iq(CursorType.ADJUST, "cursor_adjust", new Point(10, 4));
                _-Iq(CursorType.FINGER, "cursor_finger", new Point(7, 0));
                _-Iq(CursorType.COLOR_PICKER, "cursor_picker", new Point(0, 13));
                _-Iq(CursorType.WAIT, "cursor_wait", new Point(11, 11));
            }
            this._editor.groot.nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            this._editor.groot.nativeStage.addEventListener(MouseEvent.MOUSE_UP, this.__mouseUp);
            return;
        }// end function

        public function setDefaultCursor(param1:String, param2:Function = null) : void
        {
            this._-Hg = param1;
            this._-C8 = param2;
            this.updateCursor();
            return;
        }// end function

        public function setWaitCursor(param1:Boolean) : void
        {
            this.setDefaultCursor(param1 ? (CursorType.WAIT) : (null));
            return;
        }// end function

        public function setCursorForObject(param1:DisplayObject, param2:String, param3:Function = null, param4:Boolean = false) : void
        {
            if (param2 != null)
            {
                this._-2I[param1] = {cursor:param2, detector:param3};
                param1.addEventListener(MouseEvent.ROLL_OVER, this._-PU);
                param1.addEventListener(MouseEvent.ROLL_OUT, this._-6A);
                param1.addEventListener(Event.REMOVED_FROM_STAGE, this.__removedFromStage);
                if (param4 && this._-By == null && param1.stage != null && param1.hitTestPoint(param1.stage.mouseX, param1.stage.mouseY))
                {
                    this._-J3(param1);
                }
            }
            else
            {
                param1.removeEventListener(MouseEvent.ROLL_OVER, this._-PU);
                param1.removeEventListener(MouseEvent.ROLL_OUT, this._-6A);
                param1.removeEventListener(Event.REMOVED_FROM_STAGE, this.__removedFromStage);
                delete this._-2I[param1];
                if (this._-By == param1)
                {
                    this._-8o();
                }
            }
            return;
        }// end function

        public function updateCursor() : void
        {
            var _loc_1:* = null;
            if (this._-Hg != null)
            {
                if (this._-C8 == null || this._-C8())
                {
                    _loc_1 = this._-Hg;
                }
            }
            if (_loc_1 == null && this._-By != null && (this._-6r.detector == null || this._-6r.detector()))
            {
                _loc_1 = this._-6r.cursor;
            }
            if (_loc_1 != this._-6X)
            {
                this._-6X = _loc_1;
                if (UtilsStr.startsWith(this._-6X, "fgui_"))
                {
                    Mouse.cursor = this._-6X;
                }
                else
                {
                    if (this._-6X == null)
                    {
                        Mouse.cursor = MouseCursor.AUTO;
                    }
                    else
                    {
                        Mouse.cursor = this._-6X;
                    }
                    Mouse.show();
                }
            }
            return;
        }// end function

        public function get currentCursor() : String
        {
            return this._-6X;
        }// end function

        public function get _-8W() : Boolean
        {
            return this._-6X == CursorType.COLOR_PICKER;
        }// end function

        private function _-J3(param1:DisplayObject) : void
        {
            this._-By = param1;
            this._-Mq = true;
            this._-6r = this._-2I[this._-By];
            this.updateCursor();
            return;
        }// end function

        private function _-8o() : void
        {
            this._-By = null;
            this._-6r = null;
            this._-Mq = false;
            this.updateCursor();
            return;
        }// end function

        private function __mouseMove(event:MouseEvent) : void
        {
            this.updateCursor();
            return;
        }// end function

        private function __mouseUp(event:MouseEvent) : void
        {
            if (this._-By != null && !this._-Mq)
            {
                this._-8o();
            }
            return;
        }// end function

        private function _-PU(event:MouseEvent) : void
        {
            if (this._editor.groot.buttonDown)
            {
                return;
            }
            var _loc_2:* = DisplayObject(event.currentTarget);
            if (this._-By == null)
            {
                this._-J3(_loc_2);
            }
            else if (this._-By == _loc_2)
            {
                this._-Mq = true;
            }
            return;
        }// end function

        private function _-6A(event:MouseEvent) : void
        {
            var _loc_2:* = DisplayObject(event.currentTarget);
            if (_loc_2 != this._-By)
            {
                return;
            }
            this._-Mq = false;
            if (this._editor.groot.buttonDown)
            {
                return;
            }
            this._-8o();
            return;
        }// end function

        private function __removedFromStage(event:Event) : void
        {
            if (this._-By == event.currentTarget)
            {
                this._-By = null;
                this._-6r = null;
                this.updateCursor();
            }
            return;
        }// end function

        private static function _-Iq(param1:String, param2:String, param3:Point = null) : void
        {
            var _loc_4:* = UIPackage.getByName("Basic").getImage(param2);
            var _loc_5:* = new MouseCursorData();
            var _loc_6:* = new Vector.<BitmapData>;
            _loc_6.push(_loc_4);
            _loc_5.data = _loc_6;
            if (param3 == null)
            {
                param3 = new Point(_loc_4.width / 2, _loc_4.height / 2);
            }
            _loc_5.hotSpot = param3;
            Mouse.registerCursor(param1, _loc_5);
            return;
        }// end function

    }
}
