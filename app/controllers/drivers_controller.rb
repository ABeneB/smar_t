class DriversController < ApplicationController
  before_action :set_driver, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if (current_user.is_admin? || current_user.is_planer?) && !current_user.company.nil?
      company = current_user.company
      @drivers = company.drivers
    else
      @drivers = []
    end
  end

  def show
    if current_user
      if current_user.is_admin?
        @driver
      elsif current_user.is_planer?
        if @driver.user.company_id == current_user.company_id
          @driver
        end
      end
    end
  end

  def new
    if current_user
      if current_user.is_admin? || current_user.is_planer?
        @driver = Driver.new
      end
    end
  end

  def edit
    # FIXME
  end

  def create
    @driver = Driver.new(driver_params)
    @driver.user_id = current_user.id # automatisches setzen der user_id
    @driver.save
    if @driver.save
      flash[:success] = t('.success', driver_id: @driver.id)
      redirect_to drivers_path, notice: "saved"
    else
      flash[:alert] = t('.failure')
      render 'new'
    end
  end

  def update
    if @driver.update(driver_params)
      flash[:success] = t('.success', driver_id: @driver.id)
    respond_with(@driver)
    else
      flash[:alert] = t('.failure', driver_id: @driver.id)
    end
  end

  def destroy
    if @driver.destroy
      flash[:success] = t('.success', driver_id: @driver.id)
    respond_with(@driver)
    else
      flash[:alert] = t('.failure', driver_id: @driver.id)
    end
  end

  private
    def set_driver
      @driver = Driver.find(params[:id])
    end

    def driver_params
      params.require(:driver).permit(:user_id, :name, :work_start_time, :work_end_time, :activ, :working_time)
    end
end
