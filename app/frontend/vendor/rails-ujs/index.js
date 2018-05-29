import Rails from 'rails-ujs';
import swal from 'vendor/sweetalert2';

const handleConfirm = function(element) {
  if (!allowAction(this)) {
    Rails.stopEverything(element);
  }
};

const allowAction = element => {
  if (element.getAttribute('data-confirm-swal') === null) {
    return true;
  }

  showConfirmationDialog(element);
  return false;
};

// Display the confirmation dialog
const showConfirmationDialog = element => {
  const message = element.getAttribute('data-confirm-swal');
  const text = element.getAttribute('data-text');

  swal({
    title: message || 'Etes vous sûr ?',
    text: text || '',
    type: 'question',
    showCancelButton: true,
    confirmButtonText: 'Oui',
    cancelButtonText: 'Non',
    reverseButtons: true
  }).then(result => confirmed(element, result));
};

const confirmed = (element, result) => {
  if (result.value) {
    // User clicked confirm button
    element.removeAttribute('data-confirm-swal');
    element.click();
  }
};

Rails.delegate(document, 'a[data-confirm-swal]', 'click', handleConfirm);

export default Rails;
