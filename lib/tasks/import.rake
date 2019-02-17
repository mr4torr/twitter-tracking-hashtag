namespace :import do
    desc "Import tweets"
    task twitter: :environment do

        Tag.unscoped.all.order('updated_at ASC').each do |tag|
            TweetsAction.update!(tag.name)
        end
    end
  end
