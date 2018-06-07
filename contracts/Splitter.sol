pragma solidity ^0.4.18;

contract Splitter {

	address private owner;

	mapping(address => uint256) public balances;

	event LogSplit(address sender, address recipient1, uint firstAmount, address recipient2, uint secondAmount);
	event LogWithdraw(address  sender, uint value);

	function Splitter()
	 public
	{
		owner = msg.sender;
	}

	function split(address recipient1, address recipient2)
 	 public
	 payable
	{
    require(msg.value != 0);
		require(recipient1 != 0);
		require(recipient2 != 0);

		if (msg.value % 2 == 1){
				 balances[recipient1] += msg.value/2 + 1;
				 balances[recipient2] += msg.value/2;
				 LogSplit(msg.sender, recipient1, msg.value/2 + 1, recipient2, msg.value/2);
		 } else {
				 balances[recipient1] += msg.value/2;
				 balances[recipient2] += msg.value/2;
				 LogSplit(msg.sender, recipient1, msg.value/2, recipient2, msg.value/2);
				 }
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
