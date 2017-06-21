/*
 easy API for listening swarm events. On on funcitions you add listeners for both swarm type and phase name
 */
function SwarmHub(swarmConnection){
    var callBacks = {};
    var self = this;

    function dispatchingCallback(swarm){
        var o = callBacks[swarm.meta.swarmingName];
        if(o){
            var myCall = o[swarm.meta.currentPhase];
            if(!myCall){
                cprint("Warning: Nobody listens for swarm " + swarm.meta.swarmingName + " and phase " + swarm.meta.currentPhase);
            } else {
                try{
                    if(myCall instanceof Array){
                        myCall.map(function(c){
                            c(swarm);
                        });
                    } else {
                        myCall(swarm);
                    }
                } catch(err){
                    cprint("Error in swarm callback " + err.stack, err);
                }

            }
        } else {
            cprint("Warning: Nobody listens for swarm " + swarm.meta.swarmingName + " and phase " + swarm.meta.currentPhase);
        }
    }


    this.on = function(swarmName, phase, callBack){
        var swarmPlace = callBacks[swarmName];
        if(!swarmPlace){
            swarmPlace = {};
            callBacks[swarmName] = swarmPlace;
            if(swarmConnection){
                swarmConnection.on(swarmName, dispatchingCallback);
            }
        }

        var phasePlace = swarmPlace[phase];
        if(!phasePlace){
            swarmPlace[phase] = callBack;
        }
        else{
            if(phasePlace instanceof Array){
                phasePlace.push(callBack);
            } else {
                swarmPlace[phase] = [phasePlace, callBack];
            }
        }
    }


    this.off = function(swarm, phase, callBack){
        var c = callBacks[swarm][phase];
        if(c instanceof Array){
            var idx = c.indexOf(callBack)
            if(idx != -1){
                c.splice(idx, 1);
            }
        } else {
            delete callBacks[swarm][phase];
        }
    }

    var pendingCommands = [];

    var disconected_start_swarm = function(){
        var args = [];
        var newCmd = {
            meta: {
                swarmingName: arguments[0]
            },
            pending:{

            }
        }
        newCmd.onResult = function(phaseName, callback){
            newCmd.pending[phaseName] = callback;
        }
        args.push(newCmd);
        for(var i = 1,len = arguments.length; i<len;i++){
            args.push(arguments[i]);
        }
        pendingCommands.push(args);

    }

    this.startSwarm = disconected_start_swarm;

    this.getConnection = function(){
        return swarmConnection;
    }

    this.resetConnection = function (newConnection){
        if(swarmConnection !== newConnection){
            swarmConnection = newConnection;
            for(var v in callBacks){
                swarmConnection.on(v,dispatchingCallback);
            }
        }
    }


    var swarmSystemAuthenticated = false;
    var swarmConnectionCallbacks = [];

    function startWaitingCallbacks(){

        self.startSwarm =  swarmConnection.startSwarm.bind(swarmConnection);

        pendingCommands.forEach(function(args){
            var cmd = self.startSwarm.apply(self, args);
            for(var phaseName in cmd.pending){
                cmd.onResponse(phaseName,cmd.pending[phaseName] );
            }
        })
        pendingCommands = [];


        swarmConnectionCallbacks.forEach(function(i){
            i();
        })
        swarmConnectionCallbacks = [];
    }
    this.on("login.js", "success", startWaitingCallbacks);
    this.on("login.js", "tokenLoginSuccessfully", startWaitingCallbacks);
    this.on("login.js", "success_guest", startWaitingCallbacks);
    this.on("login.js", "restoreSucceed", startWaitingCallbacks);


    this.onSwarmConnection = function (callback) {
        if (swarmSystemAuthenticated) {
            callback();
        } else {
            if (callback) {
                swarmConnectionCallbacks.push(callback);
            }
        }
    };

    /*
     generic observer implementation for Java Script. Created especially for integration swarms with angular.js projects. Usually angular services should be observable by controllers
     */
    this.createObservable = function(template){
        function Observer(){
            var observers = [];
            var notifiedAtLeastOnce = false;

            for(var v in template){
                this[v] = template[v];
            }

            this.observe = function(c, preventAtLeastOnce){
                observers.push(c);
                if(!preventAtLeastOnce && notifiedAtLeastOnce){
                    c();
                }
            }

            this.notify = function(){
                observers.forEach(function(c){
                    c();
                })
                notifiedAtLeastOnce = true;
            }
        }
        return new Observer(template);
    }
}

//global variable
swarmHub = new SwarmHub();