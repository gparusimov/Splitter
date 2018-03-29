pragma solidity ^0.4.18;

contract Splitter {

	address owner;

	mapping(address => uint256) public balances;

	event LogSplit(address sender, address recipient,  uint amount);
	event LogWithdraw(address  sender, uint value);

	function Splitter()
	 public
	{
		owner = msg.sender;
	}

	function split(address bob, address carol)
 	 public
	 payable
	{
    require(msg.value != 0);
		require(bob != 0);
		require(carol != 0);

		uint firstAmount = msg.value/2;
		balances[bob] += firstAmount;
		LogSplit(msg.sender, bob, firstAmount);

		uint secondAmount = msg.value - firstAmount;
		balances[carol] += secondAmount;
		LogSplit(msg.sender, carol, secondAmount);
	}

	function withdraw()
	 public
	{
	  uint payment = balances[msg.sender];
	  require(payment > 0);
		balances[msg.sender] = 0;
		LogWithdraw(msg.sender, payment);
		msg.sender.transfer(payment);
	}

	function getOwner()
    public
    view
    returns(address theOwner)
  {
    return owner;
}

}
