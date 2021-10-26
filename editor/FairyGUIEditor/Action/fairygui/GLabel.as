package fairygui
{
    import fairygui.utils.*;

    public class GLabel extends GComponent
    {
        protected var _titleObject:GObject;
        protected var _iconObject:GObject;

        public function GLabel()
        {
            return;
        }// end function

        override public function get icon() : String
        {
            if (_iconObject != null)
            {
                return _iconObject.icon;
            }
            return null;
        }// end function

        override public function set icon(param1:String) : void
        {
            if (_iconObject != null)
            {
                _iconObject.icon = param1;
            }
            updateGear(7);
            return;
        }// end function

        final public function get title() : String
        {
            if (_titleObject)
            {
                return _titleObject.text;
            }
            return null;
        }// end function

        public function set title(param1:String) : void
        {
            if (_titleObject)
            {
                _titleObject.text = param1;
            }
            updateGear(6);
            return;
        }// end function

        final override public function get text() : String
        {
            return this.title;
        }// end function

        override public function set text(param1:String) : void
        {
            this.title = param1;
            return;
        }// end function

        final public function get titleColor() : uint
        {
            var _loc_1:* = getTextField();
            if (_loc_1)
            {
                return _loc_1.color;
            }
            return 0;
        }// end function

        public function set titleColor(param1:uint) : void
        {
            var _loc_2:* = getTextField();
            if (_loc_2)
            {
                _loc_2.color = param1;
            }
            updateGear(4);
            return;
        }// end function

        final public function get titleFontSize() : int
        {
            var _loc_1:* = getTextField();
            if (_loc_1)
            {
                return _loc_1.fontSize;
            }
            return 0;
        }// end function

        public function set titleFontSize(param1:int) : void
        {
            var _loc_2:* = getTextField();
            if (_loc_2)
            {
                _loc_2.fontSize = param1;
            }
            return;
        }// end function

        public function set editable(param1:Boolean) : void
        {
            var _loc_2:* = getTextField();
            if (_loc_2 && _loc_2 is GTextInput)
            {
                _loc_2.asTextInput.editable = param1;
            }
            return;
        }// end function

        public function get editable() : Boolean
        {
            var _loc_1:* = getTextField();
            if (_loc_1 && _loc_1 is GTextInput)
            {
                return _loc_1.asTextInput.editable;
            }
            return false;
        }// end function

        public function getTextField() : GTextField
        {
            if (_titleObject is GTextField)
            {
                return this.GTextField(_titleObject);
            }
            if (_titleObject is GLabel)
            {
                return this.GLabel(_titleObject).getTextField();
            }
            if (_titleObject is GButton)
            {
                return this.GButton(_titleObject).getTextField();
            }
            return null;
        }// end function

        override public function getProp(param1:int)
        {
            var _loc_2:* = null;
            switch(param1 - 2) branch count is:<6>[26, 31, 60, 60, 60, 60, 55] default offset is:<60>;
            return this.titleColor;
            _loc_2 = getTextField();
            if (_loc_2)
            {
                return _loc_2.strokeColor;
            }
            return 0;
            return this.titleFontSize;
            return super.getProp(param1);
        }// end function

        override public function setProp(param1:int, param2) : void
        {
            var _loc_3:* = null;
            switch(param1 - 2) branch count is:<6>[26, 35, 69, 69, 69, 69, 60] default offset is:<69>;
            this.titleColor = param2;
            ;
            _loc_3 = getTextField();
            if (_loc_3)
            {
                _loc_3.strokeColor = param2;
            }
            ;
            this.titleFontSize = param2;
            ;
            super.setProp(param1, param2);
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            _titleObject = getChild("title");
            _iconObject = getChild("icon");
            return;
        }// end function

        override public function setup_afterAdd(param1:XML) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            super.setup_afterAdd(param1);
            param1 = param1.Label[0];
            if (param1)
            {
                _loc_2 = param1.@title;
                if (_loc_2)
                {
                    this.text = _loc_2;
                }
                _loc_2 = param1.@icon;
                if (_loc_2)
                {
                    this.icon = _loc_2;
                }
                _loc_2 = param1.@titleColor;
                if (_loc_2)
                {
                    this.titleColor = ToolSet.convertFromHtmlColor(_loc_2);
                }
                _loc_2 = param1.@titleFontSize;
                if (_loc_2)
                {
                    this.titleFontSize = this.parseInt(_loc_2);
                }
                _loc_3 = getTextField();
                if (_loc_3 is GTextInput)
                {
                    _loc_2 = param1.@prompt;
                    if (_loc_2)
                    {
                        this.GTextInput(_loc_3).promptText = _loc_2;
                    }
                    _loc_2 = param1.@maxLength;
                    if (_loc_2)
                    {
                        this.GTextInput(_loc_3).maxLength = this.parseInt(_loc_2);
                    }
                    _loc_2 = param1.@restrict;
                    if (_loc_2)
                    {
                        this.GTextInput(_loc_3).restrict = _loc_2;
                    }
                    _loc_2 = param1.@password;
                    if (_loc_2)
                    {
                        this.GTextInput(_loc_3).password = _loc_2 == "true";
                    }
                }
            }
            return;
        }// end function

    }
}
