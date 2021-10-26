package fairygui.editor.api
{

    public interface IDocHistoryItem
    {

        public function IDocHistoryItem();

        function get isPersists() : Boolean;

        function process(param1:IDocument) : Boolean;

    }
}
