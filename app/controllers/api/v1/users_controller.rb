class Api::V1::UsersController < ApplicationController

    # GET /users
    def index
        @users = User.all
        render json: @users
    end

    # POST /users
    def create
        userParameters = user_params
        @user = User.new(first_name: userParameters['firstName'], last_name: userParameters['lastName'], phone_number: userParameters['phoneNumber'])
        if @user.save
            render json: @user
        else
            render error: { error: 'Unable to create user.'}, status: 400
        end
    end

    private

    def user_params
      params.permit(:firstName, :lastName, :phoneNumber)
    end
end
