<template>
  <div class="standard-form">
    <va-form ref="form">
      <va-input
        label="First Name"
        v-model="firstName"
        :rules="[value => (value && value.length > 0) || 'Field is required']"
      />
      <va-input
        class="mt-3"
        label="Last Name"
        v-model="lastName"
        :rules="[value => (value && value.length > 0) || 'Field is required']"
      />
      <va-input
        class="mt-3"
        label="Phone Number"
        v-model="phoneNumber"
        :rules="[value => isPhoneNumber(value)|| 'Field must be in format ###-###-####']"
      />
      <va-button
        class="mb-3"
        @click="addUser()"
      >
        Add a user
      </va-button>
    </va-form>
    <h4 class="display-4">Users</h4>
    <va-data-table :items="users">
    </va-data-table>
  </div>
</template>

<script>
import { inject } from 'vue'
import { useStore } from 'vuex';

export default {
  setup() {
      const axios = inject('$axios');
      const store = useStore()
      const config = inject('appConfig');
      return {
        axios,
        store,
        config
      }
  },
  data () {
    return {
      firstName: '',
      lastName: '',
      phoneNumber: '',
      users: []
    }
  },
  async created() {
    this.reloadData();
  },
  methods: {
    async addUser() {
        let store = this.store;
        let self = this;
        
        if (!this.$refs.form.validate())
          return;
        await this.axios.post(`${this.config.apiUrl}/api/v1/users`, {
            firstName: this.firstName,
            lastName: this.lastName,
            phoneNumber: this.phoneNumber
        })
        .then(function() {              
          store.commit('updateNavBarMessage', { isSuccess: true, message: "Successfully added the user.", isVisible: true }); 
          self.clearFields();
          self.reloadData();
        })     
        .catch(function (error) {             
          store.commit('updateNavBarMessage', { isSuccess: false, message: error, isVisible: true }); 
        });
    },
    isPhoneNumber(value) {
        const regex = new RegExp('^[0-9]{3}-[0-9]{3}-[0-9]{4}$|^[0-9]{10}$');
        return regex.test(value);
    },
    async reloadData() {
      let self = this;
      await this.axios.get(`${this.config.apiUrl}/api/v1/users`)
        .then(function(response){
          self.users = response.data.map(user => ({ 
              id: user.id,
              name: `${user.first_name} ${user.last_name}`, 
              phone: `${user.phone_number}`
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