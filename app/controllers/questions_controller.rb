class QuestionsController < ApplicationController

  def new
    @question = Question.new
  end

  def create
    # In the line below we're using the `strong parameters` feature of Rails
    # In the line we're `requiring` that the `params` hash has a key called
    # question and we're only allowing the `title` and `body` by fetched
    question_params = params.require(:question).permit(:title, :body)
    @question        = Question.new question_params
    if @question.save
      # redirect_to question_path({id: @question.id})
      # render :show
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def show
    @question = Question.find params[:id]
    # @question.view_count += 1
    # @question.save
    @question.increment!(:view_count)
  end

  def index
    @questions = Question.order(created_at: :desc)
  end

  def edit
    @question = Question.find params[:id]
  end

  def update
    @question = Question.find params[:id]
    question_params = params.require(:question).permit(:title, :body)
    if @question.update question_params
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy
    @question = Question.find params[:id]
    @question.destroy
    redirect_to questions_path
  end

end
