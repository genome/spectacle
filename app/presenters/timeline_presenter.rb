class TimelinePresenter
  def initialize(timeline_events)
    @events = grouped_events(timeline_events.map { |e| EventPresenter.new(e) })
  end

  def each_day
    @events.each do |date, events|
      yield date.strftime('%b'), date.strftime('%0d'), events
    end
  end

  private
  def grouped_events(timeline_events)
    events_by_date = timeline_events.group_by { |e| e.updated_at.to_date }
    {}.tap do |events_by_date_and_type|
      events_by_date.each do |date, events|
        events_by_date_and_type[date] = events.group_by(&:name)
      end
    end
  end
end

class EventPresenter < SimpleDelegator
  def initialize(event)
    @event = event
    super(event)
  end

  def name
    @name ||= @event.name.titleize
  end

  def reason
    @event.reason
  end

  def timestamp
    @timestamp ||= @event.updated_at
      .strftime('%I:%M%P')
  end
end
