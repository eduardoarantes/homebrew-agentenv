class Agentenv < Formula
  desc "Project-scoped AI agent and plugin environment manager"
  homepage "https://github.com/eduardoarantes/agentenv"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v1.0.0/agentenv-aarch64-apple-darwin.tar.xz"
      sha256 "21b8c1aa2b6920f299ad6cee90b6f93ebb78d996973a9457399b63fb57f6c228"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v1.0.0/agentenv-x86_64-apple-darwin.tar.xz"
      sha256 "cc6be3545a1552791d6e4f30767e001374e5e92a4dfd1559461e34b28fbb86a1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v1.0.0/agentenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f2ef037f98dae53c7d338c7b5eb455b8b907ced29eedfa77140f554ed7e57869"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v1.0.0/agentenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa4f4d45a142a224d66a2b322982743ae6a25f35da907205b1d4b7e41e28a779"
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
