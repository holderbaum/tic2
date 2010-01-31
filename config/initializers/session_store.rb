# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tic2_session',
  :secret      => '5cdc7d8c3d87b55b6d6f3e4f8d71f367d6a84f7459bf90bf060c1e2a42918608c489796bfc1c0d7bbfe457338755cbbd85bb3056408244dad2638187297b0504'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
