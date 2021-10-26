package fairygui.editor.gui
{
    import fairygui.utils.*;
    import flash.utils.*;

    public class FTransitionValue extends Object
    {
        public var f1:Number;
        public var f2:Number;
        public var f3:Number;
        public var f4:Number;
        public var iu:uint;
        public var i:int;
        public var s:String;
        public var b1:Boolean;
        public var b2:Boolean;
        public var b3:Boolean;

        public function FTransitionValue()
        {
            this.reset();
            return;
        }// end function

        public function copyFrom(param1:FTransitionValue) : void
        {
            this.f1 = param1.f1;
            this.f2 = param1.f2;
            this.f3 = param1.f3;
            this.f4 = param1.f4;
            this.iu = param1.iu;
            this.i = param1.i;
            this.s = param1.s;
            this.b1 = param1.b1;
            this.b2 = param1.b2;
            this.b3 = param1.b3;
            return;
        }// end function

        public function reset() : void
        {
            var _loc_1:* = 0;
            this.f4 = 0;
            this.f3 = _loc_1;
            this.f2 = _loc_1;
            this.f1 = _loc_1;
            this.iu = 0;
            this.i = 0;
            var _loc_1:* = true;
            this.b2 = true;
            this.b1 = _loc_1;
            this.b3 = false;
            this.s = "";
            return;
        }// end function

        public function equals(param1:FTransitionValue) : Boolean
        {
            return this.f1 == param1.f1 && this.f2 == param1.f2 && this.f3 == param1.f3 && this.f4 == param1.f4 && this.i == param1.i && this.iu == param1.iu && this.s == param1.s && this.b1 == param1.b1 && this.b2 == param1.b2 && this.b3 == param1.b3;
        }// end function

        public function decode(param1:String, param2:String) : void
        {
            var _loc_3:* = null;
            switch(param1)
            {
                case "XY":
                case "Size":
                case "Pivot":
                case "Skew":
                {
                    _loc_3 = param2.split(",");
                    if (_loc_3[0] == "-")
                    {
                        this.b1 = false;
                        this.f1 = 0;
                    }
                    else
                    {
                        this.b1 = true;
                        this.f1 = parseFloat(_loc_3[0]);
                        if (isNaN(this.f1))
                        {
                            this.f1 = 0;
                        }
                    }
                    if (_loc_3.length == 1 || _loc_3[1] == "-")
                    {
                        this.b2 = false;
                        this.f2 = 0;
                    }
                    else
                    {
                        this.b2 = true;
                        this.f2 = parseFloat(_loc_3[1]);
                        if (isNaN(this.f2))
                        {
                            this.f2 = 0;
                        }
                    }
                    if (param1 == "XY")
                    {
                        if (_loc_3.length > 2)
                        {
                            this.f3 = parseFloat(_loc_3[2]);
                            this.f4 = parseFloat(_loc_3[3]);
                            this.b3 = true;
                        }
                        else
                        {
                            this.b3 = false;
                        }
                    }
                    break;
                }
                case "Alpha":
                case "Rotation":
                {
                    this.f1 = parseFloat(param2);
                    if (isNaN(this.f1))
                    {
                        this.f1 = 1;
                    }
                    break;
                }
                case "Scale":
                {
                    _loc_3 = param2.split(",");
                    this.f1 = parseFloat(_loc_3[0]);
                    this.f2 = parseFloat(_loc_3[1]);
                    if (isNaN(this.f1))
                    {
                        this.f1 = 1;
                    }
                    if (isNaN(this.f2))
                    {
                        this.f2 = 1;
                    }
                    break;
                }
                case "Color":
                {
                    this.iu = UtilsStr.convertFromHtmlColor(param2, false);
                    break;
                }
                case "Animation":
                {
                    _loc_3 = param2.split(",");
                    if (_loc_3[0] == "-")
                    {
                        this.b1 = false;
                    }
                    else
                    {
                        this.i = parseInt(_loc_3[0]);
                        this.b1 = true;
                    }
                    this.b2 = _loc_3.length == 1 || _loc_3[1] == "p";
                    break;
                }
                case "Sound":
                {
                    _loc_3 = param2.split(",");
                    this.s = _loc_3[0];
                    if (_loc_3.length > 1)
                    {
                        this.i = parseInt(_loc_3[1]);
                    }
                    else
                    {
                        this.i = 100;
                    }
                    break;
                }
                case "Transition":
                {
                    _loc_3 = param2.split(",");
                    this.s = _loc_3[0];
                    if (_loc_3.length > 1)
                    {
                        this.i = parseInt(_loc_3[1]);
                    }
                    else
                    {
                        this.i = 1;
                    }
                    break;
                }
                case "Shake":
                {
                    _loc_3 = param2.split(",");
                    this.f1 = parseFloat(_loc_3[0]);
                    this.f2 = parseFloat(_loc_3[1]);
                    if (isNaN(this.f2))
                    {
                        this.f2 = 0.3;
                    }
                    break;
                }
                case "Visible":
                {
                    this.b1 = param2 == "true";
                    break;
                }
                case "ColorFilter":
                {
                    _loc_3 = param2.split(",");
                    if (_loc_3.length >= 4)
                    {
                        this.f1 = parseFloat(_loc_3[0]);
                        this.f2 = parseFloat(_loc_3[1]);
                        this.f3 = parseFloat(_loc_3[2]);
                        this.f4 = parseFloat(_loc_3[3]);
                    }
                    break;
                }
                case "Text":
                case "Icon":
                {
                    this.s = param2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function encode(param1:String) : String
        {
            var _loc_2:* = null;
            switch(param1)
            {
                case "XY":
                case "Size":
                case "Pivot":
                {
                    _loc_2 = "";
                    if (this.b1)
                    {
                        _loc_2 = _loc_2 + UtilsStr.toFixed(this.f1);
                    }
                    else
                    {
                        _loc_2 = _loc_2 + "-";
                    }
                    _loc_2 = _loc_2 + ",";
                    if (this.b2)
                    {
                        _loc_2 = _loc_2 + UtilsStr.toFixed(this.f2);
                    }
                    else
                    {
                        _loc_2 = _loc_2 + "-";
                    }
                    if (this.b3)
                    {
                        _loc_2 = _loc_2 + ("," + UtilsStr.toFixed(this.f3, 3) + "," + UtilsStr.toFixed(this.f4, 3));
                    }
                    return _loc_2;
                }
                case "Alpha":
                {
                    return "" + UtilsStr.toFixed(this.f1);
                }
                case "Rotation":
                {
                    return "" + UtilsStr.toFixed(this.f1);
                }
                case "Scale":
                case "Skew":
                {
                    return "" + UtilsStr.toFixed(this.f1) + "," + UtilsStr.toFixed(this.f2);
                }
                case "Color":
                {
                    return UtilsStr.convertToHtmlColor(this.iu, false);
                }
                case "Animation":
                {
                    _loc_2 = "";
                    if (this.b1)
                    {
                        _loc_2 = _loc_2 + this.i;
                    }
                    else
                    {
                        _loc_2 = _loc_2 + "-";
                    }
                    _loc_2 = _loc_2 + ("," + (this.b2 ? ("p") : ("s")));
                    return _loc_2;
                }
                case "Sound":
                {
                    if (this.i != 0)
                    {
                        return this.s + "," + this.i;
                    }
                    return this.s;
                }
                case "Transition":
                {
                    if (this.i != 1)
                    {
                        return this.s + "," + this.i;
                    }
                    return this.s;
                }
                case "Shake":
                {
                    return "" + UtilsStr.toFixed(this.f1) + "," + UtilsStr.toFixed(this.f2);
                }
                case "Visible":
                {
                    return "" + this.b1;
                }
                case "ColorFilter":
                {
                    return this.f1.toFixed(2) + "," + this.f2.toFixed(2) + "," + this.f3.toFixed(2) + "," + this.f4.toFixed(2);
                }
                case "Text":
                case "Icon":
                {
                    return this.s;
                }
                default:
                {
                    return null;
                    break;
                }
            }
        }// end function

        public function encodeBinary(param1:String, param2:ByteArray, param3:Function) : void
        {
            switch(param1)
            {
                case "XY":
                {
                    param2.writeBoolean(this.b1);
                    param2.writeBoolean(this.b2);
                    if (this.b3)
                    {
                        param2.writeFloat(this.f3);
                        param2.writeFloat(this.f4);
                    }
                    else
                    {
                        param2.writeFloat(this.f1);
                        param2.writeFloat(this.f2);
                    }
                    param2.writeBoolean(this.b3);
                    break;
                }
                case "Size":
                case "Pivot":
                case "Skew":
                {
                    param2.writeBoolean(this.b1);
                    param2.writeBoolean(this.b2);
                    param2.writeFloat(this.f1);
                    param2.writeFloat(this.f2);
                    break;
                }
                case "Alpha":
                case "Rotation":
                {
                    param2.writeFloat(this.f1);
                    break;
                }
                case "Scale":
                {
                    param2.writeFloat(this.f1);
                    param2.writeFloat(this.f2);
                    break;
                }
                case "Color":
                {
                    param2.writeByte(this.iu >> 16 & 255);
                    param2.writeByte(this.iu >> 8 & 255);
                    param2.writeByte(this.iu & 255);
                    param2.writeByte(255);
                    break;
                }
                case "Animation":
                {
                    param2.writeBoolean(this.b2);
                    param2.writeInt(this.b1 ? (this.i) : (-1));
                    break;
                }
                case "Sound":
                {
                    this.param3(param2, this.s, false, false);
                    param2.writeFloat(this.i / 100);
                    break;
                }
                case "Transition":
                {
                    this.param3(param2, this.s, false, false);
                    param2.writeInt(this.i);
                    break;
                }
                case "Shake":
                {
                    param2.writeFloat(this.f1);
                    param2.writeFloat(this.f2);
                    break;
                }
                case "Visible":
                {
                    param2.writeBoolean(this.b1);
                    break;
                }
                case "ColorFilter":
                {
                    param2.writeFloat(this.f1);
                    param2.writeFloat(this.f2);
                    param2.writeFloat(this.f3);
                    param2.writeFloat(this.f4);
                    break;
                }
                case "Text":
                {
                    this.param3(param2, this.s, true);
                    break;
                }
                case "Icon":
                {
                    this.param3(param2, this.s);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
