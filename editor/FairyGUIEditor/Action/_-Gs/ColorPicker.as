package _-Gs
{
    import *.*;
    import _-Ds.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.utils.*;
    import flash.display.*;
    import flash.events.*;

    public class ColorPicker extends Object
    {
        private var _panel:GComponent;
        private var _editor:IEditor;
        private var _input:ColorInput;
        private var _-4L:GGraph;
        private var _-Dv:GLabel;
        private var _-Em:NumericInput;
        private var _-Do:GObject;
        private var _-6C:int;
        private var _-3h:Number;
        private var _-EH:int;
        private var _-CA:Boolean;
        private var _-9M:GTextField;

        public function ColorPicker(param1:IEditor)
        {
            this._editor = param1;
            this._panel = UIPackage.createObject("Basic", "ColorPickerPopup").asCom;
            this._-4L = this._panel.getChild("currentColorBox").asGraph;
            this._-Dv = this._panel.getChild("currentColorValue").asLabel;
            this._-Dv.addEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
            this._-9M = this._-Dv.getTextField();
            this._-9M.asTextInput.disableIME = true;
            this._-9M.addEventListener(KeyboardEvent.KEY_DOWN, this._-6W);
            this._-Em = NumericInput(this._panel.getChild("alphaInput"));
            this._-Em.addEventListener(_-Fr._-CF, this._-Cl);
            this._-Em.value = 100;
            this._-Em.max = 100;
            this._-Do = this._panel.getChild("colorTable");
            this._panel.getChild("picker").addClickListener(this._-5H);
            this._panel.getChild("more").addClickListener(this._-Ha);
            this._panel.addClickListener(this.__click);
            this._panel.addEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            this._-6C = 0;
            this._-3h = 1;
            this.update();
            return;
        }// end function

        public function show(param1:ColorInput, param2:GObject, param3:uint, param4:Number, param5:Boolean) : void
        {
            this._input = param1;
            this._editor.groot.showPopup(this._panel, param2);
            this._panel.getController("showAlpha").selectedIndex = param5 ? (1) : (0);
            this._-6C = param3 & 16777215;
            this._-3h = param4;
            this._-Em.value = Math.round(this._-3h * 100);
            this.update();
            return;
        }// end function

        public function get isShowing() : Boolean
        {
            return this._panel.onStage;
        }// end function

        public function hide() : void
        {
            this._editor.groot.hidePopup(this._panel);
            return;
        }// end function

        private function _-Lw(param1:uint) : void
        {
            this._-6C = param1;
            this._editor.groot.hidePopup(this._panel);
            this._-1b();
            return;
        }// end function

        private function _-1b() : void
        {
            this._input.colorValue = this._-6C;
            this._input.alphaValue = this._-3h;
            this._input.dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

        private function update() : void
        {
            this._-4L.drawRect(1, 0, 1, this._-6C, this._-3h);
            this._-Dv.text = ToolSet.convertToHtmlColor(this._-6C).toUpperCase();
            return;
        }// end function

        private function __focusOut(event:Event) : void
        {
            this._-6C = ToolSet.convertFromHtmlColor(this._-Dv.text);
            this.update();
            this._-1b();
            return;
        }// end function

        private function _-Cl(event:Event) : void
        {
            this._-3h = this._-Em.value / 100;
            this.update();
            this._-1b();
            return;
        }// end function

        private function __click(event:Event) : void
        {
            if (!this._-CA)
            {
                return;
            }
            this._-6C = this._-EH;
            this.update();
            this._editor.groot.hidePopup(this._panel);
            this._-1b();
            return;
        }// end function

        private function __mouseMove(event:MouseEvent) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_2:* = this._-Do.displayObject.mouseX;
            var _loc_3:* = this._-Do.displayObject.mouseY;
            var _loc_4:* = this._editor.groot;
            if (_loc_2 > 0 && _loc_2 < this._-Do.width && _loc_3 > 0 && _loc_3 < this._-Do.height && !_loc_4.buttonDown && _loc_4.nativeStage.focus != this._-9M.displayObject)
            {
                this._-CA = true;
                _loc_5 = _loc_2 / 15;
                _loc_6 = _loc_3 / 15;
                this._-EH = Bitmap(GImage(this._-Do).displayObject).bitmapData.getPixel(_loc_5 * 15 + 8, _loc_6 * 15 + 8);
                this._-4L.drawRect(1, 0, 1, this._-EH, this._-3h);
                this._-Dv.text = ToolSet.convertToHtmlColor(this._-EH).toUpperCase();
            }
            else
            {
                if (this._-CA)
                {
                    this.update();
                }
                this._-CA = false;
            }
            return;
        }// end function

        private function _-6W(event:KeyboardEvent) : void
        {
            if (event.keyCode == 13)
            {
                event.stopPropagation();
                this.__focusOut(null);
                this._editor.groot.hidePopup(this._panel);
            }
            else if (event.keyCode == 27)
            {
                event.stopPropagation();
                this._-Dv.text = ToolSet.convertToHtmlColor(this._-6C).toUpperCase();
                this._editor.groot.hidePopup(this._panel);
            }
            return;
        }// end function

        private function _-5H(event:Event) : void
        {
            ColorPickerDialog(this._editor.getDialog(ColorPickerDialog)).screenColorPicker.start(this._panel, this._-Lw);
            return;
        }// end function

        private function _-Ha(event:Event) : void
        {
            event.stopPropagation();
            ColorPickerDialog(this._editor.getDialog(ColorPickerDialog)).open(this._input, this._-6C, this._-3h, this._panel.getController("showAlpha").selectedIndex == 1);
            this._editor.groot.hidePopup(this._panel);
            return;
        }// end function

    }
}
