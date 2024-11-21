class ApplicationController < ActionController::Base
    def suggestions
        query = params[:query]
        results = MyModel.where('name LIKE ?', "%#{query}%").pluck(:name)
        render json: results
      end
end
