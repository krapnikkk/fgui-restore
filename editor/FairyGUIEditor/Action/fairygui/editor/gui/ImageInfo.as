package fairygui.editor.gui
{
    import flash.filesystem.*;
    import flash.geom.*;

    public class ImageInfo extends Object
    {
        public var targetQuality:int;
        public var format:String;
        public var file:File;
        public var trimmedRect:Rectangle;

        public function ImageInfo()
        {
            this.trimmedRect = new Rectangle();
            return;
        }// end function

        public function get needConversion() : Boolean
        {
            return this.format == "psd" || this.format == "tga" || this.format == "svg" || this.targetQuality != 100;
        }// end function

    }
}
