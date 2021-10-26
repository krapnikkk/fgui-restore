package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class GraphPropsPanel extends _-5I
    {
        private var _shape:Controller;
        private var _-KW:Controller;
        private var _-3b:GTextField;

        public function GraphPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "GraphPropsPanel").asCom;
            this._shape = _panel.getController("shape");
            this._-KW = _panel.getController("verticesEditing");
            this._-3b = _panel.getChild("pointIndex").asTextField;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"type", type:"string", items:[Consts.strings.text146, Consts.strings.text147, Consts.strings.text148, Consts.strings.text383, Consts.strings.text384], values:["empty", "rect", "ellipse", "regular_polygon", "polygon"]}, {name:"lineColor", type:"uint", showAlpha:true}, {name:"fillColor", type:"uint", showAlpha:true}, {name:"lineSize", type:"int", min:0}, {name:"cornerRadius", type:"string", trim:true}, {name:"pointX", type:"float", dummy:true}, {name:"pointY", type:"float", dummy:true}, {name:"distance", type:"float", dummy:true, min:0, max:1, precision:2}, {name:"startAngle", type:"float", precision:2, step:0.1}, {name:"sides", type:"int", min:3, max:100}, {name:"shapeLocked", type:"bool"}]);
            _panel.getChild("resetAll").addClickListener(this._-ME);
            _panel.getChild("polygonEdit").addClickListener(this._-84);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_3:* = 0;
            var _loc_1:* = FGraph(this.inspectingTarget);
            _form._-Cm(_loc_1);
            this._shape.selectedPage = _loc_1.type;
            var _loc_2:* = _loc_1.docElement.gizmo;
            if (_loc_2.verticesEditing && _loc_2.activeHandleIndex != -1)
            {
                _loc_3 = _loc_2.activeHandleIndex;
                if (_loc_3 >= 0 && _loc_3 < _loc_1.polygonPoints.length)
                {
                    this._-KW.selectedIndex = 1;
                    this._-3b.setVar("index", "" + _loc_3).flushVars();
                    if (_loc_1.type == FGraph.POLYGON)
                    {
                        _form.setValue("pointX", _loc_1.polygonPoints.get_x(_loc_3));
                        _form.setValue("pointY", _loc_1.polygonPoints.get_y(_loc_3));
                    }
                    else
                    {
                        _form.setValue("distance", _loc_1.verticesDistance[_loc_3]);
                    }
                }
                else
                {
                    this._-KW.selectedIndex = 0;
                }
            }
            else
            {
                this._-KW.selectedIndex = 0;
            }
            _form.updateUI();
            return true;
        }// end function

        private function _-84(event:Event) : void
        {
            _editor.docView.activeDocument.openChild(this.inspectingTarget);
            return;
        }// end function

        private function _-ME(event:Event) : void
        {
            var _loc_2:* = FGraph(this.inspectingTarget);
            var _loc_3:* = _loc_2.sides;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2.docElement.setVertexDistance(_loc_4, 1);
                _loc_4++;
            }
            return;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            if (param1 == "pointX" || param1 == "pointY" || param1 == "distance")
            {
                _loc_4 = FGraph(this.inspectingTarget);
                _loc_5 = _loc_4.docElement.gizmo;
                _loc_6 = _loc_5.activeHandleIndex;
                if (param1 == "distance")
                {
                    _loc_4.docElement.setVertexDistance(_loc_6, _form._-4y("distance"));
                }
                else
                {
                    _loc_4.docElement.setVertexPosition(_loc_6, _form._-4y("pointX"), _form._-4y("pointY"));
                }
            }
            else
            {
                _-Ix(param1, param2, param3);
            }
            return;
        }// end function

    }
}
