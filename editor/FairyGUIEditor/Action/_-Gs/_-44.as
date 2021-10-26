package _-Gs
{
    import *.*;
    import fairygui.editor.*;
    import fairygui.editor.settings.*;
    import flash.events.*;
    import flash.ui.*;

    public class _-44 extends Object
    {
        private static var _-M:Object;
        public static var _-KK:Array;
        public static var _-PY:Object;
        public static const _-4F:Object = {F1:28672, F2:28928, F3:29184, F4:29440, F5:29696, F6:29952, F7:30208, F8:30464, F9:30720, F10:30976, F11:31232, F12:31488, A:65, B:66, C:67, D:68, E:69, F:70, G:71, H:72, I:73, J:74, K:75, L:76, M:77, N:78, O:79, P:80, Q:81, R:82, S:83, T:84, U:85, V:86, W:87, X:88, Y:89, Z:90, 0:48, 1:49, 2:50, 3:51, 4:52, 5:53, 6:54, 7:55, 8:56, 9:57, \':39, ,:44, -:45, .:46, /:47, ;:59, =:61, [:91, |:92, ]:93, `:96, ENTER:13, BACKSPACE:8, SPACE:32, DELETE:127, INSERT:11520, HOME:9216, PAGE_UP:8448, END:8960, PAGE_DOWN:8704};

        public function _-44()
        {
            return;
        }// end function

        public static function init() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            _-KK = [{id:"0002", hotkey:"CTRL+C", desc:Consts.strings.text2}, {id:"0003", hotkey:"CTRL+V", desc:Consts.strings.text3}, {id:"0004", hotkey:"CTRL+X", desc:Consts.strings.text1}, {id:"0005", hotkey:"CTRL+A", desc:Consts.strings.text5}, {id:"0006", hotkey:"CTRL+SHIFT+A", desc:Consts.strings.text23}, {id:"0007", hotkey:"CTRL+Z", desc:Consts.strings.text107}, {id:"0008", hotkey:"CTRL+Y", desc:Consts.strings.text108}, {id:"0101", hotkey:"CTRL+N", desc:Consts.strings.text348 + " " + Consts.strings.text174}, {id:"0102", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text175}, {id:"0103", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text176}, {id:"0104", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text177}, {id:"0105", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text178}, {id:"0106", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text179}, {id:"0107", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text180}, {id:"0108", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text240}, {id:"0109", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text244}, {id:"0110", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text19}, {id:"0111", hotkey:"CTRL+R", desc:Consts.strings.text348 + " " + Consts.strings.text181}, {id:"0112", hotkey:"CTRL+S", desc:Consts.strings.text348 + " " + Consts.strings.text351}, {id:"0113", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text352}, {id:"0114", hotkey:"CTRL+W", desc:Consts.strings.text348 + " " + Consts.strings.text353}, {id:"0115", hotkey:"CTRL+PAGE_UP", desc:Consts.strings.text348 + " " + Consts.strings.text354}, {id:"0127", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text14}, {id:"0128", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text15}, {id:"0116", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text38}, {id:"0118", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text41}, {id:"0119", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text37}, {id:"0120", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text182}, {id:"0121", hotkey:"F5", desc:Consts.strings.text348 + " " + Consts.strings.text355}, {id:"0122", hotkey:"F9", desc:Consts.strings.text348 + " " + Consts.strings.text28}, {id:"0123", hotkey:"F10", desc:Consts.strings.text348 + " " + Consts.strings.text208}, {id:"0124", hotkey:"CTRL+=", desc:Consts.strings.text348 + " " + Consts.strings.text356}, {id:"0125", hotkey:"CTRL+-", desc:Consts.strings.text348 + " " + Consts.strings.text357}, {id:"0126", hotkey:"CTRL+1", desc:Consts.strings.text348 + " " + Consts.strings.text358}, {id:"0201", hotkey:"F2", desc:Consts.strings.text349 + " " + Consts.strings.text17}, {id:"0202", hotkey:"", desc:Consts.strings.text349 + " " + Consts.strings.text18}, {id:"0203", hotkey:"", desc:Consts.strings.text349 + " " + Consts.strings.text20}, {id:"0204", hotkey:"", desc:Consts.strings.text349 + " " + Consts.strings.text21}, {id:"0205", hotkey:"", desc:Consts.strings.text349 + " " + Consts.strings.text192}, {id:"0206", hotkey:"", desc:Consts.strings.text349 + " " + (Consts.isMacOS ? (Consts.strings.text90) : (Consts.strings.text24))}, {id:"0207", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text359}, {id:"0208", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text360}, {id:"0301", hotkey:"F4", desc:Consts.strings.text348 + " " + Consts.strings.text361}, {id:"0302", hotkey:"F8", desc:Consts.strings.text350 + " " + Consts.strings.text238}, {id:"0303", hotkey:"", desc:Consts.strings.text350 + " " + Consts.strings.text10}, {id:"0304", hotkey:"CTRL+G", desc:Consts.strings.text348 + " " + Consts.strings.text362}, {id:"0305", hotkey:"CTRL+SHIFT+G", desc:Consts.strings.text348 + " " + Consts.strings.text363}, {id:"0306", hotkey:"CTRL+SHIFT+V", desc:Consts.strings.text348 + " " + Consts.strings.text105}, {id:"0308", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text364}, {id:"0309", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text365}, {id:"0310", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text366}, {id:"0311", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text367}, {id:"0312", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text368}, {id:"0313", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text369}, {id:"0314", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text370}, {id:"0315", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text371}, {id:"0316", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text310}, {id:"0320", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text436}, {id:"0321", hotkey:"", desc:Consts.strings.text348 + " " + Consts.strings.text139}, {id:"0317", hotkey:"CTRL+D", desc:Consts.strings.text350 + " " + Consts.strings.text218}, {id:"0318", hotkey:"CTRL+K", desc:Consts.strings.text350 + " " + Consts.strings.text217}, {id:"0319", hotkey:"CTRL+I", desc:Consts.strings.text350 + " " + Consts.strings.text298}];
            _-PY = {};
            for each (_loc_1 in _-KK)
            {
                
                _loc_1.origin_hotkey = _loc_1.hotkey;
                _-PY[_loc_1.id] = _loc_1;
            }
            _loc_2 = Preferences.hotkeys;
            for (_loc_3 in _loc_2)
            {
                
                _loc_4 = _-PY[_loc_3];
                if (_loc_4)
                {
                    _loc_4.hotkey = _loc_2[_loc_3];
                }
            }
            _-O9();
            return;
        }// end function

        public static function _-3A(param1:String, param2:String) : void
        {
            var _loc_3:* = _-PY[param1];
            if (!_loc_3)
            {
                return;
            }
            param2 = param2.replace("⌘", "CTRL");
            _loc_3.hotkey = param2;
            if (_loc_3.origin_hotkey == param2)
            {
                delete Preferences.hotkeys[param1];
            }
            else
            {
                Preferences.hotkeys[param1] = param2;
            }
            Preferences.save();
            _-8d(_loc_3);
            return;
        }// end function

        public static function _-4x(param1:String) : void
        {
            var _loc_2:* = _-PY[param1];
            if (!_loc_2)
            {
                return;
            }
            _loc_2.hotkey = _loc_2.origin_hotkey;
            delete Preferences.hotkeys[param1];
            _-8d(_loc_2);
            return;
        }// end function

        public static function resetAll() : void
        {
            var _loc_1:* = null;
            for each (_loc_1 in _-KK)
            {
                
                _loc_1.hotkey = _loc_1.origin_hotkey;
            }
            _-O9();
            Preferences.hotkeys = {};
            Preferences.save();
            return;
        }// end function

        public static function _-Pb(event:KeyboardEvent) : String
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (event.altKey)
            {
                return null;
            }
            var _loc_2:* = 0;
            if (event.ctrlKey || event.commandKey)
            {
                _loc_2 = _loc_2 + 65536;
            }
            if (event.shiftKey)
            {
                _loc_2 = _loc_2 + 1048576;
            }
            if (event.charCode == 0)
            {
                _loc_2 = _loc_2 + (event.keyCode << 8);
            }
            else
            {
                _loc_3 = String.fromCharCode(event.charCode).toUpperCase();
                _loc_2 = _loc_2 + _loc_3.charCodeAt(0);
            }
            if (_loc_2 == Keyboard.ENTER)
            {
                return "0000";
            }
            if (_loc_2 == 127 || event.commandKey && event.charCode == Keyboard.BACKSPACE)
            {
                return "0001";
            }
            if (event.commandKey && event.shiftKey && event.charCode == Keyboard.Z)
            {
                return "0008";
            }
            _loc_4 = _-M[_loc_2];
            if (_loc_4)
            {
                return _loc_4.id;
            }
            return null;
        }// end function

        public static function _-1q(event:KeyboardEvent) : String
        {
            var _loc_3:* = null;
            if (event.keyCode >= Keyboard.F1 && event.keyCode <= Keyboard.F12)
            {
                return "F" + (event.keyCode - Keyboard.F1 + 1);
            }
            var _loc_2:* = [];
            if (event.ctrlKey || event.commandKey)
            {
                if (Consts.isMacOS)
                {
                    _loc_2.push("CMD");
                }
                else
                {
                    _loc_2.push("CTRL");
                }
            }
            if (event.shiftKey)
            {
                _loc_2.push("SHIFT");
            }
            switch(event.keyCode)
            {
                case Keyboard.INSERT:
                {
                    break;
                }
                case Keyboard.HOME:
                {
                    break;
                }
                case Keyboard.PAGE_UP:
                {
                    break;
                }
                case Keyboard.END:
                {
                    break;
                }
                case Keyboard.PAGE_DOWN:
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            switch(event.charCode)
            {
                case Keyboard.BACKSPACE:
                {
                    break;
                }
                case Keyboard.ENTER:
                {
                    break;
                }
                case Keyboard.SPACE:
                {
                    break;
                }
                case 127:
                {
                    break;
                }
                default:
                {
                    if (!_-4F[_loc_3])
                    {
                    }
                    break;
                    break;
                }
            }
            return _loc_2.join("+");
        }// end function

        private static function _-O9() : void
        {
            var _loc_1:* = null;
            _-M = {};
            for each (_loc_1 in _-KK)
            {
                
                _loc_1.code = 0;
                _-8d(_loc_1);
            }
            return;
        }// end function

        private static function _-8d(param1:Object) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            if (param1.code)
            {
                delete _-M[param1.code];
                param1.code = 0;
            }
            if (!param1.hotkey)
            {
                return;
            }
            var _loc_2:* = param1.hotkey.split("+");
            var _loc_3:* = 0;
            for each (_loc_4 in _loc_2)
            {
                
                if (_loc_4 == "CTRL" || _loc_4 == "CMD")
                {
                    _loc_3 = _loc_3 + 65536;
                    continue;
                }
                if (_loc_4 == "SHIFT")
                {
                    _loc_3 = _loc_3 + 1048576;
                    continue;
                }
                _loc_5 = _-4F[_loc_4];
                if (_loc_5 == 0)
                {
                    break;
                }
                _loc_3 = _loc_3 + _loc_5;
                param1.code = _loc_3;
                _-M[_loc_3] = param1;
            }
            return;
        }// end function

    }
}
