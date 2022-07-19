<template>
  
  <div class="standard-form">
    <va-form ref="form">
      <va-select
        label="College"
        v-model="selectedCollege"
        :options="colleges"
        :rules="[value => !!value || 'Field is required']"
      />
      <va-input
        label="Exam Name"
        v-model="examName"
        :rules="[value => (value && value.length > 0) || 'Field is required']"
      />
      <va-button
        class="mb-3"
        @click="addExam()"
      >
        Add exam {{collegeId}}
      </va-button>
    </va-form>    
    <h4 class="display-4">Exams</h4>
    <va-data-table :items="exams"/>
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
  data() {
    return {
      selectedCollege: null,
      examName: '',
      colleges: [],
      exams: []
    }
  },
  async created() {
    const collegeResponse = await this.axios.get(`${this.config.apiUrl}/api/v1/colleges`)
        .catch(function (error) {
            console.log(error)
        });

    this.colleges = collegeResponse.data.map(college => ({ text: college.name, value: college }));
    this.reloadData();
  },
  methods: {
    async addExam() {
        let store = this.store;
        let self = this;

        if (!this.$refs.form.validate())
          return;
        await this.axios.post(`${this.config.apiUrl}/api/v1/exams`, {
            collegeId: this.selectedCollege.value.id,
            name: this.examName
        })
        .then(function() {              
          store.commit('updateNavBarMessage', { isSuccess: true, message: "Successfully added the exam.", isVisible: true }); 
          self.clearFields();
          self.reloadData();
        })     
        .catch(function (error) {             
          store.commit('updateNavBarMessage', { isSuccess: false, message: error, isVisible: true }); 
        });
    },
    async reloadData() {
      let self = this;
      await this.axios.get(`${this.config.apiUrl}/api/v1/exams`)
        .then(function(response){
          self.exams = response.data.map(exam => ({ 
              id: exam.id,
              name: exam.name, 
              college: exam.college.name
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