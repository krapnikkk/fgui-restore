package fairygui.editor.api
{
    import __AS3__.vec.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.filesystem.*;

    public interface IUIPackage
    {

        public function IUIPackage();

        function get project() : IUIProject;

        function get id() : String;

        function get name() : String;

        function get basePath() : String;

        function get rootItem() : FPackageItem;

        function get items() : Vector.<FPackageItem>;

        function get opened() : Boolean;

        function setChanged() : void;

        function get publishSettings() : Object;

        function getItemListing(param1:FPackageItem, param2:Array = null, param3:Boolean = true, param4:Boolean = false, param5:Vector.<FPackageItem> = null) : Vector.<FPackageItem>;

        function getFavoriteItems(param1:Vector.<FPackageItem> = null) : Vector.<FPackageItem>;

        function getItem(param1:String) : FPackageItem;

        function findItemByName(param1:String) : FPackageItem;

        function getItemByName(param1:FPackageItem, param2:String) : FPackageItem;

        function getItemByFileName(param1:FPackageItem, param2:String) : FPackageItem;

        function getItemByPath(param1:String) : FPackageItem;

        function getItemPath(param1:FPackageItem, param2:Vector.<FPackageItem> = null) : Vector.<FPackageItem>;

        function addItem(param1:FPackageItem) : void;

        function moveItem(param1:FPackageItem, param2:String) : void;

        function duplicateItem(param1:FPackageItem, param2:String) : FPackageItem;

        function renameItem(param1:FPackageItem, param2:String) : void;

        function deleteItem(param1:FPackageItem) : int;

        function setItemProperty(param1:FPackageItem, param2:String, param3) : void;

        function getNextId() : String;

        function getSequenceName(param1:String) : String;

        function getUniqueName(param1:FPackageItem, param2:String) : String;

        function createBranch(param1:String) : void;

        function getBranchPath(param1:String) : String;

        function createFolder(param1:String, param2:String = null, param3:Boolean = false) : FPackageItem;

        function createPath(param1:String) : FPackageItem;

        function createComponentItem(param1:String, param2:int, param3:int, param4:String = "/", param5:String = null, param6:Boolean = false, param7:Boolean = false) : FPackageItem;

        function createFontItem(param1:String, param2:String = "/", param3:Boolean = false) : FPackageItem;

        function createMovieClipItem(param1:String, param2:String = null, param3:Boolean = false) : FPackageItem;

        function importResource(param1:File, param2:String, param3:String, param4:Callback) : void;

        function updateResource(param1:FPackageItem, param2:File, param3:Callback) : void;

        function setVar(param1:String, param2) : void;

        function getVar(param1:String);

        function get strings() : Object;

        function set strings(param1:Object) : void;

        function beginBatch() : void;

        function endBatch() : void;

        function save() : void;

    }
}
