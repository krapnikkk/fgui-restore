package _-5l
{
    import *.*;
    import _-Ds.*;
    import _-Gs.*;
    import _-Pz.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class ScrollPropsPanel extends _-5I
    {
        private static var _-3t:FMargin = new FMargin();

        public function ScrollPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "ScrollPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            _form._-G([{name:"scrollBarOnLeft", type:"bool", dummy:true, extData:FScrollPane.DISPLAY_ON_LEFT}, {name:"scrollSnapping", type:"bool", dummy:true, extData:FScrollPane.SNAP_TO_ITEM}, {name:"scrollBarInDemand", type:"bool", dummy:true, extData:FScrollPane.DISPLAY_IN_DEMAND}, {name:"scrollPageMode", type:"bool", dummy:true, extData:FScrollPane.PAGE_MODE}, {name:"scrollBarDisplay", type:"string", items:[Consts.strings.text138, Consts.strings.text91, Consts.strings.text92, Consts.strings.text93], values:["default", "visible", "auto", "hidden"]}, {name:"scrollTouchEffect", type:"string", dummy:true, extData:FScrollPane.TOUCH_EFFECT_ON, items:[Consts.strings.text284, Consts.strings.text285, Consts.strings.text286], values:["default", "enabled", "disabled"]}, {name:"scrollBounceBackEffect", type:"string", dummy:true, extData:FScrollPane.BOUNCE_BACK_EFFECT_ON, items:[Consts.strings.text284, Consts.strings.text285, Consts.strings.text286], values:["default", "enabled", "disabled"]}, {name:"scrollBarMarginLeft", type:"int", min:0, dummy:true, extData:"left"}, {name:"scrollBarMarginRight", type:"int", min:0, dummy:true, extData:"right"}, {name:"scrollBarMarginTop", type:"int", min:0, dummy:true, extData:"top"}, {name:"scrollBarMarginBottom", type:"int", min:0, dummy:true, extData:"bottom"}, {name:"inertiaDisabled", type:"bool", dummy:true, extData:FScrollPane.INERTIA_DISABLED}, {name:"maskDisabled", type:"bool", dummy:true, extData:FScrollPane.MASK_DISABLED}, {name:"floating", type:"bool", dummy:true, extData:FScrollPane.FLOATING}, {name:"vtScrollBarRes", type:"string"}, {name:"hzScrollBarRes", type:"string"}, {name:"headerRes", type:"string"}, {name:"footerRes", type:"string"}]);
            _panel.getChild("globalSettings").addClickListener(this._-Gl);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FComponent(this.inspectingTarget);
            var _loc_2:* = _loc_1.scrollBarFlags;
            _form.setValue("scrollBarOnLeft", (_loc_2 & FScrollPane.DISPLAY_ON_LEFT) != 0);
            _form.setValue("scrollSnapping", (_loc_2 & FScrollPane.SNAP_TO_ITEM) != 0);
            _form.setValue("scrollBarInDemand", (_loc_2 & FScrollPane.DISPLAY_IN_DEMAND) != 0);
            _form.setValue("scrollPageMode", (_loc_2 & FScrollPane.PAGE_MODE) != 0);
            _form.setValue("scrollTouchEffect", _loc_2 & FScrollPane.TOUCH_EFFECT_ON ? ("enabled") : (_loc_2 & FScrollPane.TOUCH_EFFECT_OFF ? ("disabled") : ("default")));
            _form.setValue("scrollBounceBackEffect", _loc_2 & FScrollPane.BOUNCE_BACK_EFFECT_ON ? ("enabled") : (_loc_2 & FScrollPane.BOUNCE_BACK_EFFECT_OFF ? ("disabled") : ("default")));
            _form.setValue("inertiaDisabled", (_loc_2 & FScrollPane.INERTIA_DISABLED) != 0);
            _form.setValue("maskDisabled", (_loc_2 & FScrollPane.MASK_DISABLED) != 0);
            _form.setValue("floating", (_loc_2 & FScrollPane.FLOATING) != 0);
            _form.setValue("scrollBarMarginLeft", _loc_1.scrollBarMargin.left);
            _form.setValue("scrollBarMarginRight", _loc_1.scrollBarMargin.right);
            _form.setValue("scrollBarMarginTop", _loc_1.scrollBarMargin.top);
            _form.setValue("scrollBarMarginBottom", _loc_1.scrollBarMargin.bottom);
            _form._-Cm(_loc_1);
            _form.updateUI();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            if (param3 != undefined)
            {
                _loc_4 = _editor.docView.activeDocument;
                _loc_5 = this.inspectingTargets;
                _loc_6 = _loc_5.length;
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_8 = FComponent(_loc_5[_loc_7]);
                    if (param3 is String)
                    {
                        _-3t.copy(_loc_8.scrollBarMargin);
                        _-3t[param3] = param2;
                        _loc_8.docElement.setProperty("scrollBarMarginStr", _-3t.toString());
                    }
                    else
                    {
                        _loc_9 = _loc_8.scrollBarFlags;
                        if (param3 == FScrollPane.TOUCH_EFFECT_ON)
                        {
                            if (param2 == "enabled")
                            {
                                _loc_9 = _loc_9 | FScrollPane.TOUCH_EFFECT_ON;
                                _loc_9 = _loc_9 & ~FScrollPane.TOUCH_EFFECT_OFF;
                            }
                            else if (param2 == "disabled")
                            {
                                _loc_9 = _loc_9 & ~FScrollPane.TOUCH_EFFECT_ON;
                                _loc_9 = _loc_9 | FScrollPane.TOUCH_EFFECT_OFF;
                            }
                            else
                            {
                                _loc_9 = _loc_9 & ~FScrollPane.TOUCH_EFFECT_ON;
                                _loc_9 = _loc_9 & ~FScrollPane.TOUCH_EFFECT_OFF;
                            }
                        }
                        else if (param3 == FScrollPane.BOUNCE_BACK_EFFECT_ON)
                        {
                            if (param2 == "enabled")
                            {
                                _loc_9 = _loc_9 | FScrollPane.BOUNCE_BACK_EFFECT_ON;
                                _loc_9 = _loc_9 & ~FScrollPane.BOUNCE_BACK_EFFECT_OFF;
                            }
                            else if (param2 == "disabled")
                            {
                                _loc_9 = _loc_9 & ~FScrollPane.BOUNCE_BACK_EFFECT_ON;
                                _loc_9 = _loc_9 | FScrollPane.BOUNCE_BACK_EFFECT_OFF;
                            }
                            else
                            {
                                _loc_9 = _loc_9 & ~FScrollPane.BOUNCE_BACK_EFFECT_ON;
                                _loc_9 = _loc_9 & ~FScrollPane.BOUNCE_BACK_EFFECT_OFF;
                            }
                        }
                        else if (param2)
                        {
                            _loc_9 = _loc_9 | param3;
                        }
                        else
                        {
                            _loc_9 = _loc_9 & ~param3;
                        }
                        _loc_8.docElement.setProperty("scrollBarFlags", _loc_9);
                    }
                    _loc_7++;
                }
            }
            else
            {
                _-Ix(param1, param2, param3);
            }
            return;
        }// end function

        private function _-Gl(event:Event) : void
        {
            ProjectSettingsDialog(_editor.getDialog(ProjectSettingsDialog)).openScrollBarSettings();
            return;
        }// end function

    }
}
