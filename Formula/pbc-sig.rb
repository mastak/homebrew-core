class PbcSig < Formula
  desc "Signatures library"
  homepage "https://crypto.stanford.edu/pbc/sig/"
  url "https://crypto.stanford.edu/pbc/sig/files/pbc_sig-0.0.8.tar.gz"
  sha256 "7a343bf342e709ea41beb7090c78078a9e57b833454c695f7bcad2475de9c4bb"

  bottle do
    cellar :any
    sha256 "af397bbffe6ae6d891187d74fc0ba821f97484d706a4eb075a8532625cadad74" => :mojave
    sha256 "f6dcb432ad9143a883b5eeefb2bf2efd7cc139cba99cc180a18789294f2c6875" => :high_sierra
    sha256 "be0d7bea5943fcdcfafe6c4526617a8cb7b5b99489fa4fce07d1217a5970a9fe" => :sierra
    sha256 "bef7dfdc8f790b1b1d774e886090b4ddad91ed0781d08e214a55b3656aae9618" => :el_capitan
    sha256 "55e7092f16ec44d2bfcb411466954ec42e8359bed59ed312148f053242e9bbd1" => :yosemite
    sha256 "8559952df67fda6a8ee2a865df439f6ac2380d13491bb874d271a30e94813c75" => :mavericks
    sha256 "b5d63cd6e512d8da34ec218b14fcc50534c34b15a6bc65034cc9dd8f7bc8b528" => :mountain_lion
  end

  depends_on "pbc"

  # https://groups.google.com/forum/#!topic/pbc-devel/ZmFCHZmrhcw
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pbc/pbc.h>
      #include <pbc/pbc_sig.h>

      int main()
      {
        pbc_param_t param;
        pairing_t pairing;
        bls_sys_param_t bls_param;
        pbc_param_init_a_gen(param, 160, 512);
        pairing_init_pbc_param(pairing, param);
        bls_gen_sys_param(bls_param, pairing);
        bls_clear_sys_param(bls_param);
        pairing_clear(pairing);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lpbc", "-lpbc_sig"
    system "./test"
  end
end

__END__
diff --git a/sig/bbs.c b/sig/bbs.c
index ed1b437..8aa8331 100644
--- a/sig/bbs.c
+++ b/sig/bbs.c
@@ -1,4 +1,5 @@
 //see Boneh, Boyen and Shacham, "Short Group Signatures"
+#include <stdint.h>
 #include <pbc/pbc_utils.h>
 #include "pbc_sig.h"
 #include "pbc_hash.h"
