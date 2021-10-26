package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.desktop.*;
    import flash.events.*;

    public class ChooseFontDialog extends _-3g
    {
        private var _callback:Function;
        private var _list:GList;
        private var _-k:Array;

        public function ChooseFontDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "ChooseFontDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._list = contentPane.getChild("list").asList;
            this._list.addEventListener(ItemEvent.CLICK, this.__clickItem);
            this._list.itemRenderer = this.renderListItem;
            this._list.setVirtual();
            contentPane.getChild("globalSetting").addClickListener(this._-Gl);
            contentPane.getChild("select").addClickListener(_-IJ);
            contentPane.getChild("copy").addClickListener(this._-EA);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        public function open(param1:Function) : void
        {
            this._callback = param1;
            show();
            return;
        }// end function

        override protected function onShown() : void
        {
            if (!this._-k)
            {
                _editor.cursorManager.setWaitCursor(true);
                this._-k = FontInfoReader.enumerateFonts();
                this._list.numItems = this._-k.length;
                _editor.cursorManager.setWaitCursor(false);
            }
            return;
        }// end function

        override public function _-2a() : void
        {
            var _loc_1:* = this._callback;
            this._callback = null;
            var _loc_2:* = this._list.selectedIndex;
            if (_loc_2 < 0)
            {
                _loc_2 = 0;
            }
            this._loc_1(this._-k[_loc_2].family);
            this.hide();
            return;
        }// end function

        private function renderListItem(param1:int, param2:GObject) : void
        {
            var _loc_3:* = this._-k[param1];
            if (_loc_3.localeFamily)
            {
                param2.text = _loc_3.family;
            }
            else
            {
                param2.text = _loc_3.family;
            }
            var _loc_4:* = param2.asCom.getChild("title2");
            _loc_4.text = _loc_3.localeFamily;
            var _loc_5:* = param2.asCom.getChild("demo").asTextField;
            _loc_5.font = _loc_3.family;
            _loc_5.text = Consts.strings.text241;
            return;
        }// end function

        private function __clickItem(event:ItemEvent) : void
        {
            if (event.clickCount == 2)
            {
                this._-2a();
            }
            return;
        }// end function

        private function _-Gl(event:Event) : void
        {
            this.hide();
            ProjectSettingsDialog(_editor.getDialog(ProjectSettingsDialog)).openFontSettings();
            return;
        }// end function

        private function _-EA(event:Event) : void
        {
            var _loc_2:* = this._list.selectedIndex;
            if (_loc_2 < 0)
            {
                _loc_2 = 0;
            }
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this._-k[_loc_2].family);
            this.hide();
            return;
        }// end function

    }
}
