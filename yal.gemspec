Gem::Specification.new do |s|
  s.name = 'yal'
  s.version = '0.1.0'
  s.summary = 'Yet Another Logger (YAL), logs debug and info messages using a simple UDPSocket and more.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/yal.rb']
  s.add_runtime_dependency('spspublog_drb_client', '~> 0.1', '>=0.1.1')
  s.signing_key = '../privatekeys/yal.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/yal'
end
