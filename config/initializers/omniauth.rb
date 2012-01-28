Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '39cbcfec2226d687f551', '20227ec0979afa20528bc4b80a0a7f4206e1e801'
end
