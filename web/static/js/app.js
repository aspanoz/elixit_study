import "phoenix_html";

import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';

import configureStore from './store/configureStore';
import ModalWrapper from './containers/ModalWrapper';
import ModalButtonWrapper from './containers/ModalButtonWrapper';

const store = configureStore();

render(
  <Provider store={store}><ModalWrapper /></Provider>,
  document.getElementById('r_modal')
)

for (var modalButton of document.getElementsByClassName('r_modal')) {
  render(
    <Provider store={store}><ModalButtonWrapper /></Provider>,
    modalButton
  )
}

/*
function is_modal(state = false, action) {
  switch (action.type) {
  case 'MODALOPEN':
    state = true;
    return state
  case 'MODALCLOSE':
    state = false;
    return state
  default:
    return state
  }
}

function is_modal (state) {
  return {
    user: state.user
  }
}

connect(is_modal)(App)
let store = createStore(is_modal)
class ModalWrapper extends React.Component {
  render() {
    if(this.props.isOpen){
      return (
        <ReactCSSTransitionGroup transitionName={this.props.transitionName}>
          <div className="modal">
            {this.props.children}
          </div>
        </ReactCSSTransitionGroup>
      );
    } else {
        return <ReactCSSTransitionGroup transitionName={this.props.transitionName} />;
    }
  }
}

class ModalTestButton extends React.Component {
  render() {
    <button onClick={this.openModal}>Open modal</button>
  }
}

class Modal extends React.Component {

  getInitialState() {
    return { isModalOpen: false };
  }

  openModal() {
    this.setState({ isModalOpen: true });
  }

  closeModal() {
    this.setState({ isModalOpen: false });
  }

  render() {
    return (
      <div className="app">
        <ModalWrapper isOpen={this.state.isModalOpen}
               transitionName="modal-anim">
          <h3>My Modal</h3>
          <div className="body">
            <p>This is the modal's body.</p>
          </div>
          <button onClick={this.closeModal}>Close modal</button>
        </ModalWrapper>
      </div>
    );
  }
}

ReactDOM.render(
  <Provider store={store}>
    <Modal/>
  </Provider>,
  document.getElementById("r_modal")
)
*/
