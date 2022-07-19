require  './app/models/api/registration_request'

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

        # checks if request JSON is valid
        if !registrationParameters.isValid
            render json: registrationParameters.errors.to_json, status: 400
            return
        end

        # check if college exists
        collegeExists = College.where(id: registrationParameters.collegeId).exists?
        if !collegeExists
            render json: { error: 'College with specified ID does not exist'}.to_json, status: 400
            return
        end

        # checks if the given exam collge combination exists
        exam = Exam.where(college_id: registrationParameters.collegeId, id: registrationParameters.examId)
        if !exam.present?
            render json: { error: 'Exam for the specified college does not exist.'}.to_json, status: 400
            return
        end

        # Checks to see whether start time is within any of the time windows of the exam
        examWindows = ExamWindow.where(exam_id: exam.first.attributes['id'])    
        validWindow = false
        examWindows.each do |window|
            windowData = window.as_json
            if registrationParameters.start >= windowData['start'] && registrationParameters.start <= windowData['end']
                validWindow = true
            end
        end

        if !validWindow
            render json: { error: 'Start time is not within any valid exam window.'}.to_json, status: 400
            return
        end

        # Check if user exists based on uniqueness of first name, last name, and phone number. Creates a new user
        # if doesn't exist
        user = User.where(first_name: registrationParameters.firstName, last_name: registrationParameters.lastName, 
            phone_number: registrationParameters.phoneNumber)
        if !user.exists?
            user = User.new(first_name: registrationParameters.firstName, last_name: registrationParameters.lastName, 
                phone_number: registrationParameters.phoneNumber)
            if !user.save
                render json: { error: 'Unable to create user.'}.to_json, status: 400
                return
            end
        else
            user = user.first.as_json
        end

        # registers the user to the given exam at the specified time
        @registration = Registration.new(exam_id: registrationParameters.examId, user_id: user['id'], 
            start_time: registrationParameters.start)
        if @registration.save
            render json: @registration.slice(:id, :exam_id, :user_id, :start_time)
        else
            render json: { error: 'Unable to create registration.'}.to_json, status: 400
        end          
    end

    private

    def registration_params
       Api::RegistrationRequest.new(params.permit(:first_name, :last_name, :phone_number, :college_id, :exam_id, :start_time))
    end
end
