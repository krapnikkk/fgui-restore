package _-5l
{
    import *.*;
    import _-Gs.*;
    import _-Pz.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class MarginPropsPanel extends _-5I
    {
        private static var _-3t:FMargin = new FMargin();

        public function MarginPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "MarginPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"marginLeft", type:"int", dummy:true, extData:"left"}, {name:"marginRight", type:"int", dummy:true, extData:"right"}, {name:"marginTop", type:"int", dummy:true, extData:"top"}, {name:"marginBottom", type:"int", dummy:true, extData:"bottom"}, {name:"clipSoftnessX", type:"int"}, {name:"clipSoftnessY", type:"int"}]);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FComponent(this.inspectingTarget);
            _form.setValue("marginLeft", _loc_1.margin.left);
            _form.setValue("marginRight", _loc_1.margin.right);
            _form.setValue("marginTop", _loc_1.margin.top);
            _form.setValue("marginBottom", _loc_1.margin.bottom);
            _form._-Cm(_loc_1);
            _form.updateUI();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            if (param3 != undefined)
            {
                _loc_4 = _editor.docView.activeDocument;
                _loc_5 = this.inspectingTargets;
                _loc_6 = _loc_5.length;
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_8 = FComponent(_loc_5[_loc_7]);
                    _-3t.copy(_loc_8.margin);
                    _-3t[param3] = param2;
                    _loc_8.docElement.setProperty("marginStr", _-3t.toString());
                    _loc_7++;
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
