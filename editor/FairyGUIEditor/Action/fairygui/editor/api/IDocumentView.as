package fairygui.editor.api
{
    import _-Gs.*;
    import fairygui.editor.gui.*;

    public interface IDocumentView
    {

        public function IDocumentView();

        function openDocument(param1:FPackageItem, param2:Boolean = true) : IDocument;

        function closeDocument(param1:IDocument = null) : void;

        function closeDocuments(param1:IUIPackage) : void;

        function findDocument(param1:String) : IDocument;

        function get activeDocument() : IDocument;

        function saveDocument(param1:IDocument = null) : void;

        function saveAllDocuments() : void;

        function closeAllDocuments() : void;

        function queryToCloseDocument(param1:IDocument = null) : void;

        function queryToSaveAllDocuments(param1:Function) : void;

        function queryToCloseOtherDocuments() : void;

        function queryToCloseAllDocuments() : void;

        function requestFocus() : void;

        function handleKeyEvent(param1:_-4U) : void;

    }
}
