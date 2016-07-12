class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user

  def user
    object.user
  end
end
