class MessagesController < ApplicationController
  def index
    @messages = Message.all
    render json: @messages
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      render json: @message, status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:customer_id, :content, :message_template_id, :bypass_check)
  end
end
