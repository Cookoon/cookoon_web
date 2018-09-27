module Forest
  class Company
    include ForestLiana::Collection

    collection :Company

    action 'Invite User', type: 'single', fields: [{
      field: 'First name',
      type: 'String',
      isRequired: true
    }, {
      field: 'Last name',
      type: 'String',
      isRequired: true
    }, {
      field: 'Email',
      type: 'String',
      isRequired: true
    }]
  end
end
