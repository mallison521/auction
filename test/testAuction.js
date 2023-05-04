const Auction = artifacts.require('../contracts/Auction.sol')
//const truffleAssert = require('truffle-assertions');


contract('Auction', function (accounts){
    const success = '0x01'
    const item = 'shoes'
    const startingPrice = 10
    let auction

    let bid = 15
    let owner = accounts[0]
    let bidder = accounts[1]

    beforeEach('Setup contract for each test', async function () {
        auction = await Auction.new(startingPrice, item);
      });

      it('Success on bidding.', async function () {
        
        let balanceBefore = Number(web3.utils.fromWei(await web3.eth.getBalance(bidder), 'ether'));
        await auction.placeBid(item, {from: bidder, value: bid });
        let balanceAfter = Number(web3.utils.fromWei(await web3.eth.getBalance(bidder), 'ether'));
        
        assert.isBelow(balanceBefore - balanceAfter, 15);

      });
  



})