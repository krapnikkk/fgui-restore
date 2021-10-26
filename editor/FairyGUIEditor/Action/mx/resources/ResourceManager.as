package mx.resources
{
    import *.*;
    import flash.utils.*;
    import mx.core.*;

    public class ResourceManager extends Object
    {
        static const VERSION:String = "4.6.0.23201";
        private static var implClassDependency:ResourceManagerImpl;
        private static var instance:IResourceManager;

        public function ResourceManager()
        {
            return;
        }// end function

        public static function getInstance() : IResourceManager
        {
            if (!instance)
            {
                if (!Singleton.getClass("mx.resources::IResourceManager"))
                {
                    Singleton.registerClass("mx.resources::IResourceManager", Class(getDefinitionByName("mx.resources::ResourceManagerImpl")));
                }
                try
                {
                    instance = IResourceManager(Singleton.getInstance("mx.resources::IResourceManager"));
                }
                catch (e:Error)
                {
                    instance = new ResourceManagerImpl();
                }
            }
            return instance;
        }// end function

    }
}
