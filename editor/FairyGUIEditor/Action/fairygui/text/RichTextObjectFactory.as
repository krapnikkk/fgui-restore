package fairygui.text
{
    import fairygui.*;
    import fairygui.display.*;
    import fairygui.text.*;
    import flash.display.*;

    public class RichTextObjectFactory extends Object implements IRichTextObjectFactory
    {
        public var pool:Array;

        public function RichTextObjectFactory()
        {
            pool = [];
            return;
        }// end function

        public function createObject(param1:String, param2:int, param3:int) : DisplayObject
        {
            var _loc_4:* = null;
            if (pool.length > 0)
            {
                _loc_4 = pool.pop();
            }
            else
            {
                _loc_4 = new GLoader();
                _loc_4.fill = 4;
            }
            _loc_4.url = param1;
            _loc_4.setSize(param2, param3);
            return _loc_4.displayObject;
        }// end function

        public function freeObject(param1:DisplayObject) : void
        {
            var _loc_2:* = this.GLoader(this.UIDisplayObject(param1).owner);
            _loc_2.url = null;
            pool.push(_loc_2);
            return;
        }// end function

    }
}
