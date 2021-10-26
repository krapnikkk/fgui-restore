package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class ColorInput extends GButton
    {
        private var _-6C:uint;
        private var _-3h:Number;
        private var _-9B:Boolean;

        public function ColorInput()
        {
            this._-9B = false;
            this._-3h = 1;
            return;
        }// end function

        public function get colorValue() : uint
        {
            return this._-6C;
        }// end function

        public function set colorValue(param1:uint) : void
        {
            this._-6C = param1;
            this.update();
            return;
        }// end function

        public function get alphaValue() : Number
        {
            return this._-3h;
        }// end function

        public function set alphaValue(param1:Number) : void
        {
            this._-3h = param1;
            this.update();
            return;
        }// end function

        public function set argb(param1:uint) : void
        {
            if (this._-9B)
            {
                this._-3h = (param1 >> 24 & 255) / 255;
            }
            else
            {
                this._-3h = 1;
            }
            this._-6C = param1 & 16777215;
            this.update();
            return;
        }// end function

        public function get argb() : uint
        {
            if (this._-9B)
            {
                return (Math.round(this._-3h * 255) << 24) + this._-6C;
            }
            return this._-6C;
        }// end function

        public function set showAlpha(param1:Boolean) : void
        {
            this._-9B = param1;
            return;
        }// end function

        public function get showAlpha() : Boolean
        {
            return this._-9B;
        }// end function

        private function update() : void
        {
            getChild("n1").asGraph.drawRect(1, 0, 1, this._-6C, this._-3h);
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            var _loc_2:* = getChild("arrow");
            if (_loc_2)
            {
                _loc_2.addEventListener(GTouchEvent.BEGIN, this._-6Z);
            }
            addEventListener(GTouchEvent.BEGIN, this.__click);
            this.update();
            return;
        }// end function

        private function _-2r(event:Event) : void
        {
            this.update();
            this.dispatchEvent(event);
            return;
        }// end function

        private function __click(event:Event) : void
        {
            var _loc_2:* = FairyGUIEditor._-Eb(this);
            var _loc_3:* = _loc_2.project.getVar("ColorPicker") as ColorPicker;
            if (_loc_3 == null)
            {
                _loc_3 = new ColorPicker(_loc_2);
                _loc_2.project.setVar("ColorPicker", _loc_3);
            }
            _loc_3.show(this, GObject(event.currentTarget), this._-6C, this._-3h, this._-9B);
            return;
        }// end function

        private function _-6Z(event:Event) : void
        {
            var menu:PopupMenu;
            var func:Function;
            var list:Array;
            var cnt:int;
            var i:int;
            var s:String;
            var n:String;
            var pos:int;
            var btn:GButton;
            var evt:* = event;
            evt.stopPropagation();
            var editor:* = FairyGUIEditor._-Eb(this);
            menu = editor.project.getVar("ColorPresetMenu") as PopupMenu;
            if (!menu)
            {
                menu = new PopupMenu();
                menu.contentPane.width = 200;
                menu.list.defaultItem = "ui://Basic/ColorMenuItem";
                editor.project.setVar("ColorPresetMenu", menu);
                func = function (event:ItemEvent) : void
            {
                ColorInput(menu.contentPane.data).__selectColor(event);
                return;
            }// end function
            ;
                list = editor.project.getSetting("common", "colorScheme");
                cnt = list.length;
                i;
                while (i < cnt)
                {
                    
                    s = list[i];
                    UtilsStr.trim(s);
                    n = s;
                    pos = n.lastIndexOf(" ");
                    if (pos != -1)
                    {
                        n = n.substr((pos + 1));
                    }
                    btn = menu.addItem(s, func);
                    btn.name = n;
                    btn.getChild("shape").asGraph.color = UtilsStr.convertFromHtmlColor(n, false);
                    i = (i + 1);
                }
            }
            menu.contentPane.data = this;
            menu.show(this);
            return;
        }// end function

        private function __selectColor(event:ItemEvent) : void
        {
            this.colorValue = UtilsStr.convertFromHtmlColor(event.itemObject.name, false);
            dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

    }
}
