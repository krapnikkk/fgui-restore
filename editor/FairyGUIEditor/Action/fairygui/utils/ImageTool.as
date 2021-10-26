package fairygui.utils
{
    import *.*;
    import __AS3__.vec.*;
    import fairygui.utils.loader.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;

    public class ImageTool extends Object
    {
        public static var TOOL_PATH:String = "pngquant" + File.separator + "pngquant";
        public static var TOOL_PATH_MAGICK:String = "ImageMagick" + File.separator + "magick";
        public static var APP_DIRECTORY:File;
        private static var _mac:Object = undefined;
        private static var _runningTasks:Dictionary = new Dictionary();
        private static var _toolExe:File;
        private static var _magickExe:File;

        public function ImageTool()
        {
            return;
        }// end function

        public static function get isMac() : Boolean
        {
            if (_mac == undefined)
            {
                _mac = Capabilities.os.toLowerCase().indexOf("mac") != -1;
            }
            return _mac;
        }// end function

        public static function get toolExe() : File
        {
            if (_toolExe != null)
            {
                return _toolExe;
            }
            if (APP_DIRECTORY == null)
            {
                APP_DIRECTORY = File.applicationDirectory;
            }
            var _loc_1:* = TOOL_PATH;
            if (!isMac)
            {
                _loc_1 = _loc_1 + ".exe";
            }
            _toolExe = APP_DIRECTORY.resolvePath(_loc_1);
            if (!_toolExe.exists)
            {
                _loc_1 = "tools" + File.separator + _loc_1;
                _toolExe = APP_DIRECTORY.resolvePath(_loc_1);
            }
            return _toolExe;
        }// end function

        public static function get magickExe() : File
        {
            if (_magickExe != null)
            {
                return _magickExe;
            }
            if (APP_DIRECTORY == null)
            {
                APP_DIRECTORY = File.applicationDirectory;
            }
            var _loc_1:* = TOOL_PATH_MAGICK;
            if (isMac)
            {
                _loc_1 = _loc_1 + ".sh";
            }
            else
            {
                _loc_1 = _loc_1 + ".exe";
            }
            _magickExe = APP_DIRECTORY.resolvePath(_loc_1);
            if (!_magickExe.exists)
            {
                _loc_1 = "tools" + File.separator + _loc_1;
                _magickExe = APP_DIRECTORY.resolvePath(_loc_1);
            }
            return _magickExe;
        }// end function

        public static function compressFile(param1:File, param2:File, param3:Callback) : void
        {
            arguments = new activation;
            var si:NativeProcessStartupInfo;
            var args:Vector.<String>;
            var tempFile:File;
            var process:NativeProcess;
            var output:String;
            var pngFile:* = param1;
            var targetFile:* = param2;
            var callback:* = param3;
            var arguments:* = arguments;
            if (!toolExe.exists)
            {
                ImageTool.addMsg("Image tool not available.");
                ImageTool.callOnFail();
                return;
            }
            try
            {
                si = new NativeProcessStartupInfo();
                ImageTool.executable = toolExe;
                args = new Vector.<String>;
                ImageTool.push("--force");
                ImageTool.push("--ext");
                ImageTool.push("~q.png");
                tempFile = File.createTempFile();
                UtilsFile.copyFile(, );
                ImageTool.push(ImageTool.nativePath);
                ImageTool.arguments = ;
                process = new NativeProcess();
                _runningTasks[] = true;
                output;
                ImageTool.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, function (event:ProgressEvent) : void
            {
                output = output + process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
                return;
            }// end function
            );
                ImageTool.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, function (event:ProgressEvent) : void
            {
                output = output + process.standardError.readUTFBytes(process.standardError.bytesAvailable);
                return;
            }// end function
            );
                ImageTool.addEventListener(NativeProcessExitEvent.EXIT, function (event:NativeProcessExitEvent) : void
            {
                var _loc_2:* = null;
                delete _runningTasks[process];
                if (event.exitCode == 0)
                {
                    _loc_2 = new File(UtilsStr.removeFileExt(tempFile.nativePath) + "~q.png");
                    if (!_loc_2.exists)
                    {
                        _loc_2 = new File(tempFile.nativePath + "~q.png");
                    }
                    if (_loc_2.size > pngFile.size)
                    {
                        UtilsFile.copyFile(pngFile, targetFile);
                    }
                    else
                    {
                        UtilsFile.copyFile(_loc_2, targetFile);
                    }
                    try
                    {
                        _loc_2.deleteFile();
                        tempFile.deleteFile();
                    }
                    catch (err:Error)
                    {
                    }
                    callback.callOnSuccessImmediately();
                }
                else
                {
                    if (!output)
                    {
                        output = "exit:" + event.exitCode;
                    }
                    callback.addMsg(output);
                    callback.callOnFailImmediately();
                }
                return;
            }// end function
            );
                ImageTool.start();
            }
            catch (err:Error)
            {
                err.addMsg(err.message);
                err.callOnFail();
            }
            return;
        }// end function

        public static function compressBitmapData(param1:BitmapData, param2:Callback) : void
        {
            var ba:ByteArray;
            var tempFile:File;
            var onLoaded:Function;
            var callback2:Callback;
            var bmd:* = param1;
            var callback:* = param2;
            var isPNG:* = bmd.transparent;
            if (isPNG)
            {
                ba = bmd.encode(bmd.rect, new PNGEncoderOptions());
            }
            else
            {
                ba = bmd.encode(bmd.rect, new JPEGEncoderOptions(80));
            }
            tempFile = File.createTempFile();
            UtilsFile.saveBytes(tempFile, ba);
            onLoaded = function (param1:LoaderExt) : void
            {
                var _loc_2:* = Bitmap(param1.content).bitmapData;
                var _loc_3:* = UtilsFile.loadBytes(tempFile);
                try
                {
                    tempFile.deleteFile();
                }
                catch (err:Error)
                {
                }
                if (_loc_2 != null)
                {
                    callback.result = [_loc_2, _loc_3];
                    callback.callOnSuccessImmediately();
                }
                else
                {
                    callback.addMsg(param1.error);
                    callback.callOnFailImmediately();
                }
                return;
            }// end function
            ;
            if (isPNG)
            {
                callback2 = new Callback();
                callback2.success = function () : void
            {
                EasyLoader.load(tempFile.url, {type:"image"}, onLoaded);
                return;
            }// end function
            ;
                callback2.failed = function () : void
            {
                callback.addMsgs(callback2.msgs);
                callback.callOnFailImmediately();
                return;
            }// end function
            ;
                compressFile(tempFile, tempFile, callback2);
            }
            else
            {
                EasyLoader.load(tempFile.url, {type:"image"}, onLoaded);
            }
            return;
        }// end function

        public static function cropImage(param1:File, param2:File, param3:Callback) : void
        {
            var pngFile:* = param1;
            var targetFile:* = param2;
            var callback:* = param3;
            EasyLoader.load(pngFile.url, {type:"image"}, function (param1:LoaderExt) : void
            {
                var _loc_3:* = null;
                var _loc_4:* = null;
                var _loc_5:* = null;
                if (!param1.content)
                {
                    callback.addMsg(param1.error);
                    callback.callOnFailImmediately();
                    return;
                }
                var _loc_2:* = Bitmap(param1.content).bitmapData;
                if (_loc_2.transparent)
                {
                    _loc_3 = _loc_2.getColorBoundsRect(4278190080, 0, false);
                    if (!_loc_3.isEmpty() && !_loc_3.equals(_loc_2.rect))
                    {
                        _loc_4 = new BitmapData(_loc_3.width, _loc_3.height, true, 0);
                        _loc_4.copyPixels(_loc_2, _loc_3, new Point(0, 0));
                        _loc_2.dispose();
                        _loc_2 = _loc_4;
                        _loc_5 = _loc_2.encode(_loc_2.rect, new PNGEncoderOptions());
                        UtilsFile.saveBytes(targetFile, _loc_5);
                        callback.callOnSuccessImmediately();
                        return;
                    }
                }
                UtilsFile.copyFile(pngFile, targetFile);
                callback.callOnSuccessImmediately();
                return;
            }// end function
            );
            return;
        }// end function

        public static function magick(param1:Vector.<String>, param2:Callback) : void
        {
            arguments = new activation;
            var si:NativeProcessStartupInfo;
            var process:NativeProcess;
            var output:String;
            var args:* = param1;
            var callback:* = param2;
            var arguments:* = arguments;
            if (!magickExe.exists)
            {
                ImageTool.addMsg("Magick tool not available.");
                ImageTool.callOnFail();
                return;
            }
            try
            {
                si = new NativeProcessStartupInfo();
                if (isMac)
                {
                    ImageTool.insertAt(0, "magick.sh");
                    ImageTool.executable = new File("/bin/bash");
                    ImageTool.workingDirectory = magickExe.parent;
                }
                else
                {
                    ImageTool.executable = magickExe;
                }
                ImageTool.arguments = ;
                process = new NativeProcess();
                _runningTasks[] = true;
                output;
                ImageTool.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, function (event:ProgressEvent) : void
            {
                output = output + process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
                return;
            }// end function
            );
                ImageTool.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, function (event:ProgressEvent) : void
            {
                output = output + process.standardError.readUTFBytes(process.standardError.bytesAvailable);
                return;
            }// end function
            );
                ImageTool.addEventListener(NativeProcessExitEvent.EXIT, function (event:NativeProcessExitEvent) : void
            {
                delete _runningTasks[process];
                if (event.exitCode == 0)
                {
                    callback.callOnSuccessImmediately();
                }
                else
                {
                    if (!output)
                    {
                        output = "exit:" + event.exitCode;
                    }
                    callback.addMsg(output);
                    callback.callOnFailImmediately();
                }
                return;
            }// end function
            );
                ImageTool.start();
            }
            catch (err:Error)
            {
                err.addMsg(err.message);
                err.callOnFail();
            }
            return;
        }// end function

    }
}
