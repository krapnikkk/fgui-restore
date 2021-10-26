package fairygui.editor.plugin
{

    public interface IEditorUIProject
    {

        public function IEditorUIProject();

        function get basePath() : String;

        function get id() : String;

        function get name() : String;

        function get type() : String;

        function get customProperties() : Object;

        function getSettings(param1:String) : Object;

        function save() : void;

    }
}
