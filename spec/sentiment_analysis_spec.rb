# encoding: UTF-8

require 'spec_helper'

vcr_options = { :cassette_name => "sentiment_analysis", :record => :new_episodes }

describe Dandelionapi::SentimentAnalysis, vcr: vcr_options do

  before(:each) do
    Dandelionapi.configure do |c|
      # account: Mario Rossi <datatxt@mailinator.com>
      c.app_id = "e0bca290"
      c.app_key = "2294c676b8698383764514cc219fad92"
      c.endpoint = "https://api.dandelion.eu/"
      c.path = "datatxt/"
    end
  end
  
  it "initialize a new nex request" do
    request = Dandelionapi::SentimentAnalysis::Request.new
    expect(request).to be_an_instance_of(Dandelionapi::SentimentAnalysis::Request)
  end

  it "make a request to sent using italian plain text" do
    element = Dandelionapi::SentimentAnalysis::Request.new
    response = element.analyze(
      text: "Mio padre che mi spinge a mangiare e guai se non finisco mio padre che vuol farmi guidare mi frena con il fischio"
    )
    expect(response).not_to be_empty
    expect(response["sentiment"]).not_to be_empty
    expect(response["sentiment"]["score"]).to be >= -1.0
    expect(response["sentiment"]["score"]).to be <= 1.0
    expect(["positive", "neutral", "negative"]).to include(response["sentiment"]["type"])
  end

  it "raise BadResponse exception on wrong config parameters" do
    Dandelionapi.configure do |c|
      c.app_id = "bad-app-id"
      c.app_key = "bad-app-key"
      c.endpoint = "not-an-url-endpoint"
    end
    element = Dandelionapi::SentimentAnalysis::Request.new
    expect { element.analyze(text: "test") }.to raise_error(Dandelionapi::BadResponse)
  end

  it "raise MissingParameter exception when required params are missing" do
    element = Dandelionapi::SentimentAnalysis::Request.new
    expect { element.analyze(other: "test") }.to raise_error(Dandelionapi::MissingParameter)
  end
end