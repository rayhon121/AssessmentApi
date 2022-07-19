<template>
  
  <div class="standard-form">
    <va-form ref="form">
      <va-select
        label="Exam"
        v-model="selectedExam"
        :options="exams"
        :rules="[value => (!!value) || 'Field is required']"
      />
      
      <div class="d-flex">
          <va-date-input :rules="[(date) => !!date || 'Field Required']" 
              label="Start Date" v-model="examStartDate" />
          <va-divider vertical />
          <va-time-input :rules="[(date) => !!date || 'Field Required']" 
              label="Start Time" v-model="examStartTime" ampm />
      </div>
      
      <div class="d-flex">
          <va-date-input :rules="[(date) => !!date || 'Field Required']" 
              label="End Date" v-model="examEndDate" />
          <va-divider vertical />
          <va-time-input :rules="[(date) => !!date || 'Field Required']" 
              label="End Time" v-model="examEndTime" ampm />
      </div>

      <va-button
        class="mb-3"
        @click="addExamWindow()"
      >
        Add a exam window
      </va-button>
    </va-form>    
    <h4 class="display-4">Exam Windows</h4>
    <va-data-table :items="windows"/>
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
      exams: [],
      windows: [],
      selectedExam: null,
      examStartDate: new Date(),
      examEndDate: new Date(),
      examStartTime: new Date(),
      examEndTime: new Date(),
    }
  },
  async created() {
    const examResponse = await this.axios.get(`${this.config.apiUrl}/api/v1/exams`)
        .catch(function (error) {
            console.log(error)
        });

    this.exams = examResponse.data.map(exam => ({ text: `${exam.name} - ${exam.college.name}`, value: exam }));
    this.reloadData();
  },  
  methods: {
    async addExamWindow() {
      const startDateTime = new Date(this.examStartDate);
      startDateTime.setHours(this.examStartTime.getHours(), this.examStartTime.getMinutes());

      const endDateTime = new Date(this.examEndDate);
      endDateTime.setHours(this.examEndTime.getHours(), this.examEndTime.getMinutes());

      let store = this.store;
      let self = this;
      if (!this.$refs.form.validate())
        return;

      await this.axios.post(`${this.config.apiUrl}/api/v1/exam_windows`, {
            examId: this.selectedExam.value.id,
            startDateTime,
            endDateTime
        })
        .then(function() {              
          store.commit('updateNavBarMessage', { isSuccess: true, message: "Successfully add the exam window.", isVisible: true }); 
          self.clearFields();
          self.reloadData();
        })     
        .catch(function (error) {             
          store.commit('updateNavBarMessage', { isSuccess: false, message: error, isVisible: true }); 
        });
    },
    async reloadData() {
      let self = this;
      await this.axios.get(`${this.config.apiUrl}/api/v1/exam_windows`)
        .then(function(response){
          self.windows = response.data.map(window => ({ 
              id: window.id,
              exam: window.exam.name, 
              start: new Date(window.start).toLocaleString(),
              end: new Date(window.end).toLocaleString()
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