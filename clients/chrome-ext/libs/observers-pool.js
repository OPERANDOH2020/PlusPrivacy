function PortObserver(port){
    this.port = port;
    this.observers = [];
}

PortObserver.prototype = {
    subscribe: function (request, fn) {
        this.observers.push({
            request: request,
            fn: fn
        });
    },
    unsubscribe: function (request, fn) {
        this.observers = this.observers.filter(function(observer){
            if (fn) {
                if (observer.request === request && fn === observer.fn) {
                    return false;
                }
                else {
                    return true;
                }
            }
            else {
                return observer.request !== request;
            }

        });
    },

    fire: function(request, status, message){
      this.observers.forEach(function(observer){
          if(observer.request === request){
              observer.fn.call(observer.fn,status, message);
          }
      })
    }
};


function PortsObserversPool(){
    this.observersPool = [];
}

PortsObserversPool.prototype = {

    registerPortObserver : function (port) {
        this.observersPool.push(new PortObserver(port));
    },

    unregisterPortObserver : function (port) {
        this.observersPool = this.observersPool.filter(function (portObserver) {
            return portObserver.port !== port
        })
    },

    addPortRequestSubscriber : function (port, request, fn) {
        this.observersPool.forEach(function (observer) {
            if (observer.port === port) {
                observer.subscribe(request, fn);
            }
        })
    },

    trigger : function (request, message) {
        this.observersPool.forEach(function (observer) {
            observer.fire(request, "success", message);
        });
    },

    findPortByName: function (name) {
        for(var i=0; i< this.observersPool.length; i++){
            var portObserver =  this.observersPool[i];
            if (portObserver.port.name === name) {
                return portObserver.port;
            }
        }
    }
}

var pop = new PortsObserversPool();
exports.portObserversPool = pop;