module Admin
  class UsersController < BaseController
    respond_to :html, :json
  
    # GET /users
    def index
      if params[:name] or params[:term]
        term = params[:name] if params[:name].present?
        term ||= params[:term]
        # TODO move query to model
        @users = User.where("first_name LIKE ? or last_name LIKE ? or email LIKE ?", "%#{term}%", "%#{term}%", "%#{term}%")
      else
        @users = User.all
      end

      respond_with(:admin, @users)
    end

    # GET /users/1
    def show
      @user = User.find(params[:id])
      respond_with(:admin, @user)
    end

    # GET /users/new
    def new
      @user = User.new
      @roles = Role.assignable_roles
      respond_with(:admin, @user)
    end

    # GET /users/1/edit
    def edit
      @user = User.find(params[:id])
      @roles = Role.assignable_roles
      respond_with(:admin, @user)
    end

    # POST /users
    def create
      @user = User.invite!(params[:user], @current_user)
      flash[:notice] = "User was successfully invited." if @user.errors.empty?
      respond_with(:admin, @user)
    end

    # PUT /users/1
    def update
      @user = User.find(params[:id])
      flash[:notice] = 'User was successfully updated.' if @user.update_attributes(params[:user])
      respond_with(:admin, @user)
    end

    # DELETE /users/1
    def destroy
      @user = User.find(params[:id])
      @user.destroy
      respond_with(:admin, @user)
    end
  end
end
