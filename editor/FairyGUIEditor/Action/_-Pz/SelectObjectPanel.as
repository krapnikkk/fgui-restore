package _-Pz
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class SelectObjectPanel extends Object implements IInspectorPanel
    {
        private var _panel:GComponent;
        private var _editor:IEditor;
        private var _result:FObject;
        private var _callback:Function;
        private var _-4b:Function;
        private var _-Mn:Function;

        public function SelectObjectPanel(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            this._panel = UIPackage.createObject("Builder", "SelectObjectPanel").asCom;
            this._panel.getChild("n4").addClickListener(function () : void
            {
                if (_result == null)
                {
                    return;
                }
                var _loc_1:* = _editor.docView.activeDocument;
                if (_-4b != null)
                {
                    if (!_-4b(_result))
                    {
                        return;
                    }
                }
                var _loc_2:* = _callback;
                var _loc_3:* = _result;
                reset();
                _loc_1.cancelPickObject();
                null._loc_2(_loc_3);
                return;
            }// end function
            );
            this._panel.getChild("n5").addClickListener(function () : void
            {
                var _loc_1:* = _-Mn;
                reset();
                var _loc_2:* = _editor.docView.activeDocument;
                _loc_2.cancelPickObject();
                if (_loc_1 != null)
                {
                    null._loc_1();
                }
                return;
            }// end function
            );
            return;
        }// end function

        public function get panel() : GComponent
        {
            return this._panel;
        }// end function

        public function get title() : String
        {
            return null;
        }// end function

        public function updateUI() : Boolean
        {
            var _loc_1:* = this._editor.docView.activeDocument.inspectingTarget;
            if (_loc_1.parent)
            {
                this._result = _loc_1;
                this._panel.getChild("title").text = _loc_1.toString();
                this._panel.getChild("icon").asLoader.url = _loc_1.docElement.displayIcon;
            }
            return true;
        }// end function

        public function start(param1:FObject, param2:Function, param3:Function = null, param4:Function = null) : void
        {
            this._result = param1;
            this._callback = param2;
            this._-4b = param3;
            this._-Mn = param4;
            if (this._result)
            {
                this._panel.getChild("title").text = this._result.toString();
                this._panel.getChild("icon").asLoader.url = this._result.docElement.displayIcon;
            }
            else
            {
                this._panel.getChild("title").text = "";
                this._panel.getChild("icon").asLoader.url = null;
            }
            return;
        }// end function

        public function reset() : void
        {
            this._callback = null;
            this._-4b = null;
            this._-Mn = null;
            this._result = null;
            return;
        }// end function

    }
}
