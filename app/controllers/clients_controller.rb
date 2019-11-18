class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @clients = current_user.clients.order(:name)
  end

  def show; end

  def new
    @client = Client.new
    @client.user = current_user
  end

  def edit; end

  def create
    @client = Client.new(client_params)
    @client.user = current_user
    if @client.save
      redirect_to @client
    else
      render 'new'
    end
  end

  def update
    if @client.update(client_params)
      redirect_to @client
    else
      render 'edit'
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name)
  end
end
