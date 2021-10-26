package _-Ds
{
    import *.*;
    import _-Gs.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.publish.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import fairygui.utils.pack.*;
    import flash.events.*;
    import flash.filesystem.*;

    public class PublishDialog extends _-3g
    {
        private var _-Gh:GList;
        private var _selectedPkg:IUIPackage;
        private var _global:Controller;
        private var _-1x:_-7r;
        private var _-Gr:_-7r;
        private var _compression:GButton;
        private var _excludedList:GList;
        private var _-Pe:Array;
        private var _pkgSettingsModified:Boolean;
        private var _globalSettingsModified:Boolean;

        public function PublishDialog(param1:IEditor)
        {
            var editor:* = param1;
            super(editor);
            this.contentPane = UIPackage.createObject("Builder", "PublishDialog").asCom;
            this.centerOn(_editor.groot, true);
            this._global = contentPane.getController("global");
            this._global.addEventListener(StateChangeEvent.CHANGED, function () : void
            {
                if (save() && _global.selectedIndex == 0)
                {
                    updatePkgUI();
                }
                return;
            }// end function
            );
            this._-Gh = contentPane.getChild("pkgs").asList;
            this._-Gh.addEventListener(ItemEvent.CLICK, this._-N4);
            this._-38();
            this._-7K();
            contentPane.getChild("publish").addClickListener(this._-MU);
            contentPane.getChild("publishDesc").addClickListener(this._-EP);
            contentPane.getChild("publishAll").addClickListener(this._-82);
            contentPane.getChild("close").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_1:* = _editor.getActiveFolder().owner;
            this._-Gh.removeChildrenToPool();
            var _loc_2:* = _editor.project.allPackages;
            var _loc_3:* = 0;
            for each (_loc_4 in _loc_2)
            {
                
                _loc_5 = this._-Gh.addItemFromPool().asButton;
                _loc_5.name = _loc_4.id;
                _loc_5.title = _loc_4.name;
                _loc_5.icon = Consts.icons["package"];
                if (_loc_1 == _loc_4)
                {
                    this._-Gh.selectedIndex = _loc_3;
                }
                _loc_3++;
            }
            if (this._-Gh.selectedIndex == -1)
            {
                this._-Gh.selectedIndex = 0;
            }
            if (this._-Gh.selectedIndex != -1)
            {
                this._-Gh.scrollToView(this._-Gh.selectedIndex);
                this._selectedPkg = _editor.project.getPackage(this._-Gh.getChildAt(this._-Gh.selectedIndex).name);
                this.updatePkgUI();
            }
            else
            {
                this._selectedPkg = null;
                this._global.selectedIndex = 1;
            }
            this._-Bm();
            return;
        }// end function

        override protected function onHide() : void
        {
            this.save();
            super.onHide();
            return;
        }// end function

        private function save() : Boolean
        {
            var _loc_1:* = false;
            if (this._pkgSettingsModified)
            {
                _loc_1 = true;
                this._-4Q();
            }
            if (this._globalSettingsModified)
            {
                _loc_1 = true;
                this._-Pg();
            }
            return true;
        }// end function

        public function openOrPublish(param1:Boolean = false) : void
        {
            var _loc_2:* = _editor.getActiveFolder().owner;
            if (this._-Jg(_loc_2))
            {
                if (Preferences.publishAction == "modified")
                {
                    this._-2d(1, param1);
                }
                else if (Preferences.publishAction == "all")
                {
                    this._-2d(0, param1);
                }
                else
                {
                    this.publish(_loc_2, param1);
                }
            }
            else
            {
                show();
            }
            return;
        }// end function

        private function _-Jg(param1:IUIPackage) : Boolean
        {
            var _loc_2:* = PublishSettings(param1.publishSettings);
            if (!_loc_2.path && !param1.project.getSetting("publish", "path"))
            {
                return false;
            }
            return true;
        }// end function

        private function _-N4(event:Event) : void
        {
            this.save();
            this._selectedPkg = _editor.project.getPackage(this._-Gh.getChildAt(this._-Gh.selectedIndex).name);
            this.updatePkgUI();
            return;
        }// end function

        private function _-MU(event:Event) : void
        {
            this.save();
            this.publish(this._selectedPkg, false);
            return;
        }// end function

        private function _-EP(event:Event) : void
        {
            this.save();
            this.publish(this._selectedPkg, true);
            return;
        }// end function

        private function publish(param1:IUIPackage, param2:Boolean) : void
        {
            var pkg:* = param1;
            var onlyDesc:* = param2;
            if (Preferences.saveBeforePublish)
            {
                _editor.docView.saveAllDocuments();
                this.publish2(pkg, onlyDesc);
            }
            else
            {
                _editor.docView.queryToSaveAllDocuments(function (param1:String) : void
            {
                if (param1 != "cancel")
                {
                    publish2(pkg, onlyDesc);
                }
                return;
            }// end function
            );
            }
            return;
        }// end function

        private function publish2(param1:IUIPackage, param2:Boolean) : void
        {
            var callback:Callback;
            var pkg:* = param1;
            var onlyDesc:* = param2;
            var handler:* = new PublishHandler();
            var realThis:PublishDialog;
            callback = new Callback();
            callback.success = function () : void
            {
                _editor.closeWaiting();
                PromptDialog(_editor.getDialog(PromptDialog)).open(pkg.name + "\' " + Consts.strings.text96);
                return;
            }// end function
            ;
            callback.failed = function () : void
            {
                _editor.closeWaiting();
                _editor.alert("\'" + pkg.name + "\' " + Consts.strings.text98 + "\n\n" + callback.msgs.join("\n"));
                return;
            }// end function
            ;
            _editor.showWaiting(Consts.strings.text99 + " \'" + pkg.name + "\'...");
            try
            {
                handler.publish(pkg, pkg.project.activeBranch, null, onlyDesc, callback);
            }
            catch (err:Error)
            {
                _editor.closeWaiting();
                _editor.alert("\'" + pkg.name + "\' " + Consts.strings.text98 + "\n\n" + Consts.strings.text98, err);
            }
            return;
        }// end function

        private function _-2d(param1:int, param2:Boolean) : void
        {
            var pkgSelector:* = param1;
            var onlyDesc:* = param2;
            if (Preferences.saveBeforePublish)
            {
                _editor.docView.saveAllDocuments();
                this.publishMultiple2(pkgSelector, onlyDesc);
            }
            else
            {
                _editor.docView.queryToSaveAllDocuments(function (param1:String) : void
            {
                if (param1 != "cancel")
                {
                    publishMultiple2(pkgSelector, onlyDesc);
                }
                return;
            }// end function
            );
            }
            return;
        }// end function

        private function publishMultiple2(param1:int, param2:Boolean) : void
        {
            var pkgs:Vector.<IUIPackage>;
            var pkg:IUIPackage;
            var handler:PublishHandler;
            var bt:BulkTasks;
            var callback:Callback;
            var cancel:Function;
            var activePkg:IUIPackage;
            var pkgSelector:* = param1;
            var onlyDesc:* = param2;
            if (pkgSelector == 1)
            {
                pkgs = new Vector.<IUIPackage>;
                activePkg = _editor.getActiveFolder().owner;
                var _loc_4:* = 0;
                var _loc_5:* = _editor.project.allPackages;
                while (_loc_5 in _loc_4)
                {
                    
                    pkg = _loc_5[_loc_4];
                    if (pkg == activePkg || pkg.getVar("modifiedYetNotPublished"))
                    {
                        pkgs.push(pkg);
                    }
                }
            }
            else
            {
                pkgs = _editor.project.allPackages;
            }
            handler = new PublishHandler();
            var realThis:PublishDialog;
            bt = new BulkTasks(1);
            callback = new Callback();
            callback.success = function () : void
            {
                var _loc_1:* = IUIPackage(callback.param);
                FPackage(_loc_1).freeUnusedResources(true);
                bt.finishItem();
                bt.addErrorMsgs(callback.msgs);
                callback.msgs.length = 0;
                return;
            }// end function
            ;
            callback.failed = function () : void
            {
                pkg = IUIPackage(callback.param);
                bt.clear();
                _editor.closeWaiting();
                _editor.alert("\'" + pkg.name + "\' " + Consts.strings.text98 + "\n\n" + callback.msgs.join("\n"));
                return;
            }// end function
            ;
            cancel = function () : void
            {
                bt.clear();
                return;
            }// end function
            ;
            var task:* = function () : void
            {
                var pkg:IUIPackage;
                var ret:Boolean;
                pkg = IUIPackage(bt.taskData);
                try
                {
                    callback.param = pkg;
                    handler.publish(pkg, pkg.project.activeBranch, null, onlyDesc, callback);
                    _editor.showWaiting(Consts.strings.text99 + " \'" + pkg.name + "\'...", cancel);
                }
                catch (err:Error)
                {
                    bt.clear();
                    _editor.closeWaiting();
                    _editor.alert("\'" + pkg.name + "\' " + Consts.strings.text98 + ": " + Consts.strings.text346);
                }
                return;
            }// end function
            ;
            var _loc_4:* = 0;
            var _loc_5:* = pkgs;
            while (_loc_5 in _loc_4)
            {
                
                pkg = _loc_5[_loc_4];
                bt.addTask(task, pkg);
            }
            bt.start(function () : void
            {
                _editor.closeWaiting();
                var _loc_1:* = Consts.strings.text96;
                if (bt.errorMsgs.length > 0)
                {
                    _loc_1 = _loc_1 + ("\n\n" + Consts.strings.text97 + "\n" + bt.errorMsgs.join("\n"));
                    _editor.alert(_loc_1);
                }
                else
                {
                    PromptDialog(_editor.getDialog(PromptDialog)).open(_loc_1);
                }
                return;
            }// end function
            );
            return;
        }// end function

        private function _-82(event:Event) : void
        {
            this.save();
            this._-2d(0, false);
            return;
        }// end function

        private function _-38() : void
        {
            var gcom:* = contentPane.getChild("packageSettings").asCom;
            gcom.getChild("browse1").addClickListener(this._-6T);
            gcom.getChild("browse2").addClickListener(this._-6T);
            gcom.getChild("browse3").addClickListener(this._-6T);
            this._excludedList = gcom.getChild("excludedList").asList;
            this._excludedList.addEventListener(DropEvent.DROP, this._-Jz);
            this._excludedList.addEventListener(ItemEvent.CLICK, this._-7l);
            gcom.getChild("removeExcluded").addClickListener(this._-B5);
            gcom.getChild("openDefinition").addClickListener(function () : void
            {
                AtlasDefinitionDialog(_editor.getDialog(AtlasDefinitionDialog)).open(_selectedPkg);
                return;
            }// end function
            );
            this._-1x = new _-7r(gcom);
            this._-1x.onPropChanged = function () : void
            {
                _pkgSettingsModified = true;
                return;
            }// end function
            ;
            this._-1x._-G([{name:"pathOption", type:"bool"}, {name:"atlasOption", type:"bool"}, {name:"codePathOption", type:"bool"}, {name:"fileName", type:"string"}, {name:"path", type:"string"}, {name:"branchPath", type:"string"}, {name:"twoPackages", type:"bool"}, {name:"supportPackageCount", type:"bool", dummy:true}, {name:"maxAtlasSize", type:"string"}, {name:"paging", type:"bool"}, {name:"sizeOption", type:"string"}, {name:"square", type:"bool"}, {name:"rotation", type:"bool"}, {name:"extractAlpha", type:"bool"}, {name:"genCode", type:"bool"}, {name:"codePath", type:"string"}]);
            return;
        }// end function

        private function updatePkgUI() : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_1:* = GlobalPublishSettings(_editor.project.getSettings("publish"));
            var _loc_2:* = this._selectedPkg.project as FProject;
            var _loc_3:* = PublishSettings(this._selectedPkg.publishSettings);
            var _loc_4:* = _loc_3.atlasList[0].packSettings;
            this._-1x.owner.getController("support_atlas").selectedIndex = _loc_2.supportAtlas ? (1) : (0);
            if (_loc_3.path)
            {
                this._-1x.setValue("path", _loc_3.path);
                this._-1x.setValue("branchPath", _loc_3.branchPath);
                this._-1x.setValue("pathOption", false);
            }
            else
            {
                this._-1x.setValue("path", _loc_1.path);
                this._-1x.setValue("branchPath", _loc_1.branchPath);
                this._-1x.setValue("pathOption", true);
            }
            this._-1x.setValue("fileName", _loc_3.fileName);
            this._-1x._-Om("supportPackageCount").visible = _loc_2.zipFormatOption;
            this._-1x.setValue("twoPackages", _loc_3.packageCount == 2);
            this._-1x.setValue("atlasOption", _loc_3.useGlobalAtlasSettings);
            this._-1x.setValue("maxAtlasSize", _loc_4.maxWidth);
            this._-1x.setValue("paging", _loc_4.multiPage);
            this._-1x.setValue("sizeOption", _loc_4.pot ? ("pot") : (_loc_4.mof ? ("mof") : ("npot")));
            this._-1x.setValue("square", _loc_4.square);
            this._-1x.setValue("rotation", _loc_4.rotation);
            this._-1x.setValue("extractAlpha", _loc_3.atlasList[0].extractAlpha);
            this._-1x._-Om("extractAlpha").visible = _loc_2.supportExtractAlpha;
            this._-1x.setValue("genCode", _loc_3.genCode);
            if (_loc_3.codePath)
            {
                this._-1x.setValue("codePath", _loc_3.codePath);
                this._-1x.setValue("codePathOption", false);
            }
            else
            {
                this._-1x.setValue("codePath", _loc_1.codePath);
                this._-1x.setValue("codePathOption", true);
            }
            var _loc_7:* = _loc_3.excludedList;
            var _loc_8:* = _loc_7.length;
            this._excludedList.removeChildrenToPool();
            _loc_5 = 0;
            while (_loc_5 < _loc_8)
            {
                
                _loc_6 = this._excludedList.addItemFromPool().asButton;
                var _loc_9:* = "ui://" + this._selectedPkg.id + _loc_7[_loc_5];
                _loc_6.name = "ui://" + this._selectedPkg.id + _loc_7[_loc_5];
                _loc_6.text = _loc_9;
                _loc_5++;
            }
            this._-1x.updateUI();
            return;
        }// end function

        private function _-Gk(event:Event) : void
        {
            this._pkgSettingsModified = true;
            return;
        }// end function

        private function _-4Q() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = false;
            var _loc_8:* = null;
            var _loc_11:* = false;
            var _loc_12:* = false;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            this._pkgSettingsModified = false;
            var _loc_3:* = PublishSettings(this._selectedPkg.publishSettings);
            if (!this._-1x._-4y("pathOption"))
            {
                _loc_3.path = this._-1x._-4y("path");
                _loc_3.branchPath = this._-1x._-4y("branchPath");
            }
            else
            {
                _loc_3.path = "";
                _loc_3.branchPath = "";
            }
            _loc_3.fileName = this._-1x._-4y("fileName");
            _loc_3.packageCount = this._-1x._-4y("twoPackages") ? (2) : (1);
            var _loc_17:* = this._-1x._-4y("atlasOption");
            _loc_3.useGlobalAtlasSettings = this._-1x._-4y("atlasOption");
            var _loc_4:* = _loc_17;
            var _loc_5:* = GlobalPublishSettings(_editor.project.getSettings("publish"));
            var _loc_9:* = false;
            var _loc_10:* = false;
            if (_loc_4)
            {
                _loc_6 = _loc_5.atlasMaxSize;
                _loc_7 = _loc_5.atlasPaging;
                _loc_8 = _loc_5.atlasSizeOption;
                if (_loc_8 == "pot")
                {
                    _loc_9 = true;
                }
                else if (_loc_8 == "mof")
                {
                    _loc_10 = true;
                }
                _loc_11 = _loc_5.atlasForceSquare;
                _loc_12 = _loc_5.atlasAllowRotation;
            }
            else
            {
                _loc_6 = this._-1x._-4y("maxAtlasSize");
                _loc_7 = this._-1x._-4y("paging");
                _loc_8 = this._-1x._-4y("sizeOption");
                if (_loc_8 == "pot")
                {
                    _loc_9 = true;
                }
                else if (_loc_8 == "mof")
                {
                    _loc_10 = true;
                }
                _loc_11 = this._-1x._-4y("square");
                _loc_12 = this._-1x._-4y("rotation");
            }
            var _loc_13:* = this._-1x._-4y("extractAlpha");
            _loc_2 = _loc_3.atlasList.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                _loc_15 = _loc_3.atlasList[_loc_1];
                _loc_15.extractAlpha = _loc_13;
                _loc_16 = _loc_15.packSettings;
                _loc_16.pot = _loc_9;
                _loc_16.mof = _loc_10;
                _loc_16.square = _loc_11;
                _loc_16.rotation = _loc_12;
                var _loc_17:* = _loc_6;
                _loc_16.maxWidth = _loc_6;
                _loc_16.maxHeight = _loc_17;
                _loc_16.multiPage = _loc_7;
                _loc_1++;
            }
            _loc_3.genCode = this._-1x._-4y("genCode");
            if (!this._-1x._-4y("codePathOption"))
            {
                _loc_3.codePath = this._-1x._-4y("codePath");
            }
            else
            {
                _loc_3.codePath = "";
            }
            _loc_3.excludedList.length = 0;
            _loc_2 = this._excludedList.numChildren;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                _loc_14 = this._excludedList.getChildAt(_loc_1).asButton;
                _loc_3.excludedList.push(_loc_14.text.substr(13));
                _loc_1++;
            }
            this._selectedPkg.save();
            return;
        }// end function

        private function _-Jz(event:DropEvent) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_7:* = null;
            if (event.source != _editor.libView)
            {
                return;
            }
            var _loc_2:* = event._-LE;
            var _loc_3:* = _loc_2.length;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_3)
            {
                
                _loc_7 = _loc_2[_loc_6];
                if (this._excludedList.getChild(_loc_7.getURL()))
                {
                }
                else
                {
                    if (_loc_7.owner != this._selectedPkg)
                    {
                        _editor.alert(Consts.strings.text79);
                        return;
                    }
                    this._pkgSettingsModified = true;
                    this._excludedList.addItemFromPool().text = _loc_7.getURL();
                }
                _loc_6++;
            }
            return;
        }// end function

        private function _-7l(event:ItemEvent) : void
        {
            var _loc_2:* = null;
            if (event.clickCount == 2)
            {
                _loc_2 = _editor.project.getItemByURL(event.itemObject.text);
                if (_loc_2)
                {
                    _editor.libView.highlight(_loc_2);
                }
            }
            return;
        }// end function

        private function _-B5(event:Event) : void
        {
            var _loc_2:* = this._excludedList.selectedIndex;
            if (_loc_2 != -1)
            {
                this._excludedList.removeChildToPoolAt(_loc_2);
                if (_loc_2 >= this._excludedList.numChildren)
                {
                    _loc_2 = this._excludedList.numChildren - 1;
                }
                this._excludedList.selectedIndex = _loc_2;
                this._pkgSettingsModified = true;
            }
            return;
        }// end function

        private function _-6T(event:Event) : void
        {
            var btn:String;
            var evt:* = event;
            btn = evt.currentTarget.name;
            UtilsFile.browseForDirectory(Consts.strings.text456, function (param1:File) : void
            {
                if (btn == "browse1")
                {
                    _-1x.setValue("path", param1.nativePath);
                }
                else if (btn == "browse2")
                {
                    _-1x.setValue("codePath", param1.nativePath);
                }
                else
                {
                    _-1x.setValue("branchPath", param1.nativePath);
                }
                _-1x.updateUI();
                _pkgSettingsModified = true;
                return;
            }// end function
            );
            return;
        }// end function

        private function _-7K() : void
        {
            var gcom:* = contentPane.getChild("globalSettings").asCom;
            gcom.getChild("browse1").addClickListener(this._-1h);
            gcom.getChild("browse2").addClickListener(this._-1h);
            gcom.getChild("browse3").addClickListener(this._-1h);
            this._-Gr = new _-7r(gcom);
            this._-Gr.onPropChanged = function () : void
            {
                _globalSettingsModified = true;
                return;
            }// end function
            ;
            this._-Gr._-G([{name:"path", type:"string"}, {name:"branchPath", type:"string"}, {name:"fileExtension", type:"string"}, {name:"binaryFormat", type:"bool"}, {name:"compressDesc", type:"bool"}, {name:"twoPackages", type:"bool"}, {name:"2x", type:"bool"}, {name:"3x", type:"bool"}, {name:"4x", type:"bool"}, {name:"branchProcessing", type:"int"}, {name:"compressPNG", type:"bool"}, {name:"jpegQuality", type:"int", min:0}, {name:"maxAtlasSize", type:"string"}, {name:"paging", type:"bool"}, {name:"sizeOption", type:"string"}, {name:"square", type:"bool"}, {name:"rotation", type:"bool"}, {name:"trimImage", type:"bool"}, {name:"allowGenCode", type:"bool"}, {name:"codePath", type:"string"}, {name:"classNamePrefix", type:"string"}, {name:"memberNamePrefix", type:"string"}, {name:"ignoreNoname", type:"bool"}, {name:"getMemberByName", type:"bool"}, {name:"codePackageName", type:"string"}, {name:"codeType", type:"string", items:[Consts.strings.text138, "AS3", "TypeScript (LayaAir1.x)", "TypeScript (LayaAir2.0)", "TypeScript"], values:["", "AS3", "TS", "TS-2.0", "TS-2"]}]);
            return;
        }// end function

        private function _-Bm() : void
        {
            var _loc_1:* = GlobalPublishSettings(_editor.project.getSettings("publish"));
            var _loc_2:* = this._selectedPkg.project as FProject;
            this._-Gr.owner.getController("support_atlas").selectedIndex = _loc_2.supportAtlas ? (1) : (0);
            this._-Gr._-Om("twoPackages").visible = _loc_2.zipFormatOption;
            this._-Gr._-Om("fileExtension").enabled = _loc_2.supportCustomFileExtension;
            this._-Gr._-Om("binaryFormat").visible = _loc_2.binaryFormatOption;
            this._-Gr._-Om("compressDesc").visible = _loc_2.isH5;
            this._-Gr._-Om("codeType").enabled = _loc_2.supportCodeType;
            this._-Gr.setValue("path", _loc_1.path);
            this._-Gr.setValue("branchPath", _loc_1.branchPath);
            this._-Gr.setValue("fileExtension", _loc_1.fileExtension);
            this._-Gr.setValue("twoPackages", _loc_1.packageCount == 2);
            this._-Gr.setValue("compressDesc", _loc_1.compressDesc);
            this._-Gr.setValue("binaryFormat", _loc_1.binaryFormat);
            this._-Gr.setValue("2x", _loc_1.include2x);
            this._-Gr.setValue("3x", _loc_1.include3x);
            this._-Gr.setValue("4x", _loc_1.include4x);
            this._-Gr.setValue("branchProcessing", _loc_1.branchProcessing);
            this._-Gr.setValue("compressPNG", _loc_1.compressPNG);
            this._-Gr.setValue("jpegQuality", _loc_1.jpegQuality);
            this._-Gr.setValue("maxAtlasSize", _loc_1.atlasMaxSize);
            this._-Gr.setValue("paging", _loc_1.atlasPaging);
            this._-Gr.setValue("sizeOption", _loc_1.atlasSizeOption);
            this._-Gr.setValue("square", _loc_1.atlasForceSquare);
            this._-Gr.setValue("rotation", _loc_1.atlasAllowRotation);
            this._-Gr.setValue("trimImage", _loc_1.atlasTrimImage);
            this._-Gr.setValue("allowGenCode", _loc_1.allowGenCode);
            this._-Gr.setValue("codePath", _loc_1.codePath);
            this._-Gr.setValue("classNamePrefix", _loc_1.classNamePrefix);
            this._-Gr.setValue("memberNamePrefix", _loc_1.memberNamePrefix);
            this._-Gr.setValue("codePackageName", _loc_1.packageName);
            this._-Gr.setValue("ignoreNoname", _loc_1.ignoreNoname);
            this._-Gr.setValue("getMemberByName", _loc_1.getMemberByName);
            this._-Gr.setValue("codeType", _loc_1.codeType);
            this._-Gr.updateUI();
            return;
        }// end function

        private function _-Pg() : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            this._globalSettingsModified = false;
            var _loc_1:* = GlobalPublishSettings(_editor.project.getSettings("publish"));
            _loc_1.path = this._-Gr._-4y("path");
            _loc_1.branchPath = this._-Gr._-4y("branchPath");
            _loc_1.fileExtension = this._-Gr._-4y("fileExtension");
            _loc_1.packageCount = this._-Gr._-4y("twoPackages") ? (2) : (1);
            _loc_1.compressDesc = this._-Gr._-4y("compressDesc");
            _loc_1.binaryFormat = this._-Gr._-4y("binaryFormat");
            _loc_1.include2x = this._-Gr._-4y("2x");
            _loc_1.include3x = this._-Gr._-4y("3x");
            _loc_1.include4x = this._-Gr._-4y("4x");
            _loc_1.branchProcessing = this._-Gr._-4y("branchProcessing");
            _loc_1.compressPNG = this._-Gr._-4y("compressPNG");
            _loc_1.jpegQuality = this._-Gr._-4y("jpegQuality");
            _loc_1.atlasMaxSize = this._-Gr._-4y("maxAtlasSize");
            _loc_1.atlasPaging = this._-Gr._-4y("paging");
            _loc_1.atlasSizeOption = this._-Gr._-4y("sizeOption");
            _loc_1.atlasForceSquare = this._-Gr._-4y("square");
            _loc_1.atlasAllowRotation = this._-Gr._-4y("rotation");
            _loc_1.atlasTrimImage = this._-Gr._-4y("trimImage");
            _loc_1.allowGenCode = this._-Gr._-4y("allowGenCode");
            _loc_1.codePath = this._-Gr._-4y("codePath");
            _loc_1.classNamePrefix = this._-Gr._-4y("classNamePrefix");
            _loc_1.memberNamePrefix = this._-Gr._-4y("memberNamePrefix");
            _loc_1.packageName = this._-Gr._-4y("codePackageName");
            _loc_1.ignoreNoname = this._-Gr._-4y("ignoreNoname");
            _loc_1.getMemberByName = this._-Gr._-4y("getMemberByName");
            _loc_1.codeType = this._-Gr._-4y("codeType");
            _editor.project.saveSettings("publish");
            var _loc_2:* = _loc_1.atlasSizeOption == "pot";
            var _loc_3:* = _loc_1.atlasSizeOption == "mof";
            var _loc_4:* = this._selectedPkg.project as FProject;
            var _loc_5:* = (_loc_4).allPackages;
            for each (_loc_6 in _loc_5)
            {
                
                if (!_loc_6.opened)
                {
                    continue;
                }
                _loc_7 = PublishSettings(_loc_6.publishSettings);
                if (!_loc_7.useGlobalAtlasSettings)
                {
                    continue;
                }
                _loc_8 = _loc_7.atlasList;
                _loc_9 = 0;
                while (_loc_9 < _loc_8.length)
                {
                    
                    _loc_10 = _loc_8[_loc_9];
                    _loc_11 = _loc_10.packSettings;
                    _loc_11.pot = _loc_2;
                    _loc_11.mof = _loc_3;
                    _loc_11.square = _loc_1.atlasForceSquare;
                    _loc_11.rotation = _loc_1.atlasAllowRotation;
                    var _loc_14:* = _loc_1.atlasMaxSize;
                    _loc_11.maxWidth = _loc_1.atlasMaxSize;
                    _loc_11.maxHeight = _loc_14;
                    _loc_11.multiPage = _loc_1.atlasPaging;
                    _loc_9++;
                }
            }
            return;
        }// end function

        private function _-1h(event:Event) : void
        {
            var btn:String;
            var evt:* = event;
            btn = evt.currentTarget.name;
            UtilsFile.browseForDirectory(Consts.strings.text456, function (param1:File) : void
            {
                if (btn == "browse1")
                {
                    _-Gr.setValue("path", param1.nativePath);
                }
                else if (btn == "browse2")
                {
                    _-Gr.setValue("codePath", param1.nativePath);
                }
                else if (btn == "browse3")
                {
                    _-Gr.setValue("branchPath", param1.nativePath);
                }
                _-Gr.updateUI();
                _globalSettingsModified = true;
                return;
            }// end function
            );
            return;
        }// end function

    }
}
