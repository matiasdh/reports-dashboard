Grover.configure do |config|
  options = {
    format: "Letter",
    margin: {
      top: "1cm",
      right: "1cm",
      bottom: "1cm",
      left: "1cm"
    },
    emulate_media: "print",
    wait_until: "networkidle0"
  }
  # Use remote Chrome in Docker when GROVER_CHROME_WS_URL is set
  # Local dev: ws://localhost:3000 (docker-compose chrome service)
  # Production: ws://chrome:3000 (when app and chrome share a network)
  if (ws_url = ENV["GROVER_CHROME_WS_URL"]).present?
    options[:browser_ws_endpoint] = ws_url
  end
  config.options = options
end
