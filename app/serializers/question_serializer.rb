class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :path, :created_at, :view_count

  has_many :answers

  include Rails.application.routes.url_helpers

  def path
    api_v1_questions_path(object)
  end

  def created_at
    object.created_at.strftime("%Y-%B-%d")
  end

end
