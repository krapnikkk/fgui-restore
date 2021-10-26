package fairygui
{

    public class UIConfig extends Object
    {
        public static var defaultFont:String = "";
        public static var windowModalWaiting:String;
        public static var globalModalWaiting:String;
        public static var modalLayerColor:uint = 3355443;
        public static var modalLayerAlpha:Number = 0.2;
        public static var buttonSound:String;
        public static var buttonSoundVolumeScale:Number = 1;
        public static var buttonUseHandCursor:Boolean = false;
        public static var horizontalScrollBar:String;
        public static var verticalScrollBar:String;
        public static var defaultScrollStep:int = 25;
        public static var defaultScrollDecelerationRate:Number = 0.967;
        public static var defaultScrollBarDisplay:int = 1;
        public static var defaultScrollTouchEffect:Boolean = false;
        public static var defaultScrollBounceEffect:Boolean = false;
        public static var popupMenu:String;
        public static var popupMenu_seperator:String;
        public static var loaderErrorSign:String;
        public static var tooltipsWin:String;
        public static var defaultComboBoxVisibleItemCount:int = 10;
        public static var touchScrollSensitivity:int = 20;
        public static var touchDragSensitivity:int = 10;
        public static var clickDragSensitivity:int = 2;
        public static var bringWindowToFrontOnClick:Boolean = true;
        public static var frameTimeForAsyncUIConstruction:int = 2;

        public function UIConfig()
        {
            return;
        }// end function

    }
}
