package _-C9
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.editor.api.*;
    import fairygui.editor.gui.*;

    public class _-Am extends Object implements IDocHistoryItem
    {
        private var _-4:String;
        private var _-3T:FTransition;
        private var _-FG:FTransitionItem;
        private var _-Ny:Array;
        private var _value:Object;
        private var _-3b:int;
        private var _-6S:int;

        public function _-Am()
        {
            return;
        }// end function

        public function get isPersists() : Boolean
        {
            return true;
        }// end function

        public function process(param1:IDocument) : Boolean
        {
            var _loc_2:* = null;
            var _loc_3:* = undefined;
            if (this._-6S == 0)
            {
                _loc_2 = this._-3T;
            }
            else
            {
                _loc_2 = param1.editingTransition;
                if (!_loc_2)
                {
                    return false;
                }
            }
            switch(this._-6S)
            {
                case 0:
                {
                    _loc_3 = _loc_2[this._-4];
                    param1.setTransitionProperty(_loc_2, this._-4, this._value);
                    this._value = _loc_3;
                    param1.unselectAll();
                    break;
                }
                case 1:
                {
                    _loc_3 = _loc_2.write(false);
                    param1.updateTransition(this._value);
                    this._value = _loc_3;
                    break;
                }
                case 2:
                {
                    _loc_3 = this._-FG[this._-4];
                    param1.setKeyFrameProperty(this._-FG, this._-4, this._value);
                    this._value = _loc_3;
                    param1.editor.timelineView.selectKeyFrame(this._-FG);
                    break;
                }
                case 3:
                {
                    _loc_3 = this._-FG.value;
                    this._value = param1.setKeyFrameValue(this._-FG, this._value);
                    this._value = _loc_3;
                    if (!this._-FG.prevItem || !this._-FG.prevItem.target || !this._-FG.prevItem.target.docElement.gizmo.keyFrame)
                    {
                        param1.editor.timelineView.selectKeyFrame(this._-FG);
                    }
                    break;
                }
                case 4:
                {
                    param1.removeKeyFrame(this._-FG);
                    this._-6S = 5;
                    break;
                }
                case 5:
                {
                    param1.addKeyFrame(this._-FG);
                    param1.editor.timelineView.selectKeyFrame(this._-FG);
                    this._-6S = 4;
                    break;
                }
                case 6:
                {
                    _loc_2.addItems(this._-Ny);
                    this._-6S = 7;
                    break;
                }
                case 7:
                {
                    param1.removeKeyFrames(this._-Ny[0].targetId, this._-Ny[0].type);
                    this._-6S = 6;
                    break;
                }
                case 8:
                {
                    _loc_3 = this._-FG.pathPoints[this._-3b];
                    this._-FG.pathPoints[this._-3b] = this._value;
                    this._-FG.pathPoints = this._-FG.pathPoints;
                    param1.refreshTransition();
                    param1.editor.timelineView.selectKeyFrame(this._-FG);
                    this._value = _loc_3;
                    break;
                }
                case 9:
                {
                    _loc_3 = this._-FG.pathPoints;
                    this._-FG.pathPoints = this._value;
                    param1.refreshTransition();
                    param1.editor.timelineView.selectKeyFrame(this._-FG);
                    this._value = _loc_3;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return true;
        }// end function

        public static function setProperty(param1:IDocument, param2:FTransition, param3:String, param4) : void
        {
            var _loc_8:* = null;
            if (param1.history.processing)
            {
                return;
            }
            var _loc_5:* = param1.history.getPendingList();
            var _loc_6:* = _loc_5.length - 1;
            while (_loc_6 >= 0)
            {
                
                _loc_8 = _loc_5[_loc_6] as ;
                if (_loc_8 && _loc_8._-3T == param2 && _loc_8._-6S == 0 && _loc_8._-4 == param3)
                {
                    return;
                }
                _loc_6 = _loc_6 - 1;
            }
            var _loc_7:* = new _-Am;
            _loc_7._-6S = 0;
            _loc_7._-3T = param2;
            _loc_7._-4 = param3;
            _loc_7._value = param4;
            param1.history.add(_loc_7);
            return;
        }// end function

        public static function update(param1:IDocument, param2) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            if (!param1.timelineMode)
            {
                return;
            }
            var _loc_3:* = new _-Am;
            _loc_3._-6S = 1;
            _loc_3._value = param2;
            param1.history.add(_loc_3);
            return;
        }// end function

        public static function setItemProperty(param1:IDocument, param2:FTransitionItem, param3:String, param4) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            if (!param1.timelineMode)
            {
                return;
            }
            var _loc_5:* = new _-Am;
            _loc_5._-6S = 2;
            _loc_5._-FG = param2;
            _loc_5._-4 = param3;
            _loc_5._value = param4;
            param1.history.add(_loc_5);
            return;
        }// end function

        public static function _-NM(param1:IDocument, param2:FTransitionItem, param3:FTransitionValue) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            if (!param1.timelineMode)
            {
                return;
            }
            var _loc_4:* = new _-Am;
            _loc_4._-6S = 3;
            _loc_4._-FG = param2;
            _loc_4._value = param3;
            param1.history.add(_loc_4);
            return;
        }// end function

        public static function _-CY(param1:IDocument, param2:FTransitionItem, param3:int, param4) : void
        {
            var _loc_8:* = null;
            if (param1.history.processing)
            {
                return;
            }
            if (!param1.timelineMode)
            {
                return;
            }
            var _loc_5:* = param1.history.getPendingList();
            var _loc_6:* = _loc_5.length - 1;
            while (_loc_6 >= 0)
            {
                
                _loc_8 = _loc_5[_loc_6] as ;
                if (param2 && _loc_8._-6S == 2 && _loc_8._-FG == param2 && _loc_8._-3b == param3)
                {
                    return;
                }
                _loc_6 = _loc_6 - 1;
            }
            var _loc_7:* = new _-Am;
            _loc_7._-6S = 8;
            _loc_7._-FG = param2;
            _loc_7._-3b = param3;
            _loc_7._value = param4;
            param1.history.add(_loc_7);
            return;
        }// end function

        public static function _-Kr(param1:IDocument, param2:FTransitionItem, param3) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            if (!param1.timelineMode)
            {
                return;
            }
            var _loc_4:* = new _-Am;
            _loc_4._-6S = 9;
            _loc_4._-FG = param2;
            _loc_4._value = param3;
            param1.history.add(_loc_4);
            return;
        }// end function

        public static function addItem(param1:IDocument, param2:FTransitionItem) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            if (!param1.timelineMode)
            {
                return;
            }
            var _loc_3:* = new _-Am;
            _loc_3._-6S = 4;
            _loc_3._-FG = param2;
            param1.history.add(_loc_3);
            return;
        }// end function

        public static function removeItem(param1:IDocument, param2:FTransitionItem) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            if (!param1.timelineMode)
            {
                return;
            }
            var _loc_3:* = new _-Am;
            _loc_3._-6S = 5;
            _loc_3._-FG = param2;
            param1.history.add(_loc_3);
            return;
        }// end function

        public static function _-NS(param1:IDocument, param2:Array) : void
        {
            if (param1.history.processing)
            {
                return;
            }
            if (!param1.timelineMode)
            {
                return;
            }
            var _loc_3:* = new _-Am;
            _loc_3._-6S = 6;
            _loc_3._-Ny = param2;
            param1.history.add(_loc_3);
            return;
        }// end function

    }
}
