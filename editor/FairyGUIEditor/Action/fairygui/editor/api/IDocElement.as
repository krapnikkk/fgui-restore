package fairygui.editor.api
{
    import fairygui.editor.gui.*;
    import fairygui.utils.*;

    public interface IDocElement
    {

        public function IDocElement();

        function get owner() : IDocument;

        function get isRoot() : Boolean;

        function get isValid() : Boolean;

        function get displayIcon() : String;

        function get relationsDisabled() : Boolean;

        function get selected() : Boolean;

        function set selected(param1:Boolean) : void;

        function get gizmo() : IGizmo;

        function setProperty(param1:String, param2) : void;

        function setGearProperty(param1:int, param2:String, param3) : void;

        function setRelation(param1:FObject, param2:String) : void;

        function removeRelation(param1:FObject) : void;

        function updateRelations(param1:XData) : void;

        function setExtensionProperty(param1:String, param2) : void;

        function setVertexPosition(param1:int, param2:Number, param3:Number) : void;

        function setVertexDistance(param1:int, param2:Number) : void;

        function setChildProperty(param1:String, param2:int, param3) : void;

        function setVar(param1:String, param2) : void;

        function getVar(param1:String);

    }
}
