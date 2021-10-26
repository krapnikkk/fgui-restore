package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;

    public class _-7r extends Object
    {
        private var _owner:GComponent;
        private var _-5r:Object;
        private var _-Gf:Boolean;
        private var _-BZ:Function;
        private var _version:int;
        private static const TEXT:int = 0;
        private static const _-A5:int = 1;
        private static const _-5K:int = 2;
        private static const _-NX:int = 3;
        private static const _-HE:int = 4;
        private static const _-58:int = 5;
        private static const _-Ic:int = 6;
        private static const _-EX:int = 7;
        private static const _-Gz:int = 8;
        private static const FONT:int = 9;
        private static const FONT_SIZE:int = 10;
        private static const _-Fv:int = 11;
        private static const _-Cr:int = 0;
        private static const _-4s:int = 1;
        private static const _-CG:int = 2;
        private static const _-9i:int = 3;
        private static const _-EL:int = 4;
        private static const _-8n:int = 5;
        private static const _-8u:int = 6;
        private static const _-7D:Object = {int:0, uint:1, float:2, bool:3, string:4, array:5, object:6};
        private static const _-9S:Object = {name:1, prop:1, type:1, min:1, max:1, step:1, precision:1, reversed:1, items:1, values:1, showAlpha:1, filter:1, readonly:1, extData:1, disableIME:1, pages:1, prompt:1, includeChildren:1, trim:1, dummy:1};

        public function _-7r(param1:GComponent)
        {
            this._owner = param1;
            this._-5r = new Dictionary();
            return;
        }// end function

        public function get owner() : GComponent
        {
            return this._owner;
        }// end function

        public function get onPropChanged() : Function
        {
            return this._-BZ;
        }// end function

        public function set onPropChanged(param1:Function) : void
        {
            this._-BZ = param1;
            return;
        }// end function

        public function _-G(param1:Array) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_2:* = param1.length;
            if (Capabilities.isDebugger)
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = param1[_loc_3];
                    for (_loc_5 in _loc_4)
                    {
                        
                        if (!_-9S[_loc_5])
                        {
                            throw new Error(_loc_5 + " is invalid");
                        }
                    }
                    _loc_3++;
                }
            }
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                this._-9Y(param1[_loc_3]);
                _loc_3++;
            }
            return;
        }// end function

        private function _-9Y(param1:Object) : void
        {
            var _loc_2:* = param1.name;
            var _loc_3:* = param1.prop;
            var _loc_4:* = param1.type;
            if (_loc_3 == null)
            {
                _loc_3 = _loc_2;
            }
            var _loc_5:* = this._owner.getChild(_loc_2);
            if (this._owner.getChild(_loc_2) == null)
            {
                throw new Error("control or controller \"" + _loc_2 + "\" not exists");
            }
            var _loc_6:* = {};
            _loc_6.input = _loc_5;
            _loc_6.propName = _loc_3;
            _loc_6.propType = _-7D[_loc_4];
            _loc_6.dummy = param1.dummy;
            _loc_6.extData = param1.extData;
            if (_loc_6.propType == _-9i)
            {
                _loc_6.reversed = param1.reversed;
            }
            var _loc_7:* = false;
            if (_loc_5 is NumericInput)
            {
                _loc_6.inputType = _-A5;
                if (param1.min != undefined)
                {
                    NumericInput(_loc_5).min = param1.min;
                }
                else
                {
                    NumericInput(_loc_5).min = int.MIN_VALUE;
                }
                if (param1.max != undefined)
                {
                    NumericInput(_loc_5).max = param1.max;
                }
                if (param1.step != undefined)
                {
                    NumericInput(_loc_5).step = param1.step;
                }
                if (param1.precision != undefined)
                {
                    NumericInput(_loc_5).fractionDigits = param1.precision;
                    if (param1.step == undefined)
                    {
                        NumericInput(_loc_5).step = 1 / Math.pow(10, param1.precision);
                    }
                }
                if (_loc_6.propType != _-Cr && _loc_6.propType != _-4s && _loc_6.propType != _-CG)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is GComboBox)
            {
                _loc_6.inputType = _-5K;
                if (param1.items != undefined)
                {
                    GComboBox(_loc_5).items = param1.items;
                }
                if (param1.values != undefined)
                {
                    GComboBox(_loc_5).values = param1.values;
                }
                if (_loc_6.propType != _-Cr && _loc_6.propType != _-9i && _loc_6.propType != _-EL)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is ColorInput)
            {
                _loc_6.inputType = _-NX;
                if (param1.showAlpha != undefined)
                {
                    ColorInput(_loc_5).showAlpha = param1.showAlpha;
                }
                if (_loc_6.propType != _-Cr && _loc_6.propType != _-4s)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is ChildObjectInput)
            {
                _loc_6.inputType = _-58;
                if (param1.filter != undefined)
                {
                    ChildObjectInput(_loc_5).typeFilter = param1.filter;
                }
                if (_loc_6.propType != _-8u)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is ControllerInput)
            {
                _loc_6.inputType = _-Ic;
                _loc_6.pages = param1.pages;
                if (param1.includeChildren)
                {
                    ControllerInput(_loc_5).includeChildren = true;
                }
                if (param1.prompt != undefined)
                {
                    ControllerInput(_loc_5).prompt = param1.prompt;
                }
                if (_loc_6.propType != _-EL)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is ControllerPageInput)
            {
                _loc_6.inputType = _-EX;
                if (param1.prompt != undefined)
                {
                    ControllerPageInput(_loc_5).prompt = param1.prompt;
                }
                if (_loc_6.propType != _-EL)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is ControllerMultiPageInput)
            {
                _loc_6.inputType = _-Gz;
                if (param1.prompt != undefined)
                {
                    ControllerMultiPageInput(_loc_5).prompt = param1.prompt;
                }
                if (_loc_6.propType != _-8n)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is TransitionInput)
            {
                _loc_6.inputType = _-Fv;
                if (param1.prompt != undefined)
                {
                    TransitionInput(_loc_5).prompt = param1.prompt;
                }
                if (_loc_6.propType != _-EL)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is FontInput)
            {
                _loc_6.inputType = FONT;
                if (_loc_6.propType != _-EL)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is FontSizeInput)
            {
                _loc_6.inputType = FONT_SIZE;
                if (_loc_6.propType != _-Cr && _loc_6.propType != _-4s)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is ResourceInput)
            {
                _loc_6.inputType = TEXT;
                if (_loc_6.propType != _-EL)
                {
                    _loc_7 = true;
                }
            }
            else if (_loc_5 is GButton)
            {
                _loc_6.inputType = _-HE;
                if (GButton(_loc_5).mode != ButtonMode.Check)
                {
                    _loc_6.relatedController = GButton(_loc_5).relatedController;
                }
                if (_loc_6.propType != _-9i && _loc_6.propType != _-EL && _loc_6.propType != _-Cr)
                {
                    _loc_7 = true;
                }
            }
            else
            {
                if (_loc_5 is TextArea)
                {
                    TextArea(_loc_5).inInspector = true;
                }
                _loc_6.inputType = TEXT;
                if (param1.disableIME)
                {
                    GLabel(_loc_5).getTextField().asTextInput.disableIME = true;
                }
                _loc_6.trim = param1.trim;
                if (_loc_6.propType != _-EL && !_loc_6.dummy)
                {
                    _loc_7 = true;
                }
            }
            if (_loc_7)
            {
                throw new Error("Invalid prop: " + _loc_3 + "," + _loc_4);
            }
            if (param1.readonly && _loc_5 is GLabel)
            {
                GLabel(_loc_5).editable = false;
            }
            if (_loc_6.relatedController)
            {
                _loc_6.relatedController.addEventListener(StateChangeEvent.CHANGED, this._-Kn);
            }
            else
            {
                _loc_5.addEventListener(StateChangeEvent.CHANGED, this._-Kn);
            }
            _loc_5.addEventListener(_-Fr._-CF, this._-Kn);
            this._-5r[_loc_2] = _loc_6;
            return;
        }// end function

        public function _-Om(param1:String) : GObject
        {
            var _loc_2:* = this._-5r[param1];
            return GObject(_loc_2.input);
        }// end function

        public function _-Cm(param1:Object, param2:Array = null) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (param2 == null)
            {
                for each (_loc_3 in this._-5r)
                {
                    
                    if (_loc_3.dummy)
                    {
                        continue;
                    }
                    this._-CV(_loc_3, param1[_loc_3.propName]);
                }
            }
            else
            {
                for each (_loc_4 in param2)
                {
                    
                    _loc_3 = this._-5r[_loc_4];
                    if (_loc_3.dummy)
                    {
                        continue;
                    }
                    this._-CV(_loc_3, param1[_loc_3.propName]);
                }
            }
            return;
        }// end function

        public function setValue(param1:String, param2) : void
        {
            var _loc_3:* = this._-5r[param1];
            this._-CV(_loc_3, param2);
            return;
        }// end function

        public function _-4y(param1:String)
        {
            var _loc_2:* = this._-5r[param1];
            return _loc_2.value;
        }// end function

        private function _-CV(param1:Object, param2) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (param1.propType == _-9i && param1.reversed)
            {
                param2 = !param2;
            }
            if (param1.inputType == _-Ic && param1.pages)
            {
                _loc_3 = this._-5r[param1.pages];
                if (param2)
                {
                    _loc_4 = FairyGUIEditor._-Eb(this._owner).docView.activeDocument.content.getController(String(param2));
                }
                else
                {
                    _loc_4 = null;
                }
                if (_loc_3.inputType == _-EX)
                {
                    ControllerPageInput(_loc_3.input).controller = _loc_4;
                }
                else
                {
                    ControllerMultiPageInput(_loc_3.input).controller = _loc_4;
                }
            }
            param1.value = param2;
            param1.version = this._version + 1;
            return;
        }// end function

        public function updateUI() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = this;
            var _loc_3:* = this._version + 1;
            _loc_2._version = _loc_3;
            this._-Gf = true;
            for each (_loc_1 in this._-5r)
            {
                
                if (_loc_1.version == this._version)
                {
                    this._-9F(_loc_1);
                }
            }
            this._-Gf = false;
            return;
        }// end function

        private function _-BG(param1:Object)
        {
            var _loc_2:* = param1.input;
            var _loc_3:* = param1.propType;
            switch(param1.inputType)
            {
                case TEXT:
                {
                    return _loc_2.text;
                }
                case _-A5:
                {
                    if (_loc_3 == _-Cr)
                    {
                        return int(NumericInput(_loc_2).value);
                    }
                    if (_loc_3 == _-4s)
                    {
                        return uint(NumericInput(_loc_2).value);
                    }
                    if (_loc_3 == _-CG)
                    {
                        return NumericInput(_loc_2).value;
                    }
                    break;
                }
                case _-NX:
                {
                    if (_loc_3 == _-Cr)
                    {
                        return int(ColorInput(_loc_2).argb);
                    }
                    if (_loc_3 == _-4s)
                    {
                        return uint(ColorInput(_loc_2).argb);
                    }
                    break;
                }
                case _-5K:
                {
                    if (_loc_3 == _-Cr)
                    {
                        return GComboBox(_loc_2).selectedIndex;
                    }
                    if (_loc_3 == _-EL)
                    {
                        return GComboBox(_loc_2).value;
                    }
                    if (_loc_3 == _-9i)
                    {
                        return GComboBox(_loc_2).selectedIndex == 0 ? (false) : (true);
                    }
                    break;
                }
                case _-HE:
                {
                    if (param1.relatedController)
                    {
                        if (_loc_3 == _-9i)
                        {
                            return Controller(param1.relatedController).selectedIndex == 1 ? (true) : (false);
                        }
                        else
                        {
                            if (_loc_3 == _-Cr)
                            {
                                return Controller(param1.relatedController).selectedIndex;
                            }
                            if (_loc_3 == _-EL)
                            {
                                return Controller(param1.relatedController).selectedPage;
                            }
                        }
                    }
                    else
                    {
                        if (_loc_3 == _-9i)
                        {
                            return GButton(_loc_2).selected;
                        }
                        return GButton(_loc_2).text;
                    }
                    break;
                }
                case _-58:
                {
                    return ChildObjectInput(_loc_2).value;
                }
                case _-Ic:
                {
                    return ControllerInput(_loc_2).value;
                }
                case _-EX:
                {
                    return ControllerPageInput(_loc_2).value;
                }
                case _-Gz:
                {
                    return ControllerMultiPageInput(_loc_2).value;
                }
                case _-Fv:
                {
                    return TransitionInput(_loc_2).value;
                }
                case FONT:
                {
                    return FontInput(_loc_2).text;
                }
                case FONT_SIZE:
                {
                    return FontSizeInput(_loc_2).value;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function _-9F(param1:Object) : void
        {
            var _loc_2:* = param1.input;
            var _loc_3:* = param1.propType;
            var _loc_4:* = param1.value;
            switch(param1.inputType)
            {
                case TEXT:
                {
                    _loc_2.text = _loc_4 != null ? (_loc_4.toString()) : (null);
                    break;
                }
                case _-A5:
                {
                    NumericInput(_loc_2).value = _loc_4 != null ? (Number(_loc_4)) : (0);
                    break;
                }
                case _-NX:
                {
                    ColorInput(_loc_2).argb = _loc_4 != null ? (uint(_loc_4)) : (0);
                    break;
                }
                case _-5K:
                {
                    if (_loc_3 == _-Cr)
                    {
                        GComboBox(_loc_2).selectedIndex = _loc_4 != null ? (int(_loc_4)) : (0);
                    }
                    else if (_loc_3 == _-EL)
                    {
                        GComboBox(_loc_2).value = _loc_4;
                    }
                    else if (_loc_3 == _-9i)
                    {
                        GComboBox(_loc_2).selectedIndex = _loc_4 ? (1) : (0);
                    }
                    break;
                }
                case _-HE:
                {
                    if (param1.relatedController)
                    {
                        if (_loc_3 == _-9i)
                        {
                            Controller(param1.relatedController).selectedIndex = _loc_4 ? (1) : (0);
                        }
                        else if (_loc_3 == _-Cr)
                        {
                            Controller(param1.relatedController).selectedIndex = _loc_4;
                        }
                        else
                        {
                            Controller(param1.relatedController).selectedPage = _loc_4;
                        }
                    }
                    else if (_loc_3 == _-9i)
                    {
                        GButton(_loc_2).selected = _loc_4;
                    }
                    else
                    {
                        _loc_2.text = _loc_4;
                    }
                    break;
                }
                case _-58:
                {
                    ChildObjectInput(_loc_2).value = FObject(_loc_4);
                    break;
                }
                case _-Ic:
                {
                    ControllerInput(_loc_2).value = _loc_4 != null ? (String(_loc_4)) : (null);
                    break;
                }
                case _-EX:
                {
                    ControllerPageInput(_loc_2).value = _loc_4 != null ? (String(_loc_4)) : (null);
                    break;
                }
                case _-Gz:
                {
                    ControllerMultiPageInput(_loc_2).value = _loc_4 as Array;
                    break;
                }
                case _-Fv:
                {
                    TransitionInput(_loc_2).value = _loc_4 != null ? (String(_loc_4)) : (null);
                    break;
                }
                case FONT:
                {
                    FontInput(_loc_2).text = _loc_4 != null ? (String(_loc_4)) : (null);
                    break;
                }
                case FONT_SIZE:
                {
                    FontSizeInput(_loc_2).value = int(_loc_4);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function _-Kn(event:Event) : void
        {
            if (this._-Gf)
            {
                return;
            }
            var _loc_2:* = this._-5r[event.currentTarget.name];
            var _loc_3:* = this._-BG(_loc_2);
            if (_loc_2.propType == _-9i && _loc_2.reversed)
            {
                _loc_3 = !_loc_3;
            }
            if (_loc_2.propType == _-EL && _loc_2.trim)
            {
                _loc_3 = UtilsStr.trim(String(_loc_3));
            }
            var _loc_4:* = _loc_2.value;
            _loc_2.value = _loc_3;
            this._-Gf = true;
            if (this._-BZ != null)
            {
                if (this._-BZ(_loc_2.propName, _loc_3, _loc_2.extData) == false)
                {
                    _loc_2.value = _loc_4;
                    this._-9F(_loc_2);
                }
            }
            this._-Gf = false;
            return;
        }// end function

    }
}
