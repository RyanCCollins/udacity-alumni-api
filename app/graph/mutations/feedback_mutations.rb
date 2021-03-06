module FeedbackMutations
  Create = GraphQL::Relay::Mutation.define do
    name 'CreateFeedback'
    description 'User submitted feedback for the site'
    input_field :feedback, FeedbackInputType
    input_field :auth_token, !types.String
    return_field :feedback, FeedbackType

    resolve -> (_obj, inputs, _ctx) do
      auth_token = inputs[:auth_token]
      @user = User.get_user_from_token(auth_token)
      feedback = Feedback.create(
        description: inputs[:feedback][:description],
        url: inputs[:feedback][:url],
        image: inputs[:feedback][:image].read
      )
      @user.feedback << feedback
      @user.save!
      {
        feedback: feedback
      }
    end
  end
end
