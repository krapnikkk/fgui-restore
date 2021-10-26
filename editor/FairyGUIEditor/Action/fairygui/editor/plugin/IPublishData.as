package fairygui.editor.plugin
{

    public interface IPublishData
    {

        public function IPublishData();

        function get targetUIPackage() : IEditorUIPackage;

        function get filePath() : String;

        function get fileName() : String;

        function get fileExtention() : String;

        function get singlePackage() : Boolean;

        function get exportDescOnly() : Boolean;

        function get extractAlpha() : Boolean;

        function get outputDesc() : Object;

        function set outputDesc(param1:Object) : void;

        function get outputRes() : Object;

        function set outputRes(param1:Object) : void;

        function get outputClasses() : Object;

        function set outputClasses(param1:Object) : void;

        function get sprites() : String;

        function set sprites(param1:String) : void;

        function preventDefault() : void;

    }
}
