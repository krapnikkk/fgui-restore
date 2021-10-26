package fairygui.editor.plugin
{
    import fairygui.*;
    import fairygui.editor.api.*;

    public interface IFairyGUIEditor
    {

        public function IFairyGUIEditor();

        function get v5() : IEditor;

        function get project() : IEditorUIProject;

        function getPackage(param1:String) : IEditorUIPackage;

        function get language() : String;

        function get groot() : GRoot;

        function get menuBar() : IMenuBar;

        function alert(param1:String) : void;

        function log(param1:String) : void;

        function logError(param1:String, param2:Error = null) : void;

        function logWarning(param1:String) : void;

        function registerPublishHandler(param1:IPublishHandler) : void;

        function registerComponentExtension(param1:String, param2:String, param3:String) : void;

    }
}
