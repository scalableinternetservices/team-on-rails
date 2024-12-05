class ApplicationController < ActionController::Base
    before_action :require_login
    skip_forgery_protection

    private
    
    def require_login
        unless session[:user_id]
            redirect_to login_path 
            return
        end
        @current_user = User.find_by(id: session[:user_id])
    end
    
    def suggestions
        query = params[:query]
        results = MyModel.where('name LIKE ?', "%#{query}%").pluck(:name)
        render json: results
      end
end
