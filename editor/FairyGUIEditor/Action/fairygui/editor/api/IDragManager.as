package fairygui.editor.api
{
    import fairygui.*;

    public interface IDragManager
    {

        public function IDragManager();

        function get agent() : GObject;

        function get dragging() : Boolean;

        function startDrag(param1:Object = null, param2:Object = null, param3:Object = null, param4:Object = null) : void;

        function cancel() : void;

    }
}
