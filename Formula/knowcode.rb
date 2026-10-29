class Knowcode < Formula
  desc "A lightweight, local code graph for coding agents."
  homepage "https://github.com/bubstackdev/know-code"
  version "0.6.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bubstackdev/know-code/releases/download/v0.6.1/knowcode-aarch64-apple-darwin.tar.gz"
    sha256 "b5420f43062adc20186aac6f790124c57dd118a552f8d9fcf828395e667aa07c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bubstackdev/know-code/releases/download/v0.6.1/knowcode-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "76f4fab9d070118e4206a96d5af43475f07bdbdcc853730742556d37588e9e8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bubstackdev/know-code/releases/download/v0.6.1/knowcode-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "618ffd1da40013989f82435879102e75368415d3a0dda3730e000fdd37099a63"
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
