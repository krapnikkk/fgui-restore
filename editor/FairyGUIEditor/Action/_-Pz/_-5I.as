package _-Pz
{
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class _-5I extends Object implements IInspectorPanel
    {
        protected var _editor:IEditor;
        protected var _panel:GComponent;
        protected var _form:_-7r;

        public function _-5I()
        {
            return;
        }// end function

        public function get panel() : GComponent
        {
            return this._panel;
        }// end function

        public function get inspectingTarget() : FObject
        {
            return this._editor.docView.activeDocument.inspectingTarget;
        }// end function

        public function get inspectingTargets() : Vector.<FObject>
        {
            return this._editor.docView.activeDocument.inspectingTargets;
        }// end function

        public function updateUI() : Boolean
        {
            if (this._form)
            {
                this._form._-Cm(this.inspectingTarget);
                this._form.updateUI();
            }
            return true;
        }// end function

        protected function _-Ix(param1:String, param2, param3) : void
        {
            var _loc_8:* = null;
            var _loc_4:* = this._editor.docView.activeDocument;
            var _loc_5:* = this.inspectingTargets;
            var _loc_6:* = _loc_5.length;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_8 = _loc_5[_loc_7];
                _loc_8.docElement.setProperty(param1, param2);
                _loc_7++;
            }
            return;
        }// end function

        protected function _-GQ(param1:String, param2, param3) : void
        {
            var _loc_8:* = null;
            var _loc_4:* = this._editor.docView.activeDocument;
            var _loc_5:* = this.inspectingTargets;
            var _loc_6:* = _loc_5.length;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_8 = FComponent(_loc_5[_loc_7]);
                _loc_8.docElement.setExtensionProperty(param1, param2);
                _loc_7++;
            }
            return;
        }// end function

    }
}
