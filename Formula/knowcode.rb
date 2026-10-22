class Knowcode < Formula
  desc "A lightweight, local code graph for coding agents."
  homepage "https://github.com/bubstackdev/knowcode"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bubstackdev/knowcode/releases/download/v0.2.0/knowcode-aarch64-apple-darwin.tar.gz"
    sha256 "253aa071fc0200618600b18c50cd56cb1e9c40b41bd287707e21fa0e47f15d3a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bubstackdev/knowcode/releases/download/v0.2.0/knowcode-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f4ce7f7a4f540af97e76679fc0afcff050b4e20f125fc41125bff66d3d686c73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bubstackdev/knowcode/releases/download/v0.2.0/knowcode-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "27c5b67b8115fb90b5b34edda5fe214e1f278e0247b840252fc6c019f8215a9a"
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
