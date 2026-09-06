class OneMcp < Formula
  desc "Centralized proxy for Model Context Protocol (MCP) services"
  homepage "https://github.com/burugo/one-mcp"
  version "1.0.13"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-arm64"
      sha256 "71ab4f99c38ec61b14b4340066e1ad2a333e26be977ced59fc77dbaa2e6d4394"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-amd64"
      sha256 "fad59bad44fce46a0f4f71709f79dac0835f8968ccc1aeaa93907ac52b89655c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-arm64"
      sha256 "f321dd33e2bfb4cae16944c6183e4b535fc18e454acc7aebebaeb5f5d12decbd"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-amd64"
      sha256 "8eeba8ce296481d07b785d1c0a43677197c7c18bbfd31d49f476d47c2cbb6f4f"
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
