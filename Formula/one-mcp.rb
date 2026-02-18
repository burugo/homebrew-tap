class OneMcp < Formula
  desc "Centralized proxy for Model Context Protocol (MCP) services"
  homepage "https://github.com/burugo/one-mcp"
  version "1.0.6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-arm64"
      sha256 "30ba5e22838bb6707164e6861015a58c5569f92f76874ec3dc53dd1aa4d94ce0"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-amd64"
      sha256 "8a2716ec9b04515cdb288a7947b54b20f10a6bfaa3791c63445f22ad4dc89b2f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-arm64"
      sha256 "7532331d76557a99e8863877f835357d5f7505f0cf946eb82e4492f989e6c819"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-amd64"
      sha256 "b568a36906d9dfcccd6544b6c82a1f1bb5166ae1d339523f98292133b7c15847"
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

    run [opt_bin/"one-mcp", "--port", port]
    keep_alive true
    working_dir data_dir
    log_path "#{data_dir}/one-mcp.log"
    error_log_path "#{data_dir}/one-mcp-error.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/one-mcp --version")
  end
end
