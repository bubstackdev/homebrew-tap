class Knowcode < Formula
  desc "A lightweight, local code graph for coding agents."
  homepage "https://github.com/bubstackdev/know-code"
  version "0.7.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bubstackdev/know-code/releases/download/v0.7.0/knowcode-aarch64-apple-darwin.tar.gz"
    sha256 "5c38c5676d66752d6c7fbd85804a321fba8f95f51bcaf551eec3a5de7f514ded"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bubstackdev/know-code/releases/download/v0.7.0/knowcode-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "57d5f21d1d0fec5c6eabed994ea6983cce2a6d23b0660676cdeac102a53c2be0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bubstackdev/know-code/releases/download/v0.7.0/knowcode-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9b8067fdce1dd6171baf8978deac8b2dba74df81a7746ef7ba1625c715b6775e"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "knowcode"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "knowcode"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "knowcode"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
