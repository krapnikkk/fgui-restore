package _-Pz
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;
    import flash.geom.*;

    public class ComPropsPanel extends _-5I
    {
        private var _-4M:GButton;
        private var _-DN:Array;
        private var _-JS:Array;

        public function ComPropsPanel(param1:IEditor)
        {
            var editor:* = param1;
            _editor = editor;
            _panel = UIPackage.createObject("Builder", "ComPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = this.onPropChanged;
            this._-DN = ["", "Button", "Label", "ProgressBar", "ScrollBar", "Slider", "ComboBox"];
            this._-JS = [Consts.strings.text331, Consts.strings.text140, Consts.strings.text141, Consts.strings.text142, Consts.strings.text143, Consts.strings.text144, Consts.strings.text145];
            _form._-G([{name:"width", type:"int", min:0}, {name:"height", type:"int", min:0}, {name:"minWidth", type:"int"}, {name:"minHeight", type:"int"}, {name:"maxWidth", type:"int"}, {name:"maxHeight", type:"int"}, {name:"pivotX", type:"float", precision:2}, {name:"pivotY", type:"float", precision:2}, {name:"anchor", type:"bool"}, {name:"overflow2", type:"string", items:[Consts.strings.text132, Consts.strings.text133, Consts.strings.text135, Consts.strings.text136, Consts.strings.text137], values:["visible", "hidden", "scroll-vertical", "scroll-horizontal", "scroll-both"]}, {name:"initName", type:"string", disableIME:true, trim:true}, {name:"bgColorEnabled", type:"bool"}, {name:"bgColor", type:"uint"}, {name:"opaque", type:"bool", reversed:true}, {name:"margin", type:"string", readonly:true}, {name:"mask", type:"object", filter:["image", "graph"]}, {name:"hitTestSource", type:"object", filter:["image", "graph"]}, {name:"reversedMask", type:"bool"}, {name:"extentionId", type:"string"}]);
            this._-4M = _panel.getChild("scrollEdit").asButton;
            this._-4M.addClickListener(function (event:Event) : void
            {
                _editor.inspectorView.showPopup("scroll", GObject(event.currentTarget), null, true);
                return;
            }// end function
            );
            _panel.getChild("margin").addClickListener(function (event:Event) : void
            {
                _editor.inspectorView.showPopup("margin", GObject(event.currentTarget));
                return;
            }// end function
            );
            _panel.getChild("n92").addClickListener(function (event:Event) : void
            {
                SelectPivotMenu._-30(_editor).show(_form._-Om("pivotX"), _form._-Om("pivotY"), GObject(event.currentTarget));
                return;
            }// end function
            );
            _panel.getChild("fitSize").addClickListener(this._-6Q);
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_1:* = FComponent(this.inspectingTarget);
            _form._-Cm(_loc_1);
            var _loc_2:* = _form._-Om("extentionId").asComboBox;
            if (_loc_2.items.length == 0 || _editor.project.getVar("CustomExtensionChanged"))
            {
                _editor.project.setVar("CustomExtensionChanged", undefined);
                _loc_4 = _editor.project.getVar("CustomExtensionIDs") as Array;
                this._-DN.length = 7;
                this._-JS.length = 7;
                if (_loc_4)
                {
                    for each (_loc_5 in _loc_4)
                    {
                        
                        this._-DN.push(_loc_5);
                        this._-JS.push(_editor.project.getCustomExtension(_loc_5).name);
                    }
                }
                _loc_2.items = this._-JS;
                _loc_2.values = this._-DN;
            }
            var _loc_3:* = "";
            if (_loc_1.customExtentionId != null)
            {
                _loc_6 = _editor.project.getCustomExtension(_loc_1.customExtentionId);
                if (_loc_6)
                {
                    _loc_3 = _loc_1.customExtentionId;
                }
            }
            else if (_loc_1.extentionId != null)
            {
                _loc_3 = _loc_1.extentionId;
            }
            _form.setValue("extentionId", _loc_3);
            this._-4M.visible = _loc_1.overflow == "scroll";
            _form.updateUI();
            return true;
        }// end function

        private function onPropChanged(param1:String, param2, param3) : void
        {
            var _loc_6:* = null;
            var _loc_4:* = _editor.docView.activeDocument;
            var _loc_5:* = this.inspectingTarget as FComponent;
            if (param1 == "extentionId")
            {
                _loc_6 = _editor.project.getCustomExtension(param2);
                if (_loc_6)
                {
                    _loc_5.docElement.setProperty("customExtentionId", param2);
                    if (_loc_6.superClassName)
                    {
                        _loc_5.docElement.setProperty("extentionId", _loc_6.superClassName);
                    }
                    else
                    {
                        _loc_5.docElement.setProperty("extentionId", null);
                    }
                }
                else if (FObjectType.NAME_PREFIX[param2] != undefined)
                {
                    _loc_5.docElement.setProperty("customExtentionId", null);
                    _loc_5.docElement.setProperty("extentionId", param2);
                }
                else
                {
                    _loc_5.docElement.setProperty("customExtentionId", null);
                    _loc_5.docElement.setProperty("extentionId", null);
                }
            }
            else
            {
                _loc_5.docElement.setProperty(param1, param2);
            }
            return;
        }// end function

        private function _-6Q(event:Event) : void
        {
            var _loc_2:* = _editor.docView.activeDocument;
            var _loc_3:* = this.inspectingTarget as FComponent;
            var _loc_4:* = _loc_3.getBounds();
            if (_loc_4.isEmpty())
            {
                return;
            }
            _loc_3.docElement.setProperty("width", _loc_4.right);
            _loc_3.docElement.setProperty("height", _loc_4.bottom);
            this.updateUI();
            return;
        }// end function

    }
}
