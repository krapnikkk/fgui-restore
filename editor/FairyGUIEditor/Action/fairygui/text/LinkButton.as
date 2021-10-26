package fairygui.text
{
    import flash.display.*;

    public class LinkButton extends Sprite
    {
        public var owner:HtmlNode;

        public function LinkButton() : void
        {
            buttonMode = true;
            return;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            graphics.clear();
            graphics.beginFill(0, 0);
            graphics.drawRect(0, 0, param1, param2);
            graphics.endFill();
            return;
        }// end function

    }
}
