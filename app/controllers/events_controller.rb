class EventsController < ApplicationController
	def index
		@events = Event.all
	end

	def show
		@event = find_event
		@guests = @event.guests
	end

	def new
		@event = Event.new
	end

	def create
		@event = Event.new(event_params)

		@event.save
		redirect_to events_path
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
		params.require(:event).permit(:name, :description, :floor, :room, :date, :time, :address)
	end

	def find_event
		Event.find(params[:id])
	end
end
