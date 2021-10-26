package fairygui.editor.api
{
    import fairygui.editor.gui.*;

    public interface ITestView
    {

        public function ITestView();

        function start() : void;

        function stop() : void;

        function reload() : void;

        function playTransition(param1:String) : void;

        function get running() : Boolean;

        function togglePopup(param1:FObject, param2:FObject = null, param3:String = null) : void;

        function showPopup(param1:FObject, param2:FObject = null, param3:String = null) : void;

        function hidePopup() : void;

        function showTooltips(param1:String) : void;

        function hideTooltips() : void;

    }
}
