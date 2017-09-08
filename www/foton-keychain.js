var exec = require('cordova/exec');

function FotonKeyChain() { 
}

FotonKeyChain.prototype.armazenar = function(chave, dado, callbackSuccess, callbackError){

 exec(callbackSuccess, callbackError, 'FotonKeyChain', 'armazenar', [ chave, dado ]);
}

FotonKeyChain.prototype.recuperar = function(chave, callbackSuccess, callbackError){

 exec(callbackSuccess, callbackError, 'FotonKeyChain', 'recuperar', [ chave ]);
}

 var keyChain = new FotonKeyChain();
 module.exports = keyChain;
