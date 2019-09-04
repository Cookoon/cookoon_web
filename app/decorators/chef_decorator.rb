class ChefDecorator < Draper::Decorator
  # include CloudinaryHelper
  delegate_all

  def picture_url
    # CAN SET A RANDOM IMAGE FOR CHEF
    
    # if object.picture_url
    #   object.picture_url
    # else
    #   # random chef image ?
    # end
    object.picture_url
  end
end
