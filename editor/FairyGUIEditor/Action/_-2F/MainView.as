package _-2F
{
    import *.*;
    import _-Ds.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.net.*;

    public class MainView extends Object
    {
        private var _editor:IEditor;
        private var _panel:GComponent;
        private var _-NO:GComponent;
        private var _-Pq:GComboBox;
        private var _-Or:CanvasSettingsPanel;
        private var _-Nc:GList;
        private var _-Gn:Controller;
        private var _-4D:GComboBox;

        public function MainView(param1:IEditor)
        {
            var editor:* = param1;
            this._editor = editor;
            this._panel = UIPackage.createObject("Builder", "MainView").asCom;
            var startScene:* = this._panel.getChild("startScene").asCom;
            startScene.addEventListener(TextEvent.LINK, this._-LX);
            this._-Nc = startScene.getChild("recentList").asList;
            this._-NO = this._panel.getChild("newVersionPrompt").asCom;
            this._-NO.getChild("upgrade").addClickListener(this._-My);
            this._-NO.getChild("later").addClickListener(this._-ON);
            this._-NO.getChild("notes").addClickListener(this._-Ly);
            this._-Or = new CanvasSettingsPanel(this._editor);
            var viewScaleCombo:* = this._panel.getChild("viewScale").asComboBox;
            viewScaleCombo.items = ["25%", "50%", "75%", "100%", "125%", "150%", "175%", "200%", "300%", "400%", "800%"];
            viewScaleCombo.selectedIndex = 3;
            viewScaleCombo.visibleItemCount = 20;
            this._-Pq = this._panel.getChild("branches").asComboBox;
            this._-Pq.addEventListener(StateChangeEvent.CHANGED, this._-Ig);
            this._-Gn = this._panel.getController("test");
            this._panel.getChild("tbCreatePkg").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(CreatePackageDialog).show();
                return;
            }// end function
            );
            this._panel.getChild("tbCreateCom").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(CreateComDialog).show();
                return;
            }// end function
            );
            this._panel.getChild("tbCreateLabel").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(CreateLabelDialog).show();
                return;
            }// end function
            );
            this._panel.getChild("tbCreateButton").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(CreateButtonDialog).show();
                return;
            }// end function
            );
            this._panel.getChild("tbCreateProgressBar").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(CreateProgressBarDialog).show();
                return;
            }// end function
            );
            this._panel.getChild("tbCreateSlider").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(CreateSliderDialog).show();
                return;
            }// end function
            );
            this._panel.getChild("tbCreateComboBox").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(CreateComboBoxDialog).show();
                return;
            }// end function
            );
            this._panel.getChild("tbCreateFont").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(CreateFontDialog).show();
                return;
            }// end function
            );
            this._panel.getChild("tbCreateMc").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(CreateMovieClipDialog).show();
                return;
            }// end function
            );
            this._panel.getChild("tbImport").addClickListener(function (event:Event) : void
            {
                _editor.libView.showImportResourcesDialog();
                return;
            }// end function
            );
            this._panel.getChild("tbSave").addClickListener(function (event:Event) : void
            {
                _editor.docView.saveDocument();
                return;
            }// end function
            );
            this._panel.getChild("tbSaveAll").addClickListener(function (event:Event) : void
            {
                _editor.docView.saveAllDocuments();
                return;
            }// end function
            );
            this._panel.getChild("tbTest").addClickListener(function (event:Event) : void
            {
                _editor.testView.start();
                return;
            }// end function
            );
            this._panel.getChild("tbPublish").addClickListener(function (event:Event) : void
            {
                PublishDialog(_editor.getDialog(PublishDialog)).openOrPublish();
                return;
            }// end function
            );
            this._panel.getChild("tbPublishDesc").addClickListener(function (event:Event) : void
            {
                PublishDialog(_editor.getDialog(PublishDialog)).openOrPublish(true);
                return;
            }// end function
            );
            this._panel.getChild("tbPublishSettings").addClickListener(function (event:Event) : void
            {
                _editor.getDialog(PublishDialog).show();
                return;
            }// end function
            );
            this._panel.getChild("tbCanvas").addClickListener(function (event:Event) : void
            {
                _-Or.show(GObject(event.currentTarget));
                return;
            }// end function
            );
            this._panel.getChild("tbStopTest").addClickListener(function (event:Event) : void
            {
                _editor.testView.stop();
                return;
            }// end function
            );
            this._panel.getChild("tbReload").addClickListener(function (event:Event) : void
            {
                _editor.testView.reload();
                return;
            }// end function
            );
            this._panel.getChild("tbLang").addClickListener(function (event:Event) : void
            {
                ProjectSettingsDialog(_editor.getDialog(ProjectSettingsDialog)).openLangSettings();
                return;
            }// end function
            );
            this._panel.getChild("tbBranch").addClickListener(function (event:Event) : void
            {
                ProjectSettingsDialog(_editor.getDialog(ProjectSettingsDialog)).openBranchSettings();
                return;
            }// end function
            );
            this._-4D = this._panel.getChild("lang").asComboBox;
            this._-4D.addEventListener(StateChangeEvent.CHANGED, this._-AN);
            this._panel.getChild("userInfo").addClickListener(function () : void
            {
                _editor.getDialog(RegisterNoticeDialog).show();
                return;
            }// end function
            );
            this._editor.on(EditorEvent.ProjectOpened, this.onLoad);
            this._editor.on(EditorEvent.PackageListChanged, this._-LK);
            this._editor.on(EditorEvent.TestStart, function () : void
            {
                _-Gn.selectedIndex = 1;
                return;
            }// end function
            );
            this._editor.on(EditorEvent.TestStop, function () : void
            {
                _-Gn.selectedIndex = 0;
                return;
            }// end function
            );
            if (_-3n.newVersionPrompt)
            {
                _-3n.newVersionPrompt = false;
                GTimers.inst.add(3000, 1, this._-8t);
            }
            return;
        }// end function

        public function get panel() : GComponent
        {
            return this._panel;
        }// end function

        private function onLoad() : void
        {
            this.updateUserInfo();
            this._-92();
            this.fillLanguages();
            return;
        }// end function

        public function updateUserInfo() : void
        {
            this._panel.getChild("userInfo").asCom.getController("c1").selectedIndex = _-D._-8J ? (1) : (0);
            return;
        }// end function

        private function _-LK() : void
        {
            this._-92();
            return;
        }// end function

        public function _-8t() : void
        {
            this._-NO.getController("c1").selectedIndex = 0;
            this._-NO.text = UtilsStr.formatString(Consts.strings.text228, _-3n._-l.version_name);
            this._panel.getTransition("newVersionShow").play();
            return;
        }// end function

        public function _-Ib() : void
        {
            this._-NO.getController("c1").selectedIndex = 1;
            this._-NO.text = Consts.strings.text229;
            this._panel.getTransition("newVersionShow").play();
            return;
        }// end function

        public function _-5M() : void
        {
            this._-NO.getController("c1").selectedIndex = 2;
            this._-NO.text = Consts.strings.text68;
            this._panel.getTransition("newVersionShow").play();
            GTimers.inst.add(2000, 1, this._panel.getTransition("newVersionHide").play);
            return;
        }// end function

        private function _-My(event:Event) : void
        {
            if (this._-NO.getController("c1").selectedIndex == 1)
            {
                FairyGUIEditor._-GC();
                return;
            }
            this._-NO.visible = false;
            GTimers.inst.add(200, 1, _-3n._-3q, this._editor);
            return;
        }// end function

        private function _-ON(event:Event) : void
        {
            this._panel.getTransition("newVersionHide").play();
            return;
        }// end function

        private function _-Ly(event:Event) : void
        {
            var _loc_2:* = null;
            if (Consts.language == "zh-CN")
            {
                _loc_2 = "https://www.fairygui.com/release_notes.html";
            }
            else
            {
                _loc_2 = "https://en.fairygui.com/release_notes.html";
            }
            navigateToURL(new URLRequest(_loc_2));
            return;
        }// end function

        private function _-Ig(event:Event) : void
        {
            this._editor.project.activeBranch = this._-Pq.value;
            if (this._editor.testView.running)
            {
                this._editor.testView.reload();
            }
            return;
        }// end function

        private function _-92() : void
        {
            var _loc_4:* = null;
            var _loc_1:* = [];
            var _loc_2:* = [];
            _loc_1.push(Consts.strings.text419);
            _loc_2.push("");
            var _loc_3:* = this._editor.project.allBranches;
            for each (_loc_4 in _loc_3)
            {
                
                _loc_1.push(_loc_4);
                _loc_2.push(_loc_4);
            }
            this._-Pq.items = _loc_1;
            this._-Pq.values = _loc_2;
            this._-Pq.value = this._editor.project.activeBranch;
            return;
        }// end function

        public function _-Hb() : void
        {
            this._panel.getController("start").selectedIndex = 1;
            this._-2Y();
            return;
        }// end function

        private function _-2Y() : void
        {
            var path:String;
            var item:GButton;
            this._-Nc.removeChildrenToPool();
            var recentListData:* = LocalStore.data.recent_project;
            if (!recentListData)
            {
                recentListData;
            }
            if (recentListData.length % 2 != 0)
            {
                recentListData.length = 0;
                delete LocalStore.data.recent_project;
            }
            var rl:* = recentListData.length / 2;
            var j:int;
            var i:* = (rl - 1);
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
                    item = this._-Nc.addItemFromPool().asButton;
                    j = (j + 1);
                    item.title = "[url=event:" + j + "]" + recentListData[i * 2] + "[/url]";
                    item.getChild("path").text = path;
                    item.getChild("delete").addClickListener(this._-Ky);
                    item.data = path;
                }
                i = (i - 1);
            }
            return;
        }// end function

        private function _-Ky(event:Event) : void
        {
            var _loc_2:* = this._-Nc.getChildIndex(event.currentTarget.parent);
            var _loc_3:* = String(this._-Nc.getChildAt(_loc_2).data);
            var _loc_4:* = LocalStore.data.recent_project;
            if (!LocalStore.data.recent_project)
            {
                _loc_4 = [];
            }
            var _loc_5:* = _loc_4.indexOf(_loc_3);
            if (_loc_4.indexOf(_loc_3) != -1)
            {
                _loc_4.splice((_loc_5 - 1), 2);
            }
            LocalStore.data.recent_project = _loc_4;
            LocalStore.setDirty("recent_project");
            this._-2Y();
            return;
        }// end function

        private function _-LX(event:TextEvent) : void
        {
            var index:int;
            var path:String;
            var evt:* = event;
            var cmd:* = evt.text;
            if (cmd == "create")
            {
                this._editor.getDialog(CreateProjectDialog).show();
            }
            else if (cmd == "open")
            {
                UtilsFile.browseForOpen(Consts.strings.text35, [new FileFilter(Consts.strings.text314, "*.fairy")], function (param1:File) : void
            {
                _editor.openProject(param1.nativePath);
                return;
            }// end function
            );
            }
            else if (cmd == "open_folder")
            {
                UtilsFile.browseForDirectory(Consts.strings.text35, function (param1:File) : void
            {
                _editor.openProject(param1.nativePath);
                return;
            }// end function
            );
            }
            else
            {
                index = parseInt(cmd);
                path = String(this._-Nc.getChildAt(index).data);
                this._editor.openProject(path);
            }
            return;
        }// end function

        public function _-L4(param1:String) : Boolean
        {
            if (!this._editor.project)
            {
                return false;
            }
            switch(param1)
            {
                case "0101":
                {
                    this._editor.getDialog(CreateComDialog).show();
                    break;
                }
                case "0102":
                {
                    this._editor.getDialog(CreateButtonDialog).show();
                    break;
                }
                case "0103":
                {
                    this._editor.getDialog(CreateLabelDialog).show();
                    break;
                }
                case "0104":
                {
                    this._editor.getDialog(CreateComboBoxDialog).show();
                    break;
                }
                case "0105":
                {
                    this._editor.getDialog(CreateScrollBarDialog).show();
                    break;
                }
                case "0106":
                {
                    this._editor.getDialog(CreateProgressBarDialog).show();
                    break;
                }
                case "0107":
                {
                    this._editor.getDialog(CreateSliderDialog).show();
                    break;
                }
                case "0108":
                {
                    this._editor.getDialog(CreatePopupMenuDialog).show();
                    break;
                }
                case "0109":
                {
                    this._editor.getDialog(CreateMovieClipDialog).show();
                    break;
                }
                case "0110":
                {
                    this._editor.getDialog(CreateFontDialog).show();
                    break;
                }
                case "0111":
                {
                    this._editor.libView.showImportResourcesDialog();
                    break;
                }
                case "0112":
                {
                    this._editor.docView.saveDocument();
                    break;
                }
                case "0113":
                {
                    this._editor.docView.saveAllDocuments();
                    break;
                }
                case "0114":
                {
                    this._editor.docView.queryToCloseDocument();
                    break;
                }
                case "0116":
                {
                    this._editor.getDialog(CreatePackageDialog).show();
                    break;
                }
                case "0118":
                {
                    this._editor.getDialog(PublishDialog).show();
                    break;
                }
                case "0119":
                {
                    this._editor.getDialog(ProjectSettingsDialog).show();
                    break;
                }
                case "0121":
                {
                    this._editor.testView.start();
                    break;
                }
                case "0122":
                {
                    PublishDialog(this._editor.getDialog(PublishDialog)).openOrPublish();
                    break;
                }
                case "0123":
                {
                    PublishDialog(this._editor.getDialog(PublishDialog)).openOrPublish(true);
                    break;
                }
                case "0127":
                {
                    this._editor.docView.queryToCloseOtherDocuments();
                    break;
                }
                case "0128":
                {
                    this._editor.docView.queryToCloseAllDocuments();
                    break;
                }
                default:
                {
                    return false;
                    break;
                }
            }
            return true;
        }// end function

        public function fillLanguages() : void
        {
            var _loc_1:* = I18nSettings(this._editor.project.getSettings("i18n"));
            _loc_1.fillCombo(this._-4D);
            return;
        }// end function

        private function _-AN(event:Event) : void
        {
            var _loc_2:* = I18nSettings(this._editor.project.getSettings("i18n"));
            _loc_2.langFileName = this._-4D.value;
            if (_loc_2.langFile && !_loc_2.langFile.exists)
            {
                this._editor.alert(Consts.strings.text287 + ": " + this._-4D.value);
            }
            else if (this._editor.testView.running)
            {
                this._editor.testView.reload();
            }
            return;
        }// end function

    }
}

