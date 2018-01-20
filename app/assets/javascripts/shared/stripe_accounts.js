async function handleForm(event) {
  event.stopPropagation();
  event.preventDefault();

  const result = await stripe.createToken('account', {
    legal_entity: {
      first_name: document.querySelector('.inp-first-name').value,
      last_name: document.querySelector('.inp-last-name').value,
      type: 'individual',
      address: {
        line1: document.querySelector('.inp-street-address1').value,
        city: document.querySelector('.inp-city').value,
        postal_code: document.querySelector('.inp-zip').value
      },
      dob: {
        day: parseInt(document.querySelector('#stripe_dob_3i').value),
        month: parseInt(document.querySelector('#stripe_dob_2i').value),
        year: parseInt(document.querySelector('#stripe_dob_1i').value)
      }
    },
    tos_shown_and_accepted: true
  });

  if (result.token) {
    document.querySelector('#stripe_token').value = result.token.id;
  }

  $myForm.trigger('submit.rails');
}
