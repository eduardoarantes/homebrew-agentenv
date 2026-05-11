class Agentenv < Formula
  desc "Project-scoped AI agent and plugin environment manager"
  homepage "https://github.com/eduardoarantes/agentenv"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.3.0/agentenv-aarch64-apple-darwin.tar.xz"
      sha256 "90d87adc9dbeb4a4da7bef5f8c13d98b2ba7bde44d7da07c089cd75cdfc23548"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.3.0/agentenv-x86_64-apple-darwin.tar.xz"
      sha256 "5297d3e280a60ab4cd3d18325936f6d5d434c1b2a4409d524a6ac2df0c16884a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.3.0/agentenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "27014e6962f67ec49ca7cd94b7dbc107cb067ec4419b3cd7edccf4b2a4191ff8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.3.0/agentenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "507b3c174daaa83ab9faf9a1ea23b81280bc5e228e7bbd9a10a4386785808045"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "agentenv" if OS.mac? && Hardware::CPU.arm?
    bin.install "agentenv" if OS.mac? && Hardware::CPU.intel?
    bin.install "agentenv" if OS.linux? && Hardware::CPU.arm?
    bin.install "agentenv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
