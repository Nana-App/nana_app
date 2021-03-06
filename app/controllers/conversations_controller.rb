class ConversationsController < ApplicationController
    #before_action :authenticate_user

    def index
        @users = User.all
        @conversations = policy_scope(Conversation).with_messages
        @conversations = @conversations.all.sort_by { |c| c.messages.last.created_at }.reverse
    end

    def create
        if Conversation.between(params[:user1_id],params[:user2_id])
        .present?
            @conversation = Conversation.between(params[:user1_id],
            params[:user2_id]).first
        else
            @conversation = Conversation.create!(conversation_params)
        end
        authorize @conversation
        redirect_to conversation_messages_path(@conversation)
    end

    private

    def conversation_params
        params.permit(:user1_id, :user2_id)
    end
end
