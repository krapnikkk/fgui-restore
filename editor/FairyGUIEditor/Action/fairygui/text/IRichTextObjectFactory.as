package fairygui.text
{
    import flash.display.*;

    public interface IRichTextObjectFactory
    {

        public function IRichTextObjectFactory();

        function createObject(param1:String, param2:int, param3:int) : DisplayObject;

        function freeObject(param1:DisplayObject) : void;

    }
}
