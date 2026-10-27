class Knowcode < Formula
  desc "A lightweight, local code graph for coding agents."
  homepage "https://github.com/bubstackdev/knowcode"
  version "0.5.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bubstackdev/knowcode/releases/download/v0.5.0/knowcode-aarch64-apple-darwin.tar.gz"
    sha256 "48ee68f72b4e87bfef0889c57a66223a2e4a56a75d7959dafc7e739d76b54a0f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bubstackdev/knowcode/releases/download/v0.5.0/knowcode-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4d7f7d69e59c2b5ba8a1871fccf085b857652679f619174a8b3f4ee5f4d43e8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bubstackdev/knowcode/releases/download/v0.5.0/knowcode-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e5eca0da4d7a340332165661aae6e66ceb588d1c86f3a740ee1e7b094018862"
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
