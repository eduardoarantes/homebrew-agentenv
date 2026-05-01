class Agentenv < Formula
  desc "Project-scoped AI agent and plugin environment manager"
  homepage "https://github.com/eduardoarantes/agentenv"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.1.2/agentenv-aarch64-apple-darwin.tar.xz"
      sha256 "7f46b04f5dd830245649a4eab5088740f9e6d82da4f936f115e1ba729245c382"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.1.2/agentenv-x86_64-apple-darwin.tar.xz"
      sha256 "2dfc978baa6e428470fe187845632665e9cf0b401bc24c2a143a6849283981e3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.1.2/agentenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b77f80122832f4dd286c1e9b59fab73e18993ccd328b2a9f8c83ddaf763d5f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.1.2/agentenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c64de869167cb84ef270bb5ab9c2149910a78d5a18d8531bd37e15d399aa010d"
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
