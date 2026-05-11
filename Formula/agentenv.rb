class Agentenv < Formula
  desc "Project-scoped AI agent and plugin environment manager"
  homepage "https://github.com/eduardoarantes/agentenv"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.2.0/agentenv-aarch64-apple-darwin.tar.xz"
      sha256 "8b0bcc7d11ff9d4f34a1dbb189f8579d79f27387d40a9d8d000f16b357343d6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.2.0/agentenv-x86_64-apple-darwin.tar.xz"
      sha256 "02ce6357e6e70183b335167f0b6c165b6e6ea30d6c7bcbb41cea3a189ec6299b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.2.0/agentenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e3de07be08794dc574174684be510ae3deacfc377e1cb720a53ece8e9c5672c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.2.0/agentenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b7d841d5bf66c3cdb5a8b3ecc559e364948f3db0b763d7a538339eff6907c50"
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
