package fairygui.editor
{
    import *.*;
    import _-2F.*;
    import _-6v.*;
    import _-An.*;
    import _-Ds.*;
    import _-Gs.*;
    import _-NY.*;
    import _-Pz.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.plugin.*;
    import fairygui.editor.settings.*;
    import fairygui.event.*;
    import fairygui.utils.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class _-1L extends Sprite implements IEditor
    {
        private var _docView:DocumentView;
        private var _-Bd:LibraryView;
        private var _-NL:InspectorView;
        private var _-3o:TestView;
        private var _-Bt:PreviewView;
        private var _-2P:TimelineView;
        private var _-IR:ConsoleView;
        private var _-8L:ReferenceView;
        private var _-G8:MainView;
        private var _-4S:_-2t;
        private var _-N9:_-OH;
        private var _-K8:_-LG;
        private var _-Kz:_-Lm;
        private var _-JN:PlugInManager;
        private var _-PT:_-PC;
        private var _-Cv:ProjectRefreshHandler;
        private var _-C6:NativeWindow;
        private var _-8P:GRoot;
        private var _project:FProject;
        private var _-EN:_-Al;
        private var _-1p:Dictionary;
        private var _-7n:Boolean;
        private var _-PZ:Boolean;
        private var _-KP:WorkspaceSettings;
        private var _dispatcher:SEventDispatcher;
        private var _-OD:CombineKeyHelper;
        private var _focusedObject:GComponent;
        private var _-I7:GComponent;
        private var _-7P:Boolean;
        private var _-8v:int;
        private var _-9V:String;
        private var _-Mt:int;
        private var _-Mj:int;
        private var _-2G:int;

        public function _-1L()
        {
            return;
        }// end function

        public function get nativeWindow() : NativeWindow
        {
            return this._-C6;
        }// end function

        public function get groot() : GRoot
        {
            return this._-8P;
        }// end function

        public function get mainPanel() : GComponent
        {
            return this._-G8.panel;
        }// end function

        public function get project() : IUIProject
        {
            return this._project;
        }// end function

        public function get workspaceSettings() : IWorkspaceSettings
        {
            return this._-KP;
        }// end function

        public function get focusedView() : GComponent
        {
            return this._focusedObject;
        }// end function

        public function get active() : Boolean
        {
            return this._-7n;
        }// end function

        public function get mainView() : MainView
        {
            return this._-G8;
        }// end function

        public function get docView() : IDocumentView
        {
            return this._docView;
        }// end function

        public function get libView() : ILibraryView
        {
            return this._-Bd;
        }// end function

        public function get inspectorView() : IInspectorView
        {
            return this._-NL;
        }// end function

        public function get testView() : ITestView
        {
            return this._-3o;
        }// end function

        public function get timelineView() : ITimelineView
        {
            return this._-2P;
        }// end function

        public function get consoleView() : IConsoleView
        {
            return this._-IR;
        }// end function

        public function get menu() : IMenu
        {
            return this._-Kz.root;
        }// end function

        public function get viewManager() : IViewManager
        {
            return this._-4S;
        }// end function

        public function get dragManager() : IDragManager
        {
            return this._-N9;
        }// end function

        public function get cursorManager() : ICursorManager
        {
            return this._-K8;
        }// end function

        public function get plugInManager() : PlugInManager
        {
            return this._-JN;
        }// end function

        public function get isInputing() : Boolean
        {
            return this._-8P.buttonDown || this._-OD.keyCode != 0;
        }// end function

        public function get forPublish() : Boolean
        {
            return this._-PZ;
        }// end function

        public function set forPublish(param1:Boolean) : void
        {
            this._-PZ = param1;
            return;
        }// end function

        public function create(param1:String, param2:Boolean = false) : void
        {
            var projectPath:* = param1;
            var forPublish:* = param2;
            var stage:* = this.stage;
            this._-C6 = stage.nativeWindow;
            stage.frameRate = 24;
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.color = 3684408;
            this._-C6.addEventListener(Event.CLOSING, this._-F0);
            this._-C6.addEventListener(Event.ACTIVATE, this._-AK);
            this._-C6.addEventListener(Event.DEACTIVATE, this._-33);
            this._-7n = true;
            this._-PZ = forPublish;
            this._-Mj = -10000000;
            this._-OD = new CombineKeyHelper();
            this._-OD.defineKey(38, 0, 1);
            this._-OD.defineKey(38, 39, 2);
            this._-OD.defineKey(39, 0, 3);
            this._-OD.defineKey(39, 40, 4);
            this._-OD.defineKey(40, 0, 5);
            this._-OD.defineKey(40, 37, 6);
            this._-OD.defineKey(37, 0, 7);
            this._-OD.defineKey(37, 38, 8);
            this._-8P = new GRoot();
            addChild(this._-8P.displayObject);
            this._-N9 = new _-OH(this);
            this._-K8 = new _-LG(this);
            this._-EN = new _-Al(stage);
            if (!this._-PZ)
            {
                this._-EN._-D8(function () : void
            {
                start(projectPath);
                return;
            }// end function
            );
            }
            else
            {
                this.start(projectPath);
            }
            return;
        }// end function

        private function start(param1:String) : void
        {
            var projectPath:* = param1;
            this._-1p = new Dictionary();
            this._dispatcher = new SEventDispatcher();
            this._dispatcher.errorHandler = function (param1:Error) : void
            {
                if (_-IR)
                {
                    _-IR.logError(null, param1);
                }
                return;
            }// end function
            ;
            stage.nativeWindow.title = Consts.strings.text84;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this._-FA);
            stage.addEventListener(KeyboardEvent.KEY_UP, this._-HF);
            this._-8P.addEventListener(FocusChangeEvent.CHANGED, this._-AB);
            this._-G8 = new MainView(this);
            this._-8P.addChild(this._-G8.panel);
            this._-G8.panel.setSize(this._-8P.width, this._-8P.height);
            this._-G8.panel.addRelation(this._-8P, RelationType.Size);
            this._-J7();
            this._-G8._-Hb();
            if (projectPath)
            {
                this.openProject(projectPath);
            }
            return;
        }// end function

        public function openProject(param1:String) : void
        {
            var files:Array;
            var i:int;
            var path:* = param1;
            var projectDescFile:File;
            var file:* = new File(path);
            if (!file.exists)
            {
                this.alert(Consts.strings.text117);
                return;
            }
            var ew:* = FairyGUIEditor._-C(path);
            if (ew && !this._-PZ)
            {
                ew.nativeWindow.activate();
                NativeApplication.nativeApplication.activate(ew.nativeWindow);
                return;
            }
            if (file.isDirectory)
            {
                files = file.getDirectoryListing();
                i;
                while (i < files.length)
                {
                    
                    if (File(files[i]).extension == FProject.FILE_EXT)
                    {
                        projectDescFile = files[i];
                        break;
                    }
                    i = (i + 1);
                }
                if (!projectDescFile)
                {
                    i;
                    while (i < files.length)
                    {
                        
                        if (files[i].name == "project.xml")
                        {
                            this.confirm(Consts.strings.text312, function () : void
            {
                UtilsFile.browseForDirectory(Consts.strings.text313, function (param1:File) : void
                {
                    UpgradeDialog(getDialog(UpgradeDialog)).open(File(files[i]).parent, param1);
                    return;
                }// end function
                );
                return;
            }// end function
            );
                            return;
                        }
                        i = (i + 1);
                    }
                    this.alert(Consts.strings.text117);
                    return;
                }
            }
            else
            {
                projectDescFile = file;
            }
            if (this._project)
            {
                this.closeProject();
            }
            this.cursorManager.setWaitCursor(true);
            try
            {
                this._project = new FProject(this);
                this._project.open(projectDescFile);
            }
            catch (err:Error)
            {
                cursorManager.setWaitCursor(false);
                _project = null;
                alert("openProject failed: ", err);
                return;
            }
            this._-FR();
            if (this._project.type == "Flash")
            {
                stage.frameRate = 24;
            }
            else
            {
                stage.frameRate = 60;
            }
            stage.nativeWindow.title = this.project.name;
            this._-JN = new PlugInManager(this);
            this._-4S = new _-2t(this);
            this._-KP = new WorkspaceSettings(this);
            this._-PT = new _-PC(this);
            this._-Cv = new ProjectRefreshHandler(this);
            this._-Et();
            _-JP._-7g(this);
            this._-G8.panel.getChild("holder").asGraph.replaceMe(GComponent(this._-4S));
            this._-G8.panel.getController("start").selectedIndex = 0;
            this._-Kz._-Jp();
            try
            {
                this._-KP.load();
                this._-4S._-9();
            }
            catch (err:Error)
            {
                _-IR.logError(null, err);
            }
            GTimers.inst.step();
            if (Capabilities.isDebugger)
            {
                this._-4S.showView("fairygui.DebugView");
            }
            this._-JN.load(this._-8m);
            return;
        }// end function

        private function _-8m() : void
        {
            this._-8v = this._project.lastChanged;
            addEventListener(Event.ENTER_FRAME, this._-2v);
            try
            {
                this.emit(EditorEvent.ProjectOpened);
                GTimers.inst.step();
            }
            catch (err:Error)
            {
                _-IR.logError(null, err);
            }
            this.cursorManager.setWaitCursor(false);
            return;
        }// end function

        public function closeProject() : void
        {
            var k:Object;
            if (!this._project)
            {
                return;
            }
            try
            {
                this.emit(EditorEvent.ProjectClosed);
            }
            catch (err:Error)
            {
            }
            removeEventListener(Event.ENTER_FRAME, this._-2v);
            var _loc_2:* = 0;
            var _loc_3:* = this._-1p;
            while (_loc_3 in _loc_2)
            {
                
                k = _loc_3[_loc_2];
                _loc_3[k].dispose();
            }
            this._project.close();
            if (!this._-PZ)
            {
                this._-4S._-U();
            }
            this._-JN.dispose();
            this._-PT.dispose();
            this._-Cv.dispose();
            this._-4S.dispose();
            this._-8P.closeAllWindows();
            this._-8P.hidePopup();
            this._-8P.hideTooltips();
            this._-8P.removeChildren(0, -1, true);
            if (!this._-PZ)
            {
                try
                {
                    this._-KP.save();
                }
                catch (err:Error)
                {
                }
            }
            this._project = null;
            this._-1p = null;
            this._-KP = null;
            this._-JN = null;
            this._-4S = null;
            if (!this._-7P)
            {
                this.start(null);
            }
            return;
        }// end function

        public function refreshProject() : void
        {
            this._-Cv.run();
            return;
        }// end function

        public function showPreview(param1:FPackageItem) : void
        {
            if (param1 && param1.owner.project != this._project)
            {
                return;
            }
            this._-Bt.show(param1);
            return;
        }// end function

        public function findReference(param1:String) : void
        {
            this._-4S.showView("fairygui.ReferenceView");
            this._-8L.open(param1);
            return;
        }// end function

        public function importResource(param1:IUIPackage) : IResourceImportQueue
        {
            return new _-8G(param1);
        }// end function

        public function getActiveFolder() : FPackageItem
        {
            var _loc_1:* = this._-Bd.getSelectedFolder();
            if (this._-Bd == this._-I7)
            {
                if (_loc_1 != null)
                {
                    return _loc_1;
                }
            }
            var _loc_2:* = this._docView.activeDocument;
            if (_loc_2)
            {
                return _loc_2.packageItem.parent;
            }
            if (_loc_1)
            {
                return _loc_1;
            }
            if (this._project.allPackages.length > 0)
            {
                return this._project.allPackages[0].rootItem;
            }
            return null;
        }// end function

        public function queryToClose() : void
        {
            if (this._project)
            {
                this.docView.queryToSaveAllDocuments(function (param1:String) : void
            {
                if (param1 != "cancel")
                {
                    close();
                }
                else
                {
                    FairyGUIEditor._-PI = false;
                }
                return;
            }// end function
            );
            }
            else
            {
                this.close();
            }
            return;
        }// end function

        private function close() : void
        {
            this._-7P = true;
            this.closeProject();
            this._-EN.dispose();
            stage.nativeWindow.close();
            return;
        }// end function

        public function emit(param1:String, param2 = undefined) : void
        {
            this._dispatcher.emit(param1, param2);
            return;
        }// end function

        public function on(param1:String, param2:Function) : void
        {
            this._dispatcher.on(param1, param2);
            return;
        }// end function

        public function off(param1:String, param2:Function) : void
        {
            this._dispatcher.off(param1, param2);
            return;
        }// end function

        public function alert(param1:String, param2:Error = null, param3:Function = null) : void
        {
            if (param1 == null)
            {
                param1 = "";
            }
            if (param2)
            {
                if (param2.errorID != 0)
                {
                    if (this._-IR)
                    {
                        this._-IR.logError(param1, param2);
                        ;
                    }
                }
                if (param1)
                {
                    param1 = param1 + "\n";
                }
                if (param2.errorID == 0)
                {
                    param1 = param1 + param2.message;
                }
                else
                {
                    param1 = param1 + RuntimeErrorUtil.toString(param2);
                }
            }
            AlertDialog(this.getDialog(AlertDialog)).open(param1, param3);
            return;
        }// end function

        public function confirm(param1:String, param2:Function) : void
        {
            ConfirmDialog(this.getDialog(ConfirmDialog)).open(param1, param2);
            return;
        }// end function

        public function input(param1:String, param2:String, param3:Function) : void
        {
            InputDialog(this.getDialog(InputDialog)).open(param1, param2, param3);
            return;
        }// end function

        public function showWaiting(param1:String = null, param2:Function = null) : void
        {
            WaitingDialog(this.getDialog(WaitingDialog)).open(param1, param2);
            return;
        }// end function

        public function closeWaiting() : void
        {
            WaitingDialog(this.getDialog(WaitingDialog)).hide();
            return;
        }// end function

        private function _-F0(event:Event) : void
        {
            event.preventDefault();
            this.queryToClose();
            return;
        }// end function

        private function _-AK(event:Event) : void
        {
            this._-7n = true;
            this._-8v = 0;
            if (Consts.isMacOS && this._-Kz)
            {
                NativeApplication.nativeApplication.menu = _-6j(this._-Kz.root).realMenu;
            }
            return;
        }// end function

        private function _-33(event:Event) : void
        {
            this._-7n = false;
            return;
        }// end function

        public function getDialog(param1:Object) : Window
        {
            var _loc_2:* = this._-1p[param1] as Window;
            if (!_loc_2)
            {
                _loc_2 = new param1(this);
                this._-1p[param1] = _loc_2;
            }
            return _loc_2;
        }// end function

        private function _-FR() : void
        {
            var _loc_1:* = LocalStore.data.recent_project;
            if (!_loc_1)
            {
                _loc_1 = [];
            }
            if (_loc_1.length % 2 != 0)
            {
                _loc_1.length = 0;
                delete LocalStore.data.recent_project;
            }
            var _loc_2:* = _loc_1.indexOf(this._project.basePath);
            if (_loc_2 != -1)
            {
                _loc_1.splice((_loc_2 - 1), 2);
            }
            _loc_1.push(this._project.name, this._project.basePath);
            if (_loc_1.length > 40)
            {
                _loc_1.splice(0, _loc_1.length - 40);
            }
            LocalStore.data.recent_project = _loc_1;
            LocalStore.setDirty("recent_project");
            return;
        }// end function

        private function _-2v(event:Event) : void
        {
            if (this._-8v != this._project.lastChanged)
            {
                this._-8v = this._project.lastChanged;
                this.emit(EditorEvent.Validate);
            }
            this.emit(EditorEvent.OnUpdate);
            this.emit(EditorEvent.OnLateUpdate);
            return;
        }// end function

        private function _-FA(event:KeyboardEvent) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = _-44._-Pb(event);
            if (event.target is TextField && TextField(event.target).type == TextFieldType.INPUT)
            {
                if (_loc_2 == "0007")
                {
                    TextInputHistory.inst.undo(TextField(event.target));
                    event.preventDefault();
                }
                else if (_loc_2 == "0008")
                {
                    TextInputHistory.inst.redo(TextField(event.target));
                    event.preventDefault();
                }
                else if (_loc_2 == "0112")
                {
                    event.preventDefault();
                }
                else if (event.keyCode == Keyboard.ESCAPE)
                {
                    this._-8P.nativeStage.focus = null;
                }
                return;
            }
            event.preventDefault();
            this._-OD.onKeyDown(event);
            if (event.keyCode == Keyboard.ESCAPE)
            {
                if (this._-8P.hasAnyPopup)
                {
                    this._-8P.hidePopup();
                    return;
                }
                if (this._-N9.dragging)
                {
                    this._-N9.cancel();
                    return;
                }
                if (this._-3o && this._-3o.running)
                {
                    this._-3o.stop();
                    return;
                }
            }
            if (PreferencesDialog(this.getDialog(PreferencesDialog)).swallowKeyEvent(event))
            {
                return;
            }
            if (_loc_2 != null)
            {
                if (this._-G8._-L4(_loc_2))
                {
                    _loc_2 = null;
                }
                this._-9V = null;
            }
            else if (!event.ctrlKey && !event.commandKey && !event.altKey && event.charCode >= 48 && event.charCode <= 122)
            {
                _loc_3 = getTimer();
                if (this._-9V != null && _loc_3 - this._-Mt < 600)
                {
                    this._-9V = this._-9V + String.fromCharCode(event.charCode).toLowerCase();
                }
                else
                {
                    this._-9V = String.fromCharCode(event.charCode).toLowerCase();
                }
                this._-Mt = _loc_3;
            }
            else
            {
                this._-9V = null;
            }
            if (this._focusedObject)
            {
                _loc_4 = new _-4U(_-4U._-76, event, this._-OD.keyCode, _loc_2, this._-9V);
                this._focusedObject.dispatchEvent(_loc_4);
                if (_loc_4.isDefaultPrevented())
                {
                    event.preventDefault();
                }
            }
            return;
        }// end function

        private function _-HF(event:KeyboardEvent) : void
        {
            this._-OD.onKeyUp(event);
            return;
        }// end function

        private function _-AB(event:FocusChangeEvent) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_2:* = event.newFocusedObject;
            var _loc_3:* = null;
            var _loc_4:* = false;
            var _loc_5:* = false;
            while (_loc_2 != null && _loc_2 != this._-8P)
            {
                
                if (_loc_2 is ViewGrid)
                {
                    _loc_3 = ViewGrid(_loc_2).selectedView;
                    _loc_4 = true;
                    break;
                }
                else if (_loc_2 is Window)
                {
                    _loc_3 = Window(_loc_2);
                    _loc_5 = true;
                    break;
                }
                else if (_loc_2 == this._-G8.panel)
                {
                    if (this._focusedObject is Window)
                    {
                        _loc_3 = this._-G8.panel;
                        break;
                    }
                }
                _loc_2 = _loc_2.parent;
            }
            if (_loc_3 != null)
            {
                if (this._focusedObject != _loc_3)
                {
                    _loc_6 = this._focusedObject;
                    this._focusedObject = _loc_3;
                    if (_loc_4)
                    {
                        this._-I7 = _loc_3;
                    }
                    Sprite(_loc_3.displayObject).tabChildren = !_loc_5;
                    Sprite(_loc_6.displayObject).tabChildren = true;
                    if (_loc_6)
                    {
                        Sprite(_loc_6.displayObject).tabChildren = false;
                    }
                    _loc_7 = new FocusChangeEvent(FocusChangeEvent.CHANGED, _loc_6, _loc_3);
                    if (_loc_6 && !_loc_6.isDisposed)
                    {
                        _loc_6.dispatchEvent(_loc_7);
                    }
                    _loc_3.dispatchEvent(_loc_7);
                }
            }
            return;
        }// end function

        private function _-J7() : void
        {
            var _loc_1:* = null;
            if (Consts.isMacOS)
            {
                _loc_1 = new _-6j();
                NativeApplication.nativeApplication.menu = _-6j(_loc_1).realMenu;
                this._-G8.panel.getController("menu").selectedIndex = 1;
            }
            else
            {
                _loc_1 = new _-Fl(this._-G8.panel.getChild("menuBar").asCom);
            }
            this._-Kz = new _-Lm(this, _loc_1);
            this._-Kz._-Jm();
            return;
        }// end function

        public function checkRegisterStatus() : void
        {
            if (UtilsStr.startsWith(this._project.name, "FairyGUI"))
            {
                return;
            }
            if (this._project.allPackages.length <= 2)
            {
                return;
            }
            var _loc_2:* = this;
            var _loc_3:* = this._-2G + 1;
            _loc_2._-2G = _loc_3;
            var now:* = getTimer();
            if (this._-2G > 10 && now - this._-Mj > 180000)
            {
                this._-Mj = now;
                this._-2G = 0;
                try
                {
                    this.getDialog(RegisterNoticeDialog).show();
                }
                catch (err:Error)
                {
                    nativeWindow.close();
                }
            }
            return;
        }// end function

        private function _-Et() : void
        {
            this._-Bd = LibraryView(this._-4S.addView(LibraryView, "fairygui.LibraryView", Consts.strings.text409, "ui://Builder/panel_lib", {vResizePiority:200, location:"left"}));
            this._-NL = InspectorView(this._-4S.addView(InspectorView, "fairygui.InspectorView", Consts.strings.text410, "ui://Builder/panel_inspector", {location:"right"}));
            this._-4S.addView(HierarchyView, "fairygui.HierarchyView", Consts.strings.text412, "ui://Builder/panel_hierarchy", {vResizePiority:150, location:"left"});
            this._-Bt = PreviewView(this._-4S.addView(PreviewView, "fairygui.PreviewView", Consts.strings.text413, "ui://Builder/panel_preview", {location:"left"}));
            this._-2P = TimelineView(this._-4S.addView(TimelineView, "fairygui.TimelineView", Consts.strings.text411, "ui://Builder/panel_timeline", {vResizePiority:300, location:"bottom"}));
            this._-4S.addView(TransitionListView, "fairygui.TransitionListView", Consts.strings.text322, "ui://Builder/panel_transitions", {location:"left"});
            this._-4S.addView(FavoritesView, "fairygui.FavoritesView", Consts.strings.text424, "ui://Builder/panel_favorite", {vResizePiority:200, location:"left"});
            this._-4S.addView(SearchView, "fairygui.SearchView", Consts.strings.text425, "ui://Builder/panel_search", {vResizePiority:100, location:"left"});
            this._-IR = ConsoleView(this._-4S.addView(ConsoleView, "fairygui.ConsoleView", Consts.strings.text426, "ui://Builder/panel_console", {vResizePiority:100, location:"right"}));
            this._-8L = ReferenceView(this._-4S.addView(ReferenceView, "fairygui.ReferenceView", Consts.strings.text434, "ui://Builder/panel_reference", {vResizePiority:100, location:"right"}));
            this._docView = DocumentView(this._-4S.addView(DocumentView, "fairygui.DocumentView", null, null, {hResizePiority:int.MAX_VALUE, vResizePiority:int.MAX_VALUE}));
            this._-3o = TestView(this._-4S.addView(TestView, "fairygui.TestView", null, null, {hResizePiority:int.MAX_VALUE, vResizePiority:int.MAX_VALUE}));
            return;
        }// end function

    }
}
