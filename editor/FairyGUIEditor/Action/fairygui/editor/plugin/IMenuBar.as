package fairygui.editor.plugin
{
    import fairygui.*;

    public interface IMenuBar
    {

        public function IMenuBar();

        function addMenu(param1:String, param2:String, param3:PopupMenu, param4:String = null) : void;

        function getMenu(param1:String) : PopupMenu;

        function removeMenu(param1:String) : void;

    }
}
