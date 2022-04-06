import React, { useState } from "react";
import Button from "@material-ui/core/Button";
import ButtonGroup from "@material-ui/core/ButtonGroup";
import './HeroSection.css';


let slotvalue = 1;

class GroupedButtons extends React.Component {
  state = { counter: 1 };
  
  
  handleIncrement = () => {
    this.setState((state) => ({ counter: Math.min(state.counter + 1, 10) }));
  };
  
  handleDecrement = () => {
    this.setState((state) => ({ counter: Math.max(state.counter - 1, 1) }));

  };
  render() {
    const displayCounter = this.state.counter > 0;
     slotvalue = this.state.counter ;

    return (
      <div>
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
