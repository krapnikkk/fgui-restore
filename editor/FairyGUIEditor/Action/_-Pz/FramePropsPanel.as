package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class FramePropsPanel extends _-5I
    {
        private var _tween:Controller;
        private var _-FG:FTransitionItem;

        public function FramePropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "FramePropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"easeType", type:"string", items:Consts.easeType, values:Consts.easeType}, {name:"easeInOutType", type:"string", items:Consts.easeInOutType, values:Consts.easeInOutType}, {name:"tween", type:"bool"}, {name:"repeat", type:"int", min:-1, step:1}, {name:"yoyo", type:"bool"}, {name:"label", type:"string"}]);
            this._tween = _panel.getController("tween");
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            this._-FG = _editor.timelineView.getSelection();
            if (this._-FG == null)
            {
                return false;
            }
            this._tween.selectedIndex = this._-FG.tween ? (1) : (0);
            _form._-Om("easeInOutType").visible = this._-FG.easeType != "Linear";
            _form._-Om("tween").visible = FTransition.supportTween(this._-FG.type);
            _form._-Cm(this._-FG);
            _form.updateUI();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_4:* = _editor.docView.activeDocument;
            _loc_4.setKeyFrameProperty(this._-FG, param1, param2);
            return;
        }// end function

    }
}
