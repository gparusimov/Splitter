pragma solidity ^0.4.18;

contract Splitter {

	address private owner;
  bool private isHalting;
	mapping(address => uint256) public balances;

	event LogSplit(address sender, address recipient1, address recipient2, uint amount);
	event LogWithdraw(address  sender, uint value);
	event LogHalting(bool, address);
  event LogResuming(bool, address);

	function Splitter()
	 public
	{
		owner = msg.sender;
		isHalting = false;
	}

	modifier onlyOwner
	{
		require(msg.sender == owner);
		_;
	}

	modifier onlyIfRunning
	{
	 require(!isHalting);
	 _;
	}

  modifier 	onlyIfHalting
  {
	 require(isHalting);
	 _;
	}

	function split(address recipient1, address recipient2)
 	 public
	 onlyIfRunning
	 payable
	{
    require(msg.value != 0);
		require(recipient1 != 0);
		require(recipient2 != 0);

		uint half = msg.value/2;
		balances[recipient1] += half;
		balances[recipient2] += half;
		LogSplit(msg.sender, recipient1, recipient2, half);
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


   function haltContract()
	  public
		onlyIfRunning
		onlyOwner
		returns (bool success)
	{
     LogHalting(true, msg.sender);
     isHalting = true;
     return true;
  }

   function resumeContract()
	  public
		onlyIfHalting
		onlyOwner
		returns (bool success)
	{
     LogResuming(true, msg.sender);
     isHalting = false;
     return true;
   }

	function getOwner()
    public
    view
    returns(address theOwner)
  {
    return owner;
}

}
