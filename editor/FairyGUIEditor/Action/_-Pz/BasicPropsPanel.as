package _-Pz
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class BasicPropsPanel extends _-5I
    {
        private var _-3N:Controller;

        public function BasicPropsPanel(param1:IEditor)
        {
            var editor:* = param1;
            _editor = editor;
            _panel = UIPackage.createObject("Builder", "BasicPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"name", type:"string", disableIME:true, trim:true, extData:{group:true}}, {name:"x", type:"int", extData:{group:true}}, {name:"y", type:"int", extData:{group:true}}, {name:"width", type:"int", min:0, extData:{group:true}}, {name:"height", type:"int", min:0, extData:{group:true}}, {name:"minWidth", type:"int"}, {name:"minHeight", type:"int"}, {name:"maxWidth", type:"int"}, {name:"maxHeight", type:"int"}, {name:"aspectLocked", type:"bool"}, {name:"useSourceSize", type:"bool"}, {name:"pivotX", type:"float", precision:2}, {name:"pivotY", type:"float", precision:2}, {name:"anchor", type:"bool"}, {name:"scaleX", type:"float", precision:2}, {name:"scaleY", type:"float", precision:2}, {name:"skewX", type:"float", precision:2, step:0.1, min:-360, max:360}, {name:"skewY", type:"float", precision:2, step:0.1, min:-360, max:360}, {name:"rotation", type:"float", precision:2, step:0.1}, {name:"alpha", type:"float", precision:2, min:0, max:1}, {name:"visible", type:"bool", reversed:true, extData:{group:true}}, {name:"touchable", type:"bool", reversed:true}, {name:"grayed", type:"bool"}]);
            this._-3N = _panel.getController("showRestrictSize");
            _panel.getChild("n55").addClickListener(function (event:Event) : void
            {
                SelectPivotMenu._-30(_editor).show(_form._-Om("pivotX"), _form._-Om("pivotY"), GObject(event.currentTarget));
                return;
            }// end function
            );
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_4:* = null;
            var _loc_1:* = this.inspectingTargets;
            var _loc_2:* = _loc_1[0];
            var _loc_3:* = _editor.docView.activeDocument.getInspectingTargetCount("group");
            if (_loc_3 == _loc_1.length)
            {
                return false;
            }
            _form._-Cm(_loc_2);
            _form.updateUI();
            if (_loc_1.length == 1)
            {
                _form._-Om("useSourceSize").enabled = _loc_2._res != null;
                _form._-Om("touchable").enabled = !_loc_2.touchDisabled;
                _form._-Om("width").enabled = !_loc_2.relations.widthLocked;
                _form._-Om("height").enabled = !_loc_2.relations.heightLocked;
                this._-3N.selectedIndex = _loc_2.minWidth != 0 || _loc_2.minHeight != 0 || _loc_2.maxWidth != 0 || _loc_2.maxHeight != 0 ? (1) : (0);
            }
            else
            {
                _form._-Om("useSourceSize").enabled = true;
                if (this._-18(_loc_1))
                {
                    _form._-Om("touchable").enabled = false;
                }
                else
                {
                    _form._-Om("touchable").enabled = true;
                }
                _form._-Om("width").enabled = true;
                _form._-Om("height").enabled = true;
                this._-3N.selectedIndex = 1;
            }
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_10:* = null;
            var _loc_4:* = _editor.docView.activeDocument;
            var _loc_5:* = this.inspectingTargets;
            var _loc_6:* = _loc_5.length;
            var _loc_7:* = false;
            var _loc_8:* = false;
            if (param1 == "name")
            {
                if (param2.length == 0)
                {
                    _loc_8 = true;
                }
                else
                {
                    param2 = param2.replace(/\#/g, "{0}");
                    _loc_7 = true;
                }
            }
            var _loc_9:* = 0;
            while (_loc_9 < _loc_6)
            {
                
                _loc_10 = _loc_5[_loc_9];
                if (param1 == "width")
                {
                    if (_loc_10.relations.widthLocked)
                    {
                    }
                    if (_loc_10.aspectLocked)
                    {
                        _loc_10.docElement.setProperty("height", int(param2 / _loc_10.aspectRatio));
                    }
                }
                else if (param1 == "height")
                {
                    if (_loc_10.relations.heightLocked)
                    {
                    }
                    if (_loc_10.aspectLocked)
                    {
                        _loc_10.docElement.setProperty("width", int(param2 * _loc_10.aspectRatio));
                    }
                }
                if (_loc_10 is FGroup)
                {
                    if (!param3 || !param3.group)
                    {
                        ;
                    }
                }
                if (_loc_8)
                {
                    _loc_10.docElement.setProperty(param1, UtilsStr.getNameFromId(_loc_10.id));
                }
                else if (_loc_7)
                {
                    _loc_10.docElement.setProperty(param1, UtilsStr.formatString(String(param2), _loc_9));
                }
                else
                {
                    _loc_10.docElement.setProperty(param1, param2);
                }
                _loc_9++;
            }
            return;
        }// end function

        private function _-18(param1:Vector.<FObject>) : Boolean
        {
            var _loc_5:* = null;
            var _loc_2:* = param1.length;
            var _loc_3:* = true;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = param1[_loc_4];
                if (!_loc_5.touchDisabled)
                {
                    _loc_3 = false;
                    break;
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

    }
}
