<template>
  <va-sidebar
    :width="width"
    :minimized="minimized" 
    :minimizedWidth="minimizedWidth"
  >
      <template v-for="(route, idx) in items" :key="idx">
        <va-sidebar-item  :active="isRouteActive(route)" :to="route.children ? undefined : { name: route.name } ">
          <va-sidebar-item-content>



            <va-sidebar-item-title>
              {{route.displayName}}
            </va-sidebar-item-title>

          </va-sidebar-item-content>
        </va-sidebar-item>
      </template>
  </va-sidebar>    
</template>

<script>
import { useGlobalConfig } from 'vuestic-ui';
import NavigationRoutes from './routes';


export default {
  name: "app-sidebar",
  props: {
    width: { type: String, default: '16rem' },
    color: { type: String, default: "secondary" },
    minimized: { type: Boolean, required: true },
    minimizedWidth: {
      type: Boolean,
      required: false,
      default: undefined
    },
  },
  data() {
    return {
      items: NavigationRoutes.routes,
    };
  },
  methods: {
    isRouteActive(item) {
      return item.name === this.$route.name;
    }
  },
  computed: {
    computedClass() {
      return {
        //"app-sidebar--minimized": this.minimized
      };
    },
    colors() {
      return useGlobalConfig().getGlobalConfig().colors
    },
  },
};
</script>
