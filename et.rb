class Et < Formula
  desc "Remote terminal with IP roaming"
  homepage "https://mistertea.github.io/EternalTCP/"
  url "https://github.com/MisterTea/EternalTCP/archive/et-v4.0.3.tar.gz"
  version "4.0.3"
  sha256 "b5906d8dbc1e9624d130b8c4c9a2134f6c66c7c070f0b929b4be8bf388c8b786"

  depends_on "cmake" => :build

  depends_on "protobuf"
  depends_on "libsodium"
  depends_on "glog"
  depends_on "gflags"
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    etc.install 'launcher/et' => 'et.cfg' unless File.exists? etc+'et.cfg'
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/etserver</string>
        <string>--cfgfile</string>
        <string>#{etc}/et.cfg</string>
        <string>--daemon</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>/tmp/et_err</string>
      <key>StandardOutPath</key>
      <string>/tmp/et_err</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/et", "--help"
  end
end
