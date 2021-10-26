package _-Pz
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;

    public class GroupPropsPanel extends _-5I
    {

        public function GroupPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "GroupPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"name", type:"string", disableIME:true, trim:true}, {name:"x", type:"int"}, {name:"y", type:"int"}, {name:"width", type:"int", min:0}, {name:"height", type:"int", min:0}, {name:"visible", type:"bool", reversed:true}, {name:"advanced", type:"bool"}, {name:"layout", type:"string"}, {name:"lineGap", type:"int"}, {name:"columnGap", type:"int"}, {name:"excludeInvisibles", type:"bool"}, {name:"autoSizeDisabled", type:"bool"}, {name:"hasMainGrid", type:"bool"}, {name:"mainGridIndex", type:"int", min:0}]);
            return;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_9:* = null;
            var _loc_4:* = _editor.docView.activeDocument;
            var _loc_5:* = this.inspectingTargets;
            var _loc_6:* = _loc_5.length;
            var _loc_7:* = false;
            if (param1 == "name")
            {
                param2 = param2.replace(/\#/g, "{0}");
                _loc_7 = true;
            }
            var _loc_8:* = 0;
            while (_loc_8 < _loc_6)
            {
                
                _loc_9 = _loc_5[_loc_8];
                if (_loc_7)
                {
                    _loc_9.docElement.setProperty(param1, UtilsStr.formatString(String(param2), _loc_8));
                }
                else
                {
                    _loc_9.docElement.setProperty(param1, param2);
                }
                _loc_8++;
            }
            return;
        }// end function

    }
}
