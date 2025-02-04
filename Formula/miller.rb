class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.5.0/mlr-5.5.0.tar.gz"
  sha256 "0db9329f9e7c1a65f834dc357cd459ea991c32d60633e9d97db188b11daef31a"

  bottle do
    cellar :any_skip_relocation
    sha256 "4408cd3525cb889d6155bccc924d13d4200e740eb96b690774f9e4ac39320bc3" => :mojave
    sha256 "60c3a2b069fa775ce738157a3a5eb03876c9be3fb30c43d3185368b2d409aa32" => :high_sierra
    sha256 "513f825d76b80ebe88e5fca356adfa300dd0404621d3a6f80acad4a0f37dbe15" => :sierra
    sha256 "aa5b71e92cfa956f128b1c5e44d045e60a24c5dd575520e0078f09ea12b98278" => :x86_64_linux
  end

  head do
    url "https://github.com/johnkerl/miller.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "flex" => :build unless OS.mac?

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
    # Time zone related tests fail. Reported upstream https://github.com/johnkerl/miller/issues/237
    system "make", "check" unless OS.linux? && ENV["CI"]
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match /a\n1\n4\n/, output
  end
end
