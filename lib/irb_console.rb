begin
  # load wirble
  require 'wirble'

  # start wirble (with color)
  Wirble.init(:init_color => true)
rescue LoadError => err
  warn "Couldn't load Wirble: {err}"
end

TrelloJiraBridge.load_config
