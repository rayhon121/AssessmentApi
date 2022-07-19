<template>
  <div class="standard-form">
    <va-form ref="form">
      <va-input
        label="Name"
        v-model="collegeName"
        :rules="[value => (value && value.length > 0) || 'Field is required']"
      />
      <va-button
        class="mb-3"
        @click="addCollege()"
      >
        Add college
      </va-button>
    </va-form>    
    <h4 class="display-4">Colleges</h4>
    <va-data-table :items="colleges"/>
  </div>
</template>

<script>
import { inject } from 'vue'
import { useStore } from 'vuex';

export default {
  setup() {
    const axios = inject('$axios');
    const store = useStore();
    const config = inject('appConfig');
    return {
      axios,
      store,
      config
    }
  },
  data () {
    return {
      collegeName: '',
      colleges: []
    }
  },
  async created() {
    this.reloadData();
  },
  methods: {
    async addCollege() {
      let store = this.store;
      let self = this;
      if (!this.$refs.form.validate())
        return;

      await this.axios.post(`${this.config.apiUrl}/api/v1/colleges`, {
          name: this.collegeName
      })
      .then(function() {              
        store.commit('updateNavBarMessage', { isSuccess: true, message: "Successfully added the college.", isVisible: true }); 
        self.clearFields();
        self.reloadData();
      })     
      .catch(function (error) {           
        store.commit('updateNavBarMessage', { isSuccess: false, message: error, isVisible: true }); 
      });
    },
    async reloadData() {
      let self = this;
      await this.axios.get(`${this.config.apiUrl}/api/v1/colleges`)
        .then(function(response){
          self.colleges = response.data.map(college => ({ 
              id: college.id,
              name: college.name
            }));
        })
        .catch(function (error) {
            self.store.commit('updateNavBarMessage', { isSuccess: false, message: error, isVisible: true }); 
        });
    },
    clearFields() {
      this.$refs.form.reset()
      setTimeout(() => {
        this.$refs.form.resetValidation()
      }, 1); 
    }
  },
}
</script>