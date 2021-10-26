package mx.core
{
    import *.*;

    public class RSLData extends Object
    {
        private var _applicationDomainTarget:String;
        private var _digest:String;
        private var _hashType:String;
        private var _isSigned:Boolean;
        private var _moduleFactory:IFlexModuleFactory;
        private var _policyFileURL:String;
        private var _rslURL:String;
        private var _verifyDigest:Boolean;
        static const VERSION:String = "4.6.0.23201";

        public function RSLData(param1:String = null, param2:String = null, param3:String = null, param4:String = null, param5:Boolean = false, param6:Boolean = false, param7:String = "default")
        {
            this._rslURL = param1;
            this._policyFileURL = param2;
            this._digest = param3;
            this._hashType = param4;
            this._isSigned = param5;
            this._verifyDigest = param6;
            this._applicationDomainTarget = param7;
            this._moduleFactory = this.moduleFactory;
            return;
        }// end function

        public function get applicationDomainTarget() : String
        {
            return this._applicationDomainTarget;
        }// end function

        public function get digest() : String
        {
            return this._digest;
        }// end function

        public function get hashType() : String
        {
            return this._hashType;
        }// end function

        public function get isSigned() : Boolean
        {
            return this._isSigned;
        }// end function

        public function get moduleFactory() : IFlexModuleFactory
        {
            return this._moduleFactory;
        }// end function

        public function set moduleFactory(param1:IFlexModuleFactory) : void
        {
            this._moduleFactory = param1;
            return;
        }// end function

        public function get policyFileURL() : String
        {
            return this._policyFileURL;
        }// end function

        public function get rslURL() : String
        {
            return this._rslURL;
        }// end function

        public function get verifyDigest() : Boolean
        {
            return this._verifyDigest;
        }// end function

    }
}
