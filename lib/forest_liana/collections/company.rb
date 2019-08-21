module Forest
  class Company
    include ForestLiana::Collection

    collection :Company

    action 'Invite User', type: 'single', fields: [{
      field: 'First name',
      type: 'String',
      is_required: true
    }, {
      field: 'Last name',
      type: 'String',
      is_required: true
    }, {
      field: 'Email',
      type: 'String',
      is_required: true
    }]
  end
end
