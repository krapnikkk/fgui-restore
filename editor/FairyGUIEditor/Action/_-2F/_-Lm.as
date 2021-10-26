package _-2F
{
    import *.*;
    import _-Ds.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.net.*;

    public class _-Lm extends Object
    {
        private var _editor:IEditor;
        private var _-OZ:IMenu;
        private var _-MP:IMenu;
        private var _-JQ:IMenu;
        private var _-Le:IMenu;
        private var _-6H:IMenu;
        private var _-GO:IMenu;
        private var _-L9:IMenu;
        private var _-CO:IMenu;
        private var _-JF:IMenu;
        private var _-IU:int;

        public function _-Lm(param1:IEditor, param2:IMenu)
        {
            this._editor = param1;
            this._-JF = param2;
            this._-OZ = this._-JF.createMenu(250);
            this._-MP = this._-JF.createMenu(250);
            this._-JQ = this._-JF.createMenu(280, this._-4l);
            this._-Le = this._-JF.createMenu(250);
            this._-6H = this._-JF.createMenu(250);
            this._-GO = this._-JF.createMenu(200, this._-1R);
            this._-L9 = this._-JF.createMenu(250);
            this.setup();
            return;
        }// end function

        public function get root() : IMenu
        {
            return this._-JF;
        }// end function

        public function _-Jm() : void
        {
            this._-JF.addItem(Consts.isMacOS ? (Consts.strings.text84) : (Consts.strings.text43), "app", null, null, -1, this._-OZ);
            return;
        }// end function

        public function _-Jp() : void
        {
            if (!Consts.isMacOS)
            {
                this._-JF.removeItem("app");
            }
            this._-JF.addItem(Consts.strings.text43, "file", null, null, -1, this._-MP);
            this._-JF.addItem(Consts.strings.text173, "edit", null, null, -1, this._-JQ);
            this._-JF.addItem(Consts.strings.text106, "assets", null, null, -1, this._-Le);
            this._-JF.addItem(Consts.strings.text200, "tool", null, null, -1, this._-6H);
            this._-JF.addItem(Consts.strings.text414, "view", null, null, -1, this._-GO);
            this._-JF.addItem(Consts.strings.text45, "help", null, null, -1, this._-L9);
            return;
        }// end function

        private function setup() : void
        {
            this._-OZ.addItem(Consts.strings.text44 + "...", null, function () : void
            {
                _editor.getDialog(AboutDialog).show();
                return;
            }// end function
            );
            if (!_-D._-8J)
            {
                this._-OZ.addItem(Consts.strings.text375 + "...", null, function () : void
            {
                _editor.getDialog(RegisterDialog).show();
                return;
            }// end function
            );
            }
            this._-OZ.addItem(Consts.strings.text67 + "...", null, function () : void
            {
                _-3n.start(_editor);
                return;
            }// end function
            );
            this._-OZ.addSeperator();
            this._-OZ.addItem(Consts.strings.text42, "preferences", function () : void
            {
                _editor.getDialog(PreferencesDialog).show();
                return;
            }// end function
            );
            this._-OZ.addSeperator();
            this._-OZ.addItem(Consts.strings.text83, "quit", function () : void
            {
                FairyGUIEditor._-A9();
                return;
            }// end function
            );
            this._-MP.addItem(Consts.strings.text34 + "...", null, function () : void
            {
                _editor.docView.queryToSaveAllDocuments(function (param1:String) : void
                {
                    if (param1 != "cancel")
                    {
                        _editor.getDialog(CreateProjectDialog).show();
                    }
                    return;
                }// end function
                );
                return;
            }// end function
            );
            this._-MP.addItem(Consts.strings.text311, null, function () : void
            {
                FairyGUIEditor._-BW(null);
                return;
            }// end function
            );
            this._-MP.addItem(Consts.strings.text35 + "...", null, function () : void
            {
                _editor.docView.queryToSaveAllDocuments(function (param1:String) : void
                {
                    var ret:* = param1;
                    UtilsFile.browseForOpen(Consts.strings.text35, [new FileFilter(Consts.strings.text314, "*.fairy")], function (param1:File) : void
                    {
                        _editor.openProject(param1.nativePath);
                        return;
                    }// end function
                    );
                    return;
                }// end function
                );
                return;
            }// end function
            );
            this._-CO = this._-MP.createMenu(200, this._-4t);
            this._-MP.addItem(Consts.strings.text432, "recent", null, null, -1, this._-CO);
            this._-MP.addSeperator();
            this._-MP.addItem(Consts.strings.text37 + "...", "projectSettings", function () : void
            {
                _editor.getDialog(ProjectSettingsDialog).show();
                return;
            }// end function
            );
            this._-MP.addItem(Consts.strings.text41 + "...", "publishSettings", function () : void
            {
                _editor.getDialog(PublishDialog).show();
                return;
            }// end function
            );
            this._-MP.addSeperator();
            this._-MP.addItem(Consts.strings.text36, null, function () : void
            {
                _editor.docView.queryToSaveAllDocuments(function (param1:String) : void
                {
                    if (param1 != "cancel")
                    {
                        _editor.closeProject();
                    }
                    return;
                }// end function
                );
                return;
            }// end function
            );
            this._-MP.addItem(Consts.strings.text226, null, function () : void
            {
                _editor.docView.queryToSaveAllDocuments(function (param1:String) : void
                {
                    if (param1 != "cancel")
                    {
                        _editor.queryToClose();
                    }
                    return;
                }// end function
                );
                return;
            }// end function
            );
            this._-JQ.addItem(Consts.strings.text107, "undo", function () : void
            {
                var _loc_1:* = _editor.docView.activeDocument;
                if (_loc_1 != null)
                {
                    _loc_1.history.undo();
                }
                return;
            }// end function
            , "Ctrl+Z");
            this._-JQ.addItem(Consts.strings.text108, "redo", function () : void
            {
                var _loc_1:* = _editor.docView.activeDocument;
                if (_loc_1 != null)
                {
                    _loc_1.history.redo();
                }
                return;
            }// end function
            , "Ctrl+Y");
            this._-JQ.addSeperator();
            this._-JQ.addItem(Consts.strings.text1, "cut", function () : void
            {
                var _loc_1:* = _editor.docView.activeDocument;
                if (_loc_1 != null)
                {
                    _loc_1.copySelection();
                    _loc_1.deleteSelection();
                }
                return;
            }// end function
            , "Ctrl+X");
            this._-JQ.addItem(Consts.strings.text2, "copy", function () : void
            {
                var _loc_1:* = _editor.docView.activeDocument;
                if (_loc_1 != null)
                {
                    _loc_1.copySelection();
                }
                return;
            }// end function
            , "Ctrl+C");
            this._-JQ.addItem(Consts.strings.text104, "paste", function (event:Event) : void
            {
                var _loc_2:* = _editor.docView.activeDocument;
                if (_loc_2 != null)
                {
                    _loc_2.paste(null, true);
                }
                return;
            }// end function
            , "Ctrl+V");
            this._-JQ.addItem(Consts.strings.text105, "paste2", function () : void
            {
                var _loc_1:* = _editor.docView.activeDocument;
                if (_loc_1 != null)
                {
                    _loc_1.paste(null, false);
                }
                return;
            }// end function
            , "Ctrl+Shift+V");
            this._-JQ.addItem(Consts.strings.text4, "delete", function () : void
            {
                var _loc_1:* = _editor.docView.activeDocument;
                if (_loc_1 != null)
                {
                    _loc_1.deleteSelection();
                }
                return;
            }// end function
            , "Backspace");
            this._-JQ.addSeperator();
            this._-JQ.addItem(Consts.strings.text5, "selectAll", function () : void
            {
                var _loc_1:* = _editor.docView.activeDocument;
                if (_loc_1 != null)
                {
                    _loc_1.selectAll();
                }
                return;
            }// end function
            , "Ctrl+A");
            this._-JQ.addItem(Consts.strings.text23, "unselectAll", function () : void
            {
                var _loc_1:* = _editor.docView.activeDocument;
                if (_loc_1 != null)
                {
                    _loc_1.unselectAll();
                }
                return;
            }// end function
            , "Ctrl+Shift+A");
            if (!Consts.isMacOS)
            {
                this._-JQ.addSeperator();
                this._-JQ.addItem(Consts.strings.text42, "preferences", function () : void
            {
                _editor.getDialog(PreferencesDialog).show();
                return;
            }// end function
            );
            }
            this._-Le.addItem(Consts.strings.text38 + "..", "createPackage", function () : void
            {
                _editor.getDialog(CreatePackageDialog).show();
                return;
            }// end function
            );
            this._-Le.addItem(Consts.strings.text174 + "...", "createCom", function () : void
            {
                _editor.getDialog(CreateComDialog).show();
                return;
            }// end function
            , "Ctrl+F8");
            this._-Le.addItem(Consts.strings.text175 + "...", "createButton", function () : void
            {
                _editor.getDialog(CreateButtonDialog).show();
                return;
            }// end function
            );
            this._-Le.addItem(Consts.strings.text176 + "...", "createLabel", function () : void
            {
                _editor.getDialog(CreateLabelDialog).show();
                return;
            }// end function
            );
            this._-Le.addItem(Consts.strings.text177 + "...", "createComboBox", function () : void
            {
                _editor.getDialog(CreateComboBoxDialog).show();
                return;
            }// end function
            );
            this._-Le.addItem(Consts.strings.text178 + "...", "createScrollBar", function () : void
            {
                _editor.getDialog(CreateScrollBarDialog).show();
                return;
            }// end function
            );
            this._-Le.addItem(Consts.strings.text179 + "...", "createProgressBar", function () : void
            {
                _editor.getDialog(CreateProgressBarDialog).show();
                return;
            }// end function
            );
            this._-Le.addItem(Consts.strings.text180 + "...", "createSlider", function () : void
            {
                _editor.getDialog(CreateSliderDialog).show();
                return;
            }// end function
            );
            this._-Le.addItem(Consts.strings.text240 + "...", "createPopupMenu", function () : void
            {
                _editor.getDialog(CreatePopupMenuDialog).show();
                return;
            }// end function
            );
            this._-Le.addItem(Consts.strings.text244 + "...", "createMovieClip", function () : void
            {
                _editor.getDialog(CreateMovieClipDialog).show();
                return;
            }// end function
            );
            this._-Le.addItem(Consts.strings.text19 + "...", "createFont", function () : void
            {
                _editor.getDialog(CreateFontDialog).show();
                return;
            }// end function
            );
            this._-Le.addItem(Consts.strings.text381 + "...", "createWindowFrame", function () : void
            {
                _editor.getDialog(CreateWindowFrameDialog).show();
                return;
            }// end function
            );
            this._-Le.addSeperator();
            this._-Le.addItem(Consts.strings.text320 + "...", null, this._-P);
            this._-Le.addItem(Consts.strings.text339 + "...", null, this._-L8);
            this._-Le.addItem(Consts.strings.text321 + "...", null, this._-I2);
            this._-Le.addSeperator();
            this._-Le.addItem(Consts.strings.text181 + "...", "import", this._-42, "Ctrl+R");
            this._-6H.addItem(Consts.strings.text183 + "...", "strings", function () : void
            {
                _editor.getDialog(StringsFunctionDialog).show();
                return;
            }// end function
            );
            this._-6H.addSeperator();
            this._-6H.addItem(Consts.strings.text195 + "...", "plugins", function () : void
            {
                _editor.getDialog(PlugInManageDialog).show();
                return;
            }// end function
            );
            this._-L9.addItem(Consts.strings.text373, null, function () : void
            {
                navigateToURL(new URLRequest("https://www.fairygui.com/docs/guide/index.html"));
                return;
            }// end function
            );
            this._-L9.addItem(Consts.strings.text374, null, function () : void
            {
                var _loc_1:* = null;
                if (Consts.language == "zh-CN")
                {
                    _loc_1 = "https://ask.fairygui.com/";
                }
                else
                {
                    _loc_1 = "https://github.com/fairygui/FairyGUI-Editor/issues";
                }
                navigateToURL(new URLRequest(_loc_1));
                return;
            }// end function
            );
            if (!Consts.isMacOS)
            {
                if (!_-D._-8J)
                {
                    this._-L9.addItem(Consts.strings.text375 + "...", null, function () : void
            {
                _editor.getDialog(RegisterDialog).show();
                return;
            }// end function
            );
                }
                this._-L9.addItem(Consts.strings.text67 + "...", null, function () : void
            {
                _-3n.start(_editor);
                return;
            }// end function
            );
                this._-L9.addSeperator();
                this._-L9.addItem(Consts.strings.text44 + "...", null, function () : void
            {
                _editor.getDialog(AboutDialog).show();
                return;
            }// end function
            );
            }
            return;
        }// end function

        private function _-4l(event:Event) : void
        {
            var _loc_3:* = false;
            var _loc_4:* = false;
            var _loc_2:* = this._editor.docView.activeDocument;
            if (_loc_2 != null)
            {
                _loc_3 = _loc_2.getSelection().length == 0;
                _loc_4 = _loc_2.canPaste();
                this._-JQ.setItemEnabled("undo", _loc_2.history.canUndo());
                this._-JQ.setItemEnabled("redo", _loc_2.history.canRedo());
                this._-JQ.setItemEnabled("copy", !_loc_3);
                this._-JQ.setItemEnabled("cut", !_loc_3);
                this._-JQ.setItemEnabled("paste", _loc_4);
                this._-JQ.setItemEnabled("paste2", _loc_4);
                this._-JQ.setItemEnabled("delete", !_loc_3);
                this._-JQ.setItemEnabled("selectAll", true);
                this._-JQ.setItemEnabled("unselectAll", !_loc_3);
            }
            else
            {
                this._-JQ.setItemEnabled("undo", false);
                this._-JQ.setItemEnabled("redo", false);
                this._-JQ.setItemEnabled("copy", false);
                this._-JQ.setItemEnabled("cut", false);
                this._-JQ.setItemEnabled("paste", false);
                this._-JQ.setItemEnabled("paste2", false);
                this._-JQ.setItemEnabled("delete", false);
                this._-JQ.setItemEnabled("selectAll", false);
                this._-JQ.setItemEnabled("unselectAll", false);
            }
            return;
        }// end function

        private function _-1R(event:Event) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_2:* = this._editor.viewManager.viewIds;
            if (this._-IU != _loc_2.length)
            {
                this._-GO.clearItems();
                this._-IU = _loc_2.length;
                _loc_3 = 0;
                while (_loc_3 < this._-IU)
                {
                    
                    _loc_4 = _loc_2[_loc_3];
                    _loc_5 = this._editor.viewManager.getView(_loc_4);
                    if (_loc_5 == this._editor.docView || _loc_5 == this._editor.testView)
                    {
                    }
                    else
                    {
                        this._-GO.addItem(_loc_5.data.title, _loc_4, this._-Bk);
                    }
                    _loc_3++;
                }
                this._-GO.addSeperator();
                this._-GO.addItem(Consts.strings.text89, null, this._-Mu);
            }
            _loc_3 = 0;
            while (_loc_3 < this._-IU)
            {
                
                _loc_4 = _loc_2[_loc_3];
                _loc_5 = this._editor.viewManager.getView(_loc_4);
                if (_loc_5 == this._editor.docView || _loc_5 == this._editor.testView)
                {
                }
                else
                {
                    this._-GO.setItemChecked(_loc_4, this._editor.viewManager.isViewShowing(_loc_4));
                }
                _loc_3++;
            }
            return;
        }// end function

        private function _-4t(event:Event) : void
        {
            var rl:int;
            var j:int;
            var i:int;
            var path:String;
            var evt:* = event;
            this._-CO.clearItems();
            var recentListData:* = LocalStore.data.recent_project;
            if (!recentListData || recentListData.length == 0)
            {
                this._-CO.addItem(Consts.strings.text331, null, this._-4g);
            }
            else
            {
                rl = recentListData.length / 2;
                j;
                i = (rl - 1);
                while (i >= 0)
                {
                    
                    path = recentListData[i * 2 + 1];
                    try
                    {
                        if (!new File(path).exists)
                        {
                        }
                        else
                        {
                        }
                        catch (err:Error)
                        {
                            ;
                        }
                        this._-CO.addItem(recentListData[i * 2], "" + i, this._-4g);
                    }
                    i = (i - 1);
                }
            }
            return;
        }// end function

        private function _-Bk(event:Event) : void
        {
            var _loc_2:* = null;
            if (event is ItemEvent)
            {
                _loc_2 = ItemEvent(event).itemObject.name;
            }
            else
            {
                _loc_2 = event.currentTarget.name;
            }
            if (this._editor.viewManager.isViewShowing(_loc_2))
            {
                this._editor.viewManager.hideView(_loc_2);
            }
            else
            {
                this._editor.viewManager.showView(_loc_2);
            }
            return;
        }// end function

        private function _-P(event:Event) : void
        {
            var evt:* = event;
            UtilsFile.browseForOpen("FairyGUI package", [new FileFilter("FairyGUI package", "*.fairypackage")], function (param1:File) : void
            {
                ImportPackageDialog(_editor.getDialog(ImportPackageDialog)).open(param1);
                return;
            }// end function
            );
            return;
        }// end function

        private function _-L8(event:Event) : void
        {
            var evt:* = event;
            UtilsFile.browseForOpen("FairyGUI package", [new FileFilter("FairyGUI package", "*.fairypackage")], function (param1:File) : void
            {
                ImportPackageDialog(_editor.getDialog(ImportPackageDialog)).open(param1);
                return;
            }// end function
            , File.applicationDirectory.resolvePath("standard assets"));
            return;
        }// end function

        private function _-I2(event:Event) : void
        {
            this._editor.getDialog(ExportPackageDialog).show();
            return;
        }// end function

        private function _-42(event:Event) : void
        {
            var _loc_2:* = this._editor.getActiveFolder();
            if (!_loc_2)
            {
                return;
            }
            this._editor.libView.showImportResourcesDialog(_loc_2.owner, _loc_2.id);
            return;
        }// end function

        private function _-4g(event:Event) : void
        {
            var name:String;
            var path:String;
            var evt:* = event;
            if (evt is ItemEvent)
            {
                name = ItemEvent(evt).itemObject.name;
            }
            else
            {
                name = evt.currentTarget.name;
            }
            if (!name)
            {
                return;
            }
            var index:* = parseInt(name);
            path = LocalStore.data.recent_project[index * 2 + 1];
            this._editor.docView.queryToSaveAllDocuments(function (param1:String) : void
            {
                if (param1 != "cancel")
                {
                    _editor.openProject(path);
                }
                return;
            }// end function
            );
            return;
        }// end function

        private function _-Mu(event:Event) : void
        {
            this._editor.viewManager.resetLayout();
            return;
        }// end function

    }
}
