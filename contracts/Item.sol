pragma solidity ^0.8.9;
/*contract item{

uint public priceInwei;

uint public index;




ItemManager parentContract;

uint public pricePaid;


//uint public pricePaid;




constructor(ItemManager _parentContract, uint _priceInwei, uint _index) public {

priceInwei =_priceInwei;



index=_index;

parentContract=_parentContract;

}

receive() external payable{

require(pricePaid==0, "item is paid already");

require(priceInwei== msg.value,"only full payments allowed");

pricePaid += msg.value;

(bool success,)=address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)",index));

require(success, "The transaction was not successful ; cancelling");

}

fallback() external {}

}

contract ItemManager{

enum SupplyChainState{Created,Paid, Delivered}

struct s_item{

item _item;

string _identifier;

uint _itemPrice;

ItemManager.SupplyChainState _State;

}

mapping (uint => s_item) public items;

uint itemIndex;




event SupplyChainstep(uint _itemIndex, uint _step, address _itemAddress);

function createItem(string memory _identifier, uint _itemPrice) public{

item item = new item(this, _itemPrice,itemIndex);

items[itemIndex]._item=item;

items[itemIndex]._identifier= _identifier;

items[itemIndex]._itemPrice= _itemPrice;

items[itemIndex]._State=SupplyChainState.Created;

emit SupplyChainstep(itemIndex, uint(items[itemIndex]._State), address(item));

itemIndex++;

}

function triggerPayment(uint _itemIndex) public payable {

require(items[itemIndex]._itemPrice == msg.value, "only full payment accepted");

require(items[itemIndex]._State == SupplyChainState.Created, "items is further in the chain ");

items[itemIndex]._State=SupplyChainState.Paid;

emit SupplyChainstep(itemIndex, uint(items[itemIndex]._State),address(items[_itemIndex]._item));

}

function triggerDilivery(uint _itemIndex) public {

require(items[itemIndex]._State == SupplyChainState.Paid, "items is further in the chain");

items[itemIndex]._State=SupplyChainState.Delivered;

emit SupplyChainstep(itemIndex, uint(items[itemIndex]._State),address(items[_itemIndex]._item));

}

}*/




contract Ownable{
    address _owner;

    constructor() public{
        _owner = msg.sender;
    }
    modifier onlyowner() {
        require(isOwner(), "Yor are not the owner");
        _;
    }
    function isOwner() public view returns(bool) {
        return (msg.sender == _owner);
    }
}

contract Item{
    uint public priceInwei;
    uint public index;

    ItemManager parentContract;

    uint public pricePaid;

    constructor(ItemManager _parentContract, uint _priceInwei, uint _index) public {
        priceInwei =_priceInwei;
        //uint public pricePaid;
        index=_index;
        parentContract=_parentContract;
    }
    receive() external payable{
        require(pricePaid==0, "item is paid already");
        require(priceInwei== msg.value,"only full payments allowed");
        pricePaid += msg.value;
        (bool success,)=address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)",index));
        //(bool success,)=address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)",index));
        require(success, "The transaction was not successful ; cancelling");
    }
    fallback() external {}
}
contract ItemManager is Ownable{
    enum SupplyChainState{Created,Paid, Delivered}
    struct s_item{
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _State;
    }
    mapping (uint => s_item) public items;
    uint itemIndex;

    event SupplyChainstep(uint _itemIndex, uint _step, address _itemAddress);
    function createItem(string memory _identifier, uint _itemPrice) public onlyowner{
        Item item = new Item(this, _itemPrice,itemIndex);
        items[itemIndex]._item=item;
        items[itemIndex]._identifier= _identifier;
        items[itemIndex]._itemPrice= _itemPrice;
        items[itemIndex]._State=SupplyChainState.Created;
        emit SupplyChainstep(itemIndex, uint(items[itemIndex]._State), address(item));
        itemIndex++;
    }
    function triggerPayment(uint _itemIndex) public payable {
        require(items[itemIndex]._itemPrice == msg.value, "only full payment accepted");
        require(items[itemIndex]._State == SupplyChainState.Created, "items is further in the chain ");
        items[itemIndex]._State=SupplyChainState.Paid;
        emit SupplyChainstep(itemIndex, uint(items[itemIndex]._State),address(items[_itemIndex]._item));
    }
    function triggerDilivery(uint _itemIndex) public onlyowner {
        require(items[itemIndex]._State == SupplyChainState.Paid, "items is further in the chain");
        items[itemIndex]._State=SupplyChainState.Delivered;
        emit SupplyChainstep(itemIndex, uint(items[itemIndex]._State),address(items[_itemIndex]._item));
    }
}
