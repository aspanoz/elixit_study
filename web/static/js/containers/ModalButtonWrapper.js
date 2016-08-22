import React, { Component } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux'

import ModalButton from '../components/ModalButton'
import * as modalActions from '../actions/ModalActions'

class ModalButtonWrapper extends Component {

  render() {
    const { openModal } = this.props.modalActions
    
    return <div className="app">
      <ModalButton openModal={ openModal } />
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

export default connect(mapStateToProps, mapDispatchToProps)(ModalButtonWrapper)