import *.*;

import _-Ds.*;

import __AS3__.vec.*;

import fairygui.*;

import fairygui.editor.*;

import fairygui.editor.api.*;

import fairygui.editor.settings.*;

import fairygui.event.*;

import fairygui.utils.*;

import flash.events.*;

import flash.filesystem.*;

import flash.net.*;

class CanvasSettingsPanel extends Object
{
    private var _editor:IEditor;
    private var _panel:GComponent;
    private var _form:_-7r;

    function CanvasSettingsPanel(param1:IEditor)
    {
        this._editor = param1;
        this._panel = UIPackage.createObject("Builder", "CanvasSettingsPanel").asCom;
        this._form = new _-7r(this._panel);
        this._form.onPropChanged = this.onPropChanged;
        this._form._-G([{name:"backgroundColor", type:"uint", showAlpha:false}, {name:"canvasColor", type:"uint", showAlpha:false}, {name:"auxline1", type:"bool"}, {name:"auxline2", type:"bool"}, {name:"docScaleOption", type:"bool"}]);
        return;
    }// end function

    private function onPropChanged(param1:String, param2, param3) : void
    {
        this._editor.workspaceSettings.set(param1, param2);
        this._editor.emit(EditorEvent.BackgroundChanged);
        return;
    }// end function

    public function show(param1:GObject) : void
    {
        this._form.setValue("backgroundColor", this._editor.workspaceSettings.get("backgroundColor"));
        this._form.setValue("canvasColor", this._editor.workspaceSettings.get("canvasColor"));
        this._form.setValue("auxline1", this._editor.workspaceSettings.get("auxline1"));
        this._form.setValue("auxline2", this._editor.workspaceSettings.get("auxline2"));
        this._form.setValue("docScaleOption", this._editor.workspaceSettings.get("docScaleOption"));
        this._form.updateUI();
        this._editor.groot.showPopup(this._panel, param1);
        return;
    }// end function

}

