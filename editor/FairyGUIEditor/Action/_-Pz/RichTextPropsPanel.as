package _-Pz
{
    import _-Gs.*;
    import fairygui.*;
    import fairygui.editor.*;
    import fairygui.editor.api.*;

    public class RichTextPropsPanel extends _-5I
    {

        public function RichTextPropsPanel(param1:IEditor)
        {
            _editor = param1;
            _panel = UIPackage.createObject("Builder", "RichTextPropsPanel").asCom;
            _form = new _-7r(_panel);
            _form.onPropChanged = _-Ix;
            _form._-G([{name:"text", type:"string"}, {name:"font", type:"string"}, {name:"fontSize", type:"int", min:1}, {name:"ubbEnabled", type:"bool"}, {name:"varsEnabled", type:"bool"}, {name:"color", type:"uint"}, {name:"autoSize", type:"string", items:[Consts.strings.text331, Consts.strings.text168, Consts.strings.text169, Consts.strings.text304], values:["none", "both", "height", "shrink"]}, {name:"align", type:"string"}, {name:"verticalAlign", type:"string"}, {name:"leading", type:"int"}, {name:"letterSpacing", type:"int"}, {name:"underline", type:"bool"}, {name:"italic", type:"bool"}, {name:"bold", type:"bool"}, {name:"singleLine", type:"bool"}, {name:"stroke", type:"bool"}, {name:"strokeColor", type:"uint"}, {name:"strokeSize", type:"int", min:0}, {name:"shadow", type:"bool"}, {name:"shadowX", type:"int"}, {name:"shadowY", type:"int"}, {name:"clearOnPublish", type:"bool"}]);
            return;
        }// end function

    }
}
