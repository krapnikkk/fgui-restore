package _-Gs
{
    import *.*;
    import _-Ds.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class FontInput extends GLabel
    {

        public function FontInput()
        {
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            ResourceInput(getChild("title")).isFontInput = true;
            getChild("title").addEventListener(_-Fr._-CF, this._-4f);
            getChild("preset").addClickListener(this._-Ld);
            getChild("chooseFont").addClickListener(this._-KJ);
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
            menu = editor.project.getVar("FontPresetMenu") as PopupMenu;
            if (!menu)
            {
                menu = new PopupMenu();
                menu.contentPane.width = 200;
                editor.project.setVar("FontPresetMenu", menu);
                func = function (event:ItemEvent) : void
            {
                FontInput(menu.contentPane.data).onSelectFont(event);
                return;
            }// end function
            ;
                list = editor.project.getSetting("common", "fontScheme");
                cnt = list.length;
                i;
                while (i < list.length)
                {
                    
                    s = list[i];
                    UtilsStr.trim(s);
                    n = s;
                    pos = n.indexOf(" ");
                    if (pos != -1)
                    {
                        n = n.substr((pos + 1));
                    }
                    else
                    {
                        n;
                    }
                    menu.addItem(s, func).name = n;
                    i = (i + 1);
                }
            }
            menu.contentPane.data = this;
            menu.show(this);
            return;
        }// end function

        private function onSelectFont(event:ItemEvent) : void
        {
            this.text = event.itemObject.name;
            dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

        private function _-KJ(event:Event) : void
        {
            var _loc_2:* = FairyGUIEditor._-Eb(this);
            ChooseFontDialog(_loc_2.getDialog(ChooseFontDialog)).open(this._-3K);
            return;
        }// end function

        private function _-3K(param1:String) : void
        {
            this.text = param1;
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
