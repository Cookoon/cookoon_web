module Forest
  class User
    include ForestLiana::Collection

    collection :User

    field :full_name, type: 'String' do
      object.full_name
    end

    field :invited_by_full_name, type: 'String' do
      object.invited_by&.full_name
    end
    #
    # TODO: FC 12jan17 report this as not working to ForestAdmin team
    # belongs_to :invited_by, reference: 'users.id' do
    #   object.invited_by
    # end

    action 'Award invitations', fields: [
      {
        field: 'quantity',
        type: 'Number',
        description: 'The number of invitations you want to award these users',
        isRequired: true,
        defaultValue: 5
      },
      {
        field: 'message',
        type: 'String',
        description: 'The specific message you want to embed in the email',
        widget: 'text area'
      }
    ]

    action 'Change e-mailing preferences', fields: [{
      field: 'emailing_preferences',
      type: 'Enum',
      enums: ['Aucun e-mail', 'Tous les emails']
    }]
  end
end
