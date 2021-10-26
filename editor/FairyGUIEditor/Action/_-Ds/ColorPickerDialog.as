package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.geom.*;

    public class ColorPickerDialog extends _-3g
    {
        private var _input:ColorInput;
        private var _-1a:GComponent;
        private var _-E3:GGraph;
        private var _-9G:GObject;
        private var _-4L:GGraph;
        private var _-KA:GGraph;
        private var _-3E:NumericInput;
        private var _-E8:NumericInput;
        private var _-Mh:NumericInput;
        private var _-DY:NumericInput;
        private var _-NP:NumericInput;
        private var _-J4:NumericInput;
        private var _-Em:GLabel;
        private var _-Kp:GLabel;
        private var _-53:GSlider;
        private var _-19:Object;
        private var _-8g:Object;
        private var _alpha:Number;
        private var _-GZ:_-6g;

        public function ColorPickerDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Basic", "ColorPickerDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._-19 = {};
            this._-8g = {};
            this._alpha = 1;
            this._-GZ = new _-6g(param1);
            this._-1a = contentPane.getChild("sbBox").asCom;
            this._-1a.addEventListener(GTouchEvent.BEGIN, this._-OM);
            this._-E3 = this._-1a.getChild("sbArea").asGraph;
            this._-9G = this._-1a.getChild("sbValue");
            this._-9G.draggable = true;
            this._-9G.addEventListener(DragEvent.DRAG_MOVING, this._-6U);
            this._-4L = contentPane.getChild("currentColorBox").asGraph;
            this._-KA = contentPane.getChild("oldColorBox").asGraph;
            this._-53 = contentPane.getChild("hueSlider").asSlider;
            this._-53.changeOnClick = true;
            this._-53.addEventListener(StateChangeEvent.CHANGED, this._-83);
            this._-3E = NumericInput(contentPane.getChild("hsb_h"));
            this._-E8 = NumericInput(contentPane.getChild("hsb_s"));
            this._-Mh = NumericInput(contentPane.getChild("hsb_b"));
            this._-DY = NumericInput(contentPane.getChild("rgb_r"));
            this._-NP = NumericInput(contentPane.getChild("rgb_g"));
            this._-J4 = NumericInput(contentPane.getChild("rgb_b"));
            this._-Em = contentPane.getChild("alphaValue").asLabel;
            this._-Em.getTextField().asTextInput.disableIME = true;
            this._-Kp = contentPane.getChild("colorValue").asLabel;
            this._-Kp.getTextField().asTextInput.disableIME = true;
            this._-3E.min = 0;
            this._-3E.max = 360;
            this._-E8.min = 0;
            this._-E8.max = 100;
            this._-Mh.min = 0;
            this._-Mh.max = 100;
            this._-DY.min = 0;
            this._-DY.max = 255;
            this._-NP.min = 0;
            this._-NP.max = 255;
            this._-J4.min = 0;
            this._-J4.max = 255;
            this._-3E.addEventListener(_-Fr._-CF, this._-KO);
            this._-E8.addEventListener(_-Fr._-CF, this._-KO);
            this._-Mh.addEventListener(_-Fr._-CF, this._-KO);
            this._-DY.addEventListener(_-Fr._-CF, this._-Hd);
            this._-NP.addEventListener(_-Fr._-CF, this._-Hd);
            this._-J4.addEventListener(_-Fr._-CF, this._-Hd);
            this._-Em.getTextField().addEventListener(Event.CHANGE, this._-Ie);
            this._-Kp.getTextField().addEventListener(Event.CHANGE, this._-GX);
            contentPane.getChild("ok").addClickListener(_-IJ);
            contentPane.getChild("apply").addClickListener(this._-2p);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        public function open(param1:ColorInput, param2:uint, param3:Number, param4:Boolean) : void
        {
            this.show();
            this._input = param1;
            contentPane.getController("showAlpha").selectedIndex = param4 ? (1) : (0);
            this._-19.r = (param2 & 16711680) >> 16;
            this._-19.g = (param2 & 65280) >> 8;
            this._-19.b = param2 & 255;
            this._alpha = param3 * 255;
            this._-KA.drawRect(1, 0, 0, param2, param3);
            this._-Df();
            this._-5d();
            this._-GZ.start(this, this._-Lw);
            return;
        }// end function

        public function get screenColorPicker() : _-6g
        {
            return this._-GZ;
        }// end function

        private function _-Df() : void
        {
            this._-8g = UtilsColor.RGBtoHSB(this._-19.r, this._-19.g, this._-19.b);
            return;
        }// end function

        private function _-K0() : void
        {
            this._-19 = UtilsColor.HSBtoRGB(this._-8g.h, this._-8g.s, this._-8g.b);
            return;
        }// end function

        private function _-2p(event:Event) : void
        {
            this._input.colorValue = parseInt(this._-Kp.text, 16);
            this._input.alphaValue = parseInt(this._-Em.text, 16) / 255;
            this._input.dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

        override public function _-2a() : void
        {
            this._-2p(null);
            this.hide();
            return;
        }// end function

        private function _-5d(param1:int = 0) : void
        {
            var _loc_2:* = Math.round(this._-19.r);
            var _loc_3:* = Math.round(this._-19.g);
            var _loc_4:* = Math.round(this._-19.b);
            var _loc_5:* = (_loc_2 << 16) + (_loc_3 << 8) + _loc_4;
            this._-E3.color = this._-O6(this._-8g.h);
            this._-4L.drawRect(1, 0, 0, _loc_5, this._alpha / 255);
            if (param1 != 1)
            {
                this._-9G.setXY(this._-8g.s / 100 * this._-1a.width, (1 - this._-8g.b / 100) * this._-1a.height);
            }
            if (param1 != 2)
            {
                this._-53.value = 360 - this._-8g.h;
            }
            if (param1 != 3)
            {
                this._-3E.value = Math.round(this._-8g.h);
                this._-E8.value = Math.round(this._-8g.s);
                this._-Mh.value = Math.round(this._-8g.b);
            }
            if (param1 != 4)
            {
                this._-DY.value = _loc_2;
                this._-NP.value = _loc_3;
                this._-J4.value = _loc_4;
            }
            var _loc_6:* = UtilsStr.convertToHtmlColor((this._alpha << 24) + _loc_5, true);
            if (param1 != 5)
            {
                this._-Em.text = _loc_6.substr(1, 2).toUpperCase();
            }
            if (param1 != 6)
            {
                this._-Kp.text = _loc_6.substr(3).toUpperCase();
            }
            return;
        }// end function

        private function _-OM(event:GTouchEvent) : void
        {
            var _loc_2:* = this._-E3.parent.globalToLocal(event.stageX, event.stageY);
            this._-9G.setXY(_loc_2.x, _loc_2.y);
            this._-9G.dragBounds = this._-E3.parent.localToGlobalRect(0, 0, this._-1a.width + 12, this._-1a.height + 12);
            this._-9G.startDrag();
            this._-6U(null);
            return;
        }// end function

        private function _-6U(event:Event) : void
        {
            this._-8g.s = this._-9G.x / this._-1a.width * 100;
            this._-8g.b = (1 - this._-9G.y / this._-1a.height) * 100;
            this._-K0();
            this._-5d(1);
            return;
        }// end function

        private function _-83(event:Event) : void
        {
            this._-8g.h = 360 - this._-53.value;
            this._-K0();
            this._-5d(2);
            return;
        }// end function

        private function _-KO(event:Event) : void
        {
            var _loc_2:* = NumericInput(event.currentTarget);
            var _loc_3:* = _loc_2.name.charAt(4);
            this._-8g[_loc_3] = _loc_2.value;
            this._-K0();
            this._-5d(3);
            return;
        }// end function

        private function _-Hd(event:Event) : void
        {
            var _loc_2:* = NumericInput(event.currentTarget);
            var _loc_3:* = _loc_2.name.charAt(4);
            this._-19[_loc_3] = _loc_2.value;
            this._-Df();
            this._-5d(4);
            return;
        }// end function

        private function _-Ie(event:Event) : void
        {
            this._alpha = parseInt(this._-Em.text, 16);
            this._-5d(5);
            return;
        }// end function

        private function _-GX(event:Event) : void
        {
            var _loc_2:* = UtilsStr.convertFromHtmlColor("#" + this._-Kp.text);
            this._-19.r = (_loc_2 & 16711680) >> 16;
            this._-19.g = (_loc_2 & 65280) >> 8;
            this._-19.b = _loc_2 & 255;
            this._-Df();
            this._-5d(6);
            return;
        }// end function

        private function _-O6(param1:Number) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            if (param1 < 60)
            {
                _loc_3 = Math.round(param1 / 60 * 255);
                _loc_2 = 16711680 + (_loc_3 << 8);
            }
            else if (param1 >= 60 && param1 < 120)
            {
                _loc_3 = Math.round(255 - (param1 - 60) / 60 * 255);
                _loc_2 = (_loc_3 << 16) + 65280;
            }
            else if (param1 >= 120 && param1 < 180)
            {
                _loc_3 = Math.round((param1 - 120) / 60 * 255);
                _loc_2 = 65280 + _loc_3;
            }
            else if (param1 >= 180 && param1 < 240)
            {
                _loc_3 = Math.round(255 - (param1 - 180) / 60 * 255);
                _loc_2 = (_loc_3 << 8) + 255;
            }
            else if (param1 >= 240 && param1 < 300)
            {
                _loc_3 = Math.round((param1 - 240) / 60 * 255);
                _loc_2 = (_loc_3 << 16) + 255;
            }
            else
            {
                _loc_3 = Math.round(255 - (param1 - 300) / 60 * 255);
                _loc_2 = 16711680 + Math.round(_loc_3);
            }
            return _loc_2;
        }// end function

        private function _-Lw(param1:uint) : void
        {
            this._-19.r = (param1 & 16711680) >> 16;
            this._-19.g = (param1 & 65280) >> 8;
            this._-19.b = param1 & 255;
            this._-Df();
            this._-5d(0);
            return;
        }// end function

    }
}
