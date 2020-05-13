const changeImageSubmitTag = () => {
  const reservationForm = document.getElementById("new_reservation");
  const reservationSubmitImage = document.getElementById("btn_cookoon_search_submit_img");

  const setImage = (form, action, submitImage, imagePath) => {
    form.addEventListener(action, () => {
      submitImage.setAttribute("src", imagePath)
    })
  }

  const submitForm = (form) => {
    form.addEventListener('click', (event) => {
      console.log(event.currentTarget.submit());
    })
  }

  if (reservationForm && reservationSubmitImage) {
    const imageWhitePath = reservationSubmitImage.dataset.logoWhite;
    const imageBoldPath = reservationSubmitImage.dataset.logoBold;
    setImage(reservationForm, 'mouseover', reservationSubmitImage, imageWhitePath);
    setImage(reservationForm, 'mouseout', reservationSubmitImage, imageBoldPath);
    submitForm(reservationForm);
  } else {
    console.log("No");
  }
}

export { changeImageSubmitTag };
