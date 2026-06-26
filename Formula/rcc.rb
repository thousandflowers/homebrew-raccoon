class Rcc < Formula
  desc "macOS companion toolkit for power users"
  homepage "https://github.com/thousandflowers/Raccoon"
  url "https://github.com/thousandflowers/Raccoon/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "9d84d009f8fe3626428c5f11ed25536efa3fccfc43587b46da9691eb95894b81"
  license "MIT"
  head "https://github.com/thousandflowers/Raccoon.git", branch: "main"

  depends_on "go" => :build

  def install
    libexec.install "rcc", "lib", "bin", "ui", "completions", "man"

    # Stamp the installed version so `rcc --version` always reports the tag
    # this formula was built from — no static version baked into the source.
    (libexec/"VERSION").write version.to_s

    inreplace libexec/"rcc",
      /^SCRIPT_DIR=.*$/,
      "SCRIPT_DIR=\"#{libexec}\""

    # bin/rcc-ui is a stale binary committed in the repo; remove it so
    # `go build` can write a fresh universal binary without colliding.
    rm_f libexec/"bin/rcc-ui"
    cd libexec/"ui" do
      system "go", "build", "-o", libexec/"bin/rcc-ui", "."
    end

    bin.install_symlink libexec/"rcc"
    (libexec/"ui").rmtree
    man1.install_symlink libexec/"man/man1/rcc.1"
    bash_completion.install libexec/"completions/bash/rcc"
    zsh_completion.install libexec/"completions/zsh/_rcc"
  end

  def caveats
    <<~EOS
      To enable shell completions, add to your profile:

        # Bash
        source #{etc}/bash_completion.d/rcc

        # Zsh
        fpath+=#{HOMEBREW_PREFIX}/share/zsh/site-functions
        compinit

      Run "rcc" for the interactive menu, or "rcc <command>" for direct CLI.
    EOS
  end

  test do
    assert_match "Raccoon version", shell_output("#{bin}/rcc --version")
  end
end
