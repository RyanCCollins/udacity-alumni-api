module TagMutations
  Create = GraphQL::Relay::Mutation.define do
    name 'CreateTag'
    input_field :tag, TagInputType
    input_field :auth_token, !types.String

    return_field :tags, types[TagType]

    resolve -> (_obj, inputs, _ctx) do
      auth_token = inputs[:auth_token]
      user = User.get_user_from_token(auth_token)
      Tag.create(
        tag: inputs[:tag].tag,
        user: user
      )
      tags = Tag.all
      tags
    end
  end
  SaveAll = GraphQL::Relay::Mutation.define do
    name 'SaveAll'
    input_field :tags, types[TagInputType]
    input_field :auth_token, !types.String
    return_field :tags, types[TagType]

    resolve -> (_obj, inputs, _ctx) do
      tags = inputs[:tags].to_a
      auth_token = inputs[:auth_token]
      user = User.get_user_from_token(auth_token)
      tags.each do |tag|
        Tag.find_or_create_by(tag: tag.tag, user: user)
      end
      Tag.all
    end
  end
end
