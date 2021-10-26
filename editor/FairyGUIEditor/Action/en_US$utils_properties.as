package 
{
    import en_US$utils_properties.*;
    import mx.resources.*;

    public class en_US$utils_properties extends ResourceBundle
    {

        public function en_US$utils_properties()
        {
            super("en_US", "utils");
            return;
        }// end function

        override protected function getContent() : Object
        {
            var _loc_1:* = {partialBlockDropped:"A partial block ({0} of 4 bytes) was dropped. Decoded data is probably truncated!"};
            return _loc_1;
        }// end function

    }
}
