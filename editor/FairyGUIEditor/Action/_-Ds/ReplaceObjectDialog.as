package _-Ds
{
    import fairygui.*;
    import fairygui.editor.api.*;

    public class ReplaceObjectDialog extends _-3g
    {

        public function ReplaceObjectDialog(param1:IEditor)
        {
            var editor:* = param1;
            super(editor);
            this.contentPane = UIPackage.createObject("Builder", "ReplaceObjectDialog").asCom;
            this.centerOn(_editor.groot, true);
            var func:* = function (param1:String) : void
            {
                contentPane.getChild("target").text = param1;
                return;
            }// end function
            ;
            this.contentPane.getChild("text").addClickListener(function () : void
            {
                func("text");
                return;
            }// end function
            );
            this.contentPane.getChild("richtext").addClickListener(function () : void
            {
                func("richtext");
                return;
            }// end function
            );
            this.contentPane.getChild("graph").addClickListener(function () : void
            {
                func("graph");
                return;
            }// end function
            );
            this.contentPane.getChild("loader").addClickListener(function () : void
            {
                func("loader");
                return;
            }// end function
            );
            this.contentPane.getChild("ok").addClickListener(_-IJ);
            this.contentPane.getChild("cancel").addClickListener(closeEventHandler);
            return;
        }// end function

        override public function _-2a() : void
        {
            var target:* = contentPane.getChild("target").text;
            try
            {
                _editor.docView.activeDocument.replaceSelection(target);
            }
            catch (err:Error)
            {
                _editor.alert(null, err);
                return;
            }
            this.hide();
            return;
        }// end function

    }
}
