"use strict";(self["webpackChunkassessment_test_app"]=self["webpackChunkassessment_test_app"]||[]).push([[351],{9351:function(e,t,a){a.r(t),a.d(t,{default:function(){return p}});var s=a(3396);const l={class:"standard-form"},i={class:"d-flex"},r=(0,s.Uk)(" Register "),u=(0,s._)("h4",{class:"display-4"},"Registrations",-1);function o(e,t,a,o,m,n){const d=(0,s.up)("va-input"),c=(0,s.up)("va-date-input"),p=(0,s.up)("va-divider"),h=(0,s.up)("va-time-input"),f=(0,s.up)("va-button"),g=(0,s.up)("va-form"),b=(0,s.up)("va-data-table");return(0,s.wg)(),(0,s.iD)("div",l,[(0,s.Wm)(g,{ref:"form"},{default:(0,s.w5)((()=>[(0,s.Wm)(d,{label:"First Name",modelValue:m.firstName,"onUpdate:modelValue":t[0]||(t[0]=e=>m.firstName=e),rules:[e=>e&&e.length>0||"Field is required"]},null,8,["modelValue","rules"]),(0,s.Wm)(d,{class:"mt-3",label:"Last Name",modelValue:m.lastName,"onUpdate:modelValue":t[1]||(t[1]=e=>m.lastName=e),rules:[e=>e&&e.length>0||"Field is required"]},null,8,["modelValue","rules"]),(0,s.Wm)(d,{class:"mt-3",label:"Phone Number",modelValue:m.phoneNumber,"onUpdate:modelValue":t[2]||(t[2]=e=>m.phoneNumber=e),rules:[e=>n.isPhoneNumber(e)||"Field must be in format ###-###-#### or ##########"]},null,8,["modelValue","rules"]),(0,s.Wm)(d,{class:"mt-3",label:"College ID",modelValue:m.collegeId,"onUpdate:modelValue":t[3]||(t[3]=e=>m.collegeId=e),rules:[e=>!isNaN(e)&&!!e||"Field must be a number"]},null,8,["modelValue","rules"]),(0,s.Wm)(d,{class:"mt-3",label:"Exam ID",modelValue:m.examId,"onUpdate:modelValue":t[4]||(t[4]=e=>m.examId=e),rules:[e=>!isNaN(e)&&!!e||"Field must be a number"]},null,8,["modelValue","rules"]),(0,s._)("div",i,[(0,s.Wm)(c,{rules:[e=>!!e||"Field Required"],label:"Start Date",modelValue:m.startDate,"onUpdate:modelValue":t[5]||(t[5]=e=>m.startDate=e)},null,8,["rules","modelValue"]),(0,s.Wm)(p,{vertical:""}),(0,s.Wm)(h,{rules:[e=>!!e||"Field Required"],label:"Start Time",modelValue:m.startTime,"onUpdate:modelValue":t[6]||(t[6]=e=>m.startTime=e),ampm:""},null,8,["rules","modelValue"])]),(0,s.Wm)(f,{class:"mb-3",onClick:t[7]||(t[7]=e=>n.register())},{default:(0,s.w5)((()=>[r])),_:1})])),_:1},512),u,(0,s.Wm)(b,{items:m.registrations},{"cell(actions)":(0,s.w5)((({value:e})=>[(0,s.Wm)(f,{flat:"",icon:"delete",onClick:t=>n.deleteItem({value:e})},null,8,["onClick"])])),_:1},8,["items"])])}var m=a(65),n={setup(){const e=(0,s.f3)("$axios"),t=(0,m.oR)(),a=(0,s.f3)("appConfig");return{axios:e,store:t,config:a}},data(){return{firstName:"",lastName:"",phoneNumber:"",collegeId:null,examId:null,startDate:new Date,startTime:new Date,registrations:[]}},async created(){this.reloadData()},methods:{async register(){let e=new Date(this.startDate);e.setHours(this.startTime.getHours(),this.startTime.getMinutes());let t=this.store,a=this;if(this.$refs.form.validate())return await this.axios.post(`${this.config.apiUrl}/api/v1/registrations`,{first_name:this.firstName,last_name:this.lastName,phone_number:this.phoneNumber,college_id:parseInt(this.collegeId),exam_id:parseInt(this.examId),start_time:e}).then((function(){t.commit("updateNavBarMessage",{isSuccess:!0,message:"Successfully registered the student.",isVisible:!0}),a.clearFields(),a.reloadData()})).catch((function(e){console.log(e),t.commit("updateNavBarMessage",{isSuccess:!1,message:e.response.data.error??e,isVisible:!0})}))},async deleteItem(e){let t=this;await this.axios.delete(`${this.config.apiUrl}/api/v1/registrations/${e.value}`).then((function(){t.store.commit("updateNavBarMessage",{isSuccess:!0,message:"Successfully deleted registration.",isVisible:!0}),t.clearFields(),t.reloadData()})).catch((function(e){t.store.commit("updateNavBarMessage",{isSuccess:!1,message:e.response.data.error??e,isVisible:!0})}))},async reloadData(){let e=this;await this.axios.get(`${this.config.apiUrl}/api/v1/registrations`).then((function(t){e.registrations=t.data.map((e=>({id:e.id,username:`${e.user.first_name} ${e.user.last_name}`,exam:`${e.exam.name}`,start:new Date(e.start_time).toLocaleString(),actions:e.id})))})).catch((function(t){e.store.commit("updateNavBarMessage",{isSuccess:!1,message:t,isVisible:!0})}))},clearFields(){this.$refs.form.reset(),this.startDate=new Date,this.startTime=new Date,setTimeout((()=>{this.$refs.form.resetValidation()}),1)},isPhoneNumber(e){const t=new RegExp("^[0-9]{3}-[0-9]{3}-[0-9]{4}$|^[0-9]{10}$");return t.test(e)}}},d=a(89);const c=(0,d.Z)(n,[["render",o]]);var p=c}}]);
//# sourceMappingURL=351.d9b539c9.js.map