require "json-schema"

class Api::RegistrationRequest
    attr_accessor :isValid, :collegeId, :firstName, :lastName, :phoneNumber, :examId, :start, :errors
    def initialize(parameters)
        parametersJson = parameters.to_json
        @isValid = validate(parametersJson, false)        
        if @isValid
            @firstName = parameters['first_name']
            @lastName = parameters['last_name']
            @phoneNumber = parameters['phone_number']
            @collegeId = parameters['college_id']
            @examId = parameters['exam_id']
            @start = parameters['start_time']
        else
            @errors = validate(parametersJson, true)
        end
    end

    private
    def validate(json, isFullValidation)
        format_proc = -> value {
            raise JSON::Schema::CustomFormatError.new("must be a phone number (########## or ###-###-####)") unless value =~ /^[0-9]{3}-[0-9]{3}-[0-9]{4}$|^[0-9]{10}$/
        }

        JSON::Validator.register_format_validator("phone-number", format_proc)

        schema = {
            "type" => "object",
            "required" => ["first_name", "last_name", "phone_number", "college_id", "exam_id", "start_time"],
            "properties" => {
              "first_name" => {"type" => "string"},
              "last_name" => {"type" => "string"},
              "phone_number" => {"type" => "string", "format" => "phone-number"},
              "college_id" => {"type" => "integer"},
              "exam_id" => {"type" => "integer"},
              "start_time" => {"type" => "date-time"}
            }
          }
          
         if !isFullValidation
            JSON::Validator.validate(schema, json)
         else
            JSON::Validator.fully_validate(schema, json)
         end
    end

end