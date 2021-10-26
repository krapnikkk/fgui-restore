package _-Ds
{
    import *.*;
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;
    import flash.events.*;

    public class PreferencesDialog extends _-3g
    {
        private var _-DS:GList;
        private var _-Ek:GComponent;

        public function PreferencesDialog(param1:IEditor)
        {
            var cb:GComboBox;
            var func:Object;
            var btn:GButton;
            var editor:* = param1;
            super(editor);
            this.contentPane = UIPackage.createObject("Builder", "PreferencesDialog").asCom;
            this.centerOn(_editor.groot, true);
            cb = contentPane.getChild("language").asComboBox;
            cb.items = Consts.supportedLangNames;
            cb.values = Consts.supportedLanaguages;
            cb = contentPane.getChild("checkNewVersion").asComboBox;
            cb.items = [Consts.strings.text317, Consts.strings.text318, Consts.strings.text319];
            cb.values = ["auto", "ask", "disabled"];
            this._-DS = contentPane.getChild("functionList").asList;
            var _loc_3:* = 0;
            var _loc_4:* = _-44._-KK;
            while (_loc_4 in _loc_3)
            {
                
                func = _loc_4[_loc_3];
                btn = this._-DS.addItemFromPool().asButton;
                btn.getChild("desc").text = func.desc;
                btn.name = func.id;
            }
            this._-DS.addEventListener(TextEvent.LINK, this._-Pm);
            this._-Ek = UIPackage.createObject("Builder", "HotkeyDefinePanel").asCom;
            this._-Ek.getChild("ok").addClickListener(this._-HH);
            this._-Ek.getChild("reset").addClickListener(this._-HH);
            this._-Ek.getChild("cancel").addClickListener(function () : void
            {
                _editor.groot.hidePopup(_-Ek);
                return;
            }// end function
            );
            contentPane.getChild("resetHotkeys").addClickListener(this._-25);
            contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            contentPane.getChild("language").asComboBox.value = Preferences.language;
            contentPane.getChild("checkNewVersion").asComboBox.value = Preferences.checkNewVersion;
            contentPane.getChild("publishAction").asComboBox.value = Preferences.publishAction;
            contentPane.getChild("saveBeforePublish").asComboBox.selectedIndex = Preferences.saveBeforePublish ? (1) : (0);
            this._-Ml();
            return;
        }// end function

        override protected function onHide() : void
        {
            super.onHide();
            Preferences.language = contentPane.getChild("language").asComboBox.value;
            Preferences.checkNewVersion = contentPane.getChild("checkNewVersion").asComboBox.value;
            Preferences.publishAction = contentPane.getChild("publishAction").asComboBox.value;
            Preferences.saveBeforePublish = contentPane.getChild("saveBeforePublish").asComboBox.selectedIndex == 1;
            Preferences.save();
            return;
        }// end function

        public function swallowKeyEvent(event:KeyboardEvent) : Boolean
        {
            var _loc_2:* = null;
            if (this._-Ek.parent)
            {
                _loc_2 = _-44._-1q(event);
                if (_loc_2 != null)
                {
                    _loc_2 = _loc_2.replace("CMD", "⌘");
                    this._-Ek.getChild("hotkey").text = _loc_2;
                }
                return true;
            }
            else
            {
                return false;
            }
        }// end function

        private function _-Ml() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_1:* = this._-DS.numChildren;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this._-DS.getChildAt(_loc_2).asButton;
                _loc_4 = _-44._-KK[_loc_2];
                _loc_3.text = this._-Ah(_loc_4, !UtilsStr.startsWith(_loc_4.id, "00"));
                _loc_2++;
            }
            return;
        }// end function

        private function _-Ah(param1:Object, param2:Boolean) : String
        {
            var _loc_3:* = null;
            if (param1.hotkey)
            {
                _loc_3 = param1.hotkey;
                if (Consts.isMacOS)
                {
                    _loc_3 = _loc_3.replace("CTRL", "⌘");
                    _loc_3 = _loc_3.replace("CMD", "⌘");
                }
            }
            else
            {
                _loc_3 = Consts.strings.text345;
            }
            if (!param2)
            {
                return _loc_3;
            }
            _loc_3 = "[url=event:" + param1.id + "]" + _loc_3 + "[/url]";
            if (param1.hotkey != param1.origin_hotkey)
            {
                _loc_3 = "[color=#D19036]" + _loc_3 + "[/color]";
            }
            else if (!param1.hotkey)
            {
                _loc_3 = "[color=#A0A0A0]" + _loc_3 + "[/color]";
            }
            return _loc_3;
        }// end function

        private function _-Pm(event:TextEvent) : void
        {
            var _loc_2:* = event.text;
            this._-Ek.data = _loc_2;
            this._-Ek.getChild("hotkey").text = "";
            _editor.groot.showPopup(this._-Ek);
            return;
        }// end function

        private function _-HH(event:Event) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = String(this._-Ek.data);
            var _loc_3:* = _-44._-PY[_loc_2];
            if (event.currentTarget.name == "ok")
            {
                _loc_4 = this._-Ek.getChild("hotkey").text;
                _-44._-3A(_loc_2, _loc_4);
            }
            else
            {
                _-44._-4x(_loc_2);
            }
            _editor.groot.hidePopup(this._-Ek);
            this._-DS.getChild(_loc_2).text = this._-Ah(_loc_3, true);
            return;
        }// end function

        private function _-25(event:Event) : void
        {
            var evt:* = event;
            _editor.confirm(Consts.strings.text347, function () : void
            {
                _-44.resetAll();
                _-Ml();
                return;
            }// end function
            );
            return;
        }// end function

    }
}
