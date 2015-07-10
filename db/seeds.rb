# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do
  User.create!(user_name: Faker::Name.name)
end

Poll.create!(title: "1. Presidential Poll", author_id: 1)
Poll.create!(title: "2. Music Poll", author_id: 5)
Poll.create!(title: "3. Senate Poll", author_id: 1)

Question.create!(text: "Who is the President?", poll_id: Poll.first.id)
Question.create!(text: "Who is the Vice President?", poll_id: Poll.first.id)

Question.create!(text: "What's your favorite music genre?", poll_id: 2)

Question.create!(text: "Who is your state Senator?", poll_id: 3)

AnswerChoice.create!(text: "A. Obama", question_id: 1)
AnswerChoice.create!(text: "B. Bush", question_id: 1)
AnswerChoice.create!(text: "A. Michelle", question_id: 2)
AnswerChoice.create!(text: "A. Rock", question_id: 3)
AnswerChoice.create!(text: "B. Pop", question_id: 3)
AnswerChoice.create!(text: "A. Boxer", question_id: 4)

Response.create!(answer_id: 1, user_id: 1)
Response.create!(answer_id: 1, user_id: 6)
Response.create!(answer_id: 1, user_id: 3)
Response.create!(answer_id: 2, user_id: 2)

Response.create!(answer_id: 3, user_id: 2)
