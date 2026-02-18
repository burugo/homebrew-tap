class OneMcp < Formula
  desc "Centralized proxy for Model Context Protocol (MCP) services"
  homepage "https://github.com/burugo/one-mcp"
  version "1.0.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-arm64"
      sha256 "9a322c3837c1b43ef1ab3c00c0907f9fccea64643a00614c40db453684c83464"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-amd64"
      sha256 "40b0e275b594ffe187450c07fdc26b972a8636b20930f09d96b8187c127508a7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-arm64"
      sha256 "35e21adc95625997ecd7bf6d6cf756ee3bc0eadc046f451d9260e23ab47e542a"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-amd64"
      sha256 "0f01cc6a82f3d4def482644869a785dfea95d768aaa38d4d08b02f473ed6a539"
    end
  end

  def install
    bin.install Dir["one-mcp-*"][0] => "one-mcp"
  end

  def one_mcp_data_dir
    if OS.mac?
      Pathname.new("#{Dir.home}/Library/Application Support/one-mcp")
    else
      Pathname.new("#{Dir.home}/.local/share/one-mcp")
    end
  end

  def one_mcp_port
    ENV.fetch("ONE_MCP_PORT", "3000")
  end

  def post_install
    one_mcp_data_dir.mkpath
  end

  service do
    data_dir = one_mcp_data_dir.to_s
    port = one_mcp_port

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
