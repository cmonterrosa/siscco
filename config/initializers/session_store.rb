# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_siscco_session',
  :secret      => 'e9d4fa4e62a6140a37add4bfb895d48977edd6effab24abd072b4ba45c91a588d1f934de32b629d3ee9eeb70c5ae51cdc323d3ec219b776ff3f51dc1f29c59ab'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
