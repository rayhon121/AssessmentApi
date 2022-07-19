import { createApp } from 'vue'
import App from './App.vue'
import { createVuestic } from 'vuestic-ui'
import 'vuestic-ui/dist/vuestic-ui.css'
import router from './router'
import store from './store'
import axios from 'axios'
import devConfig from './config/app.development.json'
import prodConfig from './config/app.json' 

createApp(App)
    .use(store)
    .use(router)
    .use(createVuestic())
    .provide('appConfig', process.env.NODE_ENV === 'development' ? devConfig : prodConfig)
    .provide('$axios', axios)
    .mount('#app')