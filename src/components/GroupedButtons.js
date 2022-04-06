import React, { useState } from "react";
import Button from "@material-ui/core/Button";
import ButtonGroup from "@material-ui/core/ButtonGroup";
import './HeroSection.css';


let slotvalue = 1;
let h=0.1;

class GroupedButtons extends React.Component {
  state = { counter: 1 };
  
  
  handleIncrement = () => {
    this.setState((state) => ({ counter: Math.min(state.counter + 1, 10) }));
    h = this.state.counter*0.1;
    console.log(h);
  };
  
  handleDecrement = () => {
    this.setState((state) => ({ counter: Math.max(state.counter - 1, 1) }));
    h = this.state.counter*0.1;
    console.log(this.state.counter);
    console.log(h);

  };
  render() {
    const displayCounter = this.state.counter > 0;
     slotvalue = this.state.counter ;

    return (
      <div>
      {h}
      <ButtonGroup size="small" aria-label="small outlined button group" className="borderColorBox">
        <Button onClick={this.handleDecrement} className='add'>-</Button>
        {displayCounter && <Button disabled className="numberQuantity">{this.state.counter}</Button>}
        {displayCounter && <Button  onClick={this.handleIncrement}   className='substract'>+</Button>}
      </ButtonGroup>
      </div>
    );
  }
}

export {GroupedButtons,slotvalue};
