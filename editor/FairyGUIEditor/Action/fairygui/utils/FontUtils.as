package fairygui.utils
{
    import *.*;
    import flash.text.*;

    public class FontUtils extends Object
    {
        private static var sEmbeddedFonts:Array = null;

        public function FontUtils()
        {
            return;
        }// end function

        public static function updateEmbeddedFonts() : void
        {
            sEmbeddedFonts = null;
            return;
        }// end function

        public static function isEmbeddedFont(param1:TextFormat) : Boolean
        {
            var _loc_4:* = null;
            var _loc_6:* = false;
            var _loc_2:* = false;
            var _loc_3:* = false;
            var _loc_5:* = false;
            if (sEmbeddedFonts == null)
            {
                sEmbeddedFonts = Font.enumerateFonts(false);
            }
            for each (_loc_7 in sEmbeddedFonts)
            {
                
                _loc_4 = (_loc_7).fontStyle;
                _loc_6 = _loc_4 == "bold" || _loc_4 == "boldItalic";
                _loc_2 = _loc_4 == "italic" || _loc_4 == "boldItalic";
                _loc_3 = param1.bold == null ? (false) : (param1.bold);
                _loc_5 = param1.italic == null ? (false) : (param1.italic);
                if (param1.font == _loc_7.fontName && _loc_5 == _loc_2 && _loc_3 == _loc_6)
                {
                    return true;
                }
            }
            return false;
        }// end function

    }
}
