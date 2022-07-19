class Api::V1::CollegesController < ApplicationController

    # GET /colleges
    def index
        @colleges = College.all
        render json: @colleges
    end

    # POST /colleges
    def create
        @college = College.new(college_params)
        if @college.save
            render json: @college
        else
            render error: { error: 'Unable to create college.'}, status: 400
        end
    end

    private

    def college_params
      params.permit(:name)
    end
end
