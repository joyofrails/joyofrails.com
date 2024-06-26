require "rails_helper"

RSpec.describe Wasm::ClobberWasmJob, type: :job do
  let(:cloud_api) { instance_double(CloudStorage::Api) }

  before do
    allow(CloudStorage::Api).to receive(:new).with("rails-wasm").and_return(cloud_api)
    allow(cloud_api).to receive(:delete_all)
  end

  it "deletes wasm files in s3 for current environment and version" do
    Wasm::ClobberWasmJob.perform_now

    expect(Wasm.app_version.split(".").size).to be >= 3
    expect(cloud_api).to have_received(:delete_all).with("joyofrails/test/#{Wasm.app_version}")
  end
end
