package fairygui.editor.api
{
    import fairygui.*;

    public interface IInspectorPanel
    {

        public function IInspectorPanel();

        function get panel() : GComponent;

        function updateUI() : Boolean;

    }
}
