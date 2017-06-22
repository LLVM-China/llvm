; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1

; If we have SSE/AVX intrinsics in the code, we miss obvious combines
; unless we do them late on X86-specific nodes.

declare <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32>, <4 x i32>)

define <4 x i32> @PR27924_cmpeq(<4 x i32> %a, <4 x i32> %b) {
; SSE-LABEL: PR27924_cmpeq:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: PR27924_cmpeq:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cmp = icmp sgt <4 x i32> %a, %b
  %max = select <4 x i1> %cmp, <4 x i32> %a, <4 x i32> %b
  %sse_max = tail call <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32> %a, <4 x i32> %b)
  %truth = icmp eq <4 x i32> %max, %sse_max
  %ret = sext <4 x i1> %truth to <4 x i32>
  ret <4 x i32> %ret
}

define <4 x i32> @PR27924_cmpgt(<4 x i32> %a, <4 x i32> %b) {
; SSE-LABEL: PR27924_cmpgt:
; SSE:       # BB#0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: PR27924_cmpgt:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cmp = icmp sgt <4 x i32> %a, %b
  %max = select <4 x i1> %cmp, <4 x i32> %a, <4 x i32> %b
  %sse_max = tail call <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32> %a, <4 x i32> %b)
  %untruth = icmp sgt <4 x i32> %max, %sse_max
  %ret = sext <4 x i1> %untruth to <4 x i32>
  ret <4 x i32> %ret
}

