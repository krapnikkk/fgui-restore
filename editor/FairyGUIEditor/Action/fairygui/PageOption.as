package fairygui
{
    import *.*;

    public class PageOption extends Object
    {
        private var _controller:Controller;
        private var _id:String;

        public function PageOption()
        {
            return;
        }// end function

        public function set controller(param1:Controller) : void
        {
            _controller = param1;
            return;
        }// end function

        public function set index(param1:int) : void
        {
            _id = _controller.getPageId(param1);
            return;
        }// end function

        public function set name(param1:String) : void
        {
            _id = _controller.getPageIdByName(param1);
            return;
        }// end function

        public function get index() : int
        {
            if (_id)
            {
                return _controller.getPageIndexById(_id);
            }
            return -1;
        }// end function

        public function get name() : String
        {
            if (_id)
            {
                return _controller.getPageNameById(_id);
            }
            return null;
        }// end function

        public function clear() : void
        {
            _id = null;
            return;
        }// end function

        public function set id(param1:String) : void
        {
            _id = param1;
            return;
        }// end function

        public function get id() : String
        {
            return _id;
        }// end function

    }
}
