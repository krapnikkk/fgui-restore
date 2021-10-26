package fairygui.editor.api
{
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.geom.*;

    public interface IDocument
    {

        public function IDocument();

        function get editor() : IEditor;

        function get panel() : GComponent;

        function get uid() : String;

        function get packageItem() : FPackageItem;

        function get content() : FComponent;

        function get editingTransition() : FTransition;

        function get timelineMode() : Boolean;

        function get isModified() : Boolean;

        function setModified(param1:Boolean = true) : void;

        function save() : void;

        function serialize() : Object;

        function release() : void;

        function get history() : IDocHistory;

        function get inspectingTarget() : FObject;

        function get inspectingTargets() : Vector.<FObject>;

        function get inspectingObjectType() : String;

        function getInspectingTargetCount(param1:String) : int;

        function refreshInspectors(param1:int = 0) : void;

        function selectObject(param1:FObject, param2:Boolean = false, param3:Boolean = false) : void;

        function unselectObject(param1:FObject) : void;

        function selectAll() : void;

        function unselectAll() : void;

        function getSelection() : Vector.<FObject>;

        function setSelection(param1:Object) : void;

        function adjustDepth(param1:int) : void;

        function moveSelection(param1:Number, param2:Number) : void;

        function copySelection() : void;

        function deleteSelection() : void;

        function paste(param1:Point = null, param2:Boolean = false) : void;

        function canPaste() : Boolean;

        function replaceSelection(param1:String) : void;

        function get openedGroup() : FObject;

        function openGroup(param1:FObject) : void;

        function closeGroup(param1:int = 1) : void;

        function createGroup() : void;

        function destroyGroup() : void;

        function showContextMenu() : void;

        function openChild(param1:FObject) : void;

        function enterTimelineMode(param1:String) : void;

        function exitTimelineMode() : void;

        function refreshTransition() : void;

        function insertObject(param1:String, param2:Point = null, param3:int = -1) : FObject;

        function removeObject(param1:FObject) : void;

        function addController(param1:XData) : void;

        function updateController(param1:String, param2:XData) : void;

        function removeController(param1:String) : void;

        function switchPage(param1:String, param2:int) : int;

        function addTransition(param1:String = null) : FTransition;

        function removeTransition(param1:String) : void;

        function duplicateTransition(param1:String, param2:String = null) : FTransition;

        function get head() : int;

        function set head(param1:int) : void;

        function setTransitionProperty(param1:FTransition, param2:String, param3) : void;

        function createKeyFrame(param1:FObject, param2:String) : FTransitionItem;

        function addKeyFrame(param1:FTransitionItem) : void;

        function setKeyFrameProperty(param1:FTransitionItem, param2:String, param3) : void;

        function setKeyFrameValue(param1:FTransitionItem, param2:Object) : void;

        function setKeyFramePathPos(param1:FTransitionItem, param2:int, param3:Number, param4:Number) : void;

        function setKeyFrameControlPointPos(param1:FTransitionItem, param2:int, param3:int, param4:Number, param5:Number) : void;

        function setKeyFrameControlPointSmooth(param1:FTransitionItem, param2:int, param3:Boolean) : void;

        function setKeyFrame(param1:String, param2:String, param3:int) : void;

        function setKeyFrames(param1:String, param2:String, param3:Object) : void;

        function removeKeyFrame(param1:FTransitionItem) : void;

        function removeKeyFrames(param1:String, param2:String) : void;

        function updateTransition(param1:Object) : void;

        function pickObject(param1:FObject, param2:Function, param3:Function = null, param4:Function = null) : void;

        function cancelPickObject() : void;

        function get isPickingObject() : Boolean;

        function globalToCanvas(param1:Number, param2:Number) : Point;

        function setVar(param1:String, param2) : void;

        function getVar(param1:String);

        function setMeta(param1:String, param2) : void;

        function getMeta(param1:String);

    }
}
