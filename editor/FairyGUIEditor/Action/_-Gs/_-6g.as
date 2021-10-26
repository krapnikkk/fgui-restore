package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class _-6g extends Object
    {
        private var _editor:IEditor;
        private var _owner:GObject;
        private var _callback:Function;
        private var helperBmd:BitmapData;
        private var helperMatrix:Matrix;
        private var helperRect:Rectangle;

        public function _-6g(param1:IEditor)
        {
            this._editor = param1;
            this.helperBmd = new BitmapData(1, 1, false);
            this.helperMatrix = new Matrix();
            this.helperRect = new Rectangle(0, 0, 1, 1);
            return;
        }// end function

        public function start(param1:GObject, param2:Function) : void
        {
            this._owner = param1;
            this._callback = param2;
            this._editor.cursorManager.setDefaultCursor(CursorType.COLOR_PICKER, this._-48);
            this._editor.groot.nativeStage.addEventListener(MouseEvent.MOUSE_DOWN, this._-PP, true, 1);
            param1.addEventListener(Event.REMOVED_FROM_STAGE, this._-7i);
            return;
        }// end function

        public function stop() : void
        {
            this._owner.removeEventListener(Event.REMOVED_FROM_STAGE, this._-7i);
            this._owner = null;
            this._callback = null;
            this._editor.cursorManager.setDefaultCursor(null);
            this._editor.groot.nativeStage.removeEventListener(MouseEvent.CLICK, this._-PP, true);
            return;
        }// end function

        private function _-7i(event:Event) : void
        {
            this.stop();
            return;
        }// end function

        private function _-48() : Boolean
        {
            var _loc_1:* = this._editor.groot.nativeStage.mouseX;
            var _loc_2:* = this._editor.groot.nativeStage.mouseY;
            return _loc_1 < this._owner.x || _loc_2 < this._owner.y || _loc_1 > this._owner.x + this._owner.width || _loc_2 > this._owner.y + this._owner.height;
        }// end function

        private function _-PP(event:MouseEvent) : void
        {
            if (this._editor.cursorManager.currentCursor != CursorType.COLOR_PICKER)
            {
                return;
            }
            event.stopPropagation();
            this.helperMatrix.identity();
            this.helperMatrix.translate(-event.stageX, -event.stageY);
            this.helperBmd.draw(this._editor.groot.nativeStage, this.helperMatrix, null, null, this.helperRect);
            var _loc_2:* = this.helperBmd.getPixel(0, 0);
            if (this._owner.displayObject && this._owner.displayObject.stage)
            {
                this._callback(_loc_2);
            }
            return;
        }// end function

    }
}
