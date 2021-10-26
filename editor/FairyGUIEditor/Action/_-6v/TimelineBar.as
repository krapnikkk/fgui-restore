package _-6v
{
    import *.*;
    import fairygui.*;
    import fairygui.editor.gui.*;

    public class TimelineBar extends GButton
    {
        private var _-N0:GObject;
        private var _-6o:_-KM;
        private var _-6k:String;
        private var _-AL:GComponent;
        private var _-G2:Array;
        private var _-OK:String;
        private var _-HU:GComponent;
        private var _-Bo:Object;
        private var _pool:GObjectPool;
        private var _maxFrame:int;
        private var _targetId:String;
        private var _type:String;
        private var _target:FObject;
        public var _needRefresh:Boolean;

        public function TimelineBar()
        {
            return;
        }// end function

        override protected function constructFromXML(param1:XML) : void
        {
            super.constructFromXML(param1);
            this.opaque = false;
            this.touchable = false;
            this._-6o = new _-KM();
            addChild(this._-6o);
            this._-N0 = getChild("range");
            this._-N0.x = 0;
            this._-N0.visible = false;
            this._-N0.touchable = false;
            addChild(this._-N0);
            this._pool = new GObjectPool();
            this._-Bo = {};
            this._-OK = UIPackage.getItemURL("Builder", "TweenLine");
            this._-HU = new GComponent();
            this._-HU.y = 0;
            this._-HU.touchable = false;
            addChild(this._-HU);
            this._-G2 = [];
            this._-6k = UIPackage.getItemURL("Builder", "TimelineIndicator");
            this._-AL = new GComponent();
            this._-AL.touchable = false;
            this._-AL.y = 0;
            addChild(this._-AL);
            return;
        }// end function

        public function init(param1:String, param2:String, param3:FObject) : void
        {
            this._targetId = param1;
            this._type = param2;
            this._target = param3;
            return;
        }// end function

        public function get targetId() : String
        {
            return this._targetId;
        }// end function

        public function get type() : String
        {
            return this._type;
        }// end function

        public function get target() : FObject
        {
            return this._target;
        }// end function

        public function _-6J(param1:int) : void
        {
            this._-6o.update(param1);
            this.width = this._-6o.width;
            return;
        }// end function

        public function _-8z(param1:int) : int
        {
            var _loc_3:* = null;
            var _loc_2:* = param1;
            while (_loc_2 <= this._maxFrame)
            {
                
                _loc_3 = this._-G2[_loc_2];
                if (_loc_3 != null)
                {
                    return _loc_2;
                }
                _loc_2++;
            }
            return -1;
        }// end function

        public function setKeyFrame(param1:int, param2:FTransitionItem) : void
        {
            var _loc_4:* = null;
            var _loc_3:* = this._-G2[param1];
            if (!_loc_3)
            {
                _loc_3 = new KeyFrame();
                this._-G2[param1] = _loc_3;
                _loc_4 = this._pool.getObject(this._-6k).asCom;
                _loc_4.x = param1 * 10;
                _loc_4.y = 0;
                if (param2.label)
                {
                    _loc_4.getController("c1").selectedIndex = 1;
                    _loc_4.getChild("label").text = param2.label;
                }
                else
                {
                    _loc_4.getController("c1").selectedIndex = 0;
                }
                this._-AL.addChild(_loc_4);
                _loc_3.indicator = _loc_4;
                if (param1 > this._maxFrame)
                {
                    this._maxFrame = param1;
                    this._-2e();
                }
            }
            _loc_3.data = param2;
            return;
        }// end function

        public function _-BQ(param1:int) : void
        {
            var _loc_2:* = this._-G2[param1];
            if (!_loc_2)
            {
                return;
            }
            var _loc_3:* = _loc_2.indicator;
            if (_loc_2.data.label)
            {
                _loc_3.getController("c1").selectedIndex = 1;
                _loc_3.getChild("label").text = _loc_2.data.label;
            }
            else
            {
                _loc_3.getController("c1").selectedIndex = 0;
            }
            return;
        }// end function

        public function removeKeyFrame(param1:int) : void
        {
            var _loc_2:* = this._-G2[param1];
            if (!_loc_2)
            {
                return;
            }
            this._-AL.removeChild(_loc_2.indicator);
            this._pool.returnObject(_loc_2.indicator);
            this._-G2[param1] = null;
            this._maxFrame = -1;
            var _loc_3:* = this._-G2.length;
            var _loc_4:* = _loc_3 - 1;
            while (_loc_4 >= 0)
            {
                
                if (this._-G2[_loc_4] != null)
                {
                    this._maxFrame = _loc_4;
                    break;
                }
                _loc_4 = _loc_4 - 1;
            }
            this._-2e();
            return;
        }// end function

        public function _-C1(param1:int) : Boolean
        {
            return this._-G2[param1];
        }// end function

        public function _-P3(param1:int) : FTransitionItem
        {
            var _loc_2:* = this._-G2[param1];
            if (!_loc_2)
            {
                return null;
            }
            return _loc_2.data;
        }// end function

        public function get maxFrame() : int
        {
            return this._maxFrame;
        }// end function

        public function get empty() : Boolean
        {
            return this._-AL.numChildren == 0;
        }// end function

        public function _-N5(param1:int, param2:int) : void
        {
            var _loc_4:* = null;
            var _loc_3:* = this._-G2[param1];
            if (!_loc_3)
            {
                return;
            }
            if (!_loc_3.tweenIndicator)
            {
                _loc_3.tweenIndicator = this._pool.getObject(this._-OK).asCom;
                this._-HU.addChild(_loc_3.tweenIndicator);
            }
            if (param2 - param1 <= 1)
            {
                _loc_3.tweenIndicator.visible = false;
            }
            else
            {
                _loc_3.tweenIndicator.visible = true;
                _loc_3.tweenIndicator.x = (param1 + 1) * 10;
                _loc_3.tweenIndicator.width = (param2 - param1 - 1) * 10;
                if (param2 - param1 == 2)
                {
                    _loc_3.tweenIndicator.getController("c1").selectedIndex = 1;
                }
                else
                {
                    _loc_3.tweenIndicator.getController("c1").selectedIndex = 0;
                    _loc_4 = _loc_3.tweenIndicator.getChild("body");
                    _loc_4.width = _loc_3.tweenIndicator.width - (_loc_3.tweenIndicator.sourceWidth - _loc_4.initWidth);
                }
            }
            return;
        }// end function

        public function _-Lp(param1:int) : void
        {
            var _loc_2:* = this._-G2[param1];
            if (!_loc_2 || !_loc_2.tweenIndicator)
            {
                return;
            }
            this._-HU.removeChild(_loc_2.tweenIndicator);
            this._pool.returnObject(_loc_2.tweenIndicator);
            _loc_2.tweenIndicator = null;
            return;
        }// end function

        public function _-Kd(param1:int) : int
        {
            var _loc_3:* = null;
            var _loc_2:* = param1;
            while (_loc_2 >= 0)
            {
                
                _loc_3 = this._-G2[_loc_2];
                if (_loc_3 != null)
                {
                    if (_loc_3.tweenIndicator != null)
                    {
                        return _loc_2;
                    }
                    if (_loc_2 != this._maxFrame)
                    {
                        return -1;
                    }
                }
                _loc_2 = _loc_2 - 1;
            }
            return -1;
        }// end function

        public function _-9J(param1:int) : int
        {
            var _loc_2:* = 0;
            if (this._-G2[param1] != null && param1 != this._maxFrame)
            {
                return param1;
            }
            _loc_2 = param1 - 1;
            while (_loc_2 >= 0)
            {
                
                if (this._-G2[_loc_2] != null)
                {
                    return _loc_2;
                }
                _loc_2 = _loc_2 - 1;
            }
            return -1;
        }// end function

        public function reset() : void
        {
            var _loc_2:* = null;
            this._-AL.removeChildren();
            this._-HU.removeChildren();
            var _loc_1:* = 0;
            while (_loc_1 <= this._maxFrame)
            {
                
                _loc_2 = this._-G2[_loc_1];
                if (_loc_2)
                {
                    if (_loc_2.indicator)
                    {
                        this._pool.returnObject(_loc_2.indicator);
                    }
                    if (_loc_2.tweenIndicator)
                    {
                        this._pool.returnObject(_loc_2.tweenIndicator);
                    }
                }
                _loc_1++;
            }
            this._-G2.length = 0;
            this._maxFrame = -1;
            this._-N0.visible = false;
            return;
        }// end function

        private function _-2e() : void
        {
            if (this._maxFrame == -1)
            {
                this._-N0.visible = false;
            }
            else
            {
                this._-N0.visible = true;
                this._-N0.width = (this._maxFrame + 1) * 10;
            }
            return;
        }// end function

    }
}

import *.*;

import fairygui.*;

import fairygui.editor.gui.*;

class KeyFrame extends Object
{
    public var indicator:GComponent;
    public var tweenIndicator:GComponent;
    public var data:FTransitionItem;

    function KeyFrame()
    {
        return;
    }// end function

}

