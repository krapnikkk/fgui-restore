package _-Ds
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.text.*;

    public class TextInputDialog extends _-3g
    {
        private var _input:GLabel;
        private var _-9M:TextField;
        private var _-2K:GComponent;
        private var _-NW:FTextField;
        private var _-Nr:GGraph;
        private var _-Ne:TextArea;
        private var _-GE:FObject;
        private var _-JA:Object;
        private var _-Pi:GObject;
        private var _inputURLPanel:GObject;
        private var _inputFontSizePanel:GObject;
        private var _inputImgPanel:GObject;
        private var _-Cf:int;
        private var _-2X:int;
        private var _-CZ:Boolean;
        private var _-Os:Controller;
        private var _list:GList;
        private var _tags:Array;

        public function TextInputDialog(param1:IEditor)
        {
            var k:String;
            var editor:* = param1;
            super(editor);
            _-3P = true;
            UIObjectFactory.setPackageItemExtension("ui://Builder/TextInput_item", _-8s);
            UIObjectFactory.setPackageItemExtension("ui://Builder/TextInput_item2", _-8s);
            this.contentPane = UIPackage.createObject("Builder", "TextInputDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._-Os = contentPane.getController("c1");
            this._input = contentPane.getChild("input").asLabel;
            this._-9M = TextField(this._input.getChild("title").asTextInput.displayObject);
            this._-9M.addEventListener(Event.CHANGE, this._-8i);
            this._-2K = contentPane.getChild("preview").asCom;
            this._-Nr = this._-2K.getChild("holder").asGraph;
            this._-NW = FObjectFactory.createObject2(_editor.project.allPackages[0], "richtext") as FRichTextField;
            this._-NW.autoSize = "height";
            this._-NW.width = this._-Nr.width;
            this._-NW.ubbEnabled = true;
            this._-Nr.setNativeObject(this._-NW.displayObject);
            this._-Pi = contentPane.getChild("inputPanel");
            this._inputURLPanel = contentPane.getChild("inputURL");
            this._inputFontSizePanel = contentPane.getChild("inputFontSize");
            this._inputImgPanel = contentPane.getChild("inputImg");
            this._-JA = {};
            this._-JA["b"] = {btn:contentPane.getChild("btnBold")};
            this._-JA["i"] = {btn:contentPane.getChild("btnItalic")};
            this._-JA["u"] = {btn:contentPane.getChild("btnUnderline")};
            var _loc_3:* = 0;
            var _loc_4:* = this._-JA;
            while (_loc_4 in _loc_3)
            {
                
                k = _loc_4[_loc_3];
                _loc_4[k].btn.data = k;
                _loc_4[k].btn.addClickListener(function (event:Event) : void
            {
                addTag(event.currentTarget.data);
                return;
            }// end function
            );
            }
            contentPane.getChild("btnColor").addEventListener(_-Fr._-CF, function (event:Event) : void
            {
                var _loc_2:* = getTagOfSelection("color");
                addTag("color", UtilsStr.convertToHtmlColor(ColorInput(event.currentTarget).colorValue));
                return;
            }// end function
            );
            contentPane.getChild("btnFontSize").addClickListener(function () : void
            {
                var _loc_1:* = getTagOfSelection("size");
                if (_loc_1 && _loc_1.attr)
                {
                    contentPane.getChild("fontSizeValue").text = _loc_1.attr;
                }
                else
                {
                    contentPane.getChild("fontSizeValue").text = "12";
                }
                showInputPanel(_inputFontSizePanel);
                return;
            }// end function
            );
            contentPane.getChild("btnLink").addClickListener(function () : void
            {
                var _loc_1:* = getTagOfSelection("url");
                if (_loc_1)
                {
                    contentPane.getChild("linkValue").text = _loc_1.attr;
                }
                else
                {
                    contentPane.getChild("linkValue").text = "";
                }
                showInputPanel(_inputURLPanel);
                return;
            }// end function
            );
            contentPane.getChild("btnImg").addClickListener(function () : void
            {
                var _loc_1:* = getTagOfSelection("img");
                if (_loc_1)
                {
                    contentPane.getChild("imgValue").text = _loc_1.text;
                }
                else
                {
                    contentPane.getChild("imgValue").text = "";
                }
                showInputPanel(_inputImgPanel);
                return;
            }// end function
            );
            contentPane.getChild("btnInputOk").addClickListener(function () : void
            {
                var _loc_1:* = null;
                if (_inputURLPanel.visible)
                {
                    _loc_1 = contentPane.getChild("linkValue").text;
                    if (_loc_1)
                    {
                        addTag("url", _loc_1);
                        hideInputPanel();
                    }
                }
                else if (_inputFontSizePanel.visible)
                {
                    _loc_1 = contentPane.getChild("fontSizeValue").text;
                    if (_loc_1)
                    {
                        addTag("size", _loc_1);
                        hideInputPanel();
                    }
                }
                else if (_inputImgPanel.visible)
                {
                    _loc_1 = contentPane.getChild("imgValue").text;
                    if (_loc_1)
                    {
                        addTag("img", null, _loc_1);
                    }
                    else
                    {
                        removeTag("img");
                    }
                    hideInputPanel();
                }
                return;
            }// end function
            );
            contentPane.getChild("btnInputCancel").addClickListener(function () : void
            {
                hideInputPanel();
                _input.getChild("title").requestFocus();
                return;
            }// end function
            );
            this._list = contentPane.getChild("list").asList;
            this._list.addEventListener(_-Fr._-CF, function () : void
            {
                updateInputText();
                return;
            }// end function
            );
            contentPane.getChild("btnAddText").addClickListener(function () : void
            {
                var _loc_1:* = _list.addItemFromPool() as _-8s;
                var _loc_2:* = new TextFormat();
                _loc_2.size = _-NW.fontSize;
                _loc_2.color = _-NW.color;
                _loc_1._-LN(_loc_2, "");
                _list.addSelection((_list.numChildren - 1), true);
                return;
            }// end function
            );
            contentPane.getChild("btnAddImage").addClickListener(function () : void
            {
                var _loc_1:* = _list.addItemFromPool("ui://Builder/TextInput_item2") as _-8s;
                var _loc_2:* = new TextFormat();
                _loc_1._-2R(_loc_2, "");
                _list.addSelection((_list.numChildren - 1), true);
                return;
            }// end function
            );
            contentPane.getChild("btnDelete").addClickListener(function () : void
            {
                var _loc_1:* = _list.selectedIndex;
                if (_loc_1 != -1)
                {
                    _list.removeChildToPoolAt(_loc_1);
                    if (_loc_1 >= _list.numChildren)
                    {
                        _loc_1 = _list.numChildren - 1;
                    }
                    if (_loc_1 >= 0)
                    {
                        _list.addSelection(_loc_1, true);
                    }
                    updateInputText();
                }
                return;
            }// end function
            );
            contentPane.getChild("btnMoveUp").addClickListener(function () : void
            {
                var _loc_1:* = _list.selectedIndex;
                if (_loc_1 > 0)
                {
                    _list.swapChildrenAt(_loc_1, (_loc_1 - 1));
                    updateInputText();
                }
                return;
            }// end function
            );
            contentPane.getChild("btnMoveDown").addClickListener(function () : void
            {
                var _loc_1:* = _list.selectedIndex;
                if (_loc_1 < (_list.numChildren - 1))
                {
                    _list.swapChildrenAt(_loc_1, (_loc_1 + 1));
                    updateInputText();
                }
                return;
            }// end function
            );
            contentPane.getChild("ok").addClickListener(_-IJ);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            this._tags = [];
            return;
        }// end function

        public function open(param1:TextArea, param2:FObject) : void
        {
            var _loc_3:* = null;
            this._-Ne = param1;
            this._-GE = param2;
            this._input.text = param1.text;
            this._-NW.text = "";
            if (param2 is FTextField)
            {
                _loc_3 = FTextField(param2);
            }
            else if (param2 is FLabel)
            {
                _loc_3 = FLabel(param2).getTextField();
            }
            else if (param2 is FButton)
            {
                _loc_3 = FButton(param2).getTextField();
            }
            if (_loc_3 && _loc_3.ubbEnabled)
            {
                if (Preferences.customUBBEditor)
                {
                    this._-Os.selectedIndex = 2;
                }
                else
                {
                    this._-Os.selectedIndex = 0;
                }
                this._-NW._pkg = param2._pkg;
                this._-NW.copyTextFormat(_loc_3);
                this._-NW.text = this._input.text;
                this._-Nr.height = this._-NW.height + 20;
                this._-CZ = true;
                if (this._-Os.selectedIndex == 0)
                {
                    this.displayObject.addEventListener(Event.ENTER_FRAME, this.onTimer);
                }
            }
            else
            {
                this._-Os.selectedIndex = 1;
            }
            show();
            if (this._-Os.selectedIndex != 2)
            {
                this._input.getChild("title").requestFocus();
            }
            else
            {
                this._-KI();
            }
            return;
        }// end function

        private function addTag(param1:String, param2:String = null, param3:String = null) : void
        {
            var _loc_8:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = false;
            var _loc_13:* = 0;
            var _loc_14:* = null;
            var _loc_4:* = this._-9M.selectionBeginIndex;
            var _loc_5:* = this._-9M.selectionEndIndex;
            var _loc_6:* = param1.length;
            var _loc_7:* = this._-9M.text;
            var _loc_9:* = _loc_4;
            var _loc_10:* = this._-JA[param1];
            if (this._-JA[param1] && _loc_10.tag)
            {
                _loc_8 = _loc_10.tag;
                _loc_7 = _loc_7.substring(0, _loc_8.begin) + _loc_7.substring((_loc_8.begin2 + 1), _loc_8.end2) + _loc_7.substring((_loc_8.end + 1));
                _loc_9 = _loc_9 - (_loc_4 - _loc_8.begin);
            }
            else
            {
                _loc_8 = this.getTagOfSelection(param1);
                if (_loc_8)
                {
                    _loc_7 = _loc_7.substring(0, _loc_8.begin) + "[" + param1 + (param2 ? ("=" + param2) : ("")) + "]" + (param3 != null ? (param3) : (_loc_7.substring((_loc_8.begin2 + 1), _loc_8.end2))) + "[/" + param1 + "]" + _loc_7.substring((_loc_8.end + 1));
                }
                else
                {
                    _loc_11 = this._tags.length;
                    _loc_12 = false;
                    _loc_13 = 0;
                    while (_loc_13 < _loc_11)
                    {
                        
                        _loc_8 = this._tags[_loc_13];
                        if (_loc_4 > _loc_8.begin && _loc_4 <= _loc_8.end && _loc_8.name == "img")
                        {
                            _loc_4 = _loc_8.end + 1;
                        }
                        if (_loc_5 > _loc_8.begin && _loc_5 <= _loc_8.end && _loc_8.name == "img")
                        {
                            _loc_5 = _loc_8.end + 1;
                        }
                        if (_loc_4 > _loc_8.begin && _loc_4 <= _loc_8.begin2)
                        {
                            _loc_4 = _loc_8.begin;
                        }
                        else if (_loc_4 > _loc_8.end2 && _loc_4 <= _loc_8.end)
                        {
                            _loc_4 = _loc_8.end + 1;
                        }
                        if (_loc_5 > _loc_8.begin && _loc_5 <= _loc_8.begin2)
                        {
                            _loc_5 = _loc_8.begin;
                        }
                        else if (_loc_5 > _loc_8.end2 && _loc_5 <= _loc_8.end)
                        {
                            _loc_5 = _loc_8.end + 1;
                        }
                        _loc_13++;
                    }
                    _loc_14 = "[" + param1 + (param2 ? ("=" + param2) : ("")) + "]";
                    if (_loc_4 == _loc_5 || param1 == "img")
                    {
                        _loc_14 = _loc_14 + (param3 != null ? (param3) : (""));
                    }
                    else if (_loc_4 < _loc_5)
                    {
                        _loc_14 = _loc_14 + _loc_7.substring(_loc_4, _loc_5);
                    }
                    else
                    {
                        this._input.getChild("title").requestFocus();
                        return;
                    }
                    _loc_7 = _loc_7.substring(0, _loc_4) + _loc_14 + "[/" + param1 + "]" + _loc_7.substring(_loc_5);
                    _loc_9 = _loc_9 + _loc_14.length;
                }
            }
            this._input.text = _loc_7;
            this._-8i(null);
            this._input.getChild("title").requestFocus();
            this._-9M.setSelection(_loc_9, _loc_9);
            return;
        }// end function

        private function removeTag(param1:String) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = this.getTagOfSelection(param1);
            if (_loc_2)
            {
                _loc_3 = this._-9M.text;
                this._input.text = _loc_3.substring(0, _loc_2.begin) + _loc_3.substring((_loc_2.end + 1));
                this._-8i(null);
            }
            this._input.getChild("title").requestFocus();
            return;
        }// end function

        private function getTagOfSelection(param1:String) : Object
        {
            var _loc_7:* = null;
            var _loc_2:* = this._-9M.selectionBeginIndex;
            var _loc_3:* = this._-9M.selectionEndIndex;
            var _loc_4:* = this._tags.length;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_4)
            {
                
                _loc_7 = this._tags[_loc_6];
                if (_loc_7.name == param1)
                {
                    if (_loc_2 == _loc_7.begin && _loc_3 == (_loc_7.end + 1) || _loc_2 > _loc_7.begin && _loc_2 <= _loc_7.begin + 2 || _loc_2 == _loc_3 && _loc_2 > _loc_7.begin && _loc_2 <= _loc_7.end || _loc_2 > _loc_7.begin && _loc_2 <= _loc_7.end && _loc_3 > _loc_7.begin && _loc_3 <= _loc_7.end && (param1 == "img" || param1 == "url"))
                    {
                        _loc_5 = _loc_7;
                    }
                }
                _loc_6++;
            }
            return _loc_5;
        }// end function

        private function showInputPanel(param1:GObject) : void
        {
            this._-Pi.visible = true;
            param1.visible = true;
            return;
        }// end function

        private function hideInputPanel() : void
        {
            this._-Pi.visible = false;
            this._inputURLPanel.visible = false;
            this._inputImgPanel.visible = false;
            this._inputFontSizePanel.visible = false;
            return;
        }// end function

        private function _-2C() : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = false;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = null;
            this._tags.length = 0;
            var _loc_1:* = this._-9M.text;
            var _loc_2:* = 0;
            do
            {
                
                if (_loc_3 > 0 && _loc_1.charCodeAt((_loc_3 - 1)) == 92)
                {
                    _loc_2 = _loc_3 + 1;
                }
                else
                {
                    _loc_2 = _loc_3;
                    _loc_3 = _loc_1.indexOf("]", _loc_2);
                    if (_loc_3 == -1)
                    {
                        break;
                    }
                    _loc_5 = _loc_1.charCodeAt((_loc_2 + 1)) == 47;
                    _loc_6 = _loc_1.substring(_loc_5 ? (_loc_2 + 2) : ((_loc_2 + 1)), _loc_3);
                    _loc_7 = null;
                    _loc_4 = _loc_6.indexOf("=");
                    if (_loc_4 != -1)
                    {
                        _loc_7 = _loc_6.substring((_loc_4 + 1));
                        _loc_6 = _loc_6.substring(0, _loc_4);
                    }
                    _loc_6 = _loc_6.toLowerCase();
                    if (!_loc_5)
                    {
                        this._tags.push({name:_loc_6, begin:_loc_2, begin2:_loc_3, attr:_loc_7});
                    }
                    else
                    {
                        _loc_8 = this._tags.length - 1;
                        while (_loc_8 >= 0)
                        {
                            
                            _loc_9 = this._tags[_loc_8];
                            if (_loc_9.name == _loc_6)
                            {
                                if (_loc_9.end == undefined)
                                {
                                    _loc_9.end = _loc_3;
                                    _loc_9.end2 = _loc_2;
                                    if (_loc_6 == "img")
                                    {
                                        _loc_9.text = _loc_1.substring((_loc_9.begin2 + 1), _loc_9.end2);
                                    }
                                }
                            }
                            _loc_8 = _loc_8 - 1;
                        }
                    }
                    _loc_2 = _loc_3 + 1;
                }
                var _loc_10:* = _loc_1.indexOf("[", _loc_2);
                _loc_3 = _loc_1.indexOf("[", _loc_2);
            }while (_loc_10 != -1)
            return;
        }// end function

        private function _-KI() : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = false;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            this._list.removeChildrenToPool();
            var _loc_1:* = this._input.text;
            var _loc_2:* = 0;
            var _loc_8:* = new TextFormat();
            _loc_8.size = this._-NW.fontSize;
            _loc_8.color = this._-NW.color;
            var _loc_9:* = new Vector.<TextFormat>;
            do
            {
                
                if (_loc_3 > 0 && _loc_1.charCodeAt((_loc_3 - 1)) == 92)
                {
                    _loc_2 = _loc_3 + 1;
                }
                else
                {
                    if (_loc_3 != _loc_2)
                    {
                        _loc_11 = this._list.addItemFromPool() as _-8s;
                        _loc_11._-LN(_loc_8, _loc_1.substring(_loc_2, _loc_3));
                    }
                    _loc_2 = _loc_3;
                    _loc_3 = _loc_1.indexOf("]", _loc_2);
                    if (_loc_3 == -1)
                    {
                        break;
                    }
                    _loc_5 = _loc_1.charCodeAt((_loc_2 + 1)) == 47;
                    _loc_6 = _loc_1.substring(_loc_5 ? (_loc_2 + 2) : ((_loc_2 + 1)), _loc_3);
                    _loc_7 = null;
                    _loc_4 = _loc_6.indexOf("=");
                    if (_loc_4 != -1)
                    {
                        _loc_7 = _loc_6.substring((_loc_4 + 1));
                        _loc_6 = _loc_6.substring(0, _loc_4);
                    }
                    _loc_6 = _loc_6.toLowerCase();
                    if (_loc_6 == "img")
                    {
                        _loc_2 = _loc_1.indexOf("[", (_loc_3 + 1));
                        if (_loc_2 != -1)
                        {
                            _loc_11 = this._list.addItemFromPool("ui://Builder/TextInput_item2") as _-8s;
                            _loc_11._-2R(_loc_8, _loc_1.substring((_loc_3 + 1), _loc_2));
                            _loc_3 = _loc_1.indexOf("]", _loc_2);
                            if (_loc_3 == -1)
                            {
                                break;
                            }
                        }
                    }
                    else if (_loc_5)
                    {
                        if (_loc_9.length)
                        {
                            _loc_8 = _loc_9.pop();
                        }
                    }
                    else
                    {
                        _loc_9.push(_loc_8);
                        _loc_10 = new TextFormat();
                        this.copyTextFormat(_loc_8, _loc_10);
                        _loc_8 = _loc_10;
                        switch(_loc_6)
                        {
                            case "b":
                            {
                                _loc_8.bold = true;
                                break;
                            }
                            case "i":
                            {
                                _loc_8.italic = true;
                                break;
                            }
                            case "u":
                            {
                                _loc_8.underline = true;
                                break;
                            }
                            case "size":
                            {
                                _loc_8.size = parseInt(_loc_7);
                                break;
                            }
                            case "color":
                            {
                                _loc_8.color = UtilsStr.convertFromHtmlColor(_loc_7);
                                break;
                            }
                            case "url":
                            {
                                _loc_8.url = _loc_7;
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                    }
                    _loc_2 = _loc_3 + 1;
                }
                var _loc_12:* = _loc_1.indexOf("[", _loc_2);
                _loc_3 = _loc_1.indexOf("[", _loc_2);
            }while (_loc_12 != -1)
            if (_loc_2 < _loc_1.length)
            {
                _loc_11 = this._list.addItemFromPool() as _-8s;
                _loc_11._-LN(_loc_8, _loc_1.substr(_loc_2));
            }
            return;
        }// end function

        private function copyTextFormat(param1:TextFormat, param2:TextFormat) : void
        {
            param2.size = param1.size;
            param2.color = param1.color;
            param2.underline = param1.underline;
            param2.italic = param1.italic;
            param2.bold = param1.bold;
            param2.url = param1.url;
            return;
        }// end function

        private function updateInputText() : void
        {
            var _loc_3:* = null;
            var _loc_8:* = null;
            var _loc_1:* = this._list.numChildren;
            var _loc_2:* = "";
            var _loc_4:* = null;
            var _loc_5:* = -1;
            var _loc_6:* = -1;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_1)
            {
                
                _loc_8 = this._list.getChildAt(_loc_7) as _-8s;
                if (_loc_8.textInput && _loc_8.textInput.text.length == 0 || !_loc_8.textInput && _loc_8._-Co.text.length == 0)
                {
                }
                else
                {
                    _loc_3 = UtilsStr.trim(_loc_8._-A7.text);
                    if (_loc_3.length == 0)
                    {
                        _loc_3 = null;
                    }
                    if (_loc_3 != _loc_4)
                    {
                        if (_loc_4)
                        {
                            _loc_2 = _loc_2 + "[/url]";
                        }
                        if (_loc_3)
                        {
                            _loc_2 = _loc_2 + ("[url=" + _loc_3 + "]");
                        }
                        _loc_4 = _loc_3;
                    }
                    if (_loc_8.textInput)
                    {
                        _loc_5 = _loc_8._-Z.value;
                        if (_loc_5 != this._-NW.fontSize)
                        {
                            _loc_2 = _loc_2 + ("[size=" + _loc_5 + "]");
                        }
                        _loc_6 = _loc_8._-KX.colorValue;
                        if (_loc_6 != this._-NW.color)
                        {
                            _loc_2 = _loc_2 + ("[color=" + UtilsStr.convertToHtmlColor(_loc_6) + "]");
                        }
                        if (_loc_8.btnBold.selected)
                        {
                            _loc_2 = _loc_2 + "[b]";
                        }
                        if (_loc_8.btnItalic.selected)
                        {
                            _loc_2 = _loc_2 + "[i]";
                        }
                        if (_loc_8.btnUnderline.selected)
                        {
                            _loc_2 = _loc_2 + "[u]";
                        }
                        _loc_2 = _loc_2 + _loc_8.textInput.text;
                        if (_loc_8.btnUnderline.selected)
                        {
                            _loc_2 = _loc_2 + "[/u]";
                        }
                        if (_loc_8.btnItalic.selected)
                        {
                            _loc_2 = _loc_2 + "[/i]";
                        }
                        if (_loc_8.btnBold.selected)
                        {
                            _loc_2 = _loc_2 + "[/b]";
                        }
                        if (_loc_6 != this._-NW.color)
                        {
                            _loc_2 = _loc_2 + "[/color]";
                        }
                        if (_loc_5 != this._-NW.fontSize)
                        {
                            _loc_2 = _loc_2 + "[/size]";
                        }
                    }
                    else
                    {
                        _loc_3 = UtilsStr.trim(_loc_8._-Co.text);
                        if (_loc_3)
                        {
                            _loc_2 = _loc_2 + ("[img]" + _loc_3 + "[/img]");
                        }
                    }
                }
                _loc_7++;
            }
            if (_loc_4)
            {
                _loc_2 = _loc_2 + "[/url]";
            }
            this._input.text = _loc_2;
            this._-NW.text = this._input.text;
            this._-Nr.height = this._-NW.height + 20;
            return;
        }// end function

        private function _-3f() : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_1:* = this._-9M.selectionBeginIndex;
            var _loc_2:* = this._-9M.selectionEndIndex;
            var _loc_3:* = [];
            for each (_loc_4 in this._-JA)
            {
                
                _loc_4.status = 0;
                _loc_4.tag = null;
            }
            _loc_5 = this._tags.length;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = this._tags[_loc_6];
                if (_loc_1 > _loc_7.begin && _loc_1 <= _loc_7.end)
                {
                    _loc_4 = _loc_9[_loc_7.name];
                    if (_loc_4)
                    {
                        _loc_4.btn.selected = true;
                        _loc_4.status = 1;
                        _loc_4.tag = _loc_7;
                    }
                }
                _loc_6++;
            }
            for each (_loc_4 in this._-JA)
            {
                
                if (_loc_4.status == 0)
                {
                    _loc_4.btn.selected = false;
                }
            }
            return;
        }// end function

        override protected function onHide() : void
        {
            this.displayObject.removeEventListener(Event.ENTER_FRAME, this.onTimer);
            this.hideInputPanel();
            this._-GE = null;
            super.onHide();
            return;
        }// end function

        private function onTimer(event:Event) : void
        {
            if (this._-CZ)
            {
                this._-CZ = false;
                var _loc_4:* = -1;
                this._-2X = -1;
                this._-Cf = _loc_4;
                this._-2C();
            }
            var _loc_2:* = this._-9M.selectionBeginIndex;
            var _loc_3:* = this._-9M.selectionEndIndex;
            if (_loc_2 != this._-Cf || _loc_3 != this._-2X)
            {
                this._-Cf = _loc_2;
                this._-2X = _loc_3;
                this._-3f();
            }
            return;
        }// end function

        private function _-8i(event:Event) : void
        {
            if (this._-Os.selectedIndex == 1)
            {
                return;
            }
            this._-NW.text = this._input.text;
            this._-Nr.height = this._-NW.height + 20;
            this._-CZ = true;
            return;
        }// end function

        override public function _-2a() : void
        {
            if (this._-GE.docElement)
            {
                this._-Ne.text = this._input.text;
                this._-Ne.dispatchEvent(new _-Fr(_-Fr._-CF));
            }
            hide();
            return;
        }// end function

        override public function _-E4() : void
        {
            if (this._-Pi.visible)
            {
                this.hideInputPanel();
            }
            else
            {
                hide();
            }
            return;
        }// end function

    }
}
