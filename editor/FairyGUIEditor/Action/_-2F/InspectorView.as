package _-2F
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import flash.events.*;

    public class InspectorView extends GComponent implements IInspectorView
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _list:GList;
        private var _-F1:Object;
        private var _-22:Object;
        private var _-9T:Vector.<IInspectorPanel>;
        private var _-HN:FObject;
        private var _-GP:String;

        public function InspectorView(param1:IEditor)
        {
            var _loc_3:* = null;
            this._editor = param1;
            this._panel = UIPackage.createObject("Builder", "InspectorView").asCom;
            this.setSize(this._panel.width, this._panel.height);
            this._panel.addRelation(this, RelationType.Size);
            addChild(this._panel);
            this._list = this._panel.getChild("list").asList;
            this._list.removeChildren();
            this._list.scrollItemToViewOnClick = false;
            this._-F1 = {};
            this._-22 = {};
            this._-9T = new Vector.<IInspectorPanel>;
            this._-GP = "ui://Builder/TitleBar";
            var _loc_2:* = ["none", "graph", "image", "text", "richtext", "movieclip", "swf", "loader", "group", "list", "component", "Button", "Label", "Slider", "ProgressBar", "ScrollBar", "ComboBox", "mixed"];
            for each (_loc_3 in _loc_2)
            {
                
                this._-F1[_loc_3] = new Vector.<InspectorDef>;
            }
            addEventListener(_-4U._-76, this.handleKeyEvent);
            return;
        }// end function

        public function getInspector(param1:String) : IInspectorPanel
        {
            var _loc_2:* = this._-22[param1];
            if (!_loc_2)
            {
                throw new Error("inspector not found");
            }
            if (!_loc_2.inst)
            {
                _loc_2.inst = new _loc_2.type(this._editor);
            }
            return _loc_2.inst;
        }// end function

        public function registerInspector(param1:Class, param2:String, param3:String, param4:String = null, param5:int = 0) : void
        {
            var _loc_7:* = null;
            if (param2 == null)
            {
                this._editor.consoleView.logWarning("Inspector with name \'" + param2 + "\' is exists");
                return;
            }
            var _loc_6:* = new InspectorDef();
            _loc_6.type = param1;
            _loc_6.name = param2;
            _loc_6.title = param3;
            _loc_6.flags = param5;
            this._-22[_loc_6.name] = _loc_6;
            if (param4 != null)
            {
                _loc_7 = this._-F1[param4];
                if (!_loc_7)
                {
                    throw new Error("Invalid targetObjectType");
                }
                if (param4 == "mixed")
                {
                    for each (_loc_7 in this._-F1)
                    {
                        
                        _loc_7.push(_loc_6);
                    }
                }
                else
                {
                    _loc_7.push(_loc_6);
                }
            }
            return;
        }// end function

        public function get visibleInspectors() : Vector.<IInspectorPanel>
        {
            return this._-9T;
        }// end function

        public function setTitle(param1:String, param2:String) : void
        {
            var _loc_3:* = this._-22[param1];
            if (!_loc_3)
            {
                throw new Error("inspector not found");
            }
            _loc_3.title = param2;
            if (_loc_3.titleBar)
            {
                _loc_3.titleBar.text = param2;
            }
            return;
        }// end function

        public function showDefault() : void
        {
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            if (this._-HN && this._list.numChildren > 2)
            {
                this._-HN.docElement.setVar("inspectorScrollPos", this._list.scrollPane.posY);
            }
            this._list.removeChildren();
            this._-9T.length = 0;
            var _loc_1:* = this._editor.docView.activeDocument;
            if (_loc_1 == null || _loc_1.content == null)
            {
                return;
            }
            var _loc_2:* = _loc_1.inspectingTargets;
            var _loc_3:* = _loc_2.length;
            var _loc_4:* = _loc_1.inspectingObjectType;
            if (_loc_1.isPickingObject)
            {
                this._-Fp("pickObject");
                this._list.ensureBoundsCorrect();
                this._list.scrollPane.scrollTop();
                return;
            }
            if (_loc_3 > 1)
            {
                this._-Fp("multiSelection");
            }
            var _loc_5:* = _loc_1.timelineMode;
            var _loc_6:* = _loc_2[0].docElement.isRoot;
            var _loc_7:* = this._-F1[_loc_4];
            for each (_loc_10 in _loc_7)
            {
                
                if (_loc_5)
                {
                    if ((_loc_10.flags & InspectorFlags.TIMELINE_MODE) == 0)
                    {
                        continue;
                    }
                }
                else if ((_loc_10.flags & InspectorFlags.TIMELINE_MODE) != 0 || _loc_6 != ((_loc_10.flags & InspectorFlags.EMPTY_SELECTION) != 0))
                {
                    continue;
                }
                this._-Fp(_loc_10.name);
            }
            this._list.ensureBoundsCorrect();
            if (_loc_3 <= 1)
            {
                this._-HN = _loc_2[0];
                if (!_loc_5)
                {
                    this._list.scrollPane.posY = int(this._-HN.docElement.getVar("inspectorScrollPos"));
                }
            }
            else
            {
                this._-HN = null;
                this._list.scrollPane.scrollTop();
            }
            return;
        }// end function

        public function show(param1:Array) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = false;
            var _loc_5:* = 0;
            this._-HN = null;
            if (this._-9T.length == param1.length)
            {
                _loc_3 = this._-9T.length;
                _loc_4 = true;
                _loc_5 = 0;
                while (_loc_5 < _loc_3)
                {
                    
                    if (this._-9T[_loc_5].panel.name != param1[_loc_5])
                    {
                        _loc_4 = false;
                        break;
                    }
                    _loc_5++;
                }
                if (_loc_4)
                {
                    _loc_5 = 0;
                    while (_loc_5 < _loc_3)
                    {
                        
                        this._-9T[_loc_5].updateUI();
                        _loc_5++;
                    }
                    return;
                }
            }
            this._list.removeChildren();
            this._-9T.length = 0;
            for each (_loc_2 in param1)
            {
                
                this._-Fp(_loc_2);
            }
            this._list.ensureBoundsCorrect();
            this._list.scrollPane.scrollTop();
            return;
        }// end function

        public function showPopup(param1:String, param2:GObject, param3:Object = null, param4:Boolean = false) : void
        {
            var _loc_5:* = this._-22[param1];
            if (!this._-22[param1])
            {
                throw new Error("inspector not found");
            }
            var _loc_6:* = _loc_5.inst;
            if (!_loc_5.inst)
            {
                var _loc_7:* = new _loc_5.type(this._editor);
                _loc_5.inst = new _loc_5.type(this._editor);
                _loc_6 = _loc_7;
                _loc_6.panel.name = _loc_5.name;
            }
            this._editor.groot.togglePopup(_loc_6.panel, param2, null, param4);
            if (_loc_6.panel.onStage)
            {
                _loc_6.panel.addEventListener(Event.REMOVED_FROM_STAGE, this._-Oj);
                _loc_6.updateUI();
                this._-9T.push(_loc_6);
            }
            return;
        }// end function

        private function _-Oj(event:Event) : void
        {
            var _loc_2:* = GComponent(event.currentTarget);
            _loc_2.addEventListener(Event.REMOVED_FROM_STAGE, this._-Oj);
            var _loc_3:* = this._-9T.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (this._-9T[_loc_4].panel == _loc_2)
                {
                    this._-9T.splice(_loc_4, 1);
                    break;
                }
                _loc_4++;
            }
            return;
        }// end function

        private function _-Fp(param1:String) : void
        {
            var _loc_2:* = this._-22[param1];
            var _loc_3:* = _loc_2.inst;
            var _loc_4:* = _loc_2.titleBar;
            if (!_loc_3)
            {
                var _loc_5:* = new _loc_2.type(this._editor);
                _loc_2.inst = new _loc_2.type(this._editor);
                _loc_3 = _loc_5;
                _loc_3.panel.name = _loc_2.name;
            }
            if (_loc_2.title != null)
            {
                if (!_loc_4)
                {
                    var _loc_5:* = UIPackage.createObjectFromURL(this._-GP).asButton;
                    _loc_2.titleBar = UIPackage.createObjectFromURL(this._-GP).asButton;
                    _loc_4 = _loc_5;
                    _loc_4.changeStateOnClick = false;
                    _loc_4.getChild("button").addClickListener(this._-Mx);
                    _loc_4.data = _loc_2;
                    _loc_4.text = _loc_2.title;
                }
                this._list.addChild(_loc_4);
            }
            this._list.addChild(_loc_3.panel);
            if (_loc_3.updateUI())
            {
                this._-9T.push(_loc_3);
                if (_loc_2.titleBar && _loc_4.selected)
                {
                    this._list.removeChild(_loc_3.panel);
                }
            }
            else
            {
                if (_loc_2.titleBar)
                {
                    this._list.removeChild(_loc_2.titleBar);
                }
                this._list.removeChild(_loc_3.panel);
            }
            return;
        }// end function

        private function _-Mx(event:Event) : void
        {
            var _loc_2:* = GButton(event.currentTarget.parent);
            _loc_2.selected = !_loc_2.selected;
            if (_loc_2.selected)
            {
                this._list.removeChild(IInspectorPanel(_loc_2.data.inst).panel);
            }
            else
            {
                this._list.addChildAt(IInspectorPanel(_loc_2.data.inst).panel, (this._list.getChildIndex(_loc_2) + 1));
            }
            return;
        }// end function

        private function handleKeyEvent(param1:_-4U) : void
        {
            this._editor.docView.handleKeyEvent(param1);
            return;
        }// end function

    }
}

import *.*;

import _-Gs.*;

import __AS3__.vec.*;

import fairygui.*;

import fairygui.editor.api.*;

import fairygui.editor.gui.*;

import flash.events.*;

class InspectorDef extends Object
{
    public var type:Class;
    public var name:String;
    public var title:String;
    public var flags:int;
    public var inst:IInspectorPanel;
    public var titleBar:GButton;

    function InspectorDef()
    {
        return;
    }// end function

}

