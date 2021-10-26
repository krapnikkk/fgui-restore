package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.utils.*;
    import flash.events.*;
    import flash.filesystem.*;

    public class CreateProjectDialog extends _-3g
    {
        private var _path:GLabel;
        private var _name:GLabel;
        private var _type:GComboBox;

        public function CreateProjectDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "CreateProjectDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.modal = true;
            this._name = contentPane.getChild("name").asLabel;
            this._path = contentPane.getChild("path").asLabel;
            this._type = contentPane.getChild("type").asComboBox;
            this._type.items = Consts.supportedPlatformNames;
            this._type.values = Consts.supportedPlatformIds;
            this.contentPane.getChild("n6").addClickListener(_-IJ);
            this.contentPane.getChild("btnBrowse").addClickListener(this._-90);
            this.contentPane.getChild("n7").addClickListener(closeEventHandler);
            return;
        }// end function

        override protected function onShown() : void
        {
            var _loc_1:* = File.documentsDirectory.resolvePath("FGUIProject");
            var _loc_2:* = _loc_1.nativePath;
            var _loc_3:* = 1;
            while (_loc_1.exists)
            {
                
                _loc_1 = new File(_loc_2 + "(" + _loc_3 + ")");
                _loc_3++;
            }
            this._name.text = _loc_1.name;
            this._path.text = _loc_1.parent.nativePath;
            this._type.value = "Unity";
            this._name.requestFocus();
            return;
        }// end function

        override public function _-2a() : void
        {
            var path:String;
            try
            {
                path = new File(this._path.text).resolvePath(this._name.text).nativePath;
                FProject.createNew(path, this._name.text, this._type.value, "Package1");
                _editor.openProject(path);
                this.hide();
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
                return;
            }
            return;
        }// end function

        private function _-90(event:Event) : void
        {
            var evt:* = event;
            UtilsFile.browseForDirectory(Consts.strings.text74, function (param1:File) : void
            {
                _path.text = param1.nativePath;
                return;
            }// end function
            );
            return;
        }// end function

    }
}
