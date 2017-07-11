class Model1sController < ApplicationController
  before_action :set_model1, only: [:show, :edit, :update, :destroy]

  # GET /model1s
  # GET /model1s.json
  def index
    @model1s = Model1.all
  end

  # GET /model1s/1
  # GET /model1s/1.json
  def show
  end

  # GET /model1s/new
  def new
    @model1 = Model1.new
  end

  # GET /model1s/1/edit
  def edit
  end

  # POST /model1s
  # POST /model1s.json
  def create
    @model1 = Model1.new(model1_params)

    respond_to do |format|
      if @model1.save
        format.html { redirect_to @model1, notice: 'Model1 was successfully created.' }
        format.json { render :show, status: :created, location: @model1 }
      else
        format.html { render :new }
        format.json { render json: @model1.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /model1s/1
  # PATCH/PUT /model1s/1.json
  def update
    respond_to do |format|
      if @model1.update(model1_params)
        format.html { redirect_to @model1, notice: 'Model1 was successfully updated.' }
        format.json { render :show, status: :ok, location: @model1 }
      else
        format.html { render :edit }
        format.json { render json: @model1.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /model1s/1
  # DELETE /model1s/1.json
  def destroy
    @model1.destroy
    respond_to do |format|
      format.html { redirect_to model1s_url, notice: 'Model1 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model1
      @model1 = Model1.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model1_params
      params.require(:model1).permit(:field1, :field2)
    end
end
