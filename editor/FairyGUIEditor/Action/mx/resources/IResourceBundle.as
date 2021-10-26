package mx.resources
{

    public interface IResourceBundle
    {

        public function IResourceBundle();

        function get bundleName() : String;

        function get content() : Object;

        function get locale() : String;

    }
}
