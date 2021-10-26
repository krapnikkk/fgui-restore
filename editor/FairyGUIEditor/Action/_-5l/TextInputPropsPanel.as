package _-5l
{
    import *.*;
    import _-Gs.*;
    import _-Pz.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class TextInputPropsPanel extends _-5I
    {

        public function TextInputPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "TextInputPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"promptText", type:"string"}, {name:"restrict", type:"string"}, {name:"maxLength", type:"int", min:0}, {name:"keyboardType", type:"int", items:[Consts.strings.text138, Consts.strings.text292, Consts.strings.text293, Consts.strings.text294, Consts.strings.text295, Consts.strings.text296, Consts.strings.text297]}, {name:"password", type:"bool"}]);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = this.inspectingTarget;
            if (_loc_1 is FComponent)
            {
                _form._-Cm(FComponent(_loc_1).extention);
            }
            else
            {
                _form._-Cm(_loc_1);
            }
            _form.updateUI();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_9:* = null;
            var _loc_4:* = _editor.docView.activeDocument;
            var _loc_5:* = this.inspectingTargets;
            var _loc_6:* = _loc_5[0] is FComponent;
            var _loc_7:* = _loc_5.length;
            var _loc_8:* = 0;
            while (_loc_8 < _loc_7)
            {
                
                _loc_9 = _loc_5[_loc_8];
                if (_loc_6)
                {
                    _loc_9.docElement.setExtensionProperty(param1, param2);
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
