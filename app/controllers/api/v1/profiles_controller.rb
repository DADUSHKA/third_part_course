class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :me, current_resource_owner
    render json: current_resource_owner
  end

  def index
    authorize! :index, current_resource_owner
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users
  end
end
