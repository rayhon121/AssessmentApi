# Assessment API

## Demo

## Overview
API that allows you to register a student with an exam

### Request Format
```json
POST /api/v1/registrations
{  
  first_name: String, 
  last_name: String, 
  phone_number: String, 
  college_id: Integer, 
  exam_id: Integer, 
  start_time: DateTime 
}  
```

### Response Format
```json
{
    id: Integer
    exam_id: Integer
    user_id: Integer
    start_time: DateTime
}
```

### Validation (Failure returns 400)
- the request data is invalid or not clean 
- a college with the given college_id is not found               
- an exam with the given exam_id is not found or does not belong to the college     
- a user fails to be found or created, or failed to get associated with the exam 
- a requested start_time does not fall with in an exam's time window 

### Success (Status 200
- the request data is valid and sanitized 
- a college exists in the database (college_id)        
- an exam exists and belongs to the college (exam_id)                
- a user is successfully found or created, and assigned to the exam    
- the start_time of the request falls within an Exam's time window     


## Build Instructions



## Assumptions
- Exam can only be linked to a single college
- Exams can have multiple time windows
- First Name, Last Name, and Phone Number are unique for a given user