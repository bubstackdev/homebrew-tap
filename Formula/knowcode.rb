class Knowcode < Formula
  desc "A lightweight, local code graph for coding agents."
  homepage "https://github.com/bubstackdev/knowcode"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bubstackdev/knowcode/releases/download/v0.1.1/knowcode-aarch64-apple-darwin.tar.gz"
    sha256 "571dbf60728517ae4c3f4bc5f5809571735adc025c04ba10a7cc949112d7899d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bubstackdev/knowcode/releases/download/v0.1.1/knowcode-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a143c6ce31a45cb51b4ff4bb8d9802d7d5cdd1f1c3703f9df1232b633adafc28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bubstackdev/knowcode/releases/download/v0.1.1/knowcode-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "540b8d89643ec4743ab37d37deee9a15a2a72fd706e7c4d93f7ed03610457086"
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
