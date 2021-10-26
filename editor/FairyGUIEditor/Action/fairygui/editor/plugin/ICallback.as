package fairygui.editor.plugin
{

    public interface ICallback
    {

        public function ICallback();

        function callOnSuccess() : void;

        function callOnFail() : void;

        function addMsg(param1:String) : void;

    }
}
