package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.tween.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class FrameValuePropsPanel extends _-5I
    {
        private var _-Jn:Controller;
        private var _-Di:Controller;
        private var _-FG:FTransitionItem;
        private var _-1U:GPathPoint;
        private var _-3b:int;
        private var _-8y:int;

        public function FrameValuePropsPanel(param1:IEditor)
        {
            var editor:* = param1;
            _editor = editor;
            _panel = UIPackage.createObject("Builder", "FrameValuePropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"xEnabled", type:"bool", extData:"b1"}, {name:"yEnabled", type:"bool", extData:"b2"}, {name:"x", type:"int", extData:"f1"}, {name:"y", type:"int", extData:"f2"}, {name:"px", type:"int", dummy:true}, {name:"py", type:"int", dummy:true}, {name:"widthEnabled", type:"bool", extData:"b1"}, {name:"heightEnabled", type:"bool", extData:"b2"}, {name:"width", type:"int", min:0, extData:"f1"}, {name:"height", type:"int", min:0, extData:"f2"}, {name:"pivotX", type:"float", precision:2, extData:"f1"}, {name:"pivotY", type:"float", precision:2, extData:"f2"}, {name:"alpha", type:"float", min:0, max:1, precision:2, extData:"f1"}, {name:"rotation", type:"float", precision:2, step:0.1, extData:"f1"}, {name:"scaleX", type:"float", precision:2, extData:"f1"}, {name:"scaleY", type:"float", precision:2, extData:"f2"}, {name:"skewX", type:"float", precision:2, step:0.1, min:-360, max:360, extData:"f1"}, {name:"skewY", type:"float", precision:2, step:0.1, min:-360, max:360, extData:"f2"}, {name:"color", type:"uint", extData:"iu"}, {name:"frameEnabled", type:"bool", extData:"b1"}, {name:"playing", type:"bool", extData:"b2"}, {name:"frame", type:"int", min:0, extData:"i"}, {name:"sound", type:"string", extData:"s"}, {name:"volume", type:"int", min:0, max:100, extData:"i"}, {name:"transName", type:"string", extData:"s"}, {name:"transTimes", type:"int", min:-1, extData:"i"}, {name:"shakeAmplitude", type:"float", extData:"f1"}, {name:"shakePeriod", type:"float", precision:2, extData:"f2"}, {name:"visible", type:"bool", extData:"b1"}, {name:"filter_cb", type:"float", min:-1, max:1, precision:2, extData:"f1"}, {name:"filter_cc", type:"float", min:-1, max:1, precision:2, extData:"f2"}, {name:"filter_cs", type:"float", min:-1, max:1, precision:2, extData:"f3"}, {name:"filter_ch", type:"float", min:-1, max:1, precision:2, extData:"f4"}, {name:"textValue", type:"string", extData:"s"}, {name:"iconValue", type:"string", extData:"s"}, {name:"usePath", type:"bool"}, {name:"positionInPercent", type:"bool", extData:"b3"}, {name:"pointX", type:"float"}, {name:"pointY", type:"float"}]);
            this._-Jn = _panel.getController("transType");
            this._-Di = _panel.getController("pathEditing");
            _panel.getChild("selectPivot").addClickListener(function (event:Event) : void
            {
                SelectPivotMenu._-30(_editor).show(_form._-Om("pivotX"), _form._-Om("pivotY"), GObject(event.currentTarget));
                return;
            }// end function
            );
            _panel.getChild("pathEdit").addClickListener(this._-Ez);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            this._-FG = _editor.timelineView.getSelection();
            if (this._-FG == null)
            {
                return false;
            }
            _loc_1 = this._-FG.target;
            this._-Jn.selectedPage = this._-FG.type;
            _form.setValue("usePath", this._-FG.usePath);
            _form._-Om("usePath").visible = this._-FG.tween;
            switch(this._-FG.type)
            {
                case "XY":
                {
                    _form.setValue("xEnabled", this._-FG.value.b1);
                    _form.setValue("yEnabled", this._-FG.value.b2);
                    _form.setValue("x", int(this._-FG.value.f1));
                    _form.setValue("y", int(this._-FG.value.f2));
                    _form.setValue("px", "(" + UtilsStr.toFixed(this._-FG.value.f3 * 100, 1) + "%)");
                    _form.setValue("py", "(" + UtilsStr.toFixed(this._-FG.value.f4 * 100, 1) + "%)");
                    _form._-Om("x").enabled = this._-FG.value.b1;
                    _form._-Om("y").enabled = this._-FG.value.b2;
                    _form.setValue("positionInPercent", this._-FG.value.b3);
                    _loc_2 = _loc_1.docElement.gizmo;
                    if (_loc_2.keyFrame && _loc_2.activeHandleIndex != -1 && (_loc_2.activeHandleType == 2 || _loc_2.activeHandleType == 3))
                    {
                        this._-3b = _loc_2.activeHandleIndex;
                        if (_loc_2.activeHandleType == 3)
                        {
                            _loc_3 = this._-3b % 2;
                            this._-3b = this._-3b / 2;
                            this._-8y = _loc_3 + 1;
                            this._-1U = _loc_2.keyFrame.pathPoints[this._-3b];
                            if (_loc_3 == 0)
                            {
                                _form.setValue("pointX", this._-1U.control1_x);
                                _form.setValue("pointY", this._-1U.control1_y);
                            }
                            else if (_loc_3 == 1)
                            {
                                _form.setValue("pointX", this._-1U.control2_x);
                                _form.setValue("pointY", this._-1U.control2_y);
                            }
                        }
                        else
                        {
                            this._-8y = 0;
                            this._-1U = _loc_2.keyFrame.pathPoints[this._-3b];
                            _form.setValue("pointX", this._-1U.x);
                            _form.setValue("pointY", this._-1U.y);
                        }
                        this._-Di.selectedIndex = 1;
                    }
                    else
                    {
                        this._-Di.selectedIndex = 0;
                    }
                    break;
                }
                case "Size":
                {
                    _form.setValue("widthEnabled", this._-FG.value.b1);
                    _form.setValue("heightEnabled", this._-FG.value.b2);
                    _form.setValue("width", int(this._-FG.value.f1));
                    _form.setValue("height", int(this._-FG.value.f2));
                    _form._-Om("width").enabled = this._-FG.value.b1;
                    _form._-Om("height").enabled = this._-FG.value.b2;
                    break;
                }
                case "Pivot":
                {
                    _form.setValue("pivotX", this._-FG.value.f1);
                    _form.setValue("pivotY", this._-FG.value.f2);
                    break;
                }
                case "Alpha":
                {
                    _form.setValue("alpha", this._-FG.value.f1);
                    break;
                }
                case "Rotation":
                {
                    _form.setValue("rotation", this._-FG.value.f1);
                    break;
                }
                case "Scale":
                {
                    _form.setValue("scaleX", this._-FG.value.f1);
                    _form.setValue("scaleY", this._-FG.value.f2);
                    break;
                }
                case "Skew":
                {
                    _form.setValue("skewX", this._-FG.value.f1);
                    _form.setValue("skewY", this._-FG.value.f2);
                    break;
                }
                case "Color":
                {
                    _form.setValue("color", this._-FG.value.iu);
                    break;
                }
                case "Animation":
                {
                    _form.setValue("frameEnabled", this._-FG.value.b1);
                    _form.setValue("playing", this._-FG.value.b2);
                    _form.setValue("frame", this._-FG.value.i);
                    _form._-Om("frame").enabled = this._-FG.value.b1;
                    break;
                }
                case "Sound":
                {
                    _form.setValue("sound", this._-FG.value.s);
                    _form.setValue("volume", this._-FG.value.i);
                    break;
                }
                case "Transition":
                {
                    _form.setValue("transName", this._-FG.value.s);
                    _form.setValue("transTimes", this._-FG.value.i);
                    break;
                }
                case "Shake":
                {
                    _form.setValue("shakeAmplitude", this._-FG.value.f1);
                    _form.setValue("shakePeriod", this._-FG.value.f2);
                    break;
                }
                case "Visible":
                {
                    _form.setValue("visible", this._-FG.value.b1);
                    break;
                }
                case "ColorFilter":
                {
                    _form.setValue("filter_cb", this._-FG.value.f1);
                    _form.setValue("filter_cc", this._-FG.value.f2);
                    _form.setValue("filter_cs", this._-FG.value.f3);
                    _form.setValue("filter_ch", this._-FG.value.f4);
                    break;
                }
                case "Text":
                {
                    _form.setValue("textValue", this._-FG.value.s);
                    break;
                }
                case "Icon":
                {
                    _form.setValue("iconValue", this._-FG.value.s);
                    break;
                }
                default:
                {
                    break;
                }
            }
            _form.updateUI();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_4:* = _editor.docView.activeDocument;
            if (param1 == "pointX")
            {
                _loc_5 = this._-FG.target;
                if (this._-8y == 0)
                {
                    _loc_4.setKeyFramePathPos(this._-FG, this._-3b, param2, _form._-4y("pointY"));
                }
                else
                {
                    _loc_4.setKeyFrameControlPointPos(this._-FG, this._-3b, (this._-8y - 1), param2, _form._-4y("pointY"));
                }
            }
            else if (param1 == "pointY")
            {
                _loc_5 = this._-FG.target;
                if (this._-8y == 0)
                {
                    _loc_4.setKeyFramePathPos(this._-FG, this._-3b, _form._-4y("pointX"), param2);
                }
                else
                {
                    _loc_4.setKeyFrameControlPointPos(this._-FG, this._-3b, (this._-8y - 1), _form._-4y("pointX"), param2);
                }
            }
            else if (param3)
            {
                _loc_6 = {};
                _loc_6[param3] = param2;
                _loc_4.setKeyFrameValue(this._-FG, _loc_6);
            }
            else
            {
                _loc_4.setKeyFrameProperty(this._-FG, param1, param2);
            }
            return;
        }// end function

        private function _-Ez(event:Event) : void
        {
            var _loc_2:* = this._-FG.target;
            _editor.docView.activeDocument.openChild(_loc_2);
            return;
        }// end function

    }
}
