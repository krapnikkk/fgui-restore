package fairygui
{
    import *.*;

    public class UIObjectFactory extends Object
    {
        static var packageItemExtensions:Object = {};
        private static var loaderType:Class;

        public function UIObjectFactory()
        {
            return;
        }// end function

        public static function setPackageItemExtension(param1:String, param2:Class) : void
        {
            if (param1 == null)
            {
                throw new Error("Invaild url: " + param1);
            }
            var _loc_3:* = UIPackage.getItemByURL(param1);
            if (_loc_3 != null)
            {
                _loc_3.extensionType = param2;
            }
            packageItemExtensions[param1] = param2;
            return;
        }// end function

        public static function setLoaderExtension(param1:Class) : void
        {
            loaderType = param1;
            return;
        }// end function

        static function resolvePackageItemExtension(param1:PackageItem) : void
        {
            param1.extensionType = packageItemExtensions["ui://" + param1.owner.id + param1.id];
            if (!param1.extensionType)
            {
                param1.extensionType = packageItemExtensions["ui://" + param1.owner.name + "/" + param1.name];
            }
            return;
        }// end function

        public static function newObject(param1:PackageItem) : GObject
        {
            var _loc_4:* = null;
            var _loc_3:* = null;
            var _loc_2:* = null;
            switch(param1.type) branch count is:<4>[20, 36, 28, 224, 44] default offset is:<224>;
            return new GImage();
            return new GMovieClip();
            return new GSwfObject();
            _loc_4 = param1.extensionType;
            if (_loc_4)
            {
                return new _loc_4;
            }
            _loc_3 = param1.owner.getComponentData(param1);
            _loc_2 = _loc_3.@extention;
            if (_loc_2 != null)
            {
                var _loc_5:* = _loc_2;
                while (_loc_5 === "Button")
                {
                    
                    return new GButton();
                    
                    return new GLabel();
                    
                    return new GProgressBar();
                    
                    return new GSlider();
                    
                    return new GScrollBar();
                    
                    return new GComboBox();
                    
                    return new GComponent();
                }
                if ("Label" === _loc_5) goto 118;
                if ("ProgressBar" === _loc_5) goto 127;
                if ("Slider" === _loc_5) goto 136;
                if ("ScrollBar" === _loc_5) goto 145;
                if ("ComboBox" === _loc_5) goto 154;
                ;
            }
            return new GComponent();
            return null;
        }// end function

        public static function newObject2(param1:String) : GObject
        {
            var _loc_2:* = param1;
            while (_loc_2 === "image")
            {
                
                return new GImage();
                
                return new GMovieClip();
                
                return new GSwfObject();
                
                return new GComponent();
                
                return new GTextField();
                
                return new GRichTextField();
                
                return new GTextInput();
                
                return new GGroup();
                
                return new GList();
                
                return new GTree();
                
                return new GGraph();
                
                if (loaderType != null)
                {
                    return new loaderType();
                }
                return new GLoader();
            }
            if ("movieclip" === _loc_2) goto 17;
            if ("swf" === _loc_2) goto 26;
            if ("component" === _loc_2) goto 35;
            if ("text" === _loc_2) goto 44;
            if ("richtext" === _loc_2) goto 53;
            if ("inputtext" === _loc_2) goto 62;
            if ("group" === _loc_2) goto 71;
            if ("list" === _loc_2) goto 80;
            if ("tree" === _loc_2) goto 89;
            if ("graph" === _loc_2) goto 98;
            if ("loader" === _loc_2) goto 107;
            return null;
        }// end function

    }
}
