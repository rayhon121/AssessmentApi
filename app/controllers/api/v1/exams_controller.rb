class Api::V1::ExamsController < ApplicationController

    # GET /exams
    def index
        @exams = Exam.includes(:college)
        render json: @exams.to_json( :include => [:college] )
    end

    # POST /exams
    def create
        examParams = exam_params;
        @exam = Exam.new(name: examParams['name'], college_id: examParams['collegeId'])
        if @exam.save
            render json: @exam
        else
            render error: { error: 'Unable to create exam.'}, status: 400
        end
    end

    private

    def exam_params
        params.permit(:name, :collegeId)
    end
end
