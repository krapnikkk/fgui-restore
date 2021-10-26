package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.event.*;
    import flash.events.*;
    import flash.text.*;

    public class _-8s extends GButton
    {
        public var textInput:GLabel;
        public var btnBold:GButton;
        public var btnItalic:GButton;
        public var btnUnderline:GButton;
        public var _-Z:FontSizeInput;
        public var _-KX:ColorInput;
        public var _-A7:GLabel;
        public var _-Co:GLabel;

        public function _-8s()
        {
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            var _loc_4:* = null;
            super.constructFromXML(param1);
            this.textInput = getChild("text") as GLabel;
            if (this.textInput)
            {
                this._-Z = FontSizeInput(getChild("fontSize"));
                this._-KX = ColorInput(getChild("color"));
                this.btnBold = getChild("btnBold").asButton;
                this.btnItalic = getChild("btnItalic").asButton;
                this.btnUnderline = getChild("btnUnderline").asButton;
            }
            else
            {
                this._-Co = getChild("image").asLabel;
            }
            this._-A7 = getChild("link").asLabel;
            var _loc_2:* = this.numChildren;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = getChildAt(_loc_3);
                _loc_4.addEventListener(StateChangeEvent.CHANGED, this._-Kn);
                _loc_4.addEventListener(_-Fr._-CF, this._-Kn);
                _loc_3++;
            }
            return;
        }// end function

        private function _-Kn(event:Event) : void
        {
            parent.dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

        public function _-LN(param1:TextFormat, param2:String) : void
        {
            this.textInput.text = param2;
            this._-Z.value = int(param1.size);
            this._-KX.colorValue = uint(param1.color);
            this.btnBold.selected = param1.bold;
            this.btnItalic.selected = param1.italic;
            this.btnUnderline.selected = param1.underline;
            this._-A7.text = param1.url;
            return;
        }// end function

        public function _-2R(param1:TextFormat, param2:String) : void
        {
            this._-Co.text = param2;
            this._-A7.text = param1.url;
            return;
        }// end function

    }
}
