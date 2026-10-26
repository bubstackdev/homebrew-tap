class Knowcode < Formula
  desc "A lightweight, local code graph for coding agents."
  homepage "https://github.com/bubstackdev/knowcode"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bubstackdev/knowcode/releases/download/v0.3.0/knowcode-aarch64-apple-darwin.tar.gz"
    sha256 "1d318e0d908b4f1b019a3e19152ef57907e17181aa918a1b673401eaddba86be"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bubstackdev/knowcode/releases/download/v0.3.0/knowcode-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0991709be6949b2e1677a452c5be587661b6664888521e9d34619566cfd9b08a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bubstackdev/knowcode/releases/download/v0.3.0/knowcode-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f9cca0a6255d7c7bef1fe15e3dd71ab2be6fd24641397b2d675ce83e1ef6b0aa"
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
