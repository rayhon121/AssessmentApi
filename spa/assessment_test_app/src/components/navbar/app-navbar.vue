<template>
  <div class="app-layout__navbar">
    <va-navbar  color="secondary" shape class="mb-2">
      <template #left>
        <div class="left">
          <va-icon-menu-collapsed 
            @click="isSidebarMinimized = !isSidebarMinimized"
            :class="{ 'x-flip': isSidebarMinimized }"
            class="va-navbar__item"
            :color="colors.primary"
          />
          <router-link to="/">
            <img class="brand-img" width=150 height=40 alt="Meazure Learning" src="https://www.meazurelearning.com/wp-content/themes/meazure/assets/img/mz-logo.svg">
          </router-link>          
        </div>
      </template>
      <template #center>
          <va-alert
            v-model="navBarMessage.isVisible"
            :color="navBarMessage.isSuccess ? 'success' : 'warning'"
          >
            {{navBarMessage.message}}
          </va-alert>
      </template>
      <template #right>
        <a href="https://github.com/rayhon121/AssessmentApi">
        <va-button icon="github" flat=true>Github</va-button></a>
      </template>
    </va-navbar>
  </div>
</template>

<script>
import { useColors } from 'vuestic-ui'
import { useStore } from 'vuex'
import { computed } from 'vue'
import VaIconMenuCollapsed from '@/components/icons/menu-collapsed'

export default {
  components: {  VaIconMenuCollapsed },
  setup() {
    const { getColors } = useColors()
    const colors = computed(() => getColors() )
    const store = useStore()

    const isSidebarMinimized = computed({
      get: () => store.state.isSidebarMinimized,
      set: (value) => store.commit('updateSidebarCollapsedState', value)
    })

    const navBarMessage = computed({
      get: () => store.state.navBarMessage,
      set: (value) => store.commit('updateNavBarMessage', value)
    })

    return {
      colors,
      isSidebarMinimized,
      navBarMessage, 
      store
    }
  },
  data () {
    return {
      isVisible: false,
      statusType: "success",
      statusMessage: "",
    }
  },
  watch: {
    navBarMessage(newVal) {

      if (newVal.isVisible) {
        setTimeout(() => {
          this.navBarMessage = { isSuccess: false, message: '', isVisible: false };
        }, 3000); 
      }
    }
  },
  methods: {
    showSuccess(value) {
        this.isVisible = true;
        this.statysType = "success";
        this.statusMessage = value;
    },
    showError(value) {
        this.isVisible = true;
        this.statysType = "warning";
        this.statusMessage = value;
    }
  }
}
</script>

<style lang="scss" scoped>
  .va-navbar {
    box-shadow: var(--va-box-shadow);
    z-index: 2;
    &__center {
      @media screen and (max-width: 1200px) {
        .app-navbar__github-button {
          display: none;
        }
      }
      @media screen and (max-width: 950px) {
        .app-navbar__text {
          display: none;
        }
      }
    }

    @media screen and (max-width: 950px) {
      .left {
        width: 100%;
      }
      .app-navbar__actions {
        width: 100%;
        display: flex;
        justify-content: space-between;
      }
    }
  }

  .left {
    display: flex;
    align-items: center;
    & > * {
      margin-right: 1.5rem;
    }
    & > *:last-child {
      margin-right: 0;
    }
  }

  .x-flip {
    transform: scaleX(-100%);
  }

  .app-navbar__text > * {
    margin-right: 0.5rem;
    &:last-child {
      margin-right: 0;
    }
  }
</style>