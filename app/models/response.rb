# == Schema Information
#
# Table name: responses
#
#  id         :integer          not null, primary key
#  answer_id  :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Response < ActiveRecord::Base
  validates :answer_id, :user_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_cant_answer_own_poll

  belongs_to(
    :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_id,
    primary_key: :id
  )
  belongs_to(
    :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )
  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )


  def sibling_responses
    self.question.responses.where(
      "? IS NULL OR responses.id != ?", self.id, self.id
    )
  end

  def respondent_has_not_already_answered_question
    if self.sibling_responses.exists?(user_id: self.user_id)
      errors[:responses] << "Already answered"
    end
  end

  def author_cant_answer_own_poll
    if self.question.poll.author_id == self.user_id
      errors[:own_author] << "Author can't answer own poll!"
    end
  end

end
