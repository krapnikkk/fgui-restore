package mx.events
{
    import flash.events.*;

    public class FlexEvent extends Event
    {
        static const VERSION:String = "4.6.0.23201";
        public static const ADD:String = "add";
        public static const ADD_FOCUS_MANAGER:String = "addFocusManager";
        public static const APPLICATION_COMPLETE:String = "applicationComplete";
        public static const BUTTON_DOWN:String = "buttonDown";
        public static const BACK_KEY_PRESSED:String = "backKeyPressed";
        public static const CHANGE_END:String = "changeEnd";
        public static const CHANGE_START:String = "changeStart";
        public static const CHANGING:String = "changing";
        public static const CREATION_COMPLETE:String = "creationComplete";
        public static const CONTENT_CREATION_COMPLETE:String = "contentCreationComplete";
        public static const CURSOR_UPDATE:String = "cursorUpdate";
        public static const DATA_CHANGE:String = "dataChange";
        public static const ENTER:String = "enter";
        public static const ENTER_FRAME:String = "flexEventEnterFrame";
        public static const ENTER_STATE:String = "enterState";
        public static const EXIT_STATE:String = "exitState";
        public static const FLEX_WINDOW_ACTIVATE:String = "flexWindowActivate";
        public static const FLEX_WINDOW_DEACTIVATE:String = "flexWindowDeactivate";
        public static const HIDE:String = "hide";
        public static const IDLE:String = "idle";
        public static const INIT_COMPLETE:String = "initComplete";
        public static const INIT_PROGRESS:String = "initProgress";
        public static const INITIALIZE:String = "initialize";
        public static const INVALID:String = "invalid";
        public static const LOADING:String = "loading";
        public static const MENU_KEY_PRESSED:String = "menuKeyPressed";
        public static const MUTED_CHANGE:String = "mutedChange";
        public static const NAVIGATOR_STATE_LOADING:String = "navigatorStateLoading";
        public static const NAVIGATOR_STATE_SAVING:String = "navigatorStateSaving";
        public static const NEW_CHILD_APPLICATION:String = "newChildApplication";
        public static const PREINITIALIZE:String = "preinitialize";
        public static const PRELOADER_DONE:String = "preloaderDone";
        public static const PRELOADER_DOC_FRAME_READY:String = "preloaderDocFrameReady";
        public static const READY:String = "ready";
        public static const RENDER:String = "flexEventRender";
        public static const REMOVE:String = "remove";
        public static const REPEAT:String = "repeat";
        public static const REPEAT_END:String = "repeatEnd";
        public static const REPEAT_START:String = "repeatStart";
        public static const SELECTION_CHANGE:String = "selectionChange";
        public static const SHOW:String = "show";
        public static const STATE_CHANGE_COMPLETE:String = "stateChangeComplete";
        public static const STATE_CHANGE_INTERRUPTED:String = "stateChangeInterrupted";
        public static const TRANSFORM_CHANGE:String = "transformChange";
        public static const TRANSITION_START:String = "transitionStart";
        public static const TRANSITION_END:String = "transitionEnd";
        public static const UPDATE_COMPLETE:String = "updateComplete";
        public static const URL_CHANGED:String = "urlChanged";
        public static const VALID:String = "valid";
        public static const VALUE_COMMIT:String = "valueCommit";

        public function FlexEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
        {
            super(param1, param2, param3);
            return;
        }// end function

        override public function clone() : Event
        {
            return new FlexEvent(type, bubbles, cancelable);
        }// end function

    }
}
