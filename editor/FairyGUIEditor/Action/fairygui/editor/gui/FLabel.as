package fairygui.editor.gui
{
    import *.*;
    import fairygui.*;
    import fairygui.utils.*;

    public class FLabel extends ComExtention
    {
        public var restrict:String;
        public var maxLength:int;
        public var keyboardType:int;
        private var _title:String;
        private var _icon:String;
        private var _titleColor:uint;
        private var _titleColorSet:Boolean;
        private var _originColor:uint;
        private var _titleFontSize:int;
        private var _titleFontSizeSet:Boolean;
        private var _originFontSize:int;
        private var _password:Boolean;
        private var _promptText:String;
        private var _titleObject:FObject;
        private var _iconObject:FObject;

        public function FLabel()
        {
            this._title = "";
            this._icon = "";
            return;
        }// end function

        override public function get icon() : String
        {
            return this._icon;
        }// end function

        override public function set icon(param1:String) : void
        {
            this._icon = param1;
            if (this._iconObject)
            {
                this._iconObject.icon = param1;
            }
            _owner.updateGear(7);
            return;
        }// end function

        override public function get title() : String
        {
            return this._title;
        }// end function

        override public function set title(param1:String) : void
        {
            this._title = param1;
            if (this._titleObject)
            {
                this._titleObject.text = param1;
            }
            _owner.updateGear(6);
            return;
        }// end function

        public function get titleColor() : uint
        {
            return this._titleColor;
        }// end function

        public function set titleColor(param1:uint) : void
        {
            if (this._titleColor != param1)
            {
                this._titleColor = param1;
                if (this._titleObject)
                {
                    if (this._titleObject is FTextField)
                    {
                        FTextField(this._titleObject).color = this._titleColor;
                    }
                    else if (this._titleObject is FComponent)
                    {
                        if (FComponent(this._titleObject).extentionId == "Label")
                        {
                            FLabel(FComponent(this._titleObject).extention).titleColor = this._titleColor;
                        }
                        else if (FComponent(this._titleObject).extentionId == "Button")
                        {
                            FButton(FComponent(this._titleObject).extention).titleColor = this._titleColor;
                        }
                    }
                }
                _owner.updateGear(4);
            }
            return;
        }// end function

        override public function get color() : uint
        {
            return this._titleColor;
        }// end function

        override public function set color(param1:uint) : void
        {
            this.titleColor = param1;
            return;
        }// end function

        public function get titleColorSet() : Boolean
        {
            return this._titleColorSet;
        }// end function

        public function set titleColorSet(param1:Boolean) : void
        {
            var _loc_2:* = 0;
            this._titleColorSet = param1;
            if (!this._titleColorSet)
            {
                _loc_2 = this._originColor;
            }
            else
            {
                _loc_2 = this._titleColor;
            }
            if (this._titleObject)
            {
                if (this._titleObject is FTextField)
                {
                    FTextField(this._titleObject).color = _loc_2;
                }
                else if (this._titleObject is FComponent)
                {
                    if (FComponent(this._titleObject).extentionId == "Label")
                    {
                        FLabel(FComponent(this._titleObject).extention).titleColor = _loc_2;
                    }
                    else if (FComponent(this._titleObject).extentionId == "Button")
                    {
                        FButton(FComponent(this._titleObject).extention).titleColor = _loc_2;
                    }
                }
            }
            return;
        }// end function

        public function get titleFontSize() : int
        {
            return this._titleFontSize;
        }// end function

        public function set titleFontSize(param1:int) : void
        {
            if (this._titleFontSize != param1)
            {
                this._titleFontSize = param1;
                if (this._titleObject)
                {
                    if (this._titleObject is FTextField)
                    {
                        FTextField(this._titleObject).fontSize = this._titleFontSize;
                    }
                    else if (this._titleObject is FComponent)
                    {
                        if (FComponent(this._titleObject).extentionId == "Label")
                        {
                            FLabel(FComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                        }
                        else if (FComponent(this._titleObject).extentionId == "Button")
                        {
                            FButton(FComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                        }
                    }
                }
                _owner.updateGear(9);
            }
            return;
        }// end function

        public function get titleFontSizeSet() : Boolean
        {
            return this._titleFontSizeSet;
        }// end function

        public function set titleFontSizeSet(param1:Boolean) : void
        {
            var _loc_2:* = 0;
            this._titleFontSizeSet = param1;
            if (!this._titleFontSizeSet)
            {
                _loc_2 = this._originFontSize;
            }
            else
            {
                _loc_2 = this._titleFontSize;
            }
            if (this._titleObject)
            {
                if (this._titleObject is FTextField)
                {
                    FTextField(this._titleObject).fontSize = _loc_2;
                }
                else if (this._titleObject is FComponent)
                {
                    if (FComponent(this._titleObject).extentionId == "Label")
                    {
                        FLabel(FComponent(this._titleObject).extention).titleFontSize = _loc_2;
                    }
                    else if (FComponent(this._titleObject).extentionId == "Button")
                    {
                        FButton(FComponent(this._titleObject).extention).titleFontSize = _loc_2;
                    }
                }
            }
            return;
        }// end function

        public function get input() : Boolean
        {
            var _loc_1:* = this.getTextField();
            return _loc_1 && _loc_1.input;
        }// end function

        public function get password() : Boolean
        {
            return this._password;
        }// end function

        public function set password(param1:Boolean) : void
        {
            this._password = param1;
            var _loc_2:* = this.getTextField();
            if (_loc_2)
            {
                _loc_2.password = param1;
            }
            return;
        }// end function

        public function get promptText() : String
        {
            return this._promptText;
        }// end function

        public function set promptText(param1:String) : void
        {
            this._promptText = param1;
            var _loc_2:* = this.getTextField();
            if (_loc_2)
            {
                _loc_2.promptText = param1;
            }
            return;
        }// end function

        public function getTextField() : FTextField
        {
            if (this._titleObject is FTextField)
            {
                return FTextField(this._titleObject);
            }
            if (this._titleObject is FLabel)
            {
                return FLabel(this._titleObject).getTextField();
            }
            if (this._titleObject is FButton)
            {
                return FButton(this._titleObject).getTextField();
            }
            return null;
        }// end function

        override public function getProp(param1:int)
        {
            var _loc_2:* = null;
            switch(param1)
            {
                case ObjectPropID.Color:
                {
                    return this.titleColor;
                }
                case ObjectPropID.OutlineColor:
                {
                    _loc_2 = this.getTextField();
                    if (_loc_2)
                    {
                        return _loc_2.strokeColor;
                    }
                    return 0;
                }
                case ObjectPropID.FontSize:
                {
                    return this.titleFontSize;
                }
                default:
                {
                    return super.getProp(param1);
                    break;
                }
            }
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            var _loc_3:* = null;
            switch(param1)
            {
                case ObjectPropID.Color:
                {
                    this.titleColor = param2;
                    break;
                }
                case ObjectPropID.OutlineColor:
                {
                    _loc_3 = this.getTextField();
                    if (_loc_3)
                    {
                        _loc_3.strokeColor = param2;
                    }
                    break;
                }
                case ObjectPropID.FontSize:
                {
                    this.titleFontSize = param2;
                    break;
                }
                default:
                {
                    super.setProp(param1, param2);
                    break;
                    break;
                }
            }
            return;
        }// end function

        override public function create() : void
        {
            this._titleObject = owner.getChild("title");
            this._iconObject = owner.getChild("icon");
            if (this._titleObject)
            {
                if (this._titleObject is FTextField)
                {
                    this._originColor = FTextField(this._titleObject).color;
                    this._originFontSize = FTextField(this._titleObject).fontSize;
                }
                else if (this._titleObject is FComponent)
                {
                    if (FComponent(this._titleObject).extentionId == "Label")
                    {
                        this._originColor = FLabel(FComponent(this._titleObject).extention).titleColor;
                        this._originFontSize = FLabel(FComponent(this._titleObject).extention).titleFontSize;
                    }
                    else if (FComponent(this._titleObject).extentionId == "Button")
                    {
                        this._originColor = FButton(FComponent(this._titleObject).extention).titleColor;
                        this._originFontSize = FButton(FComponent(this._titleObject).extention).titleFontSize;
                    }
                }
            }
            if (!this._titleColorSet)
            {
                this._titleColor = this._originColor;
            }
            if (!this._titleFontSizeSet)
            {
                this._titleFontSize = this._originFontSize;
            }
            return;
        }// end function

        override public function read(param1:XData, param2:Object) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = undefined;
            _loc_3 = param1.getAttribute("title");
            if (param2)
            {
                _loc_4 = param2[_owner.id];
                if (_loc_4 != undefined)
                {
                    _loc_3 = _loc_4;
                }
            }
            if (_loc_3)
            {
                this.title = _loc_3;
            }
            _loc_3 = param1.getAttribute("icon");
            if (_loc_3)
            {
                this.icon = _loc_3;
            }
            _loc_3 = param1.getAttribute("titleColor");
            if (_loc_3)
            {
                this.titleColor = UtilsStr.convertFromHtmlColor(_loc_3);
                this._titleColorSet = true;
            }
            _loc_3 = param1.getAttribute("titleFontSize");
            if (_loc_3)
            {
                this.titleFontSize = parseInt(_loc_3);
                this._titleFontSizeSet = true;
            }
            if (this.input)
            {
                this.promptText = param1.getAttribute("prompt");
                if (param2)
                {
                    _loc_4 = param2[_owner.id + "-0"];
                    if (_loc_4 != undefined)
                    {
                        this.promptText = _loc_4;
                    }
                }
                if (this.promptText)
                {
                    FTextField(this._titleObject).promptText = this.promptText;
                }
                _loc_3 = param1.getAttribute("maxLength");
                if (_loc_3)
                {
                    this.maxLength = parseInt(_loc_3);
                    if (this.maxLength > 0)
                    {
                        FTextField(this._titleObject).maxLength = this.maxLength;
                    }
                }
                this.restrict = param1.getAttribute("restrict");
                if (this.restrict)
                {
                    FTextField(this._titleObject).restrict = this.restrict;
                }
                this.keyboardType = param1.getAttributeInt("keyboardType");
                if (this.keyboardType)
                {
                    FTextField(this._titleObject).keyboardType = this.keyboardType;
                }
                this._password = param1.getAttributeBool("password");
                if (this._password)
                {
                    FTextField(this._titleObject).password = this._password;
                }
            }
            return;
        }// end function

        override public function write() : XData
        {
            var _loc_1:* = XData.create("Label");
            if (this._title)
            {
                _loc_1.setAttribute("title", this._title);
            }
            if (this._titleColorSet)
            {
                _loc_1.setAttribute("titleColor", UtilsStr.convertToHtmlColor(this._titleColor));
            }
            if (this._titleFontSizeSet)
            {
                _loc_1.setAttribute("titleFontSize", this._titleFontSize);
            }
            if (this._icon)
            {
                _loc_1.setAttribute("icon", this._icon);
            }
            if (this.input)
            {
                if (this.promptText)
                {
                    _loc_1.setAttribute("prompt", this.promptText);
                }
                if (this.maxLength > 0)
                {
                    _loc_1.setAttribute("maxLength", this.maxLength);
                }
                if (this.restrict)
                {
                    _loc_1.setAttribute("restrict", this.restrict);
                }
                if (this.keyboardType)
                {
                    _loc_1.setAttribute("keyboardType", this.keyboardType);
                }
                if (this._password)
                {
                    _loc_1.setAttribute("password", this._password);
                }
            }
            if (_loc_1.hasAttributes())
            {
                return _loc_1;
            }
            return null;
        }// end function

    }
}
