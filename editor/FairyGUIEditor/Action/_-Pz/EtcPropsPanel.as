package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class EtcPropsPanel extends _-5I
    {
        private var _-1Q:Controller;

        public function EtcPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "EtcPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"tooltips", type:"string"}, {name:"customData", type:"string"}]);
            this._-1Q = _panel.getController("noTips");
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = this.inspectingTarget;
            if (_loc_1 is FGroup && !FGroup(_loc_1).advanced)
            {
                return false;
            }
            _form._-Cm(_loc_1);
            _form.updateUI();
            this._-1Q.selectedIndex = _loc_1.touchDisabled ? (1) : (0);
            return true;
        }// end function

    }
}
