package _-Ds
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;

    public class FolderPropertyDialog extends _-3g
    {
        private var _-39:FPackageItem;

        public function FolderPropertyDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "FolderPropertyDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.contentPane.getChild("ok").addClickListener(_-IJ);
            this.contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        public function open(param1:FPackageItem) : void
        {
            this._-39 = param1;
            this.frame.text = this._-39.fileName;
            var _loc_2:* = contentPane.getChild("atlas").asComboBox;
            PublishSettings(this._-39.owner.publishSettings).fillCombo(_loc_2);
            if (this._-39.folderSettings.atlas != null)
            {
                contentPane.getChild("atlasEnabled").asButton.selected = true;
                _loc_2.value = this._-39.folderSettings.atlas;
            }
            else
            {
                contentPane.getChild("atlasEnabled").asButton.selected = false;
                _loc_2.value = "default";
            }
            show();
            return;
        }// end function

        override public function _-2a() : void
        {
            if (contentPane.getChild("atlasEnabled").asButton.selected)
            {
                this._-39.folderSettings.atlas = contentPane.getChild("atlas").asComboBox.value;
            }
            else
            {
                this._-39.folderSettings.atlas = null;
            }
            this._-39.owner.save();
            _editor.emit(EditorEvent.PackageItemChanged, this._-39);
            hide();
            return;
        }// end function

    }
}
