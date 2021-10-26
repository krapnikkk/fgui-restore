package fairygui.editor.plugin
{
    import flash.filesystem.*;

    public interface IEditorUIPackage
    {

        public function IEditorUIPackage();

        function get basePath() : String;

        function get id() : String;

        function get name() : String;

        function getResourceId(param1:String) : String;

        function setExported(param1:Array, param2:Boolean) : void;

        function createFolder(param1:String, param2:String) : void;

        function renameResources(param1:Array, param2:Array) : void;

        function importResources(param1:String, param2:Array, param3:Array, param4:Function) : void;

        function updateResource(param1:String, param2:File, param3:Function, param4:Function) : void;

        function createMovieClip(param1:String, param2:String, param3:Array, param4:Object, param5:Function, param6:Function) : void;

        function createComponent(param1:String, param2:int, param3:int, param4:String, param5:XML) : String;

    }
}
