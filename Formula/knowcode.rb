class Knowcode < Formula
  desc "A lightweight, local code graph for coding agents."
  homepage "https://github.com/bubstackdev/knowcode"
  version "0.4.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bubstackdev/knowcode/releases/download/v0.4.1/knowcode-aarch64-apple-darwin.tar.gz"
    sha256 "2220407ffbb23fa2dd52bc493b8c59eaacc8940f984c749a5ff7d1ff228c367a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bubstackdev/knowcode/releases/download/v0.4.1/knowcode-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "63e190bdc571ee8092cd7b4e0cb931c6fe8cc9f90a896f21633f051de50b2dcf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bubstackdev/knowcode/releases/download/v0.4.1/knowcode-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "547aba8e7e418750a22c63c980d9cca274e534812703626bcc225fca061fd1c1"
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
