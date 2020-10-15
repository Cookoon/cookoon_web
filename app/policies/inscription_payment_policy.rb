class InscriptionPaymentPolicy < Struct.new(:user, :inscription_payment)
  def create?
    user.inscription_payment_required == true
  end

  def new?
    create?
  end

  def secret_inscription?
    create?
  end
end
