package fairygui.editor.plugin
{

    public interface IPublishHandler
    {

        public function IPublishHandler();

        function doExport(param1:IPublishData, param2:ICallback) : Boolean;

    }
}
