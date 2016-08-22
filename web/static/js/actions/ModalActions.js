import { OPEN_MODAL } from '../constants/Modal'

export function openModal(modal_state) {

  return (dispatch) => {
    dispatch({
      type: OPEN_MODAL,
      payload: modal_state
    })
  }

}
