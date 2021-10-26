package fairygui
{
    import flash.utils.*;

    public interface IUIPackageReader
    {

        public function IUIPackageReader();

        function readDescFile(param1:String) : String;

        function readResFile(param1:String) : ByteArray;

    }
}
