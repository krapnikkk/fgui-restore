package _-An
{
    import *.*;
    import fairygui.editor.*;
    import fairygui.utils.*;
    import flash.display.*;

    public class _-Jy extends Sprite
    {
        public var index:int;
        private var _type:int;
        private var _selected:Boolean;
        private var _color:uint;
        private var _shape:int;

        public function _-Jy(param1:int, param2:uint, param3:int = 0)
        {
            this._type = param1;
            this._color = param2;
            this._shape = param3;
            this.draw();
            this.cacheAsBitmap = true;
            return;
        }// end function

        public function get type() : int
        {
            return this._type;
        }// end function

        public function get selected() : Boolean
        {
            return this._selected;
        }// end function

        public function set selected(param1:Boolean) : void
        {
            if (this._selected != param1)
            {
                this._selected = param1;
                this.draw();
            }
            return;
        }// end function

        private function draw() : void
        {
            var _loc_1:* = this.graphics;
            var _loc_2:* = Utils.transformColor(this._color, 0.8, 0.8, 0.8);
            _loc_1.lineStyle(Consts.auxLineSize, _loc_2, 1, false, LineScaleMode.NONE);
            _loc_1.beginFill(this.selected ? (_loc_2) : (this._color), 1);
            if (this._shape == 0)
            {
                _loc_1.drawCircle(0, 0, _-I9._-2 / 2 + 1);
            }
            else
            {
                _loc_1.drawRect((-_-I9._-2) / 2, (-_-I9._-2) / 2, _-I9._-2, _-I9._-2);
            }
            _loc_1.endFill();
            return;
        }// end function

    }
}
