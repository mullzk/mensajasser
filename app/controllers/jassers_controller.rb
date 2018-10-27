class JassersController < ApplicationController
  before_action :set_jasser, only: [:show, :edit, :update, :destroy]

  # GET /jassers
  def index
    @jassers = Jasser.all
  end

  # GET /jassers/1
  def show
  end

  # GET /jassers/new
  def new
    @jasser = Jasser.new
  end

  # GET /jassers/1/edit
  def edit
  end

  # POST /jassers
  def create
    @jasser = Jasser.new(jasser_params)

    if @jasser.save
      redirect_to @jasser, notice: 'Jasser was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /jassers/1
  def update
    if @jasser.update(jasser_params)
      redirect_to @jasser, notice: 'Jasser was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /jassers/1
  def destroy
    @jasser.destroy
    redirect_to jassers_url, notice: 'Jasser was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jasser
      @jasser = Jasser.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def jasser_params
      params.fetch(:jasser, {})
    end
end
