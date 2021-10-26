package fairygui.editor.api
{

    public interface IMenu
    {

        public function IMenu();

        function createMenu(param1:int = 0, param2:Function = null) : IMenu;

        function addItem(param1:String, param2:String = null, param3:Function = null, param4:String = null, param5:int = -1, param6:IMenu = null) : void;

        function removeItem(param1:String) : void;

        function addSeperator(param1:int = -1) : void;

        function setItemEnabled(param1:String, param2:Boolean) : void;

        function setItemChecked(param1:String, param2:Boolean) : void;

        function clearItems() : void;

        function getSubMenu(param1:String) : IMenu;

        function invoke(param1:String) : void;

    }
}
