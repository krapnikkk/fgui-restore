package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class FontSizeInput extends GLabel
    {
        private var _input:NumericInput;

        public function FontSizeInput()
        {
            return;
        }// end function

        public function get value() : Number
        {
            return this._input.value;
        }// end function

        public function set value(param1:Number) : void
        {
            this._input.value = param1;
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._input = NumericInput(getChild("title"));
            this._input.min = 0;
            this._input.addEventListener(_-Fr._-CF, this._-4f);
            getChild("btn").addClickListener(this._-Ld);
            return;
        }// end function

        private function _-Ld(event:Event) : void
        {
            var menu:PopupMenu;
            var func:Function;
            var list:Array;
            var cnt:int;
            var i:int;
            var s:String;
            var n:String;
            var pos:int;
            var evt:* = event;
            var editor:* = FairyGUIEditor._-Eb(this);
            menu = editor.project.getVar("FontSizePresetMenu") as PopupMenu;
            if (!menu)
            {
                menu = new PopupMenu();
                menu.contentPane.width = 200;
                editor.project.setVar("FontSizePresetMenu", menu);
                func = function (event:ItemEvent) : void
            {
                FontSizeInput(menu.contentPane.data).__selectSize(event);
                return;
            }// end function
            ;
                list = editor.project.getSetting("common", "fontSizeScheme");
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
                    menu.addItem(s, func).name = n;
                    i = (i + 1);
                }
            }
            menu.contentPane.data = this;
            menu.show(this);
            return;
        }// end function

        private function __selectSize(event:ItemEvent) : void
        {
            this.value = parseInt(event.itemObject.name);
            dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

        private function _-4f(event:Event) : void
        {
            this.dispatchEvent(event);
            return;
        }// end function

    }
}
