require "spec_helper"
require "rest_client"
require "./lib/gitsearch/external_service/rest_client_dispatcher"

RSpec.describe ExternalService::RestClientDispatcher, "#dispatch" do
  it "retries 5 times when an external service replies with a 400" do
    client = double
    allow(client).to receive(:get).with(any_args).and_raise(RestClient::BadRequest).exactly(5).times

    dispatcher = ExternalService::GithubDispatcher.new(sleep_time_seconds: 0.001, client: client)
    expect{ dispatcher.dispatch(:get, "valid_path") }.to raise_error(ExternalService::BadRequest)
  end
end
