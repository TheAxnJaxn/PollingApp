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
    # get number of responses for each possible answer choice
    # store the possible answer choice along with count of responses in hash
    # i.e. { "A. Choice 1" => 2, "B. Choice 2" => 0, "C. Choice 3" => 5}

    hash = {}

    # N + 1 database queries version:
    # self.answer_choices.each do |option|
    #   hash[option.text] = option.responses.count
    # end
    # hash

    # SQL version:
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

    # Needs work:
    self.answer_choices
      .select('answer_choices.*, COUNT(responses.answer_id) as response_count')
      .joins(<<-SQL).group('answer_choices.id')
      "LEFT OUTER JOIN responses ON responses.answer_id = answer_choices.id"
      SQL
  end

end
