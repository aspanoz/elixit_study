import React, { PropTypes, Component } from 'react'

export default class Modal extends Component {

  onModalBtnClick() {
    this.props.openModal(false)
  }

  render() {
    if ( this.props.modal_open == true ) {
      return <div>Всё Открыто
        <button onClick={ this.onModalBtnClick.bind(this) }>Закрыть всё</button>
        </div>
    }
    else {
      return <div>Закрыто</div>
    }
  }
}

Modal.propTypes = {
  modal_open: PropTypes.bool.isRequired,
  openModal: PropTypes.func.isRequired
}
