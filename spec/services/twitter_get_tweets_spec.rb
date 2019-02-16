require 'rails_helper'

describe 'Service Twitter' do
    context 'search tweets' do
        it 'check values configuration' do
            expect(Rails.application.secrets.twitter).to_not eq(nil)
        end

        it 'response without params ou invalid' do

            tweets = TwitterService.import!([])
            expect(tweets.length).to eq(0)

            tweets = TwitterService.import!(["#coffee"])
            expect(tweets.length).to eq(0)
        end

        it 'response without value' do
            hastag = "#magratealabs-test-#{rand(0..1000)}"
            tweets = TwitterService.import!(hastag)

            expect(tweets.length).to eq(0)
        end

        it 'response with hashtag' do
            tweets = TwitterService.import!("#coffee")
            expect(tweets).to be_truthy
        end

        it 'response with value' do
            tweets = TwitterService.import!("coffee")
            expect(tweets).to be_truthy
        end
    end
end
