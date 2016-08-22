import { createStore, applyMiddleware } from 'redux'
import thunk from 'redux-thunk'
// import createLogger from 'redux-logger' // только с webpack?

import rootReducer from '../reducers'


export default function configureStore(initialState) {

  // const logger = createLogger()

  const store = createStore(
      rootReducer,
      initialState,
      applyMiddleware(thunk /*s, logger*/) //logger последним
    )

  if (module.hot) { // webpack
    module.hot.accept('../reducers', () => {
      const nextRootReducer = require('../reducers')
      store.replaceReducer(nextRootReducer)
    })
  }

  return store
}
