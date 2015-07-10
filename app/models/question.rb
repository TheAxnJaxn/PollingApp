# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  text       :text             not null
#  poll_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ActiveRecord::Base
  validates :poll_id, :text, presence: true
  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id
  )
  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )

  def results
    hash = {}
    #get number of responses for each possible answer choice
    # self.answer_choices.includes(:responses)
    # self.answer_choices.each do |option|
    #   hash[option.text] = option.responses.count
    # end
    # hash

    self.answer_choices
      .select('answer_choices.*, COUNT(responses.answer_id) as response_count')
      .joins(<<-SQL).group('answer_choices.id')
      "LEFT OUTER JOIN responses ON responses.answer_id = answer_choices.id"
      SQL


    # SELECT
    #   answer_choices.*, COUNT(responses.answer_id)
    # FROM
    #   answer_choices
    # LEFT OUTER JOIN
    #   responses ON responses.answer_id = answer_choices.id
    # HAVING
    #   answer_choices.question_id = ? (self.id)
    # GROUP BY
    #   answer_choices.id
  end

end
