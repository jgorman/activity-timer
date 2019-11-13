class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @page_title = 'Clients'
    @clients = current_user.clients
  end

  def show
    @page_title = 'Client'
  end

  def new
    @page_title = 'New Client'
    @client = Client.new
  end

  def edit
    @page_title = 'Edit Client'
  end

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
