class Rcc < Formula
  desc "macOS companion toolkit for power users"
  homepage "https://github.com/thousandflowers/Raccoon"
  url "https://github.com/thousandflowers/Raccoon/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "209affaa11b628c7b04e8d63eafb40347c92ccf6ef5191b01b716d7af46f33e7"
  license "MIT"
  head "https://github.com/thousandflowers/Raccoon.git", branch: "main"

  depends_on "go" => :build

  def install
    libexec.install "rcc", "lib", "bin", "ui", "completions", "man"

    # Point SCRIPT_DIR to libexec — avoids readlink -f compat issues
    inreplace libexec/"rcc",
      /^SCRIPT_DIR=.*$/,
      "SCRIPT_DIR=\"#{libexec}\""

    # Build Go TUI
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

      Run `rcc` for the interactive menu, or `rcc <command>` for direct CLI.
    EOS
  end

  test do
    assert_match "Raccoon version", shell_output("#{bin}/rcc --version")
  end
end
