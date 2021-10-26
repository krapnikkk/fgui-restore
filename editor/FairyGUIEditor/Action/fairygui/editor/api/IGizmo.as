package fairygui.editor.api
{
    import fairygui.editor.gui.*;
    import flash.display.*;

    public interface IGizmo
    {

        public function IGizmo();

        function get activeHandleIndex() : int;

        function get activeHandleType() : int;

        function get keyFrame() : FTransitionItem;

        function get verticesEditing() : Boolean;

        function get normalUI() : Sprite;

        function get selectedUI() : Sprite;

        function refresh(param1:Boolean = false) : void;

    }
}
