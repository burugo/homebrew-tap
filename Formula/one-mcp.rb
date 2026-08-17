class OneMcp < Formula
  desc "Centralized proxy for Model Context Protocol (MCP) services"
  homepage "https://github.com/burugo/one-mcp"
  version "1.0.12"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-arm64"
      sha256 "5180dbfe2c6c3f48df17e38428d66b4b887db6243a422d8b62f5b5d8c470ad7d"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-darwin-amd64"
      sha256 "788081edd3a8433d31ae575c73ed26cd586ac7992a524a5084421bfb244d8e3a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-arm64"
      sha256 "d17d967db1e3203b560b2c220f4241bdcce99d10a01a5d6b541b9f26d44a7f6f"
    else
      url "https://github.com/burugo/one-mcp/releases/download/v#{version}/one-mcp-v#{version}-linux-amd64"
      sha256 "549f25b85a99178445f711231d361442e390392b8ea3918891cbd6d35ee72936"
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
