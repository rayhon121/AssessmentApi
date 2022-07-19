require "json-schema"

class Api::RegistrationRequest
    attr_accessor :isValid, :collegeId, :firstName, :lastName, :phoneNumber, :examId, :start, :errors
    def initialize(parameters)
        @isValid = validate(parameters.to_json)        
        if @isValid
            @firstName = parameters['first_name']
            @lastName = parameters['last_name']
            @phoneNumber = parameters['phone_number']
            @collegeId = parameters['college_id']
            @examId = parameters['exam_id']
            @start = parameters['start_time']
        else
            @errors = fully_validate(parameters.to_json)
        end
    end

    private
    def validate(json)
        schema = {
            "type" => "object",
            "required" => ["first_name", "last_name", "phone_number", "college_id", "exam_id", "start_time"],
            "properties" => {
              "first_name" => {"type" => "string"},
              "last_name" => {"type" => "string"},
              "phone_number" => {"type" => "string"},
              "college_id" => {"type" => "integer"},
              "exam_id" => {"type" => "integer"},
              "start_time" => {"type" => "date-time"}
            }
          }
          
         JSON::Validator.validate(schema, json)
    end

end