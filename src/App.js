import React from 'react';
import './App.css';
import Home from './components/pages/Home';
import { BrowserRouter, Switch, Route } from 'react-router-dom';






function App() {
  return (
    <>
     <BrowserRouter basename={process.env.PUBLIC_URL}>
       
        
        <Switch>
          <Route path='/' exact component={Home} />
         
        </Switch>
        </BrowserRouter>
      
    </>
  );
}

export default App;
