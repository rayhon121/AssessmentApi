class Api::V1::ExamWindowsController < ApplicationController
    # GET /examwindows
    def index
        @examWindow = ExamWindow.includes(:exam)
        render json: @examWindow.to_json( :include => [:exam] )
    end

    # POST /examwindows
    def create
        examWindowParams = examWindow_params;
        @examWindow = ExamWindow.new(start: examWindowParams['startDateTime'], end: examWindowParams['endDateTime'], exam_id: examWindowParams['examId'])
        if @examWindow.save
            render json: @examWindow
        else
            render error: { error: 'Unable to create exam window.'}, status: 400
        end
    end

    private

    def examWindow_params
        params.permit(:endDateTime, :startDateTime, :examId)
    end
end
