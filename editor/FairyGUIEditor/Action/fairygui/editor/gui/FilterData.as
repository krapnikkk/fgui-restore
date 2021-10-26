package fairygui.editor.gui
{
    import *.*;
    import fairygui.utils.*;

    public class FilterData extends Object
    {
        private var _type:String;
        private var _brightness:Number;
        private var _contrast:Number;
        private var _saturation:Number;
        private var _hue:Number;

        public function FilterData()
        {
            var _loc_1:* = 0;
            this._hue = 0;
            this._saturation = _loc_1;
            this._contrast = _loc_1;
            this._brightness = _loc_1;
            this._type = "none";
            return;
        }// end function

        public function read(param1:XData) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            _loc_2 = param1.getAttribute("filter");
            if (_loc_2)
            {
                this._type = _loc_2;
                _loc_2 = param1.getAttribute("filterData");
                _loc_3 = _loc_2.split(",");
                this._brightness = parseFloat(_loc_3[0]);
                this._contrast = parseFloat(_loc_3[1]);
                this._saturation = parseFloat(_loc_3[2]);
                this._hue = parseFloat(_loc_3[3]);
            }
            else
            {
                this._type = "none";
            }
            return;
        }// end function

        public function write(param1:XData) : void
        {
            if (this._type != "none")
            {
                param1.setAttribute("filter", this._type);
                param1.setAttribute("filterData", this._brightness.toFixed(2) + "," + this._contrast.toFixed(2) + "," + this._saturation.toFixed(2) + "," + this._hue.toFixed(2));
            }
            return;
        }// end function

        public function copyFrom(param1:FilterData) : void
        {
            this._type = param1._type;
            this._brightness = param1._brightness;
            this._contrast = param1._contrast;
            this._saturation = param1._saturation;
            this._hue = param1._hue;
            return;
        }// end function

        public function clone() : FilterData
        {
            var _loc_1:* = new FilterData();
            _loc_1.copyFrom(this);
            return _loc_1;
        }// end function

        public function get type() : String
        {
            return this._type;
        }// end function

        public function set type(param1:String) : void
        {
            this._type = param1;
            return;
        }// end function

        public function get brightness() : Number
        {
            return this._brightness;
        }// end function

        public function set brightness(param1:Number) : void
        {
            this._brightness = param1;
            return;
        }// end function

        public function get contrast() : Number
        {
            return this._contrast;
        }// end function

        public function set contrast(param1:Number) : void
        {
            this._contrast = param1;
            return;
        }// end function

        public function get saturation() : Number
        {
            return this._saturation;
        }// end function

        public function set saturation(param1:Number) : void
        {
            this._saturation = param1;
            return;
        }// end function

        public function get hue() : Number
        {
            return this._hue;
        }// end function

        public function set hue(param1:Number) : void
        {
            this._hue = param1;
            return;
        }// end function

    }
}
