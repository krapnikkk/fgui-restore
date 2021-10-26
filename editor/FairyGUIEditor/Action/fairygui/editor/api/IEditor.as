package fairygui.editor.api
{
    import fairygui.*;
    import fairygui.editor.gui.*;
    import flash.display.*;

    public interface IEditor
    {

        public function IEditor();

        function get project() : IUIProject;

        function openProject(param1:String) : void;

        function closeProject() : void;

        function refreshProject() : void;

        function queryToClose() : void;

        function get nativeWindow() : NativeWindow;

        function get groot() : GRoot;

        function get mainPanel() : GComponent;

        function get active() : Boolean;

        function get workspaceSettings() : IWorkspaceSettings;

        function get viewManager() : IViewManager;

        function get dragManager() : IDragManager;

        function get cursorManager() : ICursorManager;

        function get menu() : IMenu;

        function get focusedView() : GComponent;

        function get docView() : IDocumentView;

        function get libView() : ILibraryView;

        function get inspectorView() : IInspectorView;

        function get testView() : ITestView;

        function get timelineView() : ITimelineView;

        function get consoleView() : IConsoleView;

        function emit(param1:String, param2 = undefined) : void;

        function on(param1:String, param2:Function) : void;

        function off(param1:String, param2:Function) : void;

        function alert(param1:String, param2:Error = null, param3:Function = null) : void;

        function confirm(param1:String, param2:Function) : void;

        function input(param1:String, param2:String, param3:Function) : void;

        function getDialog(param1:Object) : Window;

        function showWaiting(param1:String = null, param2:Function = null) : void;

        function closeWaiting() : void;

        function get isInputing() : Boolean;

        function showPreview(param1:FPackageItem) : void;

        function findReference(param1:String) : void;

        function importResource(param1:IUIPackage) : IResourceImportQueue;

        function getActiveFolder() : FPackageItem;

    }
}
