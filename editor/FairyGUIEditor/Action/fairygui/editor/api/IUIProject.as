package fairygui.editor.api
{
    import __AS3__.vec.*;
    import fairygui.editor.gui.*;
    import flash.filesystem.*;

    public interface IUIProject
    {

        public function IUIProject();

        function get editor() : IEditor;

        function get id() : String;

        function get name() : String;

        function get type() : String;

        function set type(param1:String) : void;

        function get basePath() : String;

        function get assetsPath() : String;

        function get settingsPath() : String;

        function get objsPath() : String;

        function get versionCode() : int;

        function get serialNumberSeed() : String;

        function get lastChanged() : int;

        function setChanged() : void;

        function get supportAtlas() : Boolean;

        function get isH5() : Boolean;

        function get supportExtractAlpha() : Boolean;

        function get supportAlphaMask() : Boolean;

        function get supportCustomFileExtension() : Boolean;

        function getSettings(param1:String) : Object;

        function getSetting(param1:String, param2:String);

        function setSetting(param1:String, param2:String, param3) : void;

        function saveSettings(param1:String) : void;

        function getPackage(param1:String) : IUIPackage;

        function getPackageByName(param1:String) : IUIPackage;

        function get allPackages() : Vector.<IUIPackage>;

        function get activeBranch() : String;

        function set activeBranch(param1:String) : void;

        function get allBranches() : Vector.<String>;

        function createBranch(param1:String) : void;

        function renameBranch(param1:String, param2:String) : void;

        function removeBranch(param1:String) : void;

        function createPackage(param1:String) : IUIPackage;

        function deletePackage(param1:String) : void;

        function addPackage(param1:File) : IUIPackage;

        function getItemByURL(param1:String) : FPackageItem;

        function findItemByFile(param1:File) : FPackageItem;

        function setVar(param1:String, param2) : void;

        function getVar(param1:String);

        function registerCustomExtension(param1:String, param2:String, param3:String) : void;

        function getCustomExtension(param1:String) : Object;

        function clearCustomExtensions() : void;

        function logError(param1:String, param2:Error = null) : void;

        function playSound(param1:String, param2:Number) : void;

        function asyncRequest(param1:String, param2 = undefined, param3:Function = null, param4:Function = null) : void;

    }
}
