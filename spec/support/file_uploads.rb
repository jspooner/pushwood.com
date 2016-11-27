def spec_file_upload(path, mime_type = nil, binary = false)
  fixture_path = Rails.root.join("spec/fixtures/files", path)
  Rack::Test::UploadedFile.new("#{fixture_path}", mime_type, binary)
end
