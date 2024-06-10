class MessageTemplatesController < ApplicationController
  before_action :set_message_template, only: %i[show update destroy]

  def index
    @message_templates = MessageTemplate.all
    render json: @message_templates
  end

  def show
    render json: @message_template
  end

  def create
    @message_template = MessageTemplate.new(message_template_params)
    if @message_template.save
      render json: @message_template, status: :created
    else
      render json: @message_template.errors, status: :unprocessable_entity
    end
  end

  def update
    if @message_template.update(message_template_params)
      render json: @message_template
    else
      render json: @message_template.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @message_template.destroy
    head :no_content
  end

  private

  def set_message_template
    @message_template = MessageTemplate.find(params[:id])
  end

  def message_template_params
    params.require(:message_template).permit(:name, :content, :content_en)
  end
end
