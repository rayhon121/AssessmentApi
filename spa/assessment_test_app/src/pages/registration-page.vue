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
        :rules="[value => isPhoneNumber(value)|| 'Field must be in format ###-###-#### or ##########']"
      />
      <va-input
        class="mt-3"
        label="College ID"
        v-model="collegeId"
        :rules="[value => !isNaN(value) && !!value|| 'Field must be a number']"
      />
      <va-input
        class="mt-3"
        label="Exam ID"
        v-model="examId"
        :rules="[value => !isNaN(value) && !!value|| 'Field must be a number']"
      />

      <div class="d-flex">
          <va-date-input :rules="[(date) => !!date || 'Field Required']" 
              label="Start Date" v-model="startDate" />
          <va-divider vertical />
          <va-time-input :rules="[(date) => !!date || 'Field Required']" 
              label="Start Time" v-model="startTime" ampm />
      </div>
      
      <va-button
        class="mb-3"
        @click="register()"
      >
        Register
      </va-button>
    </va-form>
    <h4 class="display-4">Registrations</h4>
    <va-data-table :items="registrations">
      <template #cell(actions)="{ value }"><va-button flat icon="delete" @click="deleteItem({value})"></va-button></template>
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
      collegeId: null,
      examId: null,
      startDate: new Date(),
      startTime: new Date(),
      registrations: []
    }
  },
  async created() {
    this.reloadData();
  },
  methods: {
    async register() {
        
        let startDateTime = new Date(this.startDate);
        startDateTime.setHours(this.startTime.getHours(), this.startTime.getMinutes());
        let store = this.store;
        let self = this;

        if (!this.$refs.form.validate())
          return;
        return await this.axios.post(`${this.config.apiUrl}/api/v1/registrations`, {
            first_name: this.firstName,
            last_name: this.lastName,
            phone_number: this.phoneNumber,
            college_id: parseInt(this.collegeId),
            exam_id: parseInt(this.examId),
            start_time: startDateTime
            })   
            .then(function() {              
              store.commit('updateNavBarMessage', { isSuccess: true, message: "Successfully registered the student.", isVisible: true }); 
              self.clearFields();
              self.reloadData();
            })     
            .catch(function (error) {          
              console.log(error);   
              store.commit('updateNavBarMessage', { isSuccess: false, message: error.response.data.error ?? error, isVisible: true }); 
            });
            
    },
    async deleteItem(id) {
      let self = this;
      await this.axios.delete(`${this.config.apiUrl}/api/v1/registrations/${id.value}`)   
            .then(function() {              
              self.store.commit('updateNavBarMessage', { isSuccess: true, message: "Successfully deleted registration.", isVisible: true }); 
              self.clearFields();
              self.reloadData();
            })     
            .catch(function (error) {            
              self.store.commit('updateNavBarMessage', { isSuccess: false, message: error.response.data.error ?? error, isVisible: true }); 
            });
    },
    async reloadData() {
      let self = this;
      await this.axios.get(`${this.config.apiUrl}/api/v1/registrations`)
        .then(function(response){
          self.registrations = response.data.map(registration => ({ 
              id: registration.id,
              username: `${registration.user.first_name} ${registration.user.last_name}`, 
              exam: `${registration.exam.name}`,
              start: new Date(registration.start_time).toLocaleString(),
              actions: registration.id
            }));
        })
        .catch(function (error) {
            self.store.commit('updateNavBarMessage', { isSuccess: false, message: error, isVisible: true }); 
        });
    },
    clearFields() {
      this.$refs.form.reset()
      this.startDate = new Date();
      this.startTime = new Date();
      setTimeout(() => {
        this.$refs.form.resetValidation()
      }, 1); 
    },
    isPhoneNumber(value) {
        const regex = new RegExp('^[0-9]{3}-[0-9]{3}-[0-9]{4}$|^[0-9]{10}$');
        return regex.test(value);
    }
  },
}
</script>