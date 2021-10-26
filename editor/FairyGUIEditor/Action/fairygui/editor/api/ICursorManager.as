package fairygui.editor.api
{
    import flash.display.*;

    public interface ICursorManager
    {

        public function ICursorManager();

        function setDefaultCursor(param1:String, param2:Function = null) : void;

        function setWaitCursor(param1:Boolean) : void;

        function setCursorForObject(param1:DisplayObject, param2:String, param3:Function = null, param4:Boolean = false) : void;

        function updateCursor() : void;

        function get currentCursor() : String;

    }
}
