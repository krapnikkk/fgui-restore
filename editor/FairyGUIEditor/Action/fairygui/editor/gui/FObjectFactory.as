package fairygui.editor.gui
{
    import fairygui.editor.api.*;

    public class FObjectFactory extends Object
    {
        public static var constructingDepth:int;

        public function FObjectFactory()
        {
            return;
        }// end function

        public static function createObject(param1:FPackageItem, param2:int = 0) : FObject
        {
            var pi:* = param1;
            var flags:* = param2;
            var g:* = newObject(pi, flags);
            g._underConstruct = true;
            var _loc_5:* = constructingDepth + 1;
            constructingDepth = _loc_5;
            try
            {
                g.create();
            }
            catch (e:Error)
            {
                throw null;
            }
            finally
            {
                var _loc_7:* = constructingDepth - 1;
                constructingDepth = _loc_7;
                g._underConstruct = false;
            }
            return g;
        }// end function

        public static function createObject2(param1:IUIPackage, param2:String, param3:MissingInfo = null, param4:int = 0) : FObject
        {
            var pkg:* = param1;
            var type:* = param2;
            var missingInfo:* = param3;
            var flags:* = param4;
            var g:* = newObject2(pkg, type, missingInfo, flags);
            g._underConstruct = true;
            var _loc_7:* = constructingDepth + 1;
            constructingDepth = _loc_7;
            try
            {
                g.create();
            }
            catch (e:Error)
            {
                throw null;
            }
            finally
            {
                var _loc_9:* = constructingDepth - 1;
                constructingDepth = _loc_9;
                g._underConstruct = false;
            }
            return g;
        }// end function

        public static function createObject3(param1:FDisplayListItem, param2:int = 0) : FObject
        {
            var di:* = param1;
            var flags:* = param2;
            var g:* = newObject3(di, flags);
            g._underConstruct = true;
            var _loc_5:* = constructingDepth + 1;
            constructingDepth = _loc_5;
            try
            {
                g.create();
            }
            catch (e:Error)
            {
                throw null;
            }
            finally
            {
                var _loc_7:* = constructingDepth - 1;
                constructingDepth = _loc_7;
                g._underConstruct = false;
            }
            return g;
        }// end function

        static function newObject(param1:FPackageItem, param2:int = 0) : FObject
        {
            var _loc_3:* = getClassByType(param1.type);
            var _loc_4:* = new _loc_3;
            _loc_4._pkg = param1.owner;
            _loc_4._flags = param2;
            _loc_4._res = new ResourceRef(param1, null, param2);
            return _loc_4;
        }// end function

        static function newObject2(param1:IUIPackage, param2:String, param3:MissingInfo = null, param4:int = 0) : FObject
        {
            var _loc_5:* = getClassByType(param2);
            var _loc_6:* = new getClassByType(param2);
            _loc_6._pkg = FPackage(param1);
            _loc_6._flags = param4;
            if (param3)
            {
                _loc_6._res = new ResourceRef(null, param3, param4);
            }
            return _loc_6;
        }// end function

        static function newObject3(param1:FDisplayListItem, param2:int = 0) : FObject
        {
            if (param1.packageItem)
            {
                return newObject(param1.packageItem, param2);
            }
            return newObject2(param1.pkg, param1.type, param1.missingInfo, param2);
        }// end function

        public static function newExtention(param1:IUIPackage, param2:String) : ComExtention
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            switch(param2)
            {
                case "Label":
                {
                    _loc_3 = new FLabel();
                    break;
                }
                case "Button":
                {
                    _loc_3 = new FButton();
                    break;
                }
                case "ProgressBar":
                {
                    _loc_3 = new FProgressBar();
                    break;
                }
                case "ScrollBar":
                {
                    _loc_3 = new FScrollBar();
                    break;
                }
                case "Slider":
                {
                    _loc_3 = new FSlider();
                    break;
                }
                case "ComboBox":
                {
                    _loc_3 = new FComboBox();
                    break;
                }
                default:
                {
                    _loc_4 = param1.project.getCustomExtension(param2);
                    if (_loc_4)
                    {
                        return newExtention(param1, _loc_4.superClassName);
                    }
                    break;
                    break;
                }
            }
            if (_loc_3)
            {
                _loc_3._type = param2;
            }
            return _loc_3;
        }// end function

        public static function getClassByType(param1:String) : Object
        {
            var _loc_2:* = null;
            switch(param1)
            {
                case FObjectType.IMAGE:
                {
                    _loc_2 = FImage;
                    break;
                }
                case FObjectType.SWF:
                {
                    _loc_2 = FSwfObject;
                    break;
                }
                case FObjectType.MOVIECLIP:
                case "jta":
                {
                    _loc_2 = FMovieClip;
                    break;
                }
                case FObjectType.COMPONENT:
                {
                    _loc_2 = FComponent;
                    break;
                }
                case FObjectType.TEXT:
                {
                    _loc_2 = FTextField;
                    break;
                }
                case FObjectType.RICHTEXT:
                {
                    _loc_2 = FRichTextField;
                    break;
                }
                case FObjectType.GROUP:
                {
                    _loc_2 = FGroup;
                    break;
                }
                case FObjectType.LIST:
                {
                    _loc_2 = FList;
                    break;
                }
                case FObjectType.GRAPH:
                {
                    _loc_2 = FGraph;
                    break;
                }
                case FObjectType.LOADER:
                {
                    _loc_2 = FLoader;
                    break;
                }
                default:
                {
                    _loc_2 = FGraph;
                    break;
                    break;
                }
            }
            return _loc_2;
        }// end function

    }
}
