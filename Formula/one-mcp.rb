class OneMcp < Formula
  desc "Centralized proxy for Model Context Protocol (MCP) services"
  homepage "https://github.com/burugo/one-mcp"
  version "1.0.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-arm64"
      sha256 "d6bd8208a3a2cfa278f352e0a58d1aef6730b897ad3adb56280fbb8474850a87"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-amd64"
      sha256 "b810bfc78b127a16e5421e6a46172f0d1d6f4c4935b9d7ca07242658a587c515"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-arm64"
      sha256 "9eb2b68427461a85f67d651e15796db0a05b4f9227bce2055aa51bded48ece32"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-amd64"
      sha256 "81b86bdfbb13d1852a4ab6a8ffad8aa23203b2a428eb9381897de3cf613ee8c6"
    end
  end

  def install
    bin.install Dir["one-mcp-*"][0] => "one-mcp"
  end

  def post_install
    data_dir = if RUBY_PLATFORM.include?("darwin")
      Pathname.new("#{Dir.home}/Library/Application Support/one-mcp")
    else
      Pathname.new("#{Dir.home}/.local/share/one-mcp")
    end
    data_dir.mkpath
  end

  service do
    data_dir = if RUBY_PLATFORM.include?("darwin")
      "#{Dir.home}/Library/Application Support/one-mcp"
    else
      "#{Dir.home}/.local/share/one-mcp"
    end
    port = ENV.fetch("ONE_MCP_PORT", "3000")

    path_env = [
      "#{HOMEBREW_PREFIX}/bin",
      "/opt/homebrew/bin",
      "/usr/local/bin",
      "/usr/bin",
      "/bin",
      "/usr/sbin",
      "/sbin",
      "#{Dir.home}/.local/bin",
      "#{Dir.home}/.cargo/bin"
    ].uniq.join(":")

    run [opt_bin/"one-mcp", "--port", port]
    keep_alive true
    working_dir data_dir
    environment_variables PATH: path_env
    log_path "#{data_dir}/one-mcp.log"
    error_log_path "#{data_dir}/one-mcp-error.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/one-mcp --version")
  end
end
