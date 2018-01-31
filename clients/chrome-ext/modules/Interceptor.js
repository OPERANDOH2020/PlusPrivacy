var bus = require("bus-service").bus;

var acceptedTypes = ["body-request","headers-request", "headers-response"];

var Interceptor = function(type, osp, pattern, callback){

    if(acceptedTypes.indexOf(type).length == -1){
        throw "Interceptor type is not recognized!";
    }

    this.type = type;
    this.osp = osp;
    this.pattern = pattern;
    this.callback = callback;
};


var InterceptorPools = (function(){

    var instance;
    var self = this;
    this.bodyRequestsPoolInterceptor = [];
    this.headersRequestsPoolInterceptor = [];
    this.headersResponsesPoolInterceptor = [];


    this.addBodyRequestInterceptor = function(osp, pattern, callback){
        var bodyRequestInterceptor = new Interceptor("body-request", osp, pattern,callback);
        self.bodyRequestsPoolInterceptor.push(bodyRequestInterceptor);
    };

    this.addHeadersRequestsPoolInterceptor = function(osp, pattern, callback){
        var headerRequestInterceptor = new Interceptor("headers-request", osp, pattern,callback);
        self.headersRequestsPoolInterceptor.push(headerRequestInterceptor);
    };

    this.addHeadersResponsesPoolInterceptor = function(osp, pattern, callback){
        var headerResponsesInterceptor = new Interceptor("headers-response", osp, pattern,callback);
        self.headersResponsesPoolInterceptor.push(headerResponsesInterceptor);
    };

    function init(){

        return {
            addBodyRequestInterceptor:self.addBodyRequestInterceptor,
            addHeadersRequestsPoolInterceptor:self.addHeadersRequestsPoolInterceptor,
            headersResponsesPoolInterceptor:self.addHeadersResponsesPoolInterceptor
        }
    }

    return {

        getInstance: function () {

            if ( !instance ) {
                instance = init();
            }

            return instance;
        }

    };

})();
