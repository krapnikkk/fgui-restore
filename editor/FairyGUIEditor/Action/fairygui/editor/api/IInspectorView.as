package fairygui.editor.api
{
    import __AS3__.vec.*;
    import fairygui.*;

    public interface IInspectorView
    {

        public function IInspectorView();

        function get visibleInspectors() : Vector.<IInspectorPanel>;

        function registerInspector(param1:Class, param2:String, param3:String, param4:String = null, param5:int = 0) : void;

        function getInspector(param1:String) : IInspectorPanel;

        function setTitle(param1:String, param2:String) : void;

        function showPopup(param1:String, param2:GObject, param3:Object = null, param4:Boolean = false) : void;

        function show(param1:Array) : void;

        function showDefault() : void;

    }
}
