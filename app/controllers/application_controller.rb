class ApplicationController < ActionController::Base



def after_sign_in_path_for(resource)

  #r#esource.sign_in_count <= 1 ? edit_user_registration_path  : root_url
    #stored_location_for(resource) || edit_user_registration_path

      new_donation_path

  end 
end
