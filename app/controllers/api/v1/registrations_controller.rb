class Api::V1::RegistrationsController < ApplicationController

    # GET /registrations
    def index
        @registration = Registration.all
        render json: @registration.to_json( :include => [:user, :exam] )
    end

    def destroy
        @registration = Registration.find(params[:id])
        @registration.destroy
        render body: nil, status: :no_content
    end

    # POST /registrations
    def create
        registrationParameters = registration_params
        userId = -1
        collegeExists = College.where(id: registrationParameters['college_id']).exists?

        if !collegeExists
            render json: { error: 'College with specified ID does not exist'}.to_json, status: 400
            return
        end

        exam = Exam.where(college_id: registrationParameters['college_id'], id: registrationParameters['exam_id'])
        if exam.present?
            examWindows = ExamWindow.where(exam_id: exam.first.attributes['id'])
            
            validWindow = false
            examWindows.each do |window|
                windowData = window.as_json
                if registrationParameters['start_time'] >= windowData['start'] && registrationParameters['start_time'] <= windowData['end']
                    validWindow = true
                end
            end

            if validWindow
                
                user = User.where(first_name: registrationParameters['first_name'], last_name: registrationParameters['last_name'], 
                    phone_number: registrationParameters['phone_number'])
                if !user.exists?
                    user = User.new(first_name: registrationParameters['first_name'], last_name: registrationParameters['last_name'], 
                        phone_number: registrationParameters['phone_number'])
                    if !user.save
                        render json: { error: 'Unable to create user.'}.to_json, status: 400
                    end
                else
                    user = user.first.as_json
                end

                @registration = Registration.new(exam_id: registrationParameters['exam_id'], user_id: user['id'], start_time: registrationParameters['start_time'])
                if @registration.save
                    render json: @registration
                else
                    render json: { error: 'Unable to create registration.'}.to_json, status: 400
                end
            else
                render json: { error: 'Start time is not within any valid exam window.'}.to_json, status: 400
            end
        else
            render json: { error: 'Exam for the specified college does not exist.'}.to_json, status: 400
        end
    end

    private

    def registration_params
      params.permit(:first_name, :last_name, :phone_number, :college_id, :exam_id, :start_time)
    end
end
