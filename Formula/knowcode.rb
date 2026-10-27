class Knowcode < Formula
  desc "A lightweight, local code graph for coding agents."
  homepage "https://github.com/bubstackdev/know-code"
  version "0.5.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bubstackdev/know-code/releases/download/v0.5.1/knowcode-aarch64-apple-darwin.tar.gz"
    sha256 "344c8b3d48f74a365544eaed133ab5e5c6821d56314269fee2d025c4fa997dd5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bubstackdev/know-code/releases/download/v0.5.1/knowcode-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6ca3e66d81db3066575a3676b8f82bdce22b6371ee4b5ecf8c915fdebab3723d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bubstackdev/know-code/releases/download/v0.5.1/knowcode-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c24698e7957e859eb6aa896d0795711643c5fcbbb1a87536cf3cdfb94766d4f4"
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
