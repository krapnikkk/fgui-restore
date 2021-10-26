package fairygui.editor.gui
{
    import fairygui.utils.*;
    import flash.filesystem.*;

    public class FPackageItemType extends Object
    {
        public static const FOLDER:String = "folder";
        public static const IMAGE:String = "image";
        public static const SWF:String = "swf";
        public static const MOVIECLIP:String = "movieclip";
        public static const SOUND:String = "sound";
        public static const COMPONENT:String = "component";
        public static const FONT:String = "font";
        public static const MISC:String = "misc";
        public static const ATLAS:String = "atlas";
        public static const fileExtensionMap:Object = {jpg:IMAGE, jpeg:IMAGE, png:IMAGE, psd:IMAGE, tga:IMAGE, svg:IMAGE, plist:MOVIECLIP, eas:MOVIECLIP, jta:MOVIECLIP, gif:MOVIECLIP, wav:SOUND, mp3:SOUND, ogg:SOUND, fnt:FONT, swf:SWF, xml:COMPONENT};

        public function FPackageItemType()
        {
            return;
        }// end function

        public static function getFileType(param1:File) : String
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (param1.isHidden || param1.isSymbolicLink || param1.name == "package.xml" || param1.name == "package_branch.xml" || param1.extension == "meta" || param1.name.charAt(0) == ".")
            {
                return null;
            }
            var _loc_2:* = param1.extension;
            if (_loc_2)
            {
                _loc_2 = _loc_2.toLowerCase();
            }
            if (_loc_2 == "xml")
            {
                _loc_4 = UtilsFile.loadXMLRoot(param1);
                if (_loc_4)
                {
                    if (_loc_4.getName() == "component")
                    {
                        _loc_3 = FPackageItemType.COMPONENT;
                    }
                    else
                    {
                        _loc_3 = FPackageItemType.MISC;
                    }
                }
                else
                {
                    _loc_3 = FPackageItemType.MISC;
                }
            }
            else
            {
                _loc_3 = FPackageItemType.fileExtensionMap[_loc_2];
                if (!_loc_3)
                {
                    _loc_3 = FPackageItemType.MISC;
                }
            }
            return _loc_3;
        }// end function

    }
}
