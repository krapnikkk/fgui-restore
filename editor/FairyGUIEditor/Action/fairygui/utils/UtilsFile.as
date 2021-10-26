package fairygui.utils
{
    import *.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.utils.*;

    public class UtilsFile extends Object
    {
        private static var helperBuffer:ByteArray = new ByteArray();
        private static var elementBuffer:ByteArray = new ByteArray();

        public function UtilsFile()
        {
            return;
        }// end function

        public static function browseForOpen(param1:String, param2:Array, param3:Function, param4:File = null) : void
        {
            var title:* = param1;
            var filters:* = param2;
            var callback:* = param3;
            var initiator:* = param4;
            if (initiator == null)
            {
                initiator = new File();
            }
            initiator.browseForOpen(title, filters);
            initiator.addEventListener(Event.SELECT, function (event:Event) : void
            {
                callback(event.target as File);
                return;
            }// end function
            );
            return;
        }// end function

        public static function browseForOpenMultiple(param1:String, param2:Array, param3:Function, param4:File = null) : void
        {
            var title:* = param1;
            var filters:* = param2;
            var callback:* = param3;
            var initiator:* = param4;
            if (initiator == null)
            {
                initiator = new File();
            }
            initiator.browseForOpenMultiple(title, filters);
            initiator.addEventListener(Event.SELECT, function (event:Event) : void
            {
                callback([event.target]);
                return;
            }// end function
            );
            initiator.addEventListener(FileListEvent.SELECT_MULTIPLE, function (event:FileListEvent) : void
            {
                callback(event.files);
                return;
            }// end function
            );
            return;
        }// end function

        public static function browseForDirectory(param1:String, param2:Function, param3:File = null) : void
        {
            var title:* = param1;
            var callback:* = param2;
            var initiator:* = param3;
            if (initiator == null)
            {
                initiator = new File();
            }
            initiator.browseForDirectory(title);
            initiator.addEventListener(Event.SELECT, function (event:Event) : void
            {
                callback(event.target as File);
                return;
            }// end function
            );
            return;
        }// end function

        public static function browseForSave(param1:String, param2:Function, param3:File = null) : void
        {
            var title:* = param1;
            var callback:* = param2;
            var initiator:* = param3;
            if (initiator == null)
            {
                initiator = new File();
            }
            initiator.browseForSave(title);
            initiator.addEventListener(Event.SELECT, function (event:Event) : void
            {
                callback(event.target as File);
                return;
            }// end function
            );
            return;
        }// end function

        public static function listAllFiles(param1:File, param2:Array) : void
        {
            var _loc_4:* = null;
            var _loc_3:* = param1.getDirectoryListing();
            for each (_loc_4 in _loc_3)
            {
                
                if (_loc_4.isDirectory)
                {
                    listAllFiles(_loc_4, param2);
                    continue;
                }
                param2.push(_loc_4);
            }
            return;
        }// end function

        public static function loadString(param1:File, param2:String = null) : String
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_3:* = loadBytes(param1);
            if (_loc_3 == null)
            {
                return null;
            }
            if (!param2)
            {
                if (_loc_3.bytesAvailable > 2)
                {
                    _loc_4 = _loc_3.readUnsignedByte();
                    _loc_5 = _loc_3.readUnsignedByte();
                    if (_loc_4 == 239 && _loc_5 == 187)
                    {
                        param2 = "utf-8";
                        var _loc_6:* = _loc_3;
                        var _loc_7:* = _loc_3.position + 1;
                        _loc_6.position = _loc_7;
                    }
                    else if (_loc_4 == 254 && _loc_5 == 255)
                    {
                        param2 = "unicodeFFFE";
                    }
                    else if (_loc_4 == 255 && _loc_5 == 254)
                    {
                        param2 = "unicode";
                    }
                    else
                    {
                        param2 = "utf-8";
                        _loc_3.position = _loc_3.position - 2;
                    }
                }
                else
                {
                    param2 = "utf-8";
                }
            }
            if (param2.toLowerCase() == "utf-8")
            {
                return _loc_3.readUTFBytes(_loc_3.length - _loc_3.position);
            }
            return _loc_3.readMultiByte(_loc_3.length - _loc_3.position, param2);
        }// end function

        public static function saveString(param1:File, param2:String, param3:String = null) : void
        {
            var _loc_4:* = new ByteArray();
            if (!param3 || param3.toUpperCase() == "UTF-8")
            {
                _loc_4.writeUTFBytes(param2);
            }
            else
            {
                _loc_4.writeMultiByte(param2, param3);
            }
            saveBytes(param1, _loc_4);
            return;
        }// end function

        public static function loadBytes(param1:File) : ByteArray
        {
            if (!param1.exists)
            {
                return null;
            }
            var _loc_2:* = new FileStream();
            _loc_2.open(param1, FileMode.READ);
            var _loc_3:* = new ByteArray();
            _loc_2.readBytes(_loc_3, 0, param1.size);
            _loc_2.close();
            return _loc_3;
        }// end function

        public static function saveBytes(param1:File, param2:ByteArray) : void
        {
            var _loc_3:* = new FileStream();
            _loc_3.open(param1, FileMode.WRITE);
            param2.position = 0;
            _loc_3.writeBytes(param2);
            _loc_3.close();
            return;
        }// end function

        public static function loadXMLRoot(param1:File) : XData
        {
            var i:int;
            var elementStart:int;
            var b:int;
            var str:String;
            var file:* = param1;
            if (!file.exists)
            {
                return null;
            }
            var fs:* = new FileStream();
            fs.open(file, FileMode.READ);
            var len:* = Math.min(file.size, 1024);
            helperBuffer.length = 0;
            fs.readBytes(helperBuffer, 0, len);
            fs.close();
            do
            {
                
                b = helperBuffer.readByte();
                if (b == 60)
                {
                    elementStart = (i - 1);
                    do
                    {
                        
                        b = helperBuffer.readByte();
                        if (b == 62)
                        {
                            helperBuffer.position = elementStart;
                            str = helperBuffer.readUTFBytes(i - elementStart);
                            if (str.charCodeAt(1) != 63 && str.charCodeAt(1) != 33)
                            {
                                if (str.charCodeAt(str.length - 2) != 47)
                                {
                                    i = str.indexOf(" ");
                                    if (i == -1)
                                    {
                                        i = (str.length - 1);
                                    }
                                    str = str + "</" + str.substring(1, i) + ">";
                                }
                                try
                                {
                                    return XData.parse(str);
                                }
                                catch (err:Error)
                                {
                                    return null;
                                }
                            }
                            helperBuffer.position = i;
                            break;
                        }
                        i = (i + 1);
                    }while (i < len)
                }
                i = (i + 1);
            }while (i < len)
            return null;
        }// end function

        public static function loadXML(param1:File) : XML
        {
            var _loc_2:* = loadString(param1);
            if (_loc_2)
            {
                return new XML(_loc_2);
            }
            return null;
        }// end function

        public static function saveXML(param1:File, param2:XML) : void
        {
            saveString(param1, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" + param2.toXMLString());
            return;
        }// end function

        public static function loadXData(param1:File) : XData
        {
            var _loc_2:* = loadString(param1);
            if (_loc_2)
            {
                return XData.parse(_loc_2);
            }
            return null;
        }// end function

        public static function saveXData(param1:File, param2:XData) : void
        {
            saveXML(param1, param2.toXML());
            return;
        }// end function

        public static function loadJSON(param1:File) : Object
        {
            var _loc_2:* = loadString(param1);
            if (_loc_2)
            {
                return JSON.parse(_loc_2);
            }
            return null;
        }// end function

        public static function saveJSON(param1:File, param2:Object, param3:Boolean = false) : void
        {
            if (param3)
            {
                saveString(param1, OrderedJSONEncoder.encode(param2));
            }
            else
            {
                saveString(param1, JSON.stringify(param2, null, "\t"));
            }
            return;
        }// end function

        public static function deleteFile(param1:File, param2:Boolean = false) : Boolean
        {
            var file:* = param1;
            var moveToTrash:* = param2;
            try
            {
                if (moveToTrash)
                {
                    file.moveToTrashAsync();
                }
                else
                {
                    file.deleteFile();
                }
                return true;
            }
            catch (e:Error)
            {
                if (e.errorID == 3001 && !moveToTrash)
                {
                    try
                    {
                        file.moveToTrashAsync();
                    }
                    catch (e:Error)
                    {
                    }
                }
                else if (UtilsFile.errorID != 3003)
                {
                }
                return false;
        }// end function

        public static function copyFile(param1:File, param2:File) : Boolean
        {
            var srcFile:* = param1;
            var dstFile:* = param2;
            if (srcFile.nativePath == dstFile.nativePath)
            {
                return true;
            }
            deleteFile(dstFile);
            try
            {
                if (srcFile.exists)
                {
                    srcFile.copyTo(dstFile, true);
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (e:Error)
            {
            }
            return false;
        }// end function

        public static function renameFile(param1:File, param2:File) : void
        {
            var _loc_4:* = null;
            var _loc_3:* = param2.name.toLowerCase() == param1.name.toLowerCase();
            if (param2.exists && !_loc_3)
            {
                throw new Error("file already exits");
            }
            if (_loc_3)
            {
                _loc_4 = new File(param2.nativePath + "_" + Math.random() * 1000);
                param1.moveTo(_loc_4);
                _loc_4.moveTo(param2);
            }
            else
            {
                param1.moveTo(param2);
            }
            return;
        }// end function

    }
}
