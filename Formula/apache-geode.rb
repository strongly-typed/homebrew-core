class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=geode/1.5.0/apache-geode-1.5.0.tgz"
  sha256 "397eb6bec1e2c101d96f68b2da1ae166839a632e9506d7daa87e9abad56aa17f"

  bottle :unneeded

  # Geode does not work with Java 1.9 (see https://issues.apache.org/jira/browse/GEODE-3)
  depends_on :java => "1.8"

  def install
    rm_f "bin/gfsh.bat"
    bash_completion.install "bin/gfsh-completion.bash" => "gfsh"
    libexec.install Dir["*"]
    (bin/"gfsh").write_env_script libexec/"bin/gfsh", Language::Java.java_home_env("1.8")
  end

  test do
    begin
      output = shell_output("#{bin}/gfsh start locator --dir #{testpath} --name=geode_locator_brew_test")
      assert_match /Cluster configuration service is up and running/, output
    ensure
      quiet_system "pkill", "-9", "-f", "geode_locator_brew_test"
    end
  end
end
