/**
 * Created by ciprian on 4/20/17.
 */

var accountsSwarming = {
    createAccount: function (userEmail) {
        if(!userEmail){
            this.userId = this.meta.userId;
            this.swarm("create");
        }else{
            this.userEmail = userEmail;
            this.nextPhase = 'create';
            this.swarm("getId");
        }
    },
    create:{
        node:"CreditAdapter",
        code:function(){
            var self = this;
            createAccount(this.userId,S(function(err,result){
                if(err && !err.message.match('User already has an account')){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.home('accountCreated');
                }
            }))
        }
    },

    getId:{
        node:"UsersManager",
        code:function(){
            var self  = this;
            getUserId(this.userEmail,S(function(err,id){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.userId = id;
                    self.swarm(self.nextPhase);
                }
            }))
        }
    },

    getFundsForUser:function(userEmail){
        if(!userEmail){
            this.userId = this.meta.userId;
            this.swarm("getFunds");
        }else{
            this.userEmail = userEmail;
            this.nextPhase = 'getFunds';
            this.swarm("getId");
        }
    },
    getFunds:{
        node:"CreditAdapter",
        code:function(){
            var self = this;
            getFunds(this.userId,S(function(err,funds){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.funds = funds;
                    self.home('gotFunds');
                }
            }))
        }
    },

    getTransactions:function(userEmail){         
        if(!userEmail){
            this.userId = this.meta.userId;
            this.swarm("get");
        }else{
            this.userEmail = userEmail;
            this.nextPhase = 'get';
            this.swarm("getId");
        }
    },
    get:{
        node:"CreditAdapter",
        code:function(){
            var self = this;
            getTransactions(this.userId, S(function (err, transactions) {
                if (err) {
                    self.err = err.message;
                    self.home('failed');
                } else {
                    self.transactions = transactions;
                    self.swarm('getEmails');
                }
            }))    

        }
    },
    getEmails:{
        node:"UsersManager",
        code:function(){
            var self = this;
            var emails = {}
            var uniqueIds = []
            self.transactions.forEach((transaction) => {
                emails[transaction.target] = null;
                emails[transaction.source] = null;
            });

            for(var uniqueId in emails){
                uniqueIds.push(uniqueId)
            }

            filterUsers({"userId":uniqueIds},S(function(err,users){
                if(err){
                    self.err = err.message;
                    self.home('failed')
                }else{
                    users.forEach(function(user){
                        emails[user.userId] = user.email
                    });
                    self.transactions.forEach(function (transaction) {
                        transaction.sourceEmail = emails[transaction.source];
                        transaction.targetEmail = emails[transaction.target];
                        delete transaction.source
                        delete transaction.target
                    });
                    self.home('gotTransactions')
                }
            }))
        }
    },
    sendMoney:function(transaction){
        this.transaction = transaction;
        this.userEmail = transaction.receiverEmail;
        this.nextPhase = "send";
        this.swarm('getId');
    },
    send:{
        node:"CreditAdapter",
        code:function(){
            var self = this;
            var transaction = this.transaction;
            createTransaction(this.meta.userId,this.userId,transaction.amount,transaction.formalType,transaction.description,S(function(err,transaction){
                if(err){
                    self.err = err.message;
                    self.home('failed');
                }else{
                    self.transaction = transaction;
                    delete self.transaction.target;
                    delete self.transaction.source;
                    self.transaction.targetEmail = self.userEmail;
                    self.home('moneySent');
                }
            }))
        }
    }
};
accountsSwarming;
