class PopupController < ApplicationController

    def signin
        render template: '/devise/sessions/_form_signin', layout: !request.xhr?
    end

    def signup
        render template: '/devise/registrations/_form_signup', layout: !request.xhr?
    end

    def forgot
        render template: '/devise/passwords/_forgot', layout: !request.xhr?
    end


    def devise_mapping
      Devise.mappings[:user]
    end

    def resource
        @resource ||= User.new
    end

    def resource_name
      devise_mapping.name
    end

    def resource_class
      devise_mapping.to
    end

    helper_method :resource, :devise_mapping, :resource_name, :resource_class

end
