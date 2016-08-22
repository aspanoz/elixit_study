import React, { Component } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux'

import Modal from '../components/Modal'
import * as modalActions from '../actions/ModalActions'

class ModalWrapper extends Component {

  render() {
    const { modal } = this.props
    const { openModal } = this.props.modalActions

    return <div className="app">
      <Modal modal_open={modal.modal_open} openModal={ openModal }/>
    </div>
  }
}

function mapStateToProps (state) {
  return {
    modal: state.modal
  }
}

function mapDispatchToProps(dispatch) {
  return {
    modalActions: bindActionCreators(modalActions, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ModalWrapper)
