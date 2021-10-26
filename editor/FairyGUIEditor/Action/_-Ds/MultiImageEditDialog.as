package _-Ds
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;
    import fairygui.editor.settings.*;
    import flash.events.*;

    public class MultiImageEditDialog extends _-3g
    {
        private var _items:Vector.<FPackageItem>;

        public function MultiImageEditDialog(param1:IEditor)
        {
            super(param1);
            this.contentPane = UIPackage.createObject("Builder", "MultiImageEditDialog").asCom;
            this.centerOn(_editor.groot, true);
            this.contentPane.getChild("n21").addClickListener(this._-1);
            this.contentPane.getChild("n23").addClickListener(closeEventHandler);
            return;
        }// end function

        public function open(param1:Vector.<FPackageItem>) : void
        {
            this._items = param1;
            contentPane.getController("scaleOption").selectedIndex = 0;
            contentPane.getController("qualityOption").selectedIndex = 0;
            contentPane.getChild("smoothing").asComboBox.selectedIndex = 0;
            contentPane.getChild("quality").text = "";
            var _loc_2:* = contentPane.getChild("atlas").asComboBox;
            PublishSettings(this._items[0].owner.publishSettings).fillCombo(_loc_2);
            _loc_2.selectedIndex = 0;
            contentPane.getChild("cb0").asButton.selected = false;
            contentPane.getChild("cb1").asButton.selected = false;
            contentPane.getChild("cb2").asButton.selected = false;
            contentPane.getChild("cb3").asButton.selected = false;
            contentPane.getChild("cb4").asButton.selected = false;
            show();
            return;
        }// end function

        private function apply(param1:Boolean) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_2:* = this._items.length;
            var _loc_5:* = new Vector.<IUIPackage>;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._items[_loc_3];
                _loc_6 = _loc_4.imageSettings;
                if (!_loc_6)
                {
                }
                else
                {
                    if (_loc_5.indexOf(_loc_4.owner) == -1)
                    {
                        _loc_5.push(_loc_4.owner);
                        _loc_4.owner.beginBatch();
                    }
                    if (_loc_4.type == FPackageItemType.MOVIECLIP)
                    {
                        if (contentPane.getChild("cb1").asButton.selected)
                        {
                            _loc_6.smoothing = contentPane.getChild("smoothing").asComboBox.selectedIndex == 1;
                        }
                        if (contentPane.getChild("cb3").asButton.selected)
                        {
                            _loc_6.atlas = contentPane.getChild("atlas").asComboBox.value;
                        }
                    }
                    else
                    {
                        if (contentPane.getChild("cb0").asButton.selected)
                        {
                            _loc_6.scaleOption = contentPane.getController("scaleOption").selectedPage;
                        }
                        if (contentPane.getChild("cb1").asButton.selected)
                        {
                            _loc_6.smoothing = contentPane.getChild("smoothing").asComboBox.selectedIndex == 1;
                        }
                        if (contentPane.getChild("cb2").asButton.selected)
                        {
                            _loc_6.qualityOption = contentPane.getController("qualityOption").selectedPage;
                            if (_loc_6.qualityOption == "custom")
                            {
                                _loc_6.quality = parseInt(contentPane.getChild("quality").text);
                            }
                        }
                        if (contentPane.getChild("cb3").asButton.selected)
                        {
                            _loc_6.atlas = contentPane.getChild("atlas").asComboBox.value;
                        }
                        if (contentPane.getChild("cb4").asButton.selected)
                        {
                            _loc_6.duplicatePadding = contentPane.getChild("duplicatePadding").asComboBox.selectedIndex == 1;
                        }
                    }
                    _loc_4.owner.save();
                    _editor.emit(EditorEvent.PackageItemChanged, _loc_4);
                }
                _loc_3++;
            }
            _loc_2 = _loc_5.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_5[_loc_3].endBatch();
                _loc_3++;
            }
            hide();
            return;
        }// end function

        private function _-1(event:Event) : void
        {
            this.apply(true);
            return;
        }// end function

        private function _-2p(event:Event) : void
        {
            this.apply(false);
            return;
        }// end function

        private function _-MQ(event:Event) : void
        {
            contentPane.getChild("n25").enabled = contentPane.getChild("n18").asComboBox.selectedIndex == 2;
            return;
        }// end function

    }
}
