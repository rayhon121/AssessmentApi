# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user = User.create({first_name: "Bob", last_name: "Smith", phone_number: "4101354123"})
college = College.create({name: "Test University"})
exam = Exam.create({name: "Basic Sciences Week 1 Test", college: college})
examWindow = ExamWindow.create(start: DateTime.strptime("07/19/2022 8:00", "%m/%d/%Y %H:%M"), 
    end: DateTime.strptime("07/19/2022 10:00", "%m/%d/%Y %H:%M"), exam: exam)
