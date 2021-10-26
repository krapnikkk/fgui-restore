package fairygui.text
{
    import flash.display.*;

    public class HtmlNode extends Object
    {
        public var charStart:int;
        public var charEnd:int;
        public var element:HtmlElement;
        public var displayObject:DisplayObject;
        public var topY:Number;

        public function HtmlNode()
        {
            return;
        }// end function

        public function reset() : void
        {
            charStart = -1;
            charEnd = -1;
            displayObject = null;
            return;
        }// end function

    }
}
