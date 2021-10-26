package fairygui
{
    import *.*;
    import fairygui.*;
    import fairygui.utils.*;
    import flash.utils.*;

    public class ZipUIPackageReader extends Object implements IUIPackageReader
    {
        private var _desc:ZipReader;
        private var _files:ZipReader;

        public function ZipUIPackageReader(param1:ByteArray, param2:ByteArray)
        {
            _desc = new ZipReader(param1);
            if (param2 && param2.length)
            {
                _files = new ZipReader(param2);
            }
            else
            {
                _files = _desc;
            }
            return;
        }// end function

        public function readDescFile(param1:String) : String
        {
            var _loc_3:* = _desc.getEntryData(param1);
            var _loc_2:* = _loc_3.readUTFBytes(_loc_3.length);
            _loc_3.clear();
            return _loc_2;
        }// end function

        public function readResFile(param1:String) : ByteArray
        {
            return _files.getEntryData(param1);
        }// end function

    }
}
