namespace :wasm do
  desc "Upload WebAssembly files to S3"
  task upload: :environment do
    Wasm::UploadWasmJob.perform_now
  end

  desc "Clobber WebAssembly files for current version in S3"
  task clobber: :environment do
    Wasm::ClobberWasmJob.perform_now
  end
end
