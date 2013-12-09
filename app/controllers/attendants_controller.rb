class AttendantsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :authenticate_api_call_from_token!, only: "by_event", :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :authenticate_user!, except: "by_event"

  # GET /attendants
  # GET /attendants.json
  def index
    @attendants = Attendant.where("user_id = ?", current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attendants }
    end
  end

  def by_event
    session[:event_permalink] = params[:event_permalink]

    @attendants = Attendant.where("permalink = ?", session[:event_permalink])
    respond_to do |format|
      format.html { render action: :index }
      format.json { render json: @attendants }
    end
  end

  # GET /attendants/1
  # GET /attendants/1.json
  def show
    @attendant = Attendant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attendant }
    end
  end

  # GET /attendants/new
  # GET /attendants/new.json
  def new
    @attendant = Attendant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attendant }
    end
  end

  # GET /attendants/1/edit
  def edit
    @attendant = Attendant.find(params[:id])
  end

  # POST /attendants
  # POST /attendants.json
  def create
    @attendant = Attendant.new(params[:attendant])
    @attendant.permalink = session[:event_permalink]
    @attendant.user = current_user
    respond_to do |format|
      if @attendant.save
        format.html { redirect_to by_event_attendants_path(session[:event_permalink]), notice: 'Attendant was successfully created.' }
        format.json { render json: @attendant, status: :created, location: @attendant }
      else
        format.html { render action: "new" }
        format.json { render json: @attendant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attendants/1
  # PUT /attendants/1.json
  def update
    @attendant = Attendant.find(params[:id])

    respond_to do |format|
      if @attendant.update_attributes(params[:attendant])
        format.html { redirect_to by_event_attendants_path(session[:event_permalink]), notice: 'Attendant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @attendant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendants/1
  # DELETE /attendants/1.json
  def destroy
    @attendant = Attendant.find(params[:id])
    @attendant.destroy

    respond_to do |format|
      format.html { redirect_to attendants_url }
      format.json { head :no_content }
    end
  end
end
