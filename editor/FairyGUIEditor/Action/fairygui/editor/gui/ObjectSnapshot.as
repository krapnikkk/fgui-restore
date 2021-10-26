package fairygui.editor.gui
{
    import *.*;
    import __AS3__.vec.*;

    public class ObjectSnapshot extends Object
    {
        private var _obj:FObject;
        public var x:Number;
        public var y:Number;
        public var width:Number;
        public var height:Number;
        public var scaleX:Number;
        public var scaleY:Number;
        public var skewX:Number;
        public var skewY:Number;
        public var pivotX:Number;
        public var pivotY:Number;
        public var anchor:Boolean;
        public var alpha:Number;
        public var rotation:Number;
        public var color:uint;
        public var playing:Boolean;
        public var frame:int;
        public var visible:Boolean;
        public var filterData:FilterData;
        public var text:String;
        public var icon:String;
        private static var pool:Vector.<ObjectSnapshot> = new Vector.<ObjectSnapshot>;

        public function ObjectSnapshot()
        {
            this.filterData = new FilterData();
            return;
        }// end function

        public function take() : void
        {
            this._obj.takeSnapshot(this);
            return;
        }// end function

        public function load() : void
        {
            this._obj.readSnapshot(this);
            return;
        }// end function

        public static function getFromPool(param1:FObject) : ObjectSnapshot
        {
            var _loc_2:* = null;
            if (pool.length)
            {
                _loc_2 = pool.pop();
            }
            else
            {
                _loc_2 = new ObjectSnapshot;
            }
            _loc_2._obj = param1;
            if (_loc_2._obj)
            {
                _loc_2._obj._hasSnapshot = true;
            }
            return _loc_2;
        }// end function

        public static function returnToPool(param1:Vector.<ObjectSnapshot>) : void
        {
            var _loc_2:* = null;
            for each (_loc_2 in param1)
            {
                
                if (_loc_2._obj)
                {
                    _loc_2._obj._hasSnapshot = false;
                }
                _loc_2._obj = null;
                pool.push(_loc_2);
            }
            return;
        }// end function

    }
}
