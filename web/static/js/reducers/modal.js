import { OPEN_MODAL } from '../constants/Modal'

const initialState = {
  modal_open: false
}

export default function modal(state = initialState, action) {

  switch (action.type) {
    case OPEN_MODAL:
      return { modal_open: action.payload }

    default:
      return state;
  }

}
