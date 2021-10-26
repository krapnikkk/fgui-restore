package fairygui.editor.api
{
    import __AS3__.vec.*;
    import fairygui.editor.gui.*;

    public interface ILibraryView
    {

        public function ILibraryView();

        function getSelectedResource() : FPackageItem;

        function getSelectedResources(param1:Boolean) : Vector.<FPackageItem>;

        function getSelectedFolder() : FPackageItem;

        function getFolderUnderPoint(param1:Number, param2:Number) : FPackageItem;

        function highlight(param1:FPackageItem, param2:Boolean = true) : void;

        function openResource(param1:FPackageItem) : void;

        function openResources(param1:Vector.<FPackageItem>) : void;

        function showResourceInExplorer(param1:FPackageItem) : void;

        function showUpdateResourceDialog(param1:FPackageItem) : void;

        function showImportResourcesDialog(param1:IUIPackage = null, param2:String = null) : void;

        function moveResources(param1:FPackageItem, param2:Vector.<FPackageItem>) : void;

        function deleteResources(param1:Vector.<FPackageItem>) : void;

        function setResourcesExported(param1:Vector.<FPackageItem>, param2:Boolean) : void;

        function setResourcesFavorite(param1:Vector.<FPackageItem>, param2:Boolean) : void;

    }
}
