import React, { PropTypes, Component } from 'react'


export default class ModalButton extends Component {

  onModalBtnClick() {
    this.props.openModal(true)
  }

  render() {
    return <a
      className="btn btn-danger btn-xs"
      onClick={ this.onModalBtnClick.bind(this) }
      href="#"
      rel="nofollow"
      >
        r.Delete
      </a>
  }
}


ModalButton.propTypes = {
  openModal: PropTypes.func.isRequired
}
