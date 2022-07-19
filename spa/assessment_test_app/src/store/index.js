import { createStore } from 'vuex'

export default createStore({
  strict: true, // process.env.NODE_ENV !== 'production',
  state: {
    isSidebarMinimized: false,
    navBarMessage: { isSuccess: false, message: "", isVisible: false }
  },
  mutations: {
    updateSidebarCollapsedState(state, isSidebarMinimized) {
      state.isSidebarMinimized = isSidebarMinimized
    },
    updateNavBarMessage(state, navBarMessage) {
      state.navBarMessage = navBarMessage
    }
  },
})