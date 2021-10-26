package _-Gs
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.desktop.*;
    import flash.events.*;
    import flash.text.*;
    import flash.ui.*;

    public class ResourceInput extends GLabel
    {
        protected var _-3L:GTextField;
        protected var _-1V:String;
        protected var _-5N:Controller;
        protected var _-5C:uint;
        public var isFontInput:Boolean;

        public function ResourceInput()
        {
            return;
        }// end function

        override public function set text(param1:String) : void
        {
            super.text = param1;
            this.update();
            return;
        }// end function

        private function update() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = this.text;
            if (_loc_1)
            {
                if (UtilsStr.startsWith(_loc_1, "ui://"))
                {
                    _loc_2 = FairyGUIEditor._-Eb(this);
                    if (!_loc_2)
                    {
                        return;
                    }
                    _loc_3 = _loc_2.project.getItemByURL(_loc_1);
                    if (_loc_3 != null)
                    {
                        this._-3L.text = _loc_3.name + " @" + _loc_3.owner.name;
                        this.icon = _loc_3.getIcon();
                        this._-3L.color = this._-5C;
                    }
                    else
                    {
                        this._-3L.text = _loc_1;
                        this._-3L.color = this._-5C;
                        this.icon = Consts.icons.res_error;
                    }
                }
                else
                {
                    this._-3L.text = _loc_1;
                    this._-3L.color = this._-5C;
                    this.icon = null;
                }
            }
            else
            {
                if (this.isFontInput)
                {
                    _loc_2 = FairyGUIEditor._-Eb(this);
                    if (!_loc_2)
                    {
                        return;
                    }
                    this._-3L.text = _loc_2.project.getSetting("common", "font");
                }
                else if (!this.grayed)
                {
                    this._-3L.text = Consts.strings.text61;
                }
                else
                {
                    this._-3L.text = "";
                }
                this._-3L.color = 9803157;
                this.icon = null;
            }
            if (this.icon == null)
            {
                if (this._-3L.x > 10)
                {
                    this._-3L.width = this._-3L.width + 18;
                }
                this._-3L.x = 2;
            }
            else
            {
                if (this._-3L.x < 10)
                {
                    this._-3L.width = this._-3L.width - 18;
                }
                this._-3L.x = 20;
            }
            return;
        }// end function

        override protected function handleGrayedChanged() : void
        {
            super.handleGrayedChanged();
            this.update();
            return;
        }// end function

        private function _-G6(event:DropEvent) : void
        {
            var _loc_4:* = null;
            if (!(event.source is ILibraryView))
            {
                return;
            }
            if (!this.enabled || !this.editable)
            {
                return;
            }
            var _loc_2:* = event._-LE;
            var _loc_3:* = _loc_2[0];
            if (_loc_3 is FPackageItem)
            {
                _loc_4 = FPackageItem(_loc_3);
                if (_loc_4.type != "folder")
                {
                    this.text = "ui://" + _loc_4.owner.id + _loc_4.id;
                    this.dispatchEvent(new _-Fr(_-Fr._-CF));
                }
            }
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this._-5N = getController("c1");
            this._-5N.selectedIndex = 1;
            this._-3L = getChild("nameText").asTextField;
            this._-3L.text = Consts.strings.text61;
            this._-5C = this._-3L.color;
            this._-3L.color = 9803157;
            this._-3L.x = 2;
            this._-3L.width = this._-3L.width + 18;
            this._titleObject.addEventListener(FocusEvent.FOCUS_IN, this.__focusIn);
            this._titleObject.addEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
            this._titleObject.addEventListener(KeyboardEvent.KEY_DOWN, this._-6W);
            addClickListener(this.__click);
            addEventListener(MouseEvent.RIGHT_CLICK, this._-Oq);
            addEventListener(DropEvent.DROP, this._-G6);
            return;
        }// end function

        private function __focusIn(event:Event) : void
        {
            this._-1V = this.text;
            return;
        }// end function

        private function __focusOut(event:Event) : void
        {
            this._-5N.selectedIndex = 1;
            if (this._-1V != this.text)
            {
                this.update();
                this.dispatchEvent(new _-Fr(_-Fr._-CF));
            }
            return;
        }// end function

        private function _-6W(event:KeyboardEvent) : void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                this.__focusOut(null);
            }
            else if (event.keyCode == Keyboard.ESCAPE)
            {
                this._titleObject.text = this._-1V;
                this._-5N.selectedIndex = 1;
            }
            return;
        }// end function

        protected function __click(event:GTouchEvent) : void
        {
            if (!this.enabled)
            {
                return;
            }
            this._-5N.selectedIndex = 0;
            this.root.nativeStage.focus = this._titleObject.displayObject as TextField;
            return;
        }// end function

        private function _-Oq(event:Event) : void
        {
            var menu:PopupMenu;
            var evt:* = event;
            evt.stopPropagation();
            var editor:* = FairyGUIEditor._-Eb(this);
            menu = editor.project.getVar("ResourceInputMenu") as PopupMenu;
            if (!menu)
            {
                menu = new PopupMenu();
                menu.addItem(Consts.strings.text62, function (event:ItemEvent) : void
            {
                ResourceInput(menu.contentPane.data).__showInLib(event);
                return;
            }// end function
            );
                menu.addItem(Consts.strings.text230, function (event:ItemEvent) : void
            {
                ResourceInput(menu.contentPane.data).__open(event);
                return;
            }// end function
            );
                menu.addItem(Consts.strings.text63, function (event:ItemEvent) : void
            {
                ResourceInput(menu.contentPane.data).__copyURL(event);
                return;
            }// end function
            );
                menu.addItem(Consts.strings.text64, function (event:ItemEvent) : void
            {
                ResourceInput(menu.contentPane.data).__clear(event);
                return;
            }// end function
            ).name = "clear";
                editor.project.setVar("ResourceInputMenu", menu);
            }
            menu.contentPane.data = this;
            menu.setItemGrayed("clear", !this.enabled);
            menu.show(editor.groot);
            return;
        }// end function

        private function __showInLib(event:ItemEvent) : void
        {
            var _loc_2:* = this.text;
            if (!UtilsStr.startsWith(_loc_2, "ui://"))
            {
                return;
            }
            var _loc_3:* = FairyGUIEditor._-Eb(this);
            var _loc_4:* = _loc_3.project.getItemByURL(_loc_2);
            if (_loc_3.project.getItemByURL(_loc_2))
            {
                _loc_3.libView.highlight(_loc_4);
            }
            return;
        }// end function

        private function __open(event:ItemEvent) : void
        {
            var _loc_2:* = this.text;
            if (!UtilsStr.startsWith(_loc_2, "ui://"))
            {
                return;
            }
            var _loc_3:* = FairyGUIEditor._-Eb(this);
            var _loc_4:* = _loc_3.project.getItemByURL(_loc_2);
            if (_loc_3.project.getItemByURL(_loc_2) != null)
            {
                _loc_3.libView.openResource(_loc_4);
            }
            return;
        }// end function

        private function __copyURL(event:ItemEvent) : void
        {
            var _loc_2:* = this.text;
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _loc_2);
            return;
        }// end function

        private function __clear(event:ItemEvent) : void
        {
            this.text = "";
            dispatchEvent(new _-Fr(_-Fr._-CF));
            return;
        }// end function

    }
}
