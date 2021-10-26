package _-Pz
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.geom.*;

    public class MultiSelectionPanel extends _-5I
    {
        private var _-BJ:Point;

        public function MultiSelectionPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "MultiSelectionPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"x", type:"int"}, {name:"y", type:"int"}, {name:"width", type:"int", min:0, dummy:true}, {name:"height", type:"int", min:0, dummy:true}]);
            this._-BJ = new Point();
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            this.updateBounds();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_10:* = null;
            var _loc_11:* = NaN;
            var _loc_4:* = NumericInput(_form._-Om("x")).value - this._-BJ.x;
            var _loc_5:* = NumericInput(_form._-Om("y")).value - this._-BJ.y;
            var _loc_6:* = _editor.docView.activeDocument;
            var _loc_7:* = this.inspectingTargets;
            var _loc_8:* = _loc_7.length;
            var _loc_9:* = 0;
            while (_loc_9 < _loc_8)
            {
                
                _loc_10 = _loc_7[_loc_9];
                _loc_11 = _loc_10.x + _loc_4;
                _loc_10.docElement.setProperty("x", _loc_11);
                _loc_11 = _loc_10.y + _loc_5;
                _loc_10.docElement.setProperty("y", _loc_11);
                _loc_9++;
            }
            return;
        }// end function

        private function updateBounds() : void
        {
            var _loc_6:* = null;
            var _loc_1:* = this.inspectingTargets;
            var _loc_2:* = _loc_1.length;
            this._-BJ.x = int.MAX_VALUE;
            this._-BJ.y = int.MAX_VALUE;
            var _loc_3:* = int.MIN_VALUE;
            var _loc_4:* = int.MIN_VALUE;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_2)
            {
                
                _loc_6 = _loc_1[_loc_5];
                if (_loc_6.xMin < this._-BJ.x)
                {
                    this._-BJ.x = _loc_6.xMin;
                }
                if (_loc_6.yMin < this._-BJ.y)
                {
                    this._-BJ.y = _loc_6.yMin;
                }
                if (_loc_6.xMax > _loc_3)
                {
                    _loc_3 = _loc_6.xMax;
                }
                if (_loc_6.yMax > _loc_4)
                {
                    _loc_4 = _loc_6.yMax;
                }
                _loc_5++;
            }
            this._-BJ.x = int(this._-BJ.x);
            this._-BJ.y = int(this._-BJ.y);
            _form.setValue("x", this._-BJ.x);
            _form.setValue("y", this._-BJ.y);
            _form.setValue("width", _loc_3 - this._-BJ.x);
            _form.setValue("height", _loc_4 - this._-BJ.y);
            _form.updateUI();
            return;
        }// end function

    }
}
