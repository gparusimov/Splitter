var Splitter = artifacts.require("./Splitter.sol");

var BigNumber = require('bignumber.js')
Promise = require("bluebird");
Promise.promisifyAll(web3.eth, { suffix: "Promise" });

contract('Splitter', function(accounts) {

  var сontract;

  const amountToSplit = web3.toWei(2, "ether");
  const amountSplitted = web3.toWei(1, "ether");

  const owner = accounts[0];
  const firstRecipient = accounts[1];
  const secondRecipient = accounts[2];


  beforeEach('Create new Splitter', function() {
    return Splitter.new( { from : owner } )
      .then( function( instance ) {
        сontract = instance;
      });
  });

  it("should be owned by the owner", function() {
    return сontract.getOwner( { from:owner } )
    .then( receivedOwner => {
        assert.strictEqual( receivedOwner, owner, "Contract is not owned by owner");
    });
  });

  it("should be 0 balance before splitting", function() {
        return web3.eth.getBalancePromise(сontract.address)
        .then(function(balance) {
            assert.equal(balance.valueOf(), 0, "shouldn't be 0 balance before splitting");
        });
});

it("Owner should split between firstRecipient and secondRecipient ", function() {
     return сontract.split(firstRecipient, secondRecipient,{ from: owner, value: amountToSplit
     }).then(function() {
         return сontract.balances.call(firstRecipient);
     }).then(function(balance) {
         assert.equal(balance.valueOf(), amountSplitted, "firstRecipient  should have 1 eth balance");
         return сontract.balances.call(secondRecipient);
      }).then(function(balance) {
           assert.equal(balance.valueOf(),amountToSplit - amountSplitted, "secondRecipient should have 1 eth balance");
     });
});

it("should withdraw for firstRecipient ", function() {
    return сontract.split(firstRecipient, secondRecipient,{ from: owner, value: amountToSplit
    }).then(function() {
        return сontract.withdraw({
            from: firstRecipient
        }).then(function() {
            return сontract.balances.call(firstRecipient);
        }).then(function(balance) {
            assert.equal(balance.valueOf(), 0, "firstRecipient should have 0 balance");
            return сontract.balances.call(secondRecipient);
          }).then(function(balance) {
              assert.equal(balance.valueOf(), amountToSplit - amountSplitted, "secondRecipient should have 1 eth balance");
        });
    });
});

});
