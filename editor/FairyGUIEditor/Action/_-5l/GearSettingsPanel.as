package _-5l
{
    import *.*;
    import _-Gs.*;
    import _-Pz.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.gear.*;

    public class GearSettingsPanel extends _-5I
    {
        private var _gearIndex:int;

        public function GearSettingsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "GearSettingsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"duration", type:"float", min:0, precision:2, step:0.1}, {name:"delay", type:"float", min:0, precision:2, step:0.1}, {name:"easeType", type:"string", items:Consts.easeType, values:Consts.easeType}, {name:"easeInOutType", type:"string", items:Consts.easeInOutType, values:Consts.easeInOutType}]);
            return;
        }// end function

        public function _-At(param1:int) : void
        {
            this._gearIndex = param1;
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = this.inspectingTarget.getGear(this._gearIndex);
            _form._-Cm(_loc_1);
            _form.updateUI();
            _form._-Om("easeInOutType").visible = _loc_1.easeType != "Linear";
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            this.inspectingTarget.docElement.setGearProperty(this._gearIndex, param1, param2);
            return;
        }// end function

    }
}
