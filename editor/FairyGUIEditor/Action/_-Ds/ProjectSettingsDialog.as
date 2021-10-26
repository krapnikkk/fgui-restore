package _-Ds
{
    import *.*;
    import _-Gs.*;
    import _-NY.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.net.*;

    public class ProjectSettingsDialog extends _-3g
    {
        private var _-C3:GList;
        private var _-M8:_-Gg;
        private var _-AH:GList;
        private var _branchList:GList;

        public function ProjectSettingsDialog(param1:IEditor)
        {
            var cb:GComboBox;
            var editor:* = param1;
            super(editor);
            this.contentPane = UIPackage.createObject("Builder", "ProjectSettingsDialog").asCom;
            this.centerOn(_editor.groot, true);
            cb = contentPane.getChild("scrollBarDisplay").asComboBox;
            cb.items = [Consts.strings.text91, Consts.strings.text92, Consts.strings.text93];
            cb.values = ["visible", "auto", "hidden"];
            cb = contentPane.getChild("projectType").asComboBox;
            cb.items = Consts.supportedPlatformNames;
            cb.values = Consts.supportedPlatformIds;
            this._-C3 = contentPane.getChild("customProps").asList;
            this._-M8 = new _-Gg(this._-C3);
            this._-M8._-Pt = function (param1:int, param2:GComponent) : void
            {
                renderCustomProp(param2, "", "");
                return;
            }// end function
            ;
            contentPane.getChild("addProp").addClickListener(this._-M8.add);
            contentPane.getChild("removeProp").addClickListener(this._-M8.remove);
            this._-AH = contentPane.getChild("langs").asList;
            contentPane.getChild("addLang").addClickListener(this._-Fh);
            contentPane.getChild("removeLang").addClickListener(this._-Ef);
            contentPane.getChild("newLangFile").addClickListener(this._-9D);
            contentPane.getChild("syncLangFiles").addClickListener(this._-AR);
            this._branchList = contentPane.getChild("branches").asList;
            contentPane.getChild("addBranch").addClickListener(this._-Cc);
            contentPane.getChild("editBranch").addClickListener(this._-Ca);
            contentPane.getChild("removeBranch").addClickListener(this._-Aj);
            contentPane.getChild("editDevices").addClickListener(function () : void
            {
                _editor.getDialog(DeviceEditDialog).show();
                return;
            }// end function
            );
            this.contentPane.getChild("chooseFont").addClickListener(this._-88);
            this.contentPane.getChild("ok").addClickListener(_-IJ);
            this.contentPane.getChild("apply").addClickListener(this._-2p);
            this.contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = null;
            var _loc_1:* = _editor.project as FProject;
            contentPane.getChild("projectName").text = _loc_1.name;
            contentPane.getChild("projectType").asComboBox.value = _loc_1.type;
            contentPane.getChild("disableFontAdjustment").visible = _loc_1.isH5;
            var _loc_2:* = CommonSettings(_editor.project.getSettings("common"));
            contentPane.getChild("fontName").text = _loc_2.font;
            NumericInput(contentPane.getChild("fontSize")).value = _loc_2.fontSize;
            ColorInput(contentPane.getChild("textColor")).colorValue = _loc_2.textColor;
            contentPane.getChild("disableFontAdjustment").asButton.selected = !_loc_2.fontAdjustment;
            contentPane.getChild("vtScrollBarRes").text = _loc_2.verticalScrollBar;
            contentPane.getChild("hzScrollBarRes").text = _loc_2.horizontalScrollBar;
            contentPane.getChild("scrollBarDisplay").asComboBox.value = _loc_2.defaultScrollBarDisplay;
            contentPane.getChild("tipsRes").text = _loc_2.tipsRes;
            contentPane.getChild("buttonClickSound").text = _loc_2.buttonClickSound;
            contentPane.getChild("pivot").asComboBox.value = _loc_2.pivot;
            var _loc_3:* = contentPane.getChild("quick").asCom;
            _loc_3.getChild("colorScheme").text = _loc_2.colorScheme.join("\n");
            _loc_3.getChild("fontSizeScheme").text = _loc_2.fontSizeScheme.join("\n");
            _loc_3.getChild("fontScheme").text = _loc_2.fontScheme.join("\n");
            var _loc_5:* = I18nSettings(_editor.project.getSettings("i18n"));
            this._-AH.removeChildrenToPool();
            for each (_loc_6 in _loc_5.langFiles)
            {
                
                _loc_4 = this._-AH.addItemFromPool().asCom;
                _loc_4.text = _loc_6.name;
                _loc_4.getChild("path").text = _loc_6.path;
            }
            _loc_7 = CustomProps(_editor.project.getSettings("customProps"));
            this._-C3.removeChildrenToPool();
            for (_loc_8 in _loc_7.all)
            {
                
                this.renderCustomProp(this._-C3.addItemFromPool().asCom, _loc_8, _loc_15[_loc_8]);
            }
            _loc_9 = AdaptationSettings(_editor.project.getSettings("adaptation"));
            contentPane.getChild("scaleMode").asComboBox.value = _loc_9.scaleMode;
            contentPane.getChild("screenMatchMode").asComboBox.value = _loc_9.screenMathMode;
            contentPane.getChild("designResolutionX").text = "" + _loc_9.designResolutionX;
            contentPane.getChild("designResolutionY").text = "" + _loc_9.designResolutionY;
            _loc_10 = _editor.project.allBranches;
            this._branchList.removeChildrenToPool();
            _loc_11 = _loc_10.length;
            _loc_12 = 0;
            while (_loc_12 < _loc_11)
            {
                
                _loc_4 = this._branchList.addItemFromPool().asCom;
                _loc_13 = ListItemInput(_loc_4.getChild("branchName"));
                _loc_13._-Fw = 0;
                _loc_13.text = _loc_10[_loc_12];
                _loc_12++;
            }
            return;
        }// end function

        override public function _-2a() : void
        {
            this._-2p(null);
            hide();
            return;
        }// end function

        public function openFontSettings() : void
        {
            show();
            contentPane.getController("c1").selectedIndex = 1;
            return;
        }// end function

        public function openScrollBarSettings() : void
        {
            show();
            contentPane.getController("c1").selectedIndex = 1;
            return;
        }// end function

        public function openAdaptationSettings() : void
        {
            show();
            contentPane.getController("c1").selectedIndex = 3;
            return;
        }// end function

        public function openLangSettings() : void
        {
            show();
            contentPane.getController("c1").selectedIndex = 5;
            return;
        }// end function

        public function openBranchSettings() : void
        {
            show();
            contentPane.getController("c1").selectedIndex = 4;
            return;
        }// end function

        private function renderCustomProp(param1:GComponent, param2:String, param3:String) : void
        {
            param1.getChild("text").text = param2;
            param1.getChild("value").text = param3;
            return;
        }// end function

        private function _-88(event:Event) : void
        {
            ChooseFontDialog(_editor.getDialog(ChooseFontDialog)).open(this._-1w);
            return;
        }// end function

        private function _-1w(param1:String) : void
        {
            contentPane.getChild("fontName").text = param1;
            return;
        }// end function

        private function _-Fh(event:Event) : void
        {
            var evt:* = event;
            UtilsFile.browseForOpen(Consts.strings.text316, [new FileFilter(Consts.strings.text316, "*.xml")], function (param1:File) : void
            {
                var _loc_2:* = _-AH.addItemFromPool().asCom;
                _loc_2.text = UtilsStr.getFileName(param1.name);
                _loc_2.getChild("path").text = new File(_editor.project.basePath).getRelativePath(param1, true).replace(/\\/g, "/");
                return;
            }// end function
            , new File(_editor.project.basePath));
            return;
        }// end function

        private function _-Ef(event:Event) : void
        {
            var _loc_2:* = this._-AH.selectedIndex;
            if (_loc_2 != -1)
            {
                this._-AH.removeChildToPoolAt(_loc_2);
            }
            return;
        }// end function

        private function _-9D(event:Event) : void
        {
            var evt:* = event;
            UtilsFile.browseForSave(Consts.strings.text316, function (param1:File) : void
            {
                var handler:_-HQ;
                var btn:GComponent;
                var file:* = param1;
                _editor.cursorManager.setWaitCursor(true);
                try
                {
                    handler = new _-HQ(_editor);
                    handler.parse(_editor.project.allPackages);
                    handler._-51(file, false);
                    btn = _-AH.addItemFromPool().asCom;
                    btn.text = UtilsStr.getFileName(file.name);
                    btn.getChild("path").text = new File(_editor.project.basePath).getRelativePath(file, true).replace(/\\/g, "/");
                }
                catch (err:Error)
                {
                    _editor.alert(null, err);
                }
                _editor.cursorManager.setWaitCursor(false);
                return;
            }// end function
            , new File(_editor.project.basePath));
            return;
        }// end function

        private function _-AR(event:Event) : void
        {
            var handler:_-HQ;
            var folder:File;
            var i:int;
            var item:GComponent;
            var path:String;
            var file:File;
            var evt:* = event;
            var cnt:* = this._-AH.numChildren;
            if (cnt == 0)
            {
                return;
            }
            _editor.cursorManager.setWaitCursor(true);
            try
            {
                handler = new _-HQ(_editor);
                handler.parse(_editor.project.allPackages, true);
                folder = new File(_editor.project.basePath);
                i;
                while (i < cnt)
                {
                    
                    item = this._-AH.getChildAt(i).asCom;
                    path = item.getChild("path").text;
                    file = folder.resolvePath(path);
                    if (file.exists && !file.isDirectory)
                    {
                        handler._-51(file, true);
                    }
                    i = (i + 1);
                }
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
            }
            _editor.cursorManager.setWaitCursor(false);
            return;
        }// end function

        private function _-Cc(event:Event) : void
        {
            var evt:* = event;
            _editor.input(Consts.strings.text446, "", function (param1:String) : void
            {
                _editor.project.createBranch(param1);
                var _loc_2:* = _branchList.addItemFromPool().asCom;
                var _loc_3:* = ListItemInput(_loc_2.getChild("branchName"));
                _loc_3._-Fw = 0;
                _loc_3.text = param1;
                return;
            }// end function
            );
            return;
        }// end function

        private function _-Aj(event:Event) : void
        {
            var index:int;
            var branchName:String;
            var evt:* = event;
            index = this._branchList.selectedIndex;
            if (index == -1)
            {
                return;
            }
            var item:* = this._branchList.getChildAt(index).asCom;
            var input:* = ListItemInput(item.getChild("branchName"));
            branchName = input.text;
            _editor.confirm(UtilsStr.formatString(Consts.strings.text448, branchName), function (param1:String) : void
            {
                if (param1 == "ok")
                {
                    _editor.project.removeBranch(branchName);
                    _branchList.removeChildToPoolAt(index);
                }
                return;
            }// end function
            );
            return;
        }// end function

        private function _-Ca(event:Event) : void
        {
            var _loc_2:* = this._branchList.selectedIndex;
            if (_loc_2 == -1)
            {
                return;
            }
            var _loc_3:* = this._branchList.getChildAt(_loc_2).asCom;
            var _loc_4:* = ListItemInput(_loc_3.getChild("branchName"));
            _loc_4.data = _loc_4.text;
            _loc_4.addEventListener(_-Fr._-CF, this._-Kg);
            _loc_4.startEditing();
            return;
        }// end function

        private function _-Kg(event:Event) : void
        {
            var _loc_2:* = this._branchList.selectedIndex;
            var _loc_3:* = this._branchList.getChildAt(_loc_2).asCom;
            var _loc_4:* = event.currentTarget.text;
            _editor.project.renameBranch(event.currentTarget.data, _loc_4);
            return;
        }// end function

        private function _-2p(event:Event) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_13:* = null;
            var _loc_17:* = null;
            var _loc_2:* = _editor.project as FProject;
            var _loc_3:* = CommonSettings(_editor.project.getSettings("common"));
            _loc_4 = contentPane.getChild("fontName").text;
            if (_loc_4 != _loc_3.font)
            {
                var _loc_18:* = _loc_2;
                var _loc_19:* = _loc_2._globalFontVersion + 1;
                _loc_18._globalFontVersion = _loc_19;
                _loc_3.font = _loc_4;
            }
            _loc_3.fontSize = NumericInput(contentPane.getChild("fontSize")).value;
            _loc_3.textColor = ColorInput(contentPane.getChild("textColor")).colorValue;
            var _loc_8:* = !contentPane.getChild("disableFontAdjustment").asButton.selected;
            if (!contentPane.getChild("disableFontAdjustment").asButton.selected != _loc_3.fontAdjustment)
            {
                var _loc_18:* = _loc_2;
                var _loc_19:* = _loc_2._globalFontVersion + 1;
                _loc_18._globalFontVersion = _loc_19;
                _loc_3.fontAdjustment = _loc_8;
            }
            var _loc_9:* = contentPane.getChild("projectType").asComboBox.value;
            var _loc_10:* = _loc_2.type != _loc_9;
            _loc_2.type = _loc_9;
            _loc_3.verticalScrollBar = contentPane.getChild("vtScrollBarRes").text;
            _loc_3.horizontalScrollBar = contentPane.getChild("hzScrollBarRes").text;
            _loc_3.defaultScrollBarDisplay = contentPane.getChild("scrollBarDisplay").asComboBox.value;
            _loc_3.tipsRes = contentPane.getChild("tipsRes").text;
            _loc_3.buttonClickSound = contentPane.getChild("buttonClickSound").text;
            _loc_3.pivot = contentPane.getChild("pivot").asComboBox.value;
            var _loc_11:* = contentPane.getChild("quick").asCom;
            _loc_4 = _loc_11.getChild("colorScheme").text;
            _loc_4 = UtilsStr.trim(_loc_4);
            _loc_4 = _loc_4.replace(/\r\n/g, "\n");
            _loc_4 = _loc_4.replace(/\r/g, "\n");
            _loc_3.colorScheme = _loc_4.split("\n");
            _loc_4 = _loc_11.getChild("fontSizeScheme").text;
            _loc_4 = UtilsStr.trim(_loc_4);
            _loc_4 = _loc_4.replace(/\r\n/g, "\n");
            _loc_4 = _loc_4.replace(/\r/g, "\n");
            _loc_3.fontSizeScheme = _loc_4.split("\n");
            _loc_4 = _loc_11.getChild("fontScheme").text;
            _loc_4 = UtilsStr.trim(_loc_4);
            _loc_4 = _loc_4.replace(/\r\n/g, "\n");
            _loc_4 = _loc_4.replace(/\r/g, "\n");
            _loc_3.fontScheme = _loc_4.split("\n");
            var _loc_12:* = CustomProps(_editor.project.getSettings("customProps"));
            for (_loc_13 in _loc_12.all)
            {
                
                delete _loc_19[_loc_13];
            }
            _loc_5 = this._-C3.numChildren;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = this._-C3.getChildAt(_loc_6).asCom;
                _loc_13 = _loc_7.getChild("text").text;
                _loc_17 = _loc_7.getChild("value").text;
                _loc_13 = UtilsStr.trim(_loc_13);
                if (_loc_13.length > 0)
                {
                    _loc_19[_loc_13] = _loc_17;
                }
                _loc_6++;
            }
            var _loc_14:* = I18nSettings(_editor.project.getSettings("i18n"));
            _loc_14.langFiles.length = 0;
            _loc_5 = this._-AH.numChildren;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = this._-AH.getChildAt(_loc_6).asCom;
                _loc_14.langFiles.push({name:_loc_7.getChild("title").text, path:_loc_7.getChild("path").text});
                _loc_6++;
            }
            var _loc_15:* = AdaptationSettings(_editor.project.getSettings("adaptation"));
            _loc_15.scaleMode = contentPane.getChild("scaleMode").asComboBox.value;
            _loc_15.screenMathMode = contentPane.getChild("screenMatchMode").asComboBox.value;
            _loc_15.designResolutionX = parseInt(contentPane.getChild("designResolutionX").text);
            _loc_15.designResolutionY = parseInt(contentPane.getChild("designResolutionY").text);
            _editor.project.saveSettings("common");
            _editor.project.saveSettings("customProps");
            _editor.project.saveSettings("adaptation");
            _editor.project.saveSettings("i18n");
            var _loc_16:* = UtilsStr.trim(contentPane.getChild("projectName").text);
            if (UtilsStr.trim(contentPane.getChild("projectName").text) != _loc_2.name)
            {
                _loc_2.rename(_loc_16);
            }
            _loc_2.save();
            _loc_2.setChanged();
            if (_loc_10)
            {
                _-1L(_editor).plugInManager.load();
            }
            _-1L(_editor).mainView.fillLanguages();
            if (_editor.testView.running)
            {
                _editor.testView.reload();
            }
            _editor.nativeWindow.title = _loc_2.name;
            return;
        }// end function

    }
}
