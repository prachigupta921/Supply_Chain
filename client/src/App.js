import React, { Component } from "react";
import SimpleStorageContract from "./contracts/SimpleStorage.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, contract: null, item_name:null,item_price:0,balance:null,pay_r:0,index:0,product_price:0}

  componentDidMount = async () => {
    try {


      // Get network provider and web3 instance.
      const web3 = await getWeb3();


      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();
   

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = SimpleStorageContract.networks[networkId];
      const instance = new web3.eth.Contract(
        SimpleStorageContract.abi,
        deployedNetwork && deployedNetwork.address,
      );
     


      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance}, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };







  runExample = async () => {
    const { accounts, contract,web3 } = this.state;

    // Stores a given value, 5 by default.
    var k= await contract.methods.set(100).send({ from: accounts[0] });
   
    console.log(contract.address);



  

    // Get the value from the contract to prove it worked.
    const response = await contract.methods.get().call();


  

    this.setState({storageValue:response});
  }

    

  handelchange=(event)=>{
    const target=event.target;
    const value=target.type=="checkbox"?target.checked:target.value;
    const name=target.name;

    this.setState({[name]:value});


  };


  handelsubmit=async()=>{
 

    
 

    const{item_name,item_price,accounts,contract}=this.state;
    const j=await contract.methods.add_item(item_price,item_name).send({from :accounts[0]});
    console.log("hello");
    console.log(j);




  };

  handelsubmit=async()=>{
 

    const{name,price,accounts,contract}=this.state;
    const j=await contract.methods.add_item(price,name).send({from :accounts[0]});
    console.log(j); 




  };

  change=async()=>{
      const { accounts, contract,web3,item_price} = this.state;
      var k= await contract.methods.set(item_price).send({ from: accounts[0] });
      var j=k.events.val_set.returnValues.i;
      this.setState({storageValue:j});








  };
   check=async()=>{
      const {contract} = this.state;

      const k=await contract.methods.get().call();
      this.setState({storageValue:k});







  }


  donate=async()=>{
        const{item_name,item_price,accounts,contract,index}=this.state;
        const j=await contract.methods.check_item_name(index).send({from:accounts[0]});
        const pr=j.events.about_item.returnValues.price;
        this.setState({product_price:pr});


        



  }



  buy_product=async=>{
    const { accounts, contract,web3 } = this.state;
    web3.eth.sendTransaction({from:accounts[0],to:accounts[1],value:100,data:"0xc6888fa10000000000000000000000000000000000000000000000000000000000000003"});
  }
  render(){
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
      <h1>Event Trigger /Supply Chain</h1>

      <div>
      <span> Name:</span><input type="text" name="item_name"  value={this.state.item_name} onChange={this.handelchange} ></input>
      <br></br>
       <span>  Price:</span><input type="number" name="item_price" value={this.state.item_price}   onChange={this.handelchange}></input>
       <br></br>
       <button onClick={this.handelsubmit}>submit </button>




       <br></br>


       <input type="number" name="index" value={this.state.index} onChange={this.handelchange} ></input>
       <button onClick={this.donate}>Check_Product_Price</button>
       <h2>{this.state.product_price}</h2>

        <button onClick={this.buy_product}>buy product</button>
      </div>
      </div>


        
    );
  }
}

export default App;
