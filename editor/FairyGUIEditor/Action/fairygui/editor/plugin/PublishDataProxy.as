package fairygui.editor.plugin
{
    import *.*;
    import fairygui.editor.*;
    import fairygui.editor.plugin.*;
    import fairygui.editor.publish.*;

    public class PublishDataProxy extends Object implements IPublishData
    {
        private var _data:_-4Z;
        private var _pkg:IEditorUIPackage;

        public function PublishDataProxy(param1:_-4Z) : void
        {
            this._data = param1;
            this._pkg = _-1L(this._data.project.editor).plugInManager.legacyProxy.getPackage(param1.pkg.name);
            return;
        }// end function

        public function get fileName() : String
        {
            return this._data.fileName;
        }// end function

        public function get singlePackage() : Boolean
        {
            return this._data.singlePackage;
        }// end function

        public function get extractAlpha() : Boolean
        {
            return this._data.extractAlpha;
        }// end function

        public function get filePath() : String
        {
            return this._data.path;
        }// end function

        public function get sprites() : String
        {
            return this._data.sprites;
        }// end function

        public function set sprites(param1:String) : void
        {
            this._data.sprites = param1;
            return;
        }// end function

        public function get exportDescOnly() : Boolean
        {
            return this._data.exportDescOnly;
        }// end function

        public function get outputClasses() : Object
        {
            return this._data.outputClasses;
        }// end function

        public function set outputClasses(param1:Object) : void
        {
            this._data.outputClasses = param1;
            return;
        }// end function

        public function get outputRes() : Object
        {
            return this._data.outputRes;
        }// end function

        public function set outputRes(param1:Object) : void
        {
            this._data.outputRes = param1;
            return;
        }// end function

        public function get fileExtention() : String
        {
            return this._data.fileExtension;
        }// end function

        public function get targetUIPackage() : IEditorUIPackage
        {
            return this._pkg;
        }// end function

        public function get outputDesc() : Object
        {
            return this._data.outputDesc;
        }// end function

        public function set outputDesc(param1:Object) : void
        {
            this._data.outputDesc = param1;
            return;
        }// end function

        public function preventDefault() : void
        {
            this._data.defaultPrevented = true;
            return;
        }// end function

    }
}
