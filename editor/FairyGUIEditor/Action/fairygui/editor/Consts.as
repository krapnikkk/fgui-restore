package fairygui.editor
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import fairygui.utils.*;
    import flash.desktop.*;
    import flash.filesystem.*;
    import flash.system.*;

    public class Consts extends Object
    {
        public static var strings:Object = {};
        public static var icons:Object = {};
        public static var language:String;
        public static var isMacOS:Boolean;
        public static var AIRVersion:int;
        public static var version:String;
        public static var versionCode:int;
        public static var build:String;
        public static var auxLineSize:int;
        public static var supportedPlatformIds:Array = [ProjectType.FLASH, ProjectType.UNITY, ProjectType.STARLING, ProjectType.EGRET, ProjectType.LAYABOX, ProjectType.HAXE, ProjectType.PIXI, ProjectType.COCOS2DX, ProjectType.COCOSCREATOR, ProjectType.CRY, ProjectType.VISION, ProjectType.MONOGAME, ProjectType.CORONA];
        public static var supportedPlatformNames:Array = [ProjectType.FLASH, ProjectType.UNITY, ProjectType.STARLING, ProjectType.EGRET, ProjectType.LAYABOX, ProjectType.HAXE, ProjectType.PIXI, "Cocos2d-x", "Cocos Creator", "Cry Engine", "Havok Vision(Project Anarchy)", "MonoGame", "Corona"];
        public static const easeType:Array = ["Back", "Bounce", "Circ", "Cubic", "Elastic", "Expo", "Linear", "Quad", "Quart", "Quint", "Sine"];
        public static const easeInOutType:Array = ["In", "Out", "InOut"];
        public static const supportedLangNames:Array = ["Auto", "English", "简体中文"];
        public static const supportedLanaguages:Array = ["auto", "en", "zh-CN"];
        public static const about:String = "Copyright 2013-2020 FairyGUI.com\n" + "All rights reserved.";
        public static const userDirectoryName:String = ".FairyGUI-Editor";

        public function Consts()
        {
            return;
        }// end function

        private static function parseVersion() : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_1:* = NativeApplication.nativeApplication.applicationDescriptor;
            var _loc_2:* = _loc_1.namespaceDeclarations();
            _loc_2 = _loc_2[0].uri.split("/");
            Consts.AIRVersion = parseInt(_loc_2[(_loc_2.length - 1)]);
            var _loc_3:* = _loc_1.namespace("");
            Consts.version = _loc_3::versionNumber;
            var _loc_4:* = _loc_3::versionLabel;
            _loc_2 = Consts.version.split(".");
            Consts.versionCode = int(_loc_2[0]) * 10000 + int(_loc_2[1]) * 100 + int(_loc_2[2]);
            Consts.build = "";
            if (_loc_4)
            {
                _loc_5 = _loc_4.indexOf("Build ");
                _loc_6 = _loc_4.indexOf(")", _loc_5);
                if (_loc_5 != -1 && _loc_6 != -1)
                {
                    Consts.build = _loc_4.substring(_loc_5 + 6, _loc_6);
                }
            }
            return;
        }// end function

        public static function init() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            parseVersion();
            isMacOS = Capabilities.os.toLowerCase().indexOf("mac") != -1;
            language = Preferences.language;
            if (language == "auto")
            {
                language = Capabilities.language;
            }
            if (!new File("app:/locales/" + language + "/strings2.xml").exists)
            {
                if (UtilsStr.startsWith(language, "zh-"))
                {
                    language = "zh-CN";
                }
                else
                {
                    language = "en";
                }
            }
            if (language != "zh-CN")
            {
                _loc_3 = UtilsFile.loadXML(new File("app:/locales/" + language + "/strings1.xml"));
                if (_loc_3)
                {
                    UIPackage.setStringsSource(_loc_3);
                }
            }
            var _loc_1:* = UtilsFile.loadXData(new File("app:/locales/" + language + "/strings2.xml"));
            var _loc_2:* = _loc_1.getEnumerator("string");
            while (_loc_2.moveNext())
            {
                
                _loc_4 = _loc_2.current.getAttribute("name");
                _loc_5 = _loc_2.current.getText();
                strings[_loc_4] = _loc_5;
            }
            icons[FObjectType.FOLDER] = UIPackage.getItemURL("Builder", "icon_folder");
            icons["folder_open"] = UIPackage.getItemURL("Builder", "icon_folder_open");
            icons[FObjectType.PACKAGE] = UIPackage.getItemURL("Builder", "icon_package");
            icons["package_open"] = UIPackage.getItemURL("Builder", "icon_package_open");
            icons["branch"] = UIPackage.getItemURL("Builder", "icon_branch");
            icons[FPackageItemType.SOUND] = UIPackage.getItemURL("Builder", "icon_sound");
            icons[FPackageItemType.FONT] = UIPackage.getItemURL("Builder", "icon_font");
            icons[FPackageItemType.MISC] = UIPackage.getItemURL("Builder", "icon_misc");
            icons[FObjectType.IMAGE] = UIPackage.getItemURL("Builder", "icon_image");
            icons[FObjectType.GRAPH] = UIPackage.getItemURL("Builder", "icon_graph");
            icons[FObjectType.LIST] = UIPackage.getItemURL("Builder", "icon_list");
            icons[FObjectType.LOADER] = UIPackage.getItemURL("Builder", "icon_loader");
            icons[FObjectType.TEXT] = UIPackage.getItemURL("Builder", "icon_text");
            icons[FObjectType.RICHTEXT] = UIPackage.getItemURL("Builder", "icon_richtext");
            icons[FObjectType.COMPONENT] = UIPackage.getItemURL("Builder", "icon_component");
            icons[FObjectType.SWF] = UIPackage.getItemURL("Builder", "icon_swf");
            icons[FObjectType.MOVIECLIP] = UIPackage.getItemURL("Builder", "icon_movieclip");
            icons[FObjectType.GROUP] = UIPackage.getItemURL("Builder", "icon_group");
            icons[FObjectType.EXT_BUTTON] = UIPackage.getItemURL("Builder", "icon_button");
            icons[FObjectType.EXT_LABEL] = UIPackage.getItemURL("Builder", "icon_label");
            icons[FObjectType.EXT_COMBOBOX] = UIPackage.getItemURL("Builder", "icon_combobox");
            icons[FObjectType.EXT_SLIDER] = UIPackage.getItemURL("Builder", "icon_slider");
            icons[FObjectType.EXT_PROGRESS_BAR] = UIPackage.getItemURL("Builder", "icon_progressbar");
            icons[FObjectType.EXT_SCROLLBAR] = UIPackage.getItemURL("Builder", "icon_scrollbar");
            return;
        }// end function

    }
}
