package _-Pz
{
    import *.*;
    import _-Ds.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class ListPropsPanel extends _-5I
    {
        private var _-4M:GObject;

        public function ListPropsPanel(param1:IEditor)
        {
            var editor:* = param1;
            _editor = editor;
            _panel = UIPackage.createObject("Builder", "ListPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"layout", type:"string", items:[Consts.strings.text149, Consts.strings.text150, Consts.strings.text151, Consts.strings.text152, Consts.strings.text307], values:["column", "row", "flow_hz", "flow_vt", "pagination"]}, {name:"lineGap", type:"int"}, {name:"columnGap", type:"int"}, {name:"repeatX", type:"int"}, {name:"repeatY", type:"int"}, {name:"selectionMode", type:"string", items:[Consts.strings.text231, Consts.strings.text232, Consts.strings.text233, Consts.strings.text234], values:["single", "multiple", "multipleSingleClick", "none"]}, {name:"overflow2", type:"string", items:[Consts.strings.text132, Consts.strings.text133, Consts.strings.text135, Consts.strings.text136, Consts.strings.text137], values:["visible", "hidden", "scroll-vertical", "scroll-horizontal", "scroll-both"]}, {name:"align", type:"string", items:[Consts.strings.text153, Consts.strings.text154, Consts.strings.text155], values:["left", "center", "right"]}, {name:"verticalAlign", type:"string", items:[Consts.strings.text156, Consts.strings.text157, Consts.strings.text158], values:["top", "middle", "bottom"]}, {name:"childrenRenderOrder", type:"string", items:[Consts.strings.text328, Consts.strings.text329, Consts.strings.text330], values:["ascent", "descent", "arch"]}, {name:"apexIndex", type:"int"}, {name:"margin", type:"string", readonly:true}, {name:"pageController", type:"string"}, {name:"selectionController", type:"string"}, {name:"defaultItem", type:"string"}, {name:"treeViewEnabled", type:"bool"}]);
            this._-4M = _panel.getChild("scrollEdit");
            this._-4M.addClickListener(function (event:Event) : void
            {
                _editor.inspectorView.showPopup("scroll", GObject(event.currentTarget), null, true);
                return;
            }// end function
            );
            _form._-Om("margin").addClickListener(function (event:Event) : void
            {
                _editor.inspectorView.showPopup("margin", GObject(event.currentTarget));
                return;
            }// end function
            );
            _panel.getChild("layoutEdit").addClickListener(function (event:Event) : void
            {
                _editor.inspectorView.showPopup("listLayout", GObject(event.currentTarget));
                return;
            }// end function
            );
            _panel.getChild("treeOption").addClickListener(function (event:Event) : void
            {
                _editor.inspectorView.showPopup("treeOption", GObject(event.currentTarget));
                return;
            }// end function
            );
            _panel.getChild("editItems").addClickListener(function () : void
            {
                _editor.getDialog(ListItemsEditDialog).show();
                return;
            }// end function
            );
            return;
        }// end function

        override public function updateUI() : Boolean
        {
            var _loc_1:* = FList(this.inspectingTarget);
            _form._-Cm(_loc_1);
            _form.updateUI();
            this._-4M.visible = _loc_1.overflow == "scroll";
            switch(_loc_1.layout)
            {
                case "column":
                {
                    _form._-Om("lineGap").enabled = true;
                    _form._-Om("columnGap").enabled = false;
                    _form._-Om("repeatX").enabled = false;
                    _form._-Om("repeatY").enabled = false;
                    break;
                }
                case "row":
                {
                    _form._-Om("lineGap").enabled = false;
                    _form._-Om("columnGap").enabled = true;
                    _form._-Om("repeatX").enabled = false;
                    _form._-Om("repeatY").enabled = false;
                    break;
                }
                case "flow_hz":
                {
                    _form._-Om("lineGap").enabled = true;
                    _form._-Om("columnGap").enabled = true;
                    _form._-Om("repeatX").enabled = true;
                    _form._-Om("repeatY").enabled = false;
                    break;
                }
                case "flow_vt":
                {
                    _form._-Om("lineGap").enabled = true;
                    _form._-Om("columnGap").enabled = true;
                    _form._-Om("repeatX").enabled = false;
                    _form._-Om("repeatY").enabled = true;
                    break;
                }
                case "pagination":
                {
                    _form._-Om("lineGap").enabled = true;
                    _form._-Om("columnGap").enabled = true;
                    _form._-Om("repeatX").enabled = true;
                    _form._-Om("repeatY").enabled = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            _form._-Om("apexIndex").enabled = _loc_1.childrenRenderOrder == "arch";
            return true;
        }// end function

    }
}
