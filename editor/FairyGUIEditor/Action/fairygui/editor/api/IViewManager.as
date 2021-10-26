package fairygui.editor.api
{
    import __AS3__.vec.*;
    import fairygui.*;

    public interface IViewManager
    {

        public function IViewManager();

        function addView(param1:Object, param2:String, param3:String, param4:String, param5:Object = null) : GComponent;

        function getView(param1:String) : GComponent;

        function get viewIds() : Vector.<String>;

        function removeView(param1:String) : void;

        function showView(param1:String) : void;

        function hideView(param1:String) : void;

        function isViewShowing(param1:String) : Boolean;

        function setViewTitle(param1:String, param2:String) : void;

        function resetLayout() : void;

    }
}
