module FeedbackMutations
  Create = GraphQL::Relay::Mutation.define do
    name 'CreateFeedback'
    description 'User submitted feedback for the site'
    input_field :feedback, FeedbackInputType
    input_field :auth_token, !types.String
    return_field :feedback, FeedbackType

    resolve -> (inputs, ctx) do
      @user = User.find_by(auth_token: inputs[:auth_token])
      feedback = Feedback.create(
        description: inputs[:feedback][:description],
        url: inputs[:feedback][:url]
      )
      @user.feedback << feedback
      @user.save!
      {
        feedback: feedback
      }
    end
  end
end
