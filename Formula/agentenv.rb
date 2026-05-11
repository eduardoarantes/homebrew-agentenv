class Agentenv < Formula
  desc "Project-scoped AI agent and plugin environment manager"
  homepage "https://github.com/eduardoarantes/agentenv"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.3.1/agentenv-aarch64-apple-darwin.tar.xz"
      sha256 "87d6d1aa0bed617046d4d44007430a0bf01956106889ae30f82e523eb16c5f82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.3.1/agentenv-x86_64-apple-darwin.tar.xz"
      sha256 "ab3c31c5ee5227debf4b12e9b27a74adddfb998fa4ffbb24798708277df94b5c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.3.1/agentenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "12924d4aff6716269e6c7c82fd3f2e0600d876a88b4fadd34966f5c660783516"
    end
    if Hardware::CPU.intel?
      url "https://github.com/eduardoarantes/agentenv/releases/download/v0.3.1/agentenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6a5f545245cfc1cb447cc18f8c35d082c4a82a68de6080af2a81f0f2a929df20"
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
