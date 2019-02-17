ActiveSupport::Notifications.subscribe 'twitter.import' do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    TweetsAction.update!(event.payload[:name])
end
