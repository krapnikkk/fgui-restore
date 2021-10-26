package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import flash.display.*;
    import flash.geom.*;

    public class _-OH extends Object implements IDragManager
    {
        private var _editor:IEditor;
        private var _-Dq:GLoader;
        private var _-GE:Object;
        private var _-NU:Object;
        private var _-B:Function;
        private var _-Mn:Function;
        private var _-G0:Function;
        private var _-7O:BitmapData;

        public function _-OH(param1:IEditor)
        {
            this._editor = param1;
            this._-Dq = new GLoader();
            this._-Dq.draggable = true;
            this._-Dq.touchable = false;
            this._-Dq.setSize(100, 100);
            this._-Dq.setPivot(0.5, 0.5, true);
            this._-Dq.align = AlignType.Center;
            this._-Dq.verticalAlign = VertAlignType.Middle;
            this._-Dq.sortingOrder = int.MAX_VALUE;
            this._-Dq.addEventListener(DragEvent.DRAG_END, this.__dragEnd);
            this._-Dq.addEventListener(DragEvent.DRAG_MOVING, this.__dragging);
            return;
        }// end function

        public function get agent() : GObject
        {
            return this._-Dq;
        }// end function

        public function get dragging() : Boolean
        {
            return this._-Dq.parent != null;
        }// end function

        public function startDrag(param1:Object = null, param2:Object = null, param3:Object = null, param4:Object = null) : void
        {
            var _loc_7:* = null;
            if (this._-Dq.parent != null)
            {
                return;
            }
            this._-GE = param1;
            this._-NU = param2;
            if (param3 is GObject)
            {
                _loc_7 = GObject(param3);
                this._-7O = new BitmapData(_loc_7.width, _loc_7.height, true, 0);
                this._-7O.draw(_loc_7.displayObject, null, new ColorTransform(1, 1, 1, 0.8));
                this._-Dq.texture = this._-7O;
            }
            else if (param3 is String)
            {
                this._-Dq.url = String(param3);
            }
            var _loc_5:* = CursorType.DRAG;
            if (param4 != null)
            {
                this._-B = param4.onComplete;
                this._-Mn = param4.onCancel;
                this._-G0 = param4.onMove;
                if (param4.cursor)
                {
                    _loc_5 = param4.cursor;
                }
                else if (param4.cursor == null)
                {
                    _loc_5 = null;
                }
            }
            if (_loc_5)
            {
                this._editor.cursorManager.setDefaultCursor(_loc_5);
            }
            this._editor.groot.addChild(this._-Dq);
            var _loc_6:* = this._editor.groot.globalToLocal(this._editor.groot.nativeStage.mouseX, this._editor.groot.nativeStage.mouseY);
            this._-Dq.setXY(_loc_6.x, _loc_6.y);
            this._-Dq.startDrag();
            return;
        }// end function

        public function cancel() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this._-Dq.parent != null)
            {
                this._-Dq.stopDrag();
                this._editor.groot.removeChild(this._-Dq);
                this._editor.cursorManager.setDefaultCursor(null);
                if (this._-7O)
                {
                    this._-7O.dispose();
                    this._-7O = null;
                }
                _loc_1 = this._-GE;
                _loc_2 = this._-NU;
                this._-GE = null;
                this._-NU = null;
                this._-B = null;
                _loc_3 = this._-Mn;
                this._-Mn = null;
                this._-G0 = null;
                if (_loc_3 != null)
                {
                    if (_loc_3.length == 2)
                    {
                        this._loc_3(_loc_1, _loc_2);
                    }
                    else if (_loc_3.length == 1)
                    {
                        this._loc_3(_loc_1);
                    }
                    else
                    {
                        this._loc_3();
                    }
                }
            }
            return;
        }// end function

        private function __dragging(event:DragEvent) : void
        {
            if (this._-G0 != null)
            {
                this._-G0(event);
            }
            return;
        }// end function

        private function __dragEnd(event:DragEvent) : void
        {
            var _loc_6:* = null;
            if (this._-Dq.parent == null)
            {
                return;
            }
            this._editor.groot.removeChild(this._-Dq);
            this._editor.cursorManager.setDefaultCursor(null);
            if (this._-7O)
            {
                this._-7O.dispose();
                this._-7O = null;
            }
            var _loc_2:* = this._-GE;
            var _loc_3:* = this._-NU;
            this._-GE = null;
            this._-NU = null;
            this._-Mn = null;
            this._-G0 = null;
            var _loc_4:* = this._-B;
            this._-B = null;
            if (_loc_4 != null)
            {
                if (_loc_4.length == 2)
                {
                    this._loc_4(_loc_2, _loc_3);
                }
                else if (_loc_4.length == 1)
                {
                    this._loc_4(_loc_2);
                }
                else
                {
                    this._loc_4();
                }
            }
            var _loc_5:* = this._editor.groot.getObjectUnderMouse();
            while (_loc_5 != null)
            {
                
                if (_loc_5.hasEventListener(DropEvent.DROP) && _loc_5.touchable)
                {
                    _loc_6 = new DropEvent(DropEvent.DROP, _loc_2, _loc_3);
                    _loc_5.requestFocus();
                    _loc_5.dispatchEvent(_loc_6);
                    return;
                }
                _loc_5 = _loc_5.parent;
            }
            return;
        }// end function

    }
}
