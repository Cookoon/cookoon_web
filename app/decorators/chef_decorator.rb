class ChefDecorator < Draper::Decorator
  # include CloudinaryHelper
  delegate_all

  def picture_url
    # This needs to be replaced by Cloudinary link, and removed once done
    if object == Chef.first
      'https://static.lexpress.fr/medias_11664/w_2048,h_1146,c_crop,x_0,y_0/w_480,h_270,c_fill,g_north/v1509987362/helene-darroze-portrait_5972444.jpg'
    else
      'https://lepetitjournal.com/sites/default/files/styles/main_article/public/2019-03/VegNewsGordonRamsay3.png?itok=97yLf3tv'
    end
  end
end
