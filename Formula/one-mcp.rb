class OneMcp < Formula
  desc "Centralized proxy for Model Context Protocol (MCP) services"
  homepage "https://github.com/burugo/one-mcp"
  version "1.0.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-arm64"
      sha256 "0809c9b80ac0650cc21533920c0c2dab1f7c9dc56b69393b64dbc26c654132ba"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-amd64"
      sha256 "e5cba4d37edf45c980fa7dc32ec12d9d956f4c76cf36cafa9e3b5ccd6e052e70"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-arm64"
      sha256 "dd3537321634602ab57d65e2f040595f9599eb1a2d1e8037f1d289867062ea59"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-amd64"
      sha256 "06268f7d5cc0bb2ad9a8d2b6486d1d63f6c430a905ebc796eecf17e4427fbfc0"
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
