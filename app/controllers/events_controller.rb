class EventsController < ApplicationController
	def index
		@events_hosting = []
		@events_going_to = []
		@all_events = Event.all
		if user_signed_in? && @all_events.nil? == false #check to see if a user is signed in
			@all_events.each do |event|
				@events_hosting << event if current_user.id == event.owner_id
				@events_going_to << event if event.guests.find_by_name(current_user.name) && @events_hosting.include?(event) == false
			end
		end
	end

	def show
		@event = find_event
		@guests = @event.guests
		@image = google_map_image(@event)
		# debugger
	end

	def new
		if user_signed_in?
			@event = Event.new
		else
			redirect_to new_user_session_path
		end
	end

	def create

		@event = Event.new(event_params)

		@event.save
		redirect_to @event
	end

	def destroy
		@event = find_event
		@event.destroy
		redirect_to events_path
	end

	def edit
		@event = Event.find(params[:id])
	end

	def update
		@event = find_event
		@event.update(event_params)		
		redirect_to @event
	end

	private
	def event_params
		params.require(:event).permit(:name, :description, :floor, :room, :date, :time, :address, :owner_id)
	end

	def find_event
		Event.find(params[:id])
	end

	def google_map_image event
		address = event.address
		address = address.tr(" ", "+")
  	return "http://maps.googleapis.com/maps/api/staticmap?center=#{address}+New+York,NY&size=400x400&zoom=13&markers=color:blue%7C#{address}+New+York,NY&sensor=false"
  end

end
