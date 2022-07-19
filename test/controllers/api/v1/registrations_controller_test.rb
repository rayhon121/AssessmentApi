require "test_helper"

class Api::V1::RegistrationsControllerTest < ActionDispatch::IntegrationTest

  test "Create: 400 when request JSON is not valid" do
    post "/api/v1/registrations",
      params: { test: { title: "test", body: "test" } },
      as: :json

      assert_response 400
      assert_match "did not contain a required property", @response.body
  end

  test "Create: 400 when phone number is not in correct format" do
    user = users(:one)
    exam = exams(:one)
    college = colleges(:one)
    examWindow = exam_windows(:one)
    post "/api/v1/registrations",
      params: { 
        first_name: user.first_name, 
        last_name: user.last_name, 
        phone_number: "14245150105501051015", 
        college_id: college.id, 
        exam_id: exam.id, 
        start_time: examWindow.start },
      as: :json

    assert_response 400
    assert_match "must be a phone number (########## or ###-###-####)", @response.body
  end

  test "Create: 400 when college ID doesn't exist" do
    user = users(:one)
    exam = exams(:one)
    examWindow = exam_windows(:one)
    post "/api/v1/registrations",
      params: { 
        first_name: user.first_name, 
        last_name: user.last_name, 
        phone_number: user.phone_number, 
        college_id: 100, 
        exam_id: exam.id, 
        start_time: examWindow.start },
      as: :json

    assert_response 400
    assert_match "College with specified ID does not exist", @response.body
  end

  test "Create: 400 when given exam ID is not linked to given college ID" do
    user = users(:one)
    exam = exams(:one)
    college = colleges(:two)
    examWindow = exam_windows(:one)
    post "/api/v1/registrations",
      params: { 
        first_name: user.first_name, 
        last_name: user.last_name, 
        phone_number: user.phone_number, 
        college_id: college.id, 
        exam_id: exam.id, 
        start_time: examWindow.start },
      as: :json

    assert_response 400
    assert_match "Exam for the specified college does not exist", @response.body
  end

  test "Create: 400 when start time doesn't fall within the given exam's time window" do
    user = users(:one)
    exam = exams(:one)
    college = colleges(:one)
    post "/api/v1/registrations",
      params: { 
        first_name: user.first_name, 
        last_name: user.last_name, 
        phone_number: user.phone_number, 
        college_id: college.id, 
        exam_id: exam.id, 
        start_time: "2022-07-18 15:24:28" },
      as: :json

    assert_response 400
    assert_match "Start time is not within any valid exam window", @response.body
  end

  test "Create: 200 when non-existent user is created and registered" do
    exam = exams(:one)
    college = colleges(:one)
    examWindow = exam_windows(:one)
    post "/api/v1/registrations",
      params: { 
        first_name: "BrandNew", 
        last_name: "User", 
        phone_number: "0000000000", 
        college_id: college.id, 
        exam_id: exam.id, 
        start_time: examWindow.start },
      as: :json

    assert_response 200
  end

  test "Create: 200 when existing user is created and registered" do
    user = users(:one)
    exam = exams(:one)
    college = colleges(:one)
    examWindow = exam_windows(:one)
    post "/api/v1/registrations",
      params: { 
        first_name: user.first_name, 
        last_name: user.last_name, 
        phone_number: user.phone_number, 
        college_id: college.id, 
        exam_id: exam.id, 
        start_time: examWindow.start },
      as: :json

    assert_response 200
  end
end
